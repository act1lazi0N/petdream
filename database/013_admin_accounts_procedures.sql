-- F06: Chay sau 004/005. CREATE OR ALTER khong xoa du lieu tai khoan.
USE PetDream;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

-- Trang chi danh cho admin: luon kiem tra lai danh tinh va phien ban trong SQL.
CREATE OR ALTER PROCEDURE dbo.sp_QuanTriTaiKhoan_DanhSach
    @NguoiId int, @PhienBanNguoi int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, HoTen, Email, DienThoai, VaiTro, HoatDong, DaXoa, PhienBanXacThuc, NgayTao
    FROM dbo.TAI_KHOAN
    WHERE EXISTS (SELECT 1 FROM dbo.TAI_KHOAN
                  WHERE Id = @NguoiId AND PhienBanXacThuc = @PhienBanNguoi
                    AND VaiTro = 'admin' AND HoatDong = 1 AND DaXoa = 0)
    ORDER BY DaXoa, Id DESC;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_QuanTriTaiKhoan_ChiTiet
    @NguoiId int, @PhienBanNguoi int, @Id int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, HoTen, Email, DienThoai, VaiTro, HoatDong, DaXoa, PhienBanXacThuc, NgayTao
    FROM dbo.TAI_KHOAN
    WHERE Id = @Id AND EXISTS (SELECT 1 FROM dbo.TAI_KHOAN
                  WHERE Id = @NguoiId AND PhienBanXacThuc = @PhienBanNguoi
                    AND VaiTro = 'admin' AND HoatDong = 1 AND DaXoa = 0);
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_QuanTriTaiKhoan_Tao
    @NguoiId int, @PhienBanNguoi int, @HoTen nvarchar(100), @Email nvarchar(254),
    @DienThoai varchar(10), @MatKhauBam varchar(100), @VaiTro varchar(10)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    IF @VaiTro IS NULL OR @VaiTro NOT IN ('khach', 'staff', 'admin')
       OR NULLIF(LTRIM(RTRIM(@HoTen)), N'') IS NULL
       OR NULLIF(@Email, N'') IS NULL OR NULLIF(@DienThoai, '') IS NULL
       OR NULLIF(@MatKhauBam, '') IS NULL
    BEGIN
        SELECT 'khong_hop_le' AS KetQua;
        RETURN;
    END;

    BEGIN TRANSACTION;
    DECLARE @Khoa int;
    EXEC @Khoa = sys.sp_getapplock @Resource = N'PetDream.QuanTriTaiKhoan',
        @LockMode = 'Exclusive', @LockOwner = 'Transaction', @LockTimeout = 10000;
    IF @Khoa < 0 THROW 51001, 'Khong lay duoc khoa quan tri tai khoan.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.TAI_KHOAN WITH (UPDLOCK, HOLDLOCK)
                   WHERE Id = @NguoiId AND PhienBanXacThuc = @PhienBanNguoi
                     AND VaiTro = 'admin' AND HoatDong = 1 AND DaXoa = 0)
    BEGIN
        ROLLBACK TRANSACTION;
        SELECT 'khong_du_quyen' AS KetQua;
        RETURN;
    END;

    INSERT dbo.TAI_KHOAN (HoTen, Email, DienThoai, MatKhauBam, VaiTro)
    VALUES (@HoTen, @Email, @DienThoai, @MatKhauBam, @VaiTro);
    COMMIT TRANSACTION;
    SELECT 'thanh_cong' AS KetQua;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_QuanTriTaiKhoan_CapNhat
    @NguoiId int, @PhienBanNguoi int, @Id int, @PhienBanMucTieu int, @HoTen nvarchar(100),
    @Email nvarchar(254), @DienThoai varchar(10), @VaiTro varchar(10),
    @HoatDong bit, @DaXoa bit
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    IF @VaiTro IS NULL OR @VaiTro NOT IN ('khach', 'staff', 'admin')
       OR @HoatDong IS NULL OR @DaXoa IS NULL OR (@DaXoa = 1 AND @HoatDong = 1)
       OR NULLIF(LTRIM(RTRIM(@HoTen)), N'') IS NULL
       OR NULLIF(@Email, N'') IS NULL OR NULLIF(@DienThoai, '') IS NULL
    BEGIN
        SELECT 'khong_hop_le' AS KetQua;
        RETURN;
    END;

    BEGIN TRANSACTION;
    DECLARE @Khoa int;
    EXEC @Khoa = sys.sp_getapplock @Resource = N'PetDream.QuanTriTaiKhoan',
        @LockMode = 'Exclusive', @LockOwner = 'Transaction', @LockTimeout = 10000;
    IF @Khoa < 0 THROW 51001, 'Khong lay duoc khoa quan tri tai khoan.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.TAI_KHOAN WITH (UPDLOCK, HOLDLOCK)
                   WHERE Id = @NguoiId AND PhienBanXacThuc = @PhienBanNguoi
                     AND VaiTro = 'admin' AND HoatDong = 1 AND DaXoa = 0)
    BEGIN
        ROLLBACK TRANSACTION;
        SELECT 'khong_du_quyen' AS KetQua;
        RETURN;
    END;

    DECLARE @VaiTroCu varchar(10), @HoatDongCu bit, @DaXoaCu bit, @PhienBanCu int;
    SELECT @VaiTroCu = VaiTro, @HoatDongCu = HoatDong, @DaXoaCu = DaXoa, @PhienBanCu = PhienBanXacThuc
    FROM dbo.TAI_KHOAN WITH (UPDLOCK, HOLDLOCK) WHERE Id = @Id;
    IF @VaiTroCu IS NULL
    BEGIN
        ROLLBACK TRANSACTION;
        SELECT 'khong_tim_thay' AS KetQua;
        RETURN;
    END;
    IF @DaXoaCu = 1
    BEGIN
        ROLLBACK TRANSACTION;
        SELECT 'khong_hop_le' AS KetQua;
        RETURN;
    END;
    IF @PhienBanMucTieu IS NULL OR @PhienBanMucTieu <> @PhienBanCu
    BEGIN
        ROLLBACK TRANSACTION;
        SELECT 'trang_thai_doi' AS KetQua;
        RETURN;
    END;

    -- Tat ca thay doi quyen/trang thai admin di qua cung khoa cua giao dich nay.
    IF @VaiTroCu = 'admin' AND @HoatDongCu = 1 AND @DaXoaCu = 0
       AND (@VaiTro <> 'admin' OR @HoatDong = 0 OR @DaXoa = 1)
       AND (SELECT COUNT(*) FROM dbo.TAI_KHOAN WITH (UPDLOCK, HOLDLOCK)
            WHERE VaiTro = 'admin' AND HoatDong = 1 AND DaXoa = 0) <= 1
    BEGIN
        ROLLBACK TRANSACTION;
        SELECT 'admin_cuoi' AS KetQua;
        RETURN;
    END;

    UPDATE dbo.TAI_KHOAN
    SET HoTen = @HoTen, Email = @Email, DienThoai = @DienThoai,
        VaiTro = @VaiTro, HoatDong = @HoatDong, DaXoa = @DaXoa,
        PhienBanXacThuc = PhienBanXacThuc +
            CASE WHEN @VaiTro <> @VaiTroCu OR @HoatDong <> @HoatDongCu OR @DaXoa <> @DaXoaCu
                 THEN 1 ELSE 0 END
    WHERE Id = @Id;
    COMMIT TRANSACTION;
    SELECT 'thanh_cong' AS KetQua;
END;
GO
