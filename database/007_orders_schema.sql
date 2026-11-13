-- Chay sau 001-005. Chay lai an toan, khong xoa du lieu don da co.
USE PetDream;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET XACT_ABORT ON;
BEGIN TRANSACTION;

IF OBJECT_ID(N'dbo.DON_HANG', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.DON_HANG
    (
        Id int IDENTITY(1,1) NOT NULL CONSTRAINT PK_DON_HANG PRIMARY KEY,
        Ma AS ('PD' + RIGHT('000000' + CONVERT(varchar(10), Id), 6)) PERSISTED,
        -- Khach so huu don; NguoiTaoId la nguoi bam dat (chinh khach hoac nhan vien tao ho).
        TaiKhoanId int NOT NULL CONSTRAINT FK_DON_HANG_TAI_KHOAN REFERENCES dbo.TAI_KHOAN(Id),
        NguoiTaoId int NOT NULL CONSTRAINT FK_DON_HANG_NGUOI_TAO REFERENCES dbo.TAI_KHOAN(Id),
        MaGuiLap uniqueidentifier NOT NULL,
        TenNguoiNhan nvarchar(100) NOT NULL,
        DienThoai varchar(10) NOT NULL,
        DiaChi nvarchar(300) NOT NULL,
        GhiChu nvarchar(500) NOT NULL CONSTRAINT DF_DON_HANG_GhiChu DEFAULT N'',
        TienHang decimal(18,0) NOT NULL,
        PhiGiao decimal(18,0) NOT NULL,
        TongTien AS (TienHang + PhiGiao) PERSISTED,
        TrangThai varchar(20) NOT NULL CONSTRAINT DF_DON_HANG_TrangThai DEFAULT 'cho_xac_nhan',
        NgayDat datetime2 NOT NULL CONSTRAINT DF_DON_HANG_NgayDat DEFAULT SYSUTCDATETIME(),
        NgayCapNhat datetime2 NOT NULL CONSTRAINT DF_DON_HANG_NgayCapNhat DEFAULT SYSUTCDATETIME(),
        CONSTRAINT UQ_DON_HANG_MaGuiLap UNIQUE (MaGuiLap),
        CONSTRAINT CK_DON_HANG_TrangThai CHECK
            (TrangThai IN ('cho_xac_nhan', 'da_xac_nhan', 'dang_giao', 'da_giao', 'da_huy')),
        CONSTRAINT CK_DON_HANG_Tien CHECK (TienHang >= 0 AND PhiGiao >= 0),
        CONSTRAINT CK_DON_HANG_DienThoai CHECK
            (LEN(DienThoai) = 10 AND DienThoai LIKE '0%' AND DienThoai NOT LIKE '%[^0-9]%')
    );
    CREATE INDEX IX_DON_HANG_TaiKhoan ON dbo.DON_HANG(TaiKhoanId, NgayDat DESC);
    CREATE INDEX IX_DON_HANG_TrangThai ON dbo.DON_HANG(TrangThai, NgayDat DESC);
END;

IF OBJECT_ID(N'dbo.CHI_TIET_DON_HANG', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.CHI_TIET_DON_HANG
    (
        Id int IDENTITY(1,1) NOT NULL CONSTRAINT PK_CHI_TIET_DON_HANG PRIMARY KEY,
        DonHangId int NOT NULL CONSTRAINT FK_CHI_TIET_DON_HANG_DON_HANG REFERENCES dbo.DON_HANG(Id),
        ThuCungId int NOT NULL CONSTRAINT FK_CHI_TIET_DON_HANG_THU_CUNG REFERENCES dbo.THU_CUNG(Id),
        -- Ban chup ten va gia luc dat; sua ho so sau nay khong doi lich su don.
        TenThuCung nvarchar(80) NOT NULL,
        Gia decimal(18,0) NOT NULL CONSTRAINT CK_CHI_TIET_DON_HANG_Gia CHECK (Gia >= 0),
        CONSTRAINT UQ_CHI_TIET_DON_HANG UNIQUE (DonHangId, ThuCungId)
    );
    CREATE INDEX IX_CHI_TIET_DON_HANG_ThuCung ON dbo.CHI_TIET_DON_HANG(ThuCungId);
END;

COMMIT;
GO
