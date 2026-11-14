using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class QuanTriDanhGiaSua : TrangDanhGia
{
    protected override bool QuanTri { get { return true; } }
    protected override Literal ThongBao { get { return lit_thongbao; } }

    protected override void HienThi(DataRow dong, bool duocSua, bool duocDuyet)
    {
        lit_ten.Text = (string)dong["TenThuCung"];
        lit_madon.Text = (string)dong["MaDon"];
        frm_danhgia.Tai(dong, duocSua, true);
        btn_luu.Visible = duocSua;
        btn_xoa.Visible = duocSua && duocDuyet;
        btn_duyet.Visible = duocDuyet && Convert.ToString(dong["TrangThai"]) != "da_duyet";
        btn_an.Visible = duocDuyet && Convert.ToString(dong["TrangThai"]) != "da_an";
        pnl_danhgia.Visible = true;
    }

    protected void btn_ghi_Click(object sender, EventArgs e)
    {
        Ghi(((Button)sender).CommandArgument, frm_danhgia.SoSao, frm_danhgia.NoiDung);
    }
}
