using System;

public partial class DangXuat : TrangTaiKhoan
{
    protected void btn_thuchien_Click(object sender, EventArgs e)
    {
        ThucHien(lit_thongbao, () =>
        {
            XacThucTaiKhoan.DangXuat(Context);
            ChuyenTrang("~/Default.aspx");
        });
    }
}
