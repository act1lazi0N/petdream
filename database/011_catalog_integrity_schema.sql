-- Chay sau 001-005, 007-008 va truoc 010. Khong thay doi ma hoac xoa du lieu cu.
USE PetDream;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF COL_LENGTH(N'dbo.LOAI', N'DaXoa') IS NULL
    ALTER TABLE dbo.LOAI ADD DaXoa bit NOT NULL
        CONSTRAINT DF_LOAI_DaXoa DEFAULT (0) WITH VALUES;
GO

-- Sequence khong reset khi chay lai; gia tri da dung khong duoc tai su dung.
IF OBJECT_ID(N'dbo.SeqMaLoai', N'SO') IS NULL
    EXEC(N'CREATE SEQUENCE dbo.SeqMaLoai AS bigint START WITH 1 INCREMENT BY 1 MAXVALUE 999999999999 NO CYCLE');
IF OBJECT_ID(N'dbo.SeqMaThuCung', N'SO') IS NULL
    EXEC(N'CREATE SEQUENCE dbo.SeqMaThuCung AS bigint START WITH 1 INCREMENT BY 1 MAXVALUE 999999999999 NO CYCLE');
GO

-- Bao ve ma ca khi co thao tac SQL khong di qua giao dien quan tri.
CREATE OR ALTER TRIGGER dbo.tr_LOAI_KhongDoiMa ON dbo.LOAI
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM inserted i INNER JOIN deleted d ON i.Id = d.Id
               WHERE DATALENGTH(i.Ma) <> DATALENGTH(d.Ma)
                  OR i.Ma COLLATE Latin1_General_100_BIN2 <> d.Ma COLLATE Latin1_General_100_BIN2)
        THROW 51010, 'Ma loai khong the thay doi.', 1;
END;
GO
CREATE OR ALTER TRIGGER dbo.tr_THU_CUNG_KhongDoiMa ON dbo.THU_CUNG
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM inserted i INNER JOIN deleted d ON i.Id = d.Id
               WHERE DATALENGTH(i.Ma) <> DATALENGTH(d.Ma)
                  OR i.Ma COLLATE Latin1_General_100_BIN2 <> d.Ma COLLATE Latin1_General_100_BIN2)
        THROW 51011, 'Ma thu cung khong the thay doi.', 1;
END;
GO

-- Danh muc cong khai khong hien thi loai da luu tru.
CREATE OR ALTER PROCEDURE dbo.sp_Loai_DanhSach
AS
BEGIN
    SET NOCOUNT ON;
    SELECT l.Id, l.Ma, l.Ten, l.MoTa, COUNT(t.Id) AS SoLuong
    FROM dbo.LOAI l
    LEFT JOIN dbo.THU_CUNG t ON t.LoaiId=l.Id AND t.DaXoa=0 AND t.TrangThai<>'ngung_ban'
    WHERE l.DaXoa=0
    GROUP BY l.Id,l.Ma,l.Ten,l.MoTa,l.ThuTu ORDER BY l.ThuTu,l.Id;
END;
GO
