-- Chạy thủ công trong SSMS sau khi đã tạo đủ ba tài khoản demo theo docs/demo-acceptance.md.
-- Chỉ dùng trên LocalDB dành cho demo. Seed catalog thông thường không chạy file này.
USE PetDream;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @Khach int, @Admin int, @Staff int;
    SELECT @Khach = Id FROM dbo.TAI_KHOAN WITH (UPDLOCK, HOLDLOCK)
    WHERE Email = 'demo-khach@petdream.test' AND DienThoai = '0810000010'
        AND VaiTro = 'khach' AND HoatDong = 1 AND DaXoa = 0;
    SELECT @Admin = Id FROM dbo.TAI_KHOAN WITH (UPDLOCK, HOLDLOCK)
    WHERE Email = 'demo-admin@petdream.test' AND DienThoai = '0810000011'
        AND VaiTro IN ('khach', 'admin') AND HoatDong = 1 AND DaXoa = 0;
    SELECT @Staff = Id FROM dbo.TAI_KHOAN WITH (UPDLOCK, HOLDLOCK)
    WHERE Email = 'demo-staff@petdream.test' AND DienThoai = '0810000012'
        AND VaiTro IN ('khach', 'staff') AND HoatDong = 1 AND DaXoa = 0;

    IF @Khach IS NULL OR @Admin IS NULL OR @Staff IS NULL
        THROW 51100, N'Chưa có đủ ba tài khoản demo hoạt động hoặc thông tin không khớp hướng dẫn.', 1;

    UPDATE dbo.TAI_KHOAN
    SET VaiTro = CASE WHEN Id = @Admin THEN 'admin' ELSE 'staff' END,
        PhienBanXacThuc = PhienBanXacThuc + 1
    WHERE Id IN (@Admin, @Staff) AND VaiTro = 'khach';

    DECLARE @MaGuiLap uniqueidentifier = 'fb4c645b-c7a7-449c-8143-c9b0706fe43e';
    DECLARE @DonId int, @ChuDon int;
    SELECT @DonId = Id, @ChuDon = TaiKhoanId FROM dbo.DON_HANG WITH (UPDLOCK, HOLDLOCK)
    WHERE MaGuiLap = @MaGuiLap;
    IF @DonId IS NOT NULL AND @ChuDon <> @Khach
        THROW 51101, N'Mã đơn mẫu đã gắn với tài khoản khác.', 1;

    IF @DonId IS NULL
    BEGIN
        DECLARE @BeId int, @LoaiId int, @Gia decimal(18,0) = 590000;
        SELECT @LoaiId = MIN(Id) FROM dbo.LOAI WHERE DaXoa = 0;
        IF @LoaiId IS NULL
            THROW 51102, N'Cần có loài đang hiển thị trong catalog.', 1;
        IF EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma = 'DEMO-F10-BE')
            THROW 51103, N'Mã thú cưng mẫu đã được dùng.', 1;

        INSERT dbo.THU_CUNG (Ma, LoaiId, Ten, Giong, GioiTinh, NgaySinh, CanNang, KichThuoc,
            Gia, MoTa, TiemChung, DacDiem)
        VALUES ('DEMO-F10-BE', @LoaiId, N'Mây (demo)', N'Hồ sơ minh họa', 'C', '20250101', 4,
            N'Nhỏ', @Gia, N'Dữ liệu riêng để trình diễn đơn hàng.', N'Hồ sơ mẫu', N'Hiền và thân thiện');
        SET @BeId = CONVERT(int, SCOPE_IDENTITY());

        DECLARE @Gio xml = (SELECT @BeId AS [@id], @Gia AS [@gia] FOR XML PATH('tc'), ROOT('gio'), TYPE);
        EXEC dbo.sp_DonHang_Dat @TaiKhoanId = @Khach, @NguoiTaoId = @Khach, @MaGuiLap = @MaGuiLap,
            @TenNguoiNhan = N'Khách demo', @DienThoai = '0810000010', @DiaChi = N'1 Đường Minh Họa',
            @GhiChu = N'Đơn PetDream dùng để chấm điểm.', @DanhSach = @Gio;

        SELECT @DonId = Id FROM dbo.DON_HANG WHERE MaGuiLap = @MaGuiLap AND TaiKhoanId = @Khach;
        IF @DonId IS NULL
            THROW 51104, N'Không tạo được đơn mẫu.', 1;
    END;

    COMMIT;
    SELECT Email, VaiTro FROM dbo.TAI_KHOAN WHERE Id IN (@Khach, @Admin, @Staff) ORDER BY VaiTro;
    SELECT Id, Ma, TrangThai FROM dbo.DON_HANG WHERE Id = @DonId;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK;
    THROW;
END CATCH;
GO
