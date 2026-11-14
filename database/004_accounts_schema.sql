USE PetDream;
GO
SET XACT_ABORT ON;

IF OBJECT_ID(N'dbo.TAI_KHOAN', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.TAI_KHOAN
    (
        Id int IDENTITY(1,1) CONSTRAINT PK_TAI_KHOAN PRIMARY KEY,
        HoTen nvarchar(100) NOT NULL,
        Email nvarchar(254) COLLATE Latin1_General_100_BIN2 NOT NULL,
        DienThoai varchar(10) COLLATE Latin1_General_100_BIN2 NOT NULL,
        MatKhauBam varchar(100) NOT NULL,
        VaiTro varchar(10) COLLATE Latin1_General_100_BIN2 NOT NULL
            CONSTRAINT DF_TAI_KHOAN_VaiTro DEFAULT 'khach',
        HoatDong bit NOT NULL CONSTRAINT DF_TAI_KHOAN_HoatDong DEFAULT 1,
        DaXoa bit NOT NULL CONSTRAINT DF_TAI_KHOAN_DaXoa DEFAULT 0,
        PhienBanXacThuc int NOT NULL CONSTRAINT DF_TAI_KHOAN_PhienBan DEFAULT 1,
        NgayTao datetime2 NOT NULL CONSTRAINT DF_TAI_KHOAN_NgayTao DEFAULT SYSUTCDATETIME(),
        CONSTRAINT UQ_TAI_KHOAN_Email UNIQUE (Email),
        CONSTRAINT UQ_TAI_KHOAN_DienThoai UNIQUE (DienThoai),
        CONSTRAINT CK_TAI_KHOAN_DienThoai CHECK
            (LEN(DienThoai) = 10 AND DienThoai LIKE '0%' AND DienThoai NOT LIKE '%[^0-9]%'),
        CONSTRAINT CK_TAI_KHOAN_VaiTro CHECK (VaiTro IN ('khach', 'staff', 'admin')),
        CONSTRAINT CK_TAI_KHOAN_PhienBan CHECK (PhienBanXacThuc >= 1)
    );
END;
GO
