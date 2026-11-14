-- Bao toan ma don cu, tranh cat ID va trung ma khi vuot 6 chu so.
-- Chay sau 007. Khong thay doi ma cua don hang hien co.
USE PetDream;
GO
SET XACT_ABORT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes
               WHERE object_id = OBJECT_ID(N'dbo.DON_HANG') AND name = N'UX_DON_HANG_Ma_PetDream')
BEGIN
    BEGIN TRANSACTION;
    -- Chan checkout trong luc doi bieu thuc, bao dam khong co don moi chen vao
    -- sau khi kiem tra ma lich su. Kiem tra lai neu hai lan nang cap chay dong thoi.
    DECLARE @IdLonNhat int;
    SELECT @IdLonNhat = MAX(Id) FROM dbo.DON_HANG WITH (TABLOCKX, HOLDLOCK);
    IF EXISTS (SELECT 1 FROM sys.indexes
               WHERE object_id = OBJECT_ID(N'dbo.DON_HANG') AND name = N'UX_DON_HANG_Ma_PetDream')
    BEGIN
        COMMIT TRANSACTION;
        RETURN;
    END;
    -- Bieu thuc cu da cat ID sau 6 chu so. Khong tu dong doi ma lich su
    -- neu database da co don nhu vay: can kiem tra va xu ly thu cong.
    IF @IdLonNhat >= 1000000
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 51030, N'Co don hang tren 6 chu so; can doi chieu ma lich su truoc khi nang cap.', 1;
    END;

    ALTER TABLE dbo.DON_HANG DROP COLUMN Ma;
    ALTER TABLE dbo.DON_HANG ADD Ma AS CONVERT(varchar(12),
        'PD' + REPLICATE('0', CASE WHEN LEN(CONVERT(varchar(10), Id)) < 6
            THEN 6 - LEN(CONVERT(varchar(10), Id)) ELSE 0 END)
            + CONVERT(varchar(10), Id)) PERSISTED;
    CREATE UNIQUE INDEX UX_DON_HANG_Ma_PetDream ON dbo.DON_HANG(Ma);
    COMMIT TRANSACTION;
END;
GO
