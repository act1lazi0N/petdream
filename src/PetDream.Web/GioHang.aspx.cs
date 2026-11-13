using System;
using System.Configuration;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;

public partial class GioHang : TrangCoCsrf
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
            return;

        if (Request.QueryString["them"] == "1")
            lit_thongbao.Text = "Bé đã có trong giỏ.";
        else if (Request.QueryString["them"] == "khongcon")
            lit_thongbao.Text = "Bé hiện không còn nhận thêm vào giỏ.";

        HienThiGioHang();
    }

    protected void rpt_giohang_ItemCommand(object sender, RepeaterCommandEventArgs e)
    {
        if (Request.HttpMethod != "POST")
            throw new HttpException(405, "Thao tác yêu cầu POST.");

        int id;
        if (e.CommandName == "Xoa" && int.TryParse(Convert.ToString(e.CommandArgument), out id))
        {
            GioHangPhien.Xoa(Session, id);
            ChuyenTrang("~/GioHang.aspx");
        }
    }

    private void HienThiGioHang()
    {
        var ids = GioHangPhien.DanhSachId(Session);
        pnl_trong.Visible = ids.Count == 0;
        if (ids.Count == 0)
            return;

        try
        {
            List<DongGioHang> cacDong = DongGioHang.Doc(ids);
            rpt_giohang.DataSource = cacDong;
            rpt_giohang.DataBind();
            lit_tong.Text = HienThiThuCung.Gia(cacDong.Sum(dong => dong.Tien ?? 0));

            // Chỉ cho sang bước đặt hàng khi mọi bé trong giỏ còn đang tìm chủ.
            bool coTheDat = cacDong.All(dong => dong.DangBan);
            bool daDangNhap = XacThucTaiKhoan.HienTai(Context) != null;
            pnl_thaydoi.Visible = !coTheDat;
            lnk_dangnhap.Visible = coTheDat && !daDangNhap;
            lnk_dathang.Visible = coTheDat && daDangNhap;
            pnl_giohang.Visible = true;
        }
        catch (SqlException ex) { BaoLoiDuLieu(ex); }
        catch (ConfigurationErrorsException ex) { BaoLoiDuLieu(ex); }
    }

    private void BaoLoiDuLieu(Exception ex)
    {
        Trace.Warn("GioHang", "Không đọc được giỏ hàng.", ex);
        Response.StatusCode = 503;
        Response.TrySkipIisCustomErrors = true;
        lit_thongbao.Text = "Giỏ hàng tạm thời chưa sẵn sàng. Vui lòng thử lại sau.";
    }
}
