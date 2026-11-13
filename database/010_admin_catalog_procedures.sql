-- F05. Chay sau 001-005, 007 va 008. Khong xoa du lieu hien co.
USE PetDream;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER PROCEDURE dbo.sp_QuanTriLoai_DanhSach
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Ma, Ten, MoTa, ThuTu FROM dbo.LOAI ORDER BY ThuTu, Id;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_QuanTriLoai_ChiTiet @Id int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Ma, Ten, MoTa, ThuTu FROM dbo.LOAI WHERE Id = @Id;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_QuanTriLoai_Luu
    @NguoiId int, @PhienBanNguoi int, @Id int, @Ma varchar(20),
    @Ten nvarchar(60), @MoTa nvarchar(250), @ThuTu int
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    IF @Id IS NULL OR @Id < 0 OR NULLIF(LTRIM(RTRIM(@Ma)), '') IS NULL
       OR NULLIF(LTRIM(RTRIM(@Ten)), N'') IS NULL OR @MoTa IS NULL OR @ThuTu IS NULL
    BEGIN SELECT 'khong_hop_le' AS KetQua; RETURN; END;
    BEGIN TRANSACTION;
    IF NOT EXISTS (SELECT 1 FROM dbo.TAI_KHOAN WITH (UPDLOCK, HOLDLOCK)
        WHERE Id = @NguoiId AND PhienBanXacThuc = @PhienBanNguoi
          AND VaiTro = 'admin' AND HoatDong = 1 AND DaXoa = 0)
    BEGIN ROLLBACK; SELECT 'khong_du_quyen' AS KetQua; RETURN; END;
    IF @Id = 0
        INSERT dbo.LOAI (Ma, Ten, MoTa, ThuTu) VALUES (@Ma, @Ten, @MoTa, @ThuTu);
    ELSE
    BEGIN
        UPDATE dbo.LOAI SET Ma = @Ma, Ten = @Ten, MoTa = @MoTa, ThuTu = @ThuTu WHERE Id = @Id;
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
    IF NOT EXISTS (SELECT 1 FROM dbo.LOAI WITH (UPDLOCK, HOLDLOCK) WHERE Id = @Id)
    BEGIN ROLLBACK; SELECT 'khong_tim_thay' AS KetQua; RETURN; END;
    -- Giu khoa tren loai cho den commit; FK cua thao tac tao/sua be cung phai kiem tra loai.
    IF EXISTS (SELECT 1 FROM dbo.THU_CUNG WITH (UPDLOCK, HOLDLOCK) WHERE LoaiId = @Id)
    BEGIN ROLLBACK; SELECT 'loai_con_thu_cung' AS KetQua; RETURN; END;
    DELETE dbo.LOAI WHERE Id = @Id;
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
    SELECT t.*, a.DuongDan, a.OAnh FROM dbo.THU_CUNG AS t
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
       OR NULLIF(LTRIM(RTRIM(@Ma)), '') IS NULL OR NULLIF(LTRIM(RTRIM(@Ten)), N'') IS NULL
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
    IF NOT EXISTS (SELECT 1 FROM dbo.LOAI WITH (UPDLOCK, HOLDLOCK) WHERE Id = @LoaiId)
    BEGIN ROLLBACK; SELECT 'khong_hop_le' AS KetQua, CAST(NULL AS int) AS Id; RETURN; END;
    IF @Id = 0
    BEGIN
        INSERT dbo.THU_CUNG (Ma, LoaiId, Ten, Giong, GioiTinh, NgaySinh, CanNang, KichThuoc,
            Gia, MoTa, TiemChung, DacDiem, TrangThai, NoiBat)
        VALUES (@Ma, @LoaiId, @Ten, @Giong, @GioiTinh, @NgaySinh, @CanNang, @KichThuoc,
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
        UPDATE dbo.THU_CUNG SET Ma = @Ma, LoaiId = @LoaiId, Ten = @Ten, Giong = @Giong,
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
