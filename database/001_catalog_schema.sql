-- Chay trong SSMS tren (localdb)\MSSQLLocalDB. Khong xoa database da co.
IF DB_ID(N'PetDream') IS NULL
    CREATE DATABASE PetDream;
GO
USE PetDream;
GO
SET XACT_ABORT ON;
BEGIN TRANSACTION;
IF OBJECT_ID(N'dbo.LOAI', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.LOAI (
        Id int IDENTITY(1,1) NOT NULL CONSTRAINT PK_LOAI PRIMARY KEY,
        Ma varchar(20) NOT NULL CONSTRAINT UQ_LOAI_Ma UNIQUE,
        Ten nvarchar(60) NOT NULL,
        MoTa nvarchar(250) NOT NULL,
        ThuTu int NOT NULL DEFAULT 0
    );
END;
IF OBJECT_ID(N'dbo.THU_CUNG', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.THU_CUNG (
        Id int IDENTITY(1,1) NOT NULL CONSTRAINT PK_THU_CUNG PRIMARY KEY,
        Ma varchar(30) NOT NULL CONSTRAINT UQ_THU_CUNG_Ma UNIQUE,
        LoaiId int NOT NULL CONSTRAINT FK_THU_CUNG_LOAI REFERENCES dbo.LOAI(Id),
        Ten nvarchar(80) NOT NULL,
        Giong nvarchar(100) NOT NULL,
        GioiTinh char(1) NOT NULL CONSTRAINT CK_THU_CUNG_GioiTinh CHECK (GioiTinh IN ('D','C')),
        NgaySinh date NOT NULL,
        CanNang decimal(6,2) NOT NULL CONSTRAINT CK_THU_CUNG_CanNang CHECK (CanNang > 0),
        KichThuoc nvarchar(100) NOT NULL,
        Gia decimal(18,0) NOT NULL CONSTRAINT CK_THU_CUNG_Gia CHECK (Gia >= 0),
        MoTa nvarchar(2000) NOT NULL,
        TiemChung nvarchar(1000) NOT NULL,
        DacDiem nvarchar(1000) NOT NULL,
        TrangThai varchar(20) NOT NULL DEFAULT 'dang_ban'
            CONSTRAINT CK_THU_CUNG_TrangThai CHECK (TrangThai IN ('dang_ban','giu_cho','da_ban','ngung_ban')),
        NoiBat bit NOT NULL DEFAULT 0,
        DaXoa bit NOT NULL DEFAULT 0,
        NgayTao datetime2 NOT NULL DEFAULT SYSUTCDATETIME()
    );
    CREATE INDEX IX_THU_CUNG_DanhMuc ON dbo.THU_CUNG(LoaiId, DaXoa, TrangThai, Gia, Id);
END;
IF OBJECT_ID(N'dbo.ANH_THU_CUNG', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.ANH_THU_CUNG (
        Id int IDENTITY(1,1) NOT NULL CONSTRAINT PK_ANH_THU_CUNG PRIMARY KEY,
        ThuCungId int NOT NULL CONSTRAINT FK_ANH_THU_CUNG_THU_CUNG REFERENCES dbo.THU_CUNG(Id),
        DuongDan nvarchar(250) NOT NULL,
        OAnh tinyint NOT NULL CONSTRAINT CK_ANH_THU_CUNG_OAnh CHECK (OAnh BETWEEN 0 AND 9),
        ThuTu int NOT NULL DEFAULT 0,
        CONSTRAINT UQ_ANH_THU_CUNG_ThuTu UNIQUE (ThuCungId, ThuTu)
    );
END;
COMMIT;
GO
