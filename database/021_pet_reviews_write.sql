USE PetDream;
GO
CREATE OR ALTER PROCEDURE dbo.sp_DanhGia_Ghi
    @NguoiId int, @PhienBanNguoi int, @ChiTietId int, @QuanTri bit,
    @ThaoTac varchar(10), @PhienBan binary(8)=NULL, @SoSao tinyint=NULL, @NoiDung nvarchar(1000)=NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    IF @ThaoTac IS NULL OR @ThaoTac NOT IN ('luu','xoa','duyet','an') OR @QuanTri IS NULL
       OR (@ThaoTac='luu' AND (@SoSao IS NULL OR @SoSao NOT BETWEEN 1 AND 5
                               OR @NoiDung IS NULL OR LEN(TRIM(@NoiDung))=0))
    BEGIN SELECT 'khong_hop_le'; RETURN; END;

    BEGIN TRY
        BEGIN TRANSACTION;
        DECLARE @VaiTro varchar(10), @KhachId int;
        SELECT @VaiTro=VaiTro FROM dbo.TAI_KHOAN WITH (UPDLOCK,HOLDLOCK)
        WHERE Id=@NguoiId AND PhienBanXacThuc=@PhienBanNguoi AND HoatDong=1 AND DaXoa=0;

        IF @VaiTro IS NULL OR (@QuanTri=0 AND (@VaiTro<>'khach' OR @ThaoTac NOT IN ('luu','xoa')))
           OR (@QuanTri=1 AND (@VaiTro NOT IN ('staff','admin') OR (@VaiTro='staff' AND @ThaoTac IN ('luu','xoa'))))
        BEGIN ROLLBACK; SELECT 'khong_du_quyen'; RETURN; END;

        SELECT @KhachId=d.TaiKhoanId FROM dbo.CHI_TIET_DON_HANG c
        JOIN dbo.DON_HANG d ON d.Id=c.DonHangId
        WHERE c.Id=@ChiTietId AND d.TrangThai='da_giao';
        IF @KhachId IS NULL OR (@QuanTri=0 AND @KhachId<>@NguoiId)
        BEGIN ROLLBACK; SELECT 'khong_tim_thay'; RETURN; END;

        DECLARE @Id int, @TrangThai varchar(12), @PhienBanCu binary(8), @QuanTriNhap bit;
        SELECT @Id=Id, @TrangThai=TrangThai, @PhienBanCu=PhienBan, @QuanTriNhap=QuanTriNhap
        FROM dbo.DANH_GIA WITH (UPDLOCK,HOLDLOCK) WHERE ChiTietDonHangId=@ChiTietId;

        IF @TrangThai<>'da_xoa' AND @QuanTri=0 AND @QuanTriNhap=1
        BEGIN ROLLBACK; SELECT 'khong_du_quyen'; RETURN; END;

        IF @ThaoTac='luu' AND @PhienBan IS NULL AND (@Id IS NULL OR @TrangThai='da_xoa')
        BEGIN
            IF @Id IS NULL
                INSERT dbo.DANH_GIA (ChiTietDonHangId,NguoiNhapId,QuanTriNhap,SoSao,NoiDung,TrangThai)
                VALUES (@ChiTietId,@NguoiId,@QuanTri,@SoSao,@NoiDung,'cho_duyet');
            ELSE
                UPDATE dbo.DANH_GIA
                SET NguoiNhapId=@NguoiId, QuanTriNhap=@QuanTri, SoSao=@SoSao, NoiDung=@NoiDung,
                    TrangThai='cho_duyet', NgayCapNhat=SYSUTCDATETIME()
                WHERE Id=@Id;
        END
        ELSE
        BEGIN
            IF @Id IS NULL OR @TrangThai='da_xoa' OR @PhienBan IS NULL OR @PhienBan<>@PhienBanCu
            BEGIN ROLLBACK; SELECT 'da_thay_doi'; RETURN; END;

            UPDATE dbo.DANH_GIA
            SET SoSao=CASE WHEN @ThaoTac='luu' THEN @SoSao ELSE SoSao END,
                NoiDung=CASE WHEN @ThaoTac='luu' THEN @NoiDung ELSE NoiDung END,
                TrangThai=CASE @ThaoTac WHEN 'luu' THEN 'cho_duyet' WHEN 'duyet' THEN 'da_duyet'
                                        WHEN 'an' THEN 'da_an' ELSE 'da_xoa' END,
                NgayCapNhat=SYSUTCDATETIME()
            WHERE Id=@Id;
        END;

        COMMIT;
        SELECT 'thanh_cong';
    END TRY
    BEGIN CATCH
        IF XACT_STATE()<>0 ROLLBACK;
        THROW;
    END CATCH;
END;
GO
