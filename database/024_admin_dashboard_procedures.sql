-- Tong quan dung so lieu that. Chay sau 011, 016 va 007/008.
USE PetDream;
GO
CREATE OR ALTER PROCEDURE dbo.sp_Admin_TongQuan
    @NguoiId int, @PhienBanNguoi int
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM dbo.TAI_KHOAN
        WHERE Id = @NguoiId AND PhienBanXacThuc = @PhienBanNguoi
          AND VaiTro IN ('admin', 'staff') AND HoatDong = 1 AND DaXoa = 0)
        RETURN;

    SELECT
        (SELECT COUNT(*) FROM dbo.LOAI WHERE DaXoa = 0) AS SoLoai,
        (SELECT COUNT(*) FROM dbo.THU_CUNG WHERE DaXoa = 0 AND TrangThai = 'dang_ban') AS DangTimChu,
        (SELECT COUNT(*) FROM dbo.THU_CUNG WHERE DaXoa = 0 AND TrangThai = 'giu_cho') AS DangGiuCho,
        (SELECT COUNT(*) FROM dbo.THU_CUNG WHERE DaXoa = 0 AND TrangThai = 'da_ban') AS DaCoMaiAm,
        (SELECT COUNT(*) FROM dbo.DON_HANG WHERE TrangThai = 'cho_xac_nhan') AS DonChoXacNhan;

    -- Khong bao gom ten, dien thoai, dia chi hay thong tin tai khoan cua khach.
    SELECT TOP (5) Id, Ma, NgayDat, TrangThai, TongTien
    FROM dbo.DON_HANG
    WHERE DaLuuTru = 0
    ORDER BY NgayDat DESC, Id DESC;
END;
GO
