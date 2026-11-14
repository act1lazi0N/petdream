USE PetDream;
GO
CREATE OR ALTER PROCEDURE dbo.sp_Loai_DanhSach
AS
BEGIN
    SET NOCOUNT ON;
    SELECT l.Id, l.Ma, l.Ten, l.MoTa, COUNT(t.Id) AS SoLuong
    FROM dbo.LOAI l
    LEFT JOIN dbo.THU_CUNG t ON t.LoaiId=l.Id AND t.DaXoa=0 AND t.TrangThai<>'ngung_ban'
    GROUP BY l.Id,l.Ma,l.Ten,l.MoTa,l.ThuTu ORDER BY l.ThuTu,l.Id;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_ThuCung_DanhSach
    @TuKhoa nvarchar(100)=N'', @LoaiId int=NULL, @GioiTinh char(1)=NULL,
    @GiaTu decimal(18,0)=NULL, @GiaDen decimal(18,0)=NULL,
    @SapXep varchar(10)='moi', @Trang int=1, @KichThuocTrang int=10, @NoiBat bit=NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF @Trang<1 OR @KichThuocTrang NOT BETWEEN 1 AND 30
        THROW 50001, 'Invalid pagination.', 1;
    IF @SapXep NOT IN ('moi','gia_tang','gia_giam') OR (@GiaTu IS NOT NULL AND @GiaTu<0)
        OR (@GiaDen IS NOT NULL AND @GiaDen<0) OR (@GiaTu>@GiaDen)
        THROW 50002, 'Invalid catalog filter.', 1;
    -- CHARINDEX tim chuoi literal: %, _ va [ khong tro thanh wildcard SQL.
    SELECT t.Id,t.Ma,t.LoaiId,t.Ten,t.Giong,t.GioiTinh,t.NgaySinh,t.Gia,t.TrangThai,t.NoiBat,t.NgayTao,
        l.Ten AS TenLoai, a.DuongDan,a.OAnh
    INTO #KetQua
    FROM dbo.THU_CUNG t
    INNER JOIN dbo.LOAI l ON l.Id=t.LoaiId
    OUTER APPLY (SELECT TOP (1) DuongDan,OAnh FROM dbo.ANH_THU_CUNG WHERE ThuCungId=t.Id ORDER BY ThuTu,Id) a
    WHERE t.DaXoa=0 AND t.TrangThai<>'ngung_ban'
        AND (@LoaiId IS NULL OR t.LoaiId=@LoaiId)
        AND (@GioiTinh IS NULL OR t.GioiTinh=@GioiTinh)
        AND (@GiaTu IS NULL OR t.Gia>=@GiaTu) AND (@GiaDen IS NULL OR t.Gia<=@GiaDen)
        AND (@NoiBat IS NULL OR t.NoiBat=@NoiBat)
        -- Latin1 CI_AI bo dau nguyen am; chuan hoa them d/đ cho tu khoa tieng Viet.
        AND (@TuKhoa=N'' OR CHARINDEX(REPLACE(@TuKhoa COLLATE Latin1_General_100_CI_AI,N'đ',N'd'),REPLACE(t.Ten COLLATE Latin1_General_100_CI_AI,N'đ',N'd'))>0
             OR CHARINDEX(REPLACE(@TuKhoa COLLATE Latin1_General_100_CI_AI,N'đ',N'd'),REPLACE(t.Giong COLLATE Latin1_General_100_CI_AI,N'đ',N'd'))>0);
    DECLARE @Tong int=(SELECT COUNT(*) FROM #KetQua);
    DECLARE @SoTrang int=CASE WHEN @Tong=0 THEN 1 ELSE ((@Tong-1)/@KichThuocTrang)+1 END;
    IF @Trang>@SoTrang SET @Trang=@SoTrang;
    SELECT @Tong AS Tong,@Trang AS Trang,@SoTrang AS SoTrang;
    SELECT * FROM #KetQua
    ORDER BY CASE WHEN @SapXep='gia_tang' THEN Gia END ASC,
             CASE WHEN @SapXep='gia_giam' THEN Gia END DESC,
             CASE WHEN @SapXep='moi' THEN NgayTao END DESC, Id DESC
    OFFSET (@Trang-1)*@KichThuocTrang ROWS FETCH NEXT @KichThuocTrang ROWS ONLY;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_ThuCung_ChiTiet @Id int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT t.*,l.Ten AS TenLoai FROM dbo.THU_CUNG t INNER JOIN dbo.LOAI l ON l.Id=t.LoaiId
    WHERE t.Id=@Id AND t.DaXoa=0 AND t.TrangThai<>'ngung_ban';
    SELECT a.* FROM dbo.ANH_THU_CUNG a INNER JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId
    WHERE t.Id=@Id AND t.DaXoa=0 AND t.TrangThai<>'ngung_ban' ORDER BY a.ThuTu,a.Id;
    SELECT TOP (4) t.Id,t.Ma,t.LoaiId,t.Ten,t.Giong,t.GioiTinh,t.NgaySinh,t.Gia,t.TrangThai,
        a.DuongDan,a.OAnh
    FROM dbo.THU_CUNG t
    OUTER APPLY (SELECT TOP (1) DuongDan,OAnh FROM dbo.ANH_THU_CUNG WHERE ThuCungId=t.Id ORDER BY ThuTu,Id) a
    WHERE t.LoaiId=(SELECT LoaiId FROM dbo.THU_CUNG WHERE Id=@Id AND DaXoa=0 AND TrangThai<>'ngung_ban')
        AND t.Id<>@Id AND t.DaXoa=0 AND t.TrangThai='dang_ban'
    ORDER BY t.NoiBat DESC,t.Id DESC;
END;
GO
