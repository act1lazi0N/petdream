using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web;

public partial class QuanTriTongQuan : TrangTaiKhoan
{
    protected override void OnInit(EventArgs e)
    {
        if (!XacThucTaiKhoan.LaQuanTri(TaiKhoanHienTai))
            throw new HttpException(403, "Bạn không có quyền truy cập trang này.");
        base.OnInit(e);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
            return;

        try
        {
            DataSet duLieu = new DAO_TONG_QUAN_QUAN_TRI().TongQuan(TaiKhoanHienTai);
            if (duLieu.Tables.Count < 2 || duLieu.Tables[0].Rows.Count == 0)
                throw new HttpException(403, "Bạn không có quyền truy cập trang này.");

            DataRow thongKe = duLieu.Tables[0].Rows[0];
            lit_soloai.Text = So(thongKe["SoLoai"]);
            lit_dangtimchu.Text = So(thongKe["DangTimChu"]);
            lit_danggiucho.Text = So(thongKe["DangGiuCho"]);
            lit_dacoam.Text = So(thongKe["DaCoMaiAm"]);
            lit_doncho.Text = So(thongKe["DonChoXacNhan"]);
            bool coDon = duLieu.Tables[1].Rows.Count > 0;
            pnl_khongdon.Visible = !coDon;
            pnl_donhang.Visible = coDon;
            rpt_donhang.DataSource = duLieu.Tables[1];
            rpt_donhang.DataBind();
            pnl_tongquan.Visible = true;
        }
        catch (SqlException ex) { pnl_loi.Visible = true; BaoLoiDuLieu(lit_loi, ex); }
        catch (ConfigurationErrorsException ex) { pnl_loi.Visible = true; BaoLoiDuLieu(lit_loi, ex); }
    }

    private static string So(object value)
    {
        return Convert.ToInt32(value).ToString("N0", CultureInfo.GetCultureInfo("vi-VN"));
    }
}
