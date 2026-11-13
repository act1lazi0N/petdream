using System;
using System.Data;

public partial class DonHang : TrangDonHang
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
            return;

        DocDuLieu(lit_thongbao, () =>
        {
            DataTable donHang = new DAO_DON_HANG().LichSu(TaiKhoanHienTai.Id);
            rpt_donhang.DataSource = donHang;
            rpt_donhang.DataBind();
            pnl_trong.Visible = donHang.Rows.Count == 0;
        });
    }
}
