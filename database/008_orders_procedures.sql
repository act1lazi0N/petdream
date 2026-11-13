-- Chay sau 007. CREATE OR ALTER nen chay lai an toan.
USE PetDream;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
-- Dat don COD va giu cho tat ca be trong cung mot transaction.
-- @DanhSach: <gio><tc id="1" gia="6500000"/>...</gio>, gia la gia khach da xem khi xac nhan.
-- Tra ve mot dong: KetQua (thanh_cong | da_ton_tai | gia_doi | khong_kha_dung | gio_trong | khong_hop_le), DonHangId.
CREATE OR ALTER PROCEDURE dbo.sp_DonHang_Dat
    @TaiKhoanId int,
    @NguoiTaoId int,
    @MaGuiLap uniqueidentifier,
    @TenNguoiNhan nvarchar(100),
    @DienThoai varchar(10),
    @DiaChi nvarchar(300),
    @GhiChu nvarchar(500),
    @DanhSach xml
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @PhiGiao decimal(18,0) = 30000;
    DECLARE @DonHangId int, @ChuDon int;
    DECLARE @Gio TABLE (ThuCungId int NULL, GiaXem decimal(18,0) NULL);
    DECLARE @Be TABLE (Id int NOT NULL PRIMARY KEY, Ten nvarchar(80) NOT NULL, Gia decimal(18,0) NOT NULL,
        TrangThai varchar(20) NOT NULL, DaXoa bit NOT NULL, GiaXem decimal(18,0) NOT NULL);

    INSERT @Gio (ThuCungId, GiaXem)
    SELECT x.n.value('@id', 'int'), x.n.value('@gia', 'decimal(18,0)')
    FROM @DanhSach.nodes('/gio/tc') AS x(n);

    IF NOT EXISTS (SELECT 1 FROM @Gio)
    BEGIN
        SELECT 'gio_trong' AS KetQua, CAST(NULL AS int) AS DonHangId;
        RETURN;
    END;

    IF @MaGuiLap IS NULL OR @TenNguoiNhan IS NULL OR @DienThoai IS NULL OR @DiaChi IS NULL
        OR EXISTS (SELECT 1 FROM @Gio WHERE ThuCungId IS NULL OR GiaXem IS NULL)
        OR (SELECT COUNT(*) FROM @Gio) <> (SELECT COUNT(DISTINCT ThuCungId) FROM @Gio)
    BEGIN
        SELECT 'khong_hop_le' AS KetQua, CAST(NULL AS int) AS DonHangId;
        RETURN;
    END;

    BEGIN TRANSACTION;

    -- Khoa theo ma chong gui lap: lan gui thu hai cho lan dau xong roi nhan lai cung don.
    SELECT @DonHangId = Id, @ChuDon = TaiKhoanId
    FROM dbo.DON_HANG WITH (UPDLOCK, HOLDLOCK)
    WHERE MaGuiLap = @MaGuiLap;

    IF @DonHangId IS NOT NULL
    BEGIN
        COMMIT;
        IF @ChuDon = @TaiKhoanId
            SELECT 'da_ton_tai' AS KetQua, @DonHangId AS DonHangId;
        ELSE
            SELECT 'khong_hop_le' AS KetQua, CAST(NULL AS int) AS DonHangId;
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM dbo.TAI_KHOAN WHERE Id = @TaiKhoanId AND HoatDong = 1 AND DaXoa = 0)
        OR NOT EXISTS (SELECT 1 FROM dbo.TAI_KHOAN WHERE Id = @NguoiTaoId AND HoatDong = 1 AND DaXoa = 0)
    BEGIN
        ROLLBACK;
        SELECT 'khong_hop_le' AS KetQua, CAST(NULL AS int) AS DonHangId;
        RETURN;
    END;

    -- Khoa cac be trong gio: don thu hai dat cung be phai cho don dau xong va se thay be da giu cho.
    INSERT @Be (Id, Ten, Gia, TrangThai, DaXoa, GiaXem)
    SELECT t.Id, t.Ten, t.Gia, t.TrangThai, t.DaXoa, g.GiaXem
    FROM dbo.THU_CUNG AS t WITH (UPDLOCK, HOLDLOCK)
    INNER JOIN @Gio AS g ON g.ThuCungId = t.Id;

    IF (SELECT COUNT(*) FROM @Be WHERE TrangThai = 'dang_ban' AND DaXoa = 0) <> (SELECT COUNT(*) FROM @Gio)
    BEGIN
        ROLLBACK;
        SELECT 'khong_kha_dung' AS KetQua, CAST(NULL AS int) AS DonHangId;
        RETURN;
    END;

    -- Gia doi sau khi khach xem: khong dat, yeu cau khach xem lai.
    IF EXISTS (SELECT 1 FROM @Be WHERE Gia <> GiaXem)
    BEGIN
        ROLLBACK;
        SELECT 'gia_doi' AS KetQua, CAST(NULL AS int) AS DonHangId;
        RETURN;
    END;

    INSERT dbo.DON_HANG (TaiKhoanId, NguoiTaoId, MaGuiLap, TenNguoiNhan, DienThoai, DiaChi, GhiChu, TienHang, PhiGiao)
    SELECT @TaiKhoanId, @NguoiTaoId, @MaGuiLap, @TenNguoiNhan, @DienThoai, @DiaChi, ISNULL(@GhiChu, N''), SUM(Gia), @PhiGiao
    FROM @Be;
    SET @DonHangId = SCOPE_IDENTITY();

    INSERT dbo.CHI_TIET_DON_HANG (DonHangId, ThuCungId, TenThuCung, Gia)
    SELECT @DonHangId, Id, Ten, Gia FROM @Be;

    UPDATE t SET TrangThai = 'giu_cho'
    FROM dbo.THU_CUNG AS t
    INNER JOIN @Be AS b ON b.Id = t.Id
    WHERE t.TrangThai = 'dang_ban';

    IF @@ROWCOUNT <> (SELECT COUNT(*) FROM @Be)
        THROW 50001, N'Khong giu cho duoc day du thu cung trong don.', 1;

    COMMIT;
    SELECT 'thanh_cong' AS KetQua, @DonHangId AS DonHangId;
END;
GO
-- Chuyen trang thai don theo luong cho_xac_nhan -> da_xac_nhan -> dang_giao -> da_giao, hoac da_huy truoc khi giao.
-- @KhachHangId khac NULL: khach tu thao tac, chi duoc huy don cua chinh minh khi dang cho xac nhan.
-- F07 goi lai procedure nay voi @KhachHangId = NULL sau khi kiem tra quyen quan tri.
-- Tra ve KetQua: thanh_cong | khong_tim_thay | trang_thai_doi | khong_hop_le.
CREATE OR ALTER PROCEDURE dbo.sp_DonHang_ChuyenTrangThai
    @DonHangId int,
    @TrangThaiCu varchar(20),
    @TrangThaiMoi varchar(20),
    @KhachHangId int = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF NOT ((@TrangThaiCu = 'cho_xac_nhan' AND @TrangThaiMoi IN ('da_xac_nhan', 'da_huy'))
            OR (@TrangThaiCu = 'da_xac_nhan' AND @TrangThaiMoi IN ('dang_giao', 'da_huy'))
            OR (@TrangThaiCu = 'dang_giao' AND @TrangThaiMoi IN ('da_giao', 'da_huy')))
        OR (@KhachHangId IS NOT NULL AND NOT (@TrangThaiCu = 'cho_xac_nhan' AND @TrangThaiMoi = 'da_huy'))
    BEGIN
        SELECT 'khong_hop_le' AS KetQua;
        RETURN;
    END;

    BEGIN TRANSACTION;

    DECLARE @HienTai varchar(20);
    SELECT @HienTai = TrangThai
    FROM dbo.DON_HANG WITH (UPDLOCK, HOLDLOCK)
    WHERE Id = @DonHangId AND (@KhachHangId IS NULL OR TaiKhoanId = @KhachHangId);

    IF @HienTai IS NULL
    BEGIN
        ROLLBACK;
        SELECT 'khong_tim_thay' AS KetQua;
        RETURN;
    END;

    IF @HienTai <> @TrangThaiCu
    BEGIN
        ROLLBACK;
        SELECT 'trang_thai_doi' AS KetQua;
        RETURN;
    END;

    UPDATE dbo.DON_HANG
    SET TrangThai = @TrangThaiMoi, NgayCapNhat = SYSUTCDATETIME()
    WHERE Id = @DonHangId;

    -- Huy mo ban lai be dang giu cho; giao thanh cong chuyen be thanh da ban. Don da_huy/da_giao la trang thai cuoi
    -- nen moi don chi doi trang thai be mot lan.
    IF @TrangThaiMoi = 'da_huy'
        UPDATE t SET TrangThai = 'dang_ban'
        FROM dbo.THU_CUNG AS t
        INNER JOIN dbo.CHI_TIET_DON_HANG AS c ON c.ThuCungId = t.Id
        WHERE c.DonHangId = @DonHangId AND t.TrangThai = 'giu_cho';
    ELSE IF @TrangThaiMoi = 'da_giao'
        UPDATE t SET TrangThai = 'da_ban'
        FROM dbo.THU_CUNG AS t
        INNER JOIN dbo.CHI_TIET_DON_HANG AS c ON c.ThuCungId = t.Id
        WHERE c.DonHangId = @DonHangId AND t.TrangThai = 'giu_cho';

    COMMIT;
    SELECT 'thanh_cong' AS KetQua;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_DonHang_LichSu @TaiKhoanId int
AS
BEGIN
    SET NOCOUNT ON;

    SELECT d.Id, d.Ma, d.NgayDat, d.TrangThai, d.TongTien, COUNT(c.Id) AS SoBe,
        STRING_AGG(c.TenThuCung, N', ') WITHIN GROUP (ORDER BY c.Id) AS DanhSachTen
    FROM dbo.DON_HANG AS d
    INNER JOIN dbo.CHI_TIET_DON_HANG AS c ON c.DonHangId = d.Id
    WHERE d.TaiKhoanId = @TaiKhoanId
    GROUP BY d.Id, d.Ma, d.NgayDat, d.TrangThai, d.TongTien
    ORDER BY d.NgayDat DESC, d.Id DESC;
END;
GO
-- Hai bang ket qua: thong tin don va danh sach be. Chi tra du lieu khi don thuoc @TaiKhoanId.
CREATE OR ALTER PROCEDURE dbo.sp_DonHang_ChiTiet @DonHangId int, @TaiKhoanId int
AS
BEGIN
    SET NOCOUNT ON;

    SELECT Id, Ma, TenNguoiNhan, DienThoai, DiaChi, GhiChu, TienHang, PhiGiao, TongTien, TrangThai, NgayDat, NgayCapNhat
    FROM dbo.DON_HANG
    WHERE Id = @DonHangId AND TaiKhoanId = @TaiKhoanId;

    SELECT c.ThuCungId, c.TenThuCung, c.Gia, a.DuongDan, a.OAnh,
        CAST(CASE WHEN t.DaXoa = 0 AND t.TrangThai <> 'ngung_ban' THEN 1 ELSE 0 END AS bit) AS CongKhai
    FROM dbo.CHI_TIET_DON_HANG AS c
    INNER JOIN dbo.DON_HANG AS d ON d.Id = c.DonHangId
    INNER JOIN dbo.THU_CUNG AS t ON t.Id = c.ThuCungId
    OUTER APPLY (
        SELECT TOP (1) DuongDan, OAnh
        FROM dbo.ANH_THU_CUNG
        WHERE ThuCungId = t.Id
        ORDER BY ThuTu, Id
    ) AS a
    WHERE c.DonHangId = @DonHangId AND d.TaiKhoanId = @TaiKhoanId
    ORDER BY c.Id;
END;
GO
