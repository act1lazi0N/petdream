-- F07: luu tru mem don da huy, khong xoa lich su hoac doi trang thai.
USE PetDream;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
IF COL_LENGTH(N'dbo.DON_HANG', N'DaLuuTru') IS NULL
    ALTER TABLE dbo.DON_HANG ADD DaLuuTru bit NOT NULL
        CONSTRAINT DF_DON_HANG_DaLuuTru DEFAULT (0) WITH VALUES;
GO
