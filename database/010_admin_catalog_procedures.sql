-- F05. Chay sau 001-005, 007, 008 va 011. Khong xoa du lieu hien co.
USE PetDream;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER PROCEDURE dbo.sp_QuanTriLoai_DanhSach
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Ma, Ten, MoTa, ThuTu FROM dbo.LOAI WHERE DaXoa = 0 ORDER BY ThuTu, Id;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_QuanTriLoai_ChiTiet @Id int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Ma, Ten, MoTa, ThuTu FROM dbo.LOAI WHERE Id = @Id AND DaXoa = 0;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_QuanTriLoai_Luu
    @NguoiId int, @PhienBanNguoi int, @Id int, @Ma varchar(20),
    @Ten nvarchar(60), @MoTa nvarchar(250), @ThuTu int
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    IF @Id IS NULL OR @Id < 0
       OR NULLIF(LTRIM(RTRIM(@Ten)), N'') IS NULL OR @MoTa IS NULL OR @ThuTu IS NULL
    BEGIN SELECT 'khong_hop_le' AS KetQua; RETURN; END;
    BEGIN TRANSACTION;
    IF NOT EXISTS (SELECT 1 FROM dbo.TAI_KHOAN WITH (UPDLOCK, HOLDLOCK)
        WHERE Id = @NguoiId AND PhienBanXacThuc = @PhienBanNguoi
          AND VaiTro = 'admin' AND HoatDong = 1 AND DaXoa = 0)
    BEGIN ROLLBACK; SELECT 'khong_du_quyen' AS KetQua; RETURN; END;
    -- Tuan tu hoa tao, doi ten va luu tru loai de khong trung ten khi co request dong thoi.
    DECLARE @KhoaTen int;
    EXEC @KhoaTen = sys.sp_getapplock @Resource = N'PetDream.QuanTriLoai',
        @LockMode = 'Exclusive', @LockOwner = 'Transaction', @LockTimeout = 10000;
    IF @KhoaTen < 0 THROW 51012, 'Khong lay duoc khoa danh muc loai.', 1;

    DECLARE @TenCu nvarchar(60);
    IF @Id <> 0
    BEGIN
        SELECT @TenCu = Ten FROM dbo.LOAI WITH (UPDLOCK, HOLDLOCK) WHERE Id = @Id AND DaXoa = 0;
        IF @TenCu IS NULL
        BEGIN ROLLBACK; SELECT 'khong_tim_thay' AS KetQua; RETURN; END;
    END;
    -- Cho sua thuoc tinh khac cua du lieu cu da trung ten neu khong doi ten.
    IF (@Id = 0 OR LTRIM(RTRIM(@TenCu)) COLLATE Latin1_General_100_CI_AS <> LTRIM(RTRIM(@Ten)) COLLATE Latin1_General_100_CI_AS)
       AND EXISTS (SELECT 1 FROM dbo.LOAI WHERE Id <> @Id AND DaXoa = 0
                   AND LTRIM(RTRIM(Ten)) COLLATE Latin1_General_100_CI_AS = LTRIM(RTRIM(@Ten)) COLLATE Latin1_General_100_CI_AS)
    BEGIN ROLLBACK; SELECT 'trung_ten' AS KetQua; RETURN; END;
    IF @Id = 0
    BEGIN
        -- @Ma tu caller chi de tuong thich: ma moi luon do SQL cap va khong tai su dung.
        DECLARE @SoLoai bigint, @MaMoi varchar(20);
        WHILE 1 = 1
        BEGIN
            SET @SoLoai = NEXT VALUE FOR dbo.SeqMaLoai;
            SET @MaMoi = 'LOAI-' + REPLICATE('0', CASE WHEN LEN(CONVERT(varchar(20), @SoLoai)) < 6 THEN 6 - LEN(CONVERT(varchar(20), @SoLoai)) ELSE 0 END) + CONVERT(varchar(20), @SoLoai);
            IF NOT EXISTS (SELECT 1 FROM dbo.LOAI WITH (UPDLOCK, HOLDLOCK) WHERE Ma = @MaMoi) BREAK;
        END;
        INSERT dbo.LOAI (Ma, Ten, MoTa, ThuTu) VALUES (@MaMoi, @Ten, @MoTa, @ThuTu);
    END
    ELSE
    BEGIN
        UPDATE dbo.LOAI SET Ten = @Ten, MoTa = @MoTa, ThuTu = @ThuTu WHERE Id = @Id AND DaXoa = 0;
        IF @@ROWCOUNT = 0
        BEGIN ROLLBACK; SELECT 'khong_tim_thay' AS KetQua; RETURN; END;
    END;
    COMMIT;
    SELECT 'thanh_cong' AS KetQua;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_QuanTriLoai_Xoa @NguoiId int, @PhienBanNguoi int, @Id int
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRANSACTION;
    IF NOT EXISTS (SELECT 1 FROM dbo.TAI_KHOAN WITH (UPDLOCK, HOLDLOCK)
        WHERE Id = @NguoiId AND PhienBanXacThuc = @PhienBanNguoi
          AND VaiTro = 'admin' AND HoatDong = 1 AND DaXoa = 0)
    BEGIN ROLLBACK; SELECT 'khong_du_quyen' AS KetQua; RETURN; END;
    DECLARE @KhoaTen int;
    EXEC @KhoaTen = sys.sp_getapplock @Resource = N'PetDream.QuanTriLoai',
        @LockMode = 'Exclusive', @LockOwner = 'Transaction', @LockTimeout = 10000;
    IF @KhoaTen < 0 THROW 51012, 'Khong lay duoc khoa danh muc loai.', 1;
    IF NOT EXISTS (SELECT 1 FROM dbo.LOAI WITH (UPDLOCK, HOLDLOCK) WHERE Id = @Id AND DaXoa = 0)
    BEGIN ROLLBACK; SELECT 'khong_tim_thay' AS KetQua; RETURN; END;
    -- Giu khoa tren loai cho den commit; FK cua thao tac tao/sua be cung phai kiem tra loai.
    IF EXISTS (SELECT 1 FROM dbo.THU_CUNG WITH (UPDLOCK, HOLDLOCK) WHERE LoaiId = @Id AND DaXoa = 0)
    BEGIN ROLLBACK; SELECT 'loai_con_thu_cung' AS KetQua; RETURN; END;
    UPDATE dbo.LOAI SET DaXoa = 1 WHERE Id = @Id;
    COMMIT;
    SELECT 'thanh_cong' AS KetQua;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_QuanTriThuCung_DanhSach
AS
BEGIN
    SET NOCOUNT ON;
    SELECT t.Id, t.Ma, t.Ten, l.Ten AS LoaiTen, t.Giong, t.TrangThai, t.DaXoa, t.Gia
    FROM dbo.THU_CUNG AS t INNER JOIN dbo.LOAI AS l ON l.Id = t.LoaiId
    ORDER BY t.DaXoa, t.Id DESC;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_QuanTriThuCung_ChiTiet @Id int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT t.*, l.Ten AS TenLoai, l.DaXoa AS LoaiDaXoa, a.DuongDan, a.OAnh FROM dbo.THU_CUNG AS t
    INNER JOIN dbo.LOAI AS l ON l.Id = t.LoaiId
    OUTER APPLY (SELECT TOP (1) DuongDan, OAnh FROM dbo.ANH_THU_CUNG WHERE ThuCungId = t.Id ORDER BY ThuTu, Id) AS a
    WHERE t.Id = @Id;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_QuanTriThuCung_Luu
    @NguoiId int, @PhienBanNguoi int, @Id int, @Ma varchar(30), @LoaiId int,
    @Ten nvarchar(80), @Giong nvarchar(100), @GioiTinh char(1), @NgaySinh date,
    @CanNang decimal(6,2), @KichThuoc nvarchar(100), @Gia decimal(18,0),
    @MoTa nvarchar(2000), @TiemChung nvarchar(1000), @DacDiem nvarchar(1000),
    @TrangThai varchar(20), @NoiBat bit, @DuongDanAnh nvarchar(250) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @TenAnh nvarchar(32) = SUBSTRING(@DuongDanAnh, 20, 32);
    IF @Id IS NULL OR @Id < 0 OR @LoaiId IS NULL OR @LoaiId <= 0
       OR NULLIF(LTRIM(RTRIM(@Ten)), N'') IS NULL
       OR NULLIF(LTRIM(RTRIM(@Giong)), N'') IS NULL OR @GioiTinh NOT IN ('D','C') OR @GioiTinh IS NULL
       OR @NgaySinh IS NULL OR @NgaySinh > CONVERT(date, GETDATE()) OR @CanNang IS NULL OR @CanNang <= 0
       OR NULLIF(LTRIM(RTRIM(@KichThuoc)), N'') IS NULL OR @Gia IS NULL OR @Gia < 0
       OR @MoTa IS NULL OR @TiemChung IS NULL OR @DacDiem IS NULL OR @NoiBat IS NULL
       OR @TrangThai IS NULL OR @TrangThai NOT IN ('dang_ban','ngung_ban','giu_cho','da_ban')
       OR (@Id = 0 AND @TrangThai NOT IN ('dang_ban','ngung_ban'))
       OR (@DuongDanAnh IS NOT NULL AND (LEN(@DuongDanAnh) <> 55
            OR LEFT(@DuongDanAnh, 19) COLLATE Latin1_General_100_BIN2 <> N'~/App_Data/Uploads/'
            OR RIGHT(@DuongDanAnh, 4) COLLATE Latin1_General_100_BIN2 <> N'.png'
            OR @TenAnh COLLATE Latin1_General_100_BIN2 LIKE N'%[^0-9a-f]%'))
    BEGIN SELECT 'khong_hop_le' AS KetQua, CAST(NULL AS int) AS Id; RETURN; END;
    BEGIN TRANSACTION;
    IF NOT EXISTS (SELECT 1 FROM dbo.TAI_KHOAN WITH (UPDLOCK, HOLDLOCK)
        WHERE Id = @NguoiId AND PhienBanXacThuc = @PhienBanNguoi
          AND VaiTro IN ('admin','staff') AND HoatDong = 1 AND DaXoa = 0)
    BEGIN ROLLBACK; SELECT 'khong_du_quyen' AS KetQua, CAST(NULL AS int) AS Id; RETURN; END;
    DECLARE @MaLoai varchar(20);
    SELECT @MaLoai = Ma FROM dbo.LOAI WITH (UPDLOCK, HOLDLOCK) WHERE Id = @LoaiId AND DaXoa = 0;
    IF @MaLoai IS NULL
    BEGIN ROLLBACK; SELECT 'khong_hop_le' AS KetQua, CAST(NULL AS int) AS Id; RETURN; END;
    IF @Id = 0
    BEGIN
        -- Nhan dien theo ma loai luc tao; chuyen loai sau nay khong doi ma da cap.
        DECLARE @SoThuCung bigint, @MaThuCung varchar(30);
        WHILE 1 = 1
        BEGIN
            SET @SoThuCung = NEXT VALUE FOR dbo.SeqMaThuCung;
            SET @MaThuCung = UPPER(LEFT(@MaLoai, 15)) + '-' + REPLICATE('0', CASE WHEN LEN(CONVERT(varchar(20), @SoThuCung)) < 3 THEN 3 - LEN(CONVERT(varchar(20), @SoThuCung)) ELSE 0 END) + CONVERT(varchar(20), @SoThuCung);
            IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WITH (UPDLOCK, HOLDLOCK) WHERE Ma = @MaThuCung) BREAK;
        END;
        INSERT dbo.THU_CUNG (Ma, LoaiId, Ten, Giong, GioiTinh, NgaySinh, CanNang, KichThuoc,
            Gia, MoTa, TiemChung, DacDiem, TrangThai, NoiBat)
        VALUES (@MaThuCung, @LoaiId, @Ten, @Giong, @GioiTinh, @NgaySinh, @CanNang, @KichThuoc,
            @Gia, @MoTa, @TiemChung, @DacDiem, @TrangThai, @NoiBat);
        SET @Id = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        DECLARE @TrangThaiCu varchar(20), @DaXoa bit;
        SELECT @TrangThaiCu = TrangThai, @DaXoa = DaXoa FROM dbo.THU_CUNG WITH (UPDLOCK, HOLDLOCK) WHERE Id = @Id;
        IF @TrangThaiCu IS NULL OR @DaXoa = 1
        BEGIN ROLLBACK; SELECT 'khong_tim_thay' AS KetQua, CAST(NULL AS int) AS Id; RETURN; END;
        -- Chi cho phep thay doi dang_ban/ngung_ban; giu_cho va da_ban do F04 quan ly.
        IF (@TrangThaiCu IN ('giu_cho','da_ban') AND @TrangThai <> @TrangThaiCu)
           OR (@TrangThaiCu IN ('dang_ban','ngung_ban') AND @TrangThai NOT IN ('dang_ban','ngung_ban'))
        BEGIN ROLLBACK; SELECT 'trang_thai_doi' AS KetQua, CAST(NULL AS int) AS Id; RETURN; END;
        UPDATE dbo.THU_CUNG SET LoaiId = @LoaiId, Ten = @Ten, Giong = @Giong,
            GioiTinh = @GioiTinh, NgaySinh = @NgaySinh, CanNang = @CanNang, KichThuoc = @KichThuoc,
            Gia = @Gia, MoTa = @MoTa, TiemChung = @TiemChung, DacDiem = @DacDiem,
            TrangThai = @TrangThai, NoiBat = @NoiBat WHERE Id = @Id;
    END;
    IF @DuongDanAnh IS NOT NULL
    BEGIN
        UPDATE dbo.ANH_THU_CUNG SET DuongDan = @DuongDanAnh, OAnh = 0 WHERE ThuCungId = @Id AND ThuTu = 0;
        IF @@ROWCOUNT = 0
            INSERT dbo.ANH_THU_CUNG (ThuCungId, DuongDan, OAnh, ThuTu) VALUES (@Id, @DuongDanAnh, 0, 0);
    END;
    COMMIT;
    SELECT 'thanh_cong' AS KetQua, @Id AS Id;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_QuanTriThuCung_Xoa @NguoiId int, @PhienBanNguoi int, @Id int
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRANSACTION;
    IF NOT EXISTS (SELECT 1 FROM dbo.TAI_KHOAN WITH (UPDLOCK, HOLDLOCK)
        WHERE Id = @NguoiId AND PhienBanXacThuc = @PhienBanNguoi
          AND VaiTro = 'admin' AND HoatDong = 1 AND DaXoa = 0)
    BEGIN ROLLBACK; SELECT 'khong_du_quyen' AS KetQua; RETURN; END;
    DECLARE @TrangThai varchar(20), @DaXoa bit;
    SELECT @TrangThai = TrangThai, @DaXoa = DaXoa FROM dbo.THU_CUNG WITH (UPDLOCK, HOLDLOCK) WHERE Id = @Id;
    IF @TrangThai IS NULL OR @DaXoa = 1
    BEGIN ROLLBACK; SELECT 'khong_tim_thay' AS KetQua; RETURN; END;
    -- F04 dat hang khoa chinh dong thu cung truoc khi giu cho va tao chi tiet don.
    IF @TrangThai = 'giu_cho' OR EXISTS (
        SELECT 1 FROM dbo.CHI_TIET_DON_HANG AS c INNER JOIN dbo.DON_HANG AS d ON d.Id = c.DonHangId
        WHERE c.ThuCungId = @Id AND d.TrangThai IN ('cho_xac_nhan','da_xac_nhan','dang_giao'))
    BEGIN ROLLBACK; SELECT 'dang_trong_don' AS KetQua; RETURN; END;
    UPDATE dbo.THU_CUNG SET DaXoa = 1 WHERE Id = @Id;
    COMMIT;
    SELECT 'thanh_cong' AS KetQua;
END;
GO
