USE PetDream;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER PROCEDURE dbo.sp_ThuCung_DocGioHang @DanhSachId xml
AS
BEGIN
    SET NOCOUNT ON;

    SELECT t.Id, t.Ten, t.Gia, t.TrangThai, a.DuongDan, a.OAnh
    FROM dbo.THU_CUNG t
    INNER JOIN (
        SELECT DISTINCT x.Id.value('(text())[1]', 'int') AS Id
        FROM @DanhSachId.nodes('/gio/id') AS x(Id)
    ) g ON g.Id=t.Id
    OUTER APPLY (
        SELECT TOP (1) DuongDan, OAnh
        FROM dbo.ANH_THU_CUNG
        WHERE ThuCungId=t.Id
        ORDER BY ThuTu, Id
    ) a
    WHERE t.DaXoa=0 AND t.TrangThai<>'ngung_ban';
END;
GO
