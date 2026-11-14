USE PetDream;
GO
SET XACT_ABORT ON;
BEGIN TRANSACTION;

IF OBJECT_ID(N'dbo.DANH_GIA', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.DANH_GIA
    (
        Id int IDENTITY(1,1) CONSTRAINT PK_DANH_GIA PRIMARY KEY,
        ChiTietDonHangId int NOT NULL CONSTRAINT UQ_DANH_GIA_ChiTiet UNIQUE
            CONSTRAINT FK_DANH_GIA_ChiTiet REFERENCES dbo.CHI_TIET_DON_HANG(Id),
        NguoiNhapId int NOT NULL CONSTRAINT FK_DANH_GIA_NguoiNhap REFERENCES dbo.TAI_KHOAN(Id),
        QuanTriNhap bit NOT NULL,
        SoSao tinyint NOT NULL CONSTRAINT CK_DANH_GIA_SoSao CHECK (SoSao BETWEEN 1 AND 5),
        NoiDung nvarchar(1000) NOT NULL CONSTRAINT CK_DANH_GIA_NoiDung CHECK (LEN(TRIM(NoiDung)) > 0),
        TrangThai varchar(12) NOT NULL CONSTRAINT CK_DANH_GIA_TrangThai
            CHECK (TrangThai IN ('cho_duyet', 'da_duyet', 'da_an', 'da_xoa')),
        NgayCapNhat datetime2 NOT NULL CONSTRAINT DF_DANH_GIA_Ngay DEFAULT SYSUTCDATETIME(),
        PhienBan rowversion NOT NULL
    );
END;

COMMIT;
GO
