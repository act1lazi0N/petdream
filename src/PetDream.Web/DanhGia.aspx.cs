using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class DanhGia : TrangDanhGia
{
    protected override bool QuanTri { get { return false; } }
    protected override Literal ThongBao { get { return lit_thongbao; } }

    protected override void HienThi(DataRow dong, bool duocSua, bool duocDuyet)
    {
        lit_ten.Text = (string)dong["TenThuCung"];
        lnk_don.NavigateUrl = "~/ChiTietDonHang.aspx?id=" + dong["DonHangId"];
        frm_danhgia.Tai(dong, duocSua, false);
        btn_luu.Visible = duocSua;
        btn_xoa.Visible = duocSua && !dong.IsNull("TrangThai");
        pnl_danhgia.Visible = true;
    }

    protected void btn_luu_Click(object sender, EventArgs e)
    {
        Ghi("luu", frm_danhgia.SoSao, frm_danhgia.NoiDung);
    }

    protected void btn_xoa_Click(object sender, EventArgs e)
    {
        Ghi("xoa", null, null);
    }
}
