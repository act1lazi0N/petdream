-- F07. Chay sau 004/005, 007/008 va 016.
-- Dat/chuyen trang thai goi lai F04; khong co giao dich giu cho thu hai.
USE PetDream;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER PROCEDURE dbo.sp_QuanTriDonHang_DanhSach
    @NguoiId int, @PhienBanNguoi int, @TuKhoa nvarchar(100) = N'',
    @TrangThai varchar(20) = NULL, @DaLuuTru bit = 0
AS
BEGIN
    SET NOCOUNT ON;
    SELECT d.Id, d.Ma, d.NgayDat, d.TrangThai, d.TongTien,
        d.TenNguoiNhan, d.DienThoai, d.DaLuuTru
    FROM dbo.DON_HANG AS d
    WHERE d.DaLuuTru = @DaLuuTru
        AND (@TrangThai IS NULL OR d.TrangThai = @TrangThai)
        AND (@TuKhoa = N'' OR CHARINDEX(@TuKhoa COLLATE Latin1_General_100_CI_AI, d.Ma COLLATE Latin1_General_100_CI_AI) > 0
             OR CHARINDEX(@TuKhoa COLLATE Latin1_General_100_CI_AI, d.TenNguoiNhan COLLATE Latin1_General_100_CI_AI) > 0
             OR CHARINDEX(@TuKhoa, d.DienThoai) > 0)
        AND EXISTS (SELECT 1 FROM dbo.TAI_KHOAN WHERE Id = @NguoiId AND PhienBanXacThuc = @PhienBanNguoi
                    AND VaiTro IN ('admin','staff') AND HoatDong = 1 AND DaXoa = 0)
    ORDER BY d.NgayDat DESC, d.Id DESC;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_QuanTriDonHang_ChiTiet
    @NguoiId int, @PhienBanNguoi int, @Id int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT d.Id, d.Ma, d.TenNguoiNhan, d.DienThoai, d.DiaChi, d.GhiChu, d.TienHang,
        d.PhiGiao, d.TongTien, d.TrangThai, d.NgayDat, d.NgayCapNhat, d.DaLuuTru,
        k.HoTen AS KhachHoTen, n.HoTen AS NguoiTaoHoTen
    FROM dbo.DON_HANG AS d
    INNER JOIN dbo.TAI_KHOAN AS k ON k.Id = d.TaiKhoanId
    INNER JOIN dbo.TAI_KHOAN AS n ON n.Id = d.NguoiTaoId
    WHERE d.Id = @Id AND EXISTS (SELECT 1 FROM dbo.TAI_KHOAN
        WHERE Id = @NguoiId AND PhienBanXacThuc = @PhienBanNguoi
          AND VaiTro IN ('admin','staff') AND HoatDong = 1 AND DaXoa = 0);

    SELECT c.ThuCungId, c.TenThuCung, c.Gia, a.DuongDan, a.OAnh
    FROM dbo.CHI_TIET_DON_HANG AS c
    OUTER APPLY (SELECT TOP (1) DuongDan, OAnh FROM dbo.ANH_THU_CUNG
                 WHERE ThuCungId = c.ThuCungId ORDER BY ThuTu, Id) AS a
    WHERE c.DonHangId = @Id AND EXISTS (SELECT 1 FROM dbo.TAI_KHOAN
        WHERE Id = @NguoiId AND PhienBanXacThuc = @PhienBanNguoi
          AND VaiTro IN ('admin','staff') AND HoatDong = 1 AND DaXoa = 0)
    ORDER BY c.Id;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_QuanTriDonHang_DanhSachKhach
    @NguoiId int, @PhienBanNguoi int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, HoTen, Email, DienThoai FROM dbo.TAI_KHOAN AS k
    WHERE k.VaiTro = 'khach' AND k.HoatDong = 1 AND k.DaXoa = 0
      AND EXISTS (SELECT 1 FROM dbo.TAI_KHOAN WHERE Id = @NguoiId AND PhienBanXacThuc = @PhienBanNguoi
                  AND VaiTro IN ('admin','staff') AND HoatDong = 1 AND DaXoa = 0)
    ORDER BY k.HoTen, k.Id;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_QuanTriDonHang_DanhSachThuCung
    @NguoiId int, @PhienBanNguoi int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT t.Id, t.Ma, t.Ten, t.Giong, t.Gia, a.DuongDan, a.OAnh
    FROM dbo.THU_CUNG AS t
    OUTER APPLY (SELECT TOP (1) DuongDan, OAnh FROM dbo.ANH_THU_CUNG
                 WHERE ThuCungId = t.Id ORDER BY ThuTu, Id) AS a
    WHERE t.DaXoa = 0 AND t.TrangThai = 'dang_ban'
      AND EXISTS (SELECT 1 FROM dbo.TAI_KHOAN WHERE Id = @NguoiId AND PhienBanXacThuc = @PhienBanNguoi
                  AND VaiTro IN ('admin','staff') AND HoatDong = 1 AND DaXoa = 0)
    ORDER BY t.Ten, t.Id;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_QuanTriDonHang_DatHo
    @NguoiId int, @PhienBanNguoi int, @KhachId int, @MaGuiLap uniqueidentifier,
    @TenNguoiNhan nvarchar(100), @DienThoai varchar(10), @DiaChi nvarchar(300),
    @GhiChu nvarchar(500), @DanhSach xml
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    IF @KhachId IS NULL OR @KhachId <= 0 OR @MaGuiLap IS NULL
       OR @TenNguoiNhan IS NULL OR LEN(LTRIM(RTRIM(@TenNguoiNhan))) < 2
       OR @DiaChi IS NULL OR LEN(LTRIM(RTRIM(@DiaChi))) < 10
       OR @DienThoai IS NULL OR LEN(@DienThoai) <> 10 OR @DienThoai NOT LIKE '0%'
       OR @DienThoai LIKE '%[^0-9]%' OR @DanhSach IS NULL
    BEGIN SELECT 'khong_hop_le' AS KetQua, CAST(NULL AS int) AS DonHangId; RETURN; END;
    BEGIN TRY
        BEGIN TRANSACTION;
        -- Khoa danh tinh/khach den khi checkout F04 ket thuc, tranh doi quyen/vo hieu giua request.
        IF NOT EXISTS (SELECT 1 FROM dbo.TAI_KHOAN WITH (UPDLOCK, HOLDLOCK)
            WHERE Id = @NguoiId AND PhienBanXacThuc = @PhienBanNguoi
              AND VaiTro IN ('admin','staff') AND HoatDong = 1 AND DaXoa = 0)
        BEGIN ROLLBACK; SELECT 'khong_du_quyen' AS KetQua, CAST(NULL AS int) AS DonHangId; RETURN; END;
        IF NOT EXISTS (SELECT 1 FROM dbo.TAI_KHOAN WITH (UPDLOCK, HOLDLOCK)
            WHERE Id = @KhachId AND VaiTro = 'khach' AND HoatDong = 1 AND DaXoa = 0)
        BEGIN ROLLBACK; SELECT 'khong_hop_le' AS KetQua, CAST(NULL AS int) AS DonHangId; RETURN; END;

        EXEC dbo.sp_DonHang_Dat @TaiKhoanId = @KhachId, @NguoiTaoId = @NguoiId,
            @MaGuiLap = @MaGuiLap, @TenNguoiNhan = @TenNguoiNhan, @DienThoai = @DienThoai,
            @DiaChi = @DiaChi, @GhiChu = @GhiChu, @DanhSach = @DanhSach;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_QuanTriDonHang_ChuyenTrangThai
    @NguoiId int, @PhienBanNguoi int, @Id int, @TrangThaiCu varchar(20), @TrangThaiMoi varchar(20)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        IF NOT EXISTS (SELECT 1 FROM dbo.TAI_KHOAN WITH (UPDLOCK, HOLDLOCK)
            WHERE Id = @NguoiId AND PhienBanXacThuc = @PhienBanNguoi
              AND VaiTro IN ('admin','staff') AND HoatDong = 1 AND DaXoa = 0)
        BEGIN ROLLBACK; SELECT 'khong_du_quyen' AS KetQua; RETURN; END;
        IF NOT EXISTS (SELECT 1 FROM dbo.DON_HANG WITH (UPDLOCK, HOLDLOCK) WHERE Id = @Id AND DaLuuTru = 0)
        BEGIN ROLLBACK; SELECT 'khong_tim_thay' AS KetQua; RETURN; END;
        EXEC dbo.sp_DonHang_ChuyenTrangThai @DonHangId = @Id, @TrangThaiCu = @TrangThaiCu,
            @TrangThaiMoi = @TrangThaiMoi, @KhachHangId = NULL;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_QuanTriDonHang_LuuTru
    @NguoiId int, @PhienBanNguoi int, @Id int
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRANSACTION;
    IF NOT EXISTS (SELECT 1 FROM dbo.TAI_KHOAN WITH (UPDLOCK, HOLDLOCK)
        WHERE Id = @NguoiId AND PhienBanXacThuc = @PhienBanNguoi
          AND VaiTro = 'admin' AND HoatDong = 1 AND DaXoa = 0)
    BEGIN ROLLBACK; SELECT 'khong_du_quyen' AS KetQua; RETURN; END;
    DECLARE @TrangThai varchar(20), @DaLuuTru bit;
    SELECT @TrangThai = TrangThai, @DaLuuTru = DaLuuTru
    FROM dbo.DON_HANG WITH (UPDLOCK, HOLDLOCK) WHERE Id = @Id;
    IF @TrangThai IS NULL OR @DaLuuTru = 1
    BEGIN ROLLBACK; SELECT 'khong_tim_thay' AS KetQua; RETURN; END;
    IF @TrangThai <> 'da_huy'
    BEGIN ROLLBACK; SELECT 'chi_don_da_huy' AS KetQua; RETURN; END;
    UPDATE dbo.DON_HANG SET DaLuuTru = 1 WHERE Id = @Id;
    COMMIT TRANSACTION;
    SELECT 'thanh_cong' AS KetQua;
END;
GO
