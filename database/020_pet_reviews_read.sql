USE PetDream;
GO
CREATE OR ALTER PROCEDURE dbo.sp_DanhGia_CongKhai @ThuCungId int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT g.SoSao, g.NoiDung, g.NgayCapNhat, g.QuanTriNhap,
           CASE WHEN g.QuanTriNhap=1 THEN N'PetDream' ELSE n.HoTen END AS TenNguoiNhap
    FROM dbo.DANH_GIA g
    JOIN dbo.CHI_TIET_DON_HANG c ON c.Id=g.ChiTietDonHangId
    JOIN dbo.DON_HANG d ON d.Id=c.DonHangId
    JOIN dbo.TAI_KHOAN n ON n.Id=g.NguoiNhapId
    WHERE c.ThuCungId=@ThuCungId AND d.TrangThai='da_giao' AND g.TrangThai='da_duyet'
    ORDER BY g.NgayCapNhat DESC, g.Id DESC;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_DanhGia_ChiTiet
    @NguoiId int, @PhienBanNguoi int, @ChiTietId int, @QuanTri bit, @DonHangId int=NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.Id, c.DonHangId, c.TenThuCung, d.Ma AS MaDon,
           g.SoSao, g.NoiDung, g.TrangThai, g.QuanTriNhap, CONVERT(binary(8), g.PhienBan) AS PhienBan,
           n.HoTen AS TenNguoiNhap
    FROM dbo.CHI_TIET_DON_HANG c
    JOIN dbo.DON_HANG d ON d.Id=c.DonHangId
    LEFT JOIN dbo.DANH_GIA g ON g.ChiTietDonHangId=c.Id AND g.TrangThai<>'da_xoa'
    LEFT JOIN dbo.TAI_KHOAN n ON n.Id=g.NguoiNhapId
    WHERE d.TrangThai='da_giao'
      AND ((@QuanTri=1 AND c.Id=@ChiTietId)
        OR (@QuanTri=0 AND c.ThuCungId=@ChiTietId AND d.Id=@DonHangId))
      AND EXISTS (
          SELECT 1 FROM dbo.TAI_KHOAN u
          WHERE u.Id=@NguoiId AND u.PhienBanXacThuc=@PhienBanNguoi AND u.HoatDong=1 AND u.DaXoa=0
            AND ((@QuanTri=1 AND u.VaiTro IN ('admin','staff'))
              OR (@QuanTri=0 AND u.VaiTro='khach' AND d.TaiKhoanId=u.Id))
            AND (@QuanTri=0 OR g.Id IS NOT NULL OR u.VaiTro='admin'));
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_DanhGia_QuanTri @NguoiId int, @PhienBanNguoi int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.Id, c.TenThuCung, d.Ma AS MaDon, g.SoSao, g.TrangThai, g.QuanTriNhap,
           n.HoTen AS TenNguoiNhap
    FROM dbo.DANH_GIA g
    JOIN dbo.CHI_TIET_DON_HANG c ON c.Id=g.ChiTietDonHangId
    JOIN dbo.DON_HANG d ON d.Id=c.DonHangId
    JOIN dbo.TAI_KHOAN n ON n.Id=g.NguoiNhapId
    WHERE g.TrangThai<>'da_xoa' AND EXISTS (
        SELECT 1 FROM dbo.TAI_KHOAN u WHERE u.Id=@NguoiId AND u.PhienBanXacThuc=@PhienBanNguoi
          AND u.HoatDong=1 AND u.DaXoa=0 AND u.VaiTro IN ('admin','staff'))
    ORDER BY CASE WHEN g.TrangThai='cho_duyet' THEN 0 ELSE 1 END, g.NgayCapNhat DESC, g.Id DESC;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_DanhGia_CoTheThem @NguoiId int, @PhienBanNguoi int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.Id, CONCAT(d.Ma, N' · ', c.TenThuCung) AS Nhan
    FROM dbo.CHI_TIET_DON_HANG c
    JOIN dbo.DON_HANG d ON d.Id=c.DonHangId
    WHERE d.TrangThai='da_giao'
      AND NOT EXISTS (SELECT 1 FROM dbo.DANH_GIA g WHERE g.ChiTietDonHangId=c.Id AND g.TrangThai<>'da_xoa')
      AND EXISTS (
          SELECT 1 FROM dbo.TAI_KHOAN u WHERE u.Id=@NguoiId AND u.PhienBanXacThuc=@PhienBanNguoi
            AND u.HoatDong=1 AND u.DaXoa=0 AND u.VaiTro='admin')
    ORDER BY d.Id DESC, c.Id;
END;
GO
