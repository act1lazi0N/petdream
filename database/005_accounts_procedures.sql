USE PetDream;
GO
CREATE OR ALTER PROCEDURE dbo.sp_TaiKhoan_DangKy
    @HoTen nvarchar(100), @Email nvarchar(254), @DienThoai varchar(10), @MatKhauBam varchar(100)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT dbo.TAI_KHOAN (HoTen, Email, DienThoai, MatKhauBam, VaiTro)
    VALUES (@HoTen, @Email, @DienThoai, @MatKhauBam, 'khach');
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_TaiKhoan_TimDangNhap
    @Email nvarchar(254) = NULL, @DienThoai varchar(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, MatKhauBam, PhienBanXacThuc
    FROM dbo.TAI_KHOAN
    WHERE HoatDong = 1 AND DaXoa = 0 AND (Email = @Email OR DienThoai = @DienThoai);
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_TaiKhoan_DanhTinh @Id int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, HoTen, Email, DienThoai, VaiTro, PhienBanXacThuc
    FROM dbo.TAI_KHOAN WHERE Id = @Id AND HoatDong = 1 AND DaXoa = 0;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_TaiKhoan_MatKhau @Id int, @PhienBan int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT MatKhauBam FROM dbo.TAI_KHOAN
    WHERE Id = @Id AND PhienBanXacThuc = @PhienBan AND HoatDong = 1 AND DaXoa = 0;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_TaiKhoan_CapNhat
    @Id int, @PhienBan int, @HoTen nvarchar(100), @Email nvarchar(254), @DienThoai varchar(10)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.TAI_KHOAN SET HoTen = @HoTen, Email = @Email, DienThoai = @DienThoai
    WHERE Id = @Id AND PhienBanXacThuc = @PhienBan AND HoatDong = 1 AND DaXoa = 0;
    SELECT @@ROWCOUNT;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_TaiKhoan_DoiMatKhau
    @Id int, @PhienBan int, @MatKhauBam varchar(100)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.TAI_KHOAN SET MatKhauBam = @MatKhauBam, PhienBanXacThuc = PhienBanXacThuc + 1
    WHERE Id = @Id AND PhienBanXacThuc = @PhienBan AND HoatDong = 1 AND DaXoa = 0;
    SELECT @@ROWCOUNT;
END;
GO
