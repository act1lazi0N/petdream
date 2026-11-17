using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI.WebControls;

public partial class LienHe : TrangCoCsrf
{
    // Trang không ghi dữ liệu nào; biểu mẫu vẫn được bảo vệ CSRF như các trang khác.
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
            return;

        ddl_chude.Items.Add(new ListItem("Chọn chủ đề", ""));
        foreach (KeyValuePair<string, string> chuDe in ThongTinLienHe.ChuDe)
            ddl_chude.Items.Add(new ListItem(chuDe.Value, chuDe.Key));

        if (Request.QueryString["gui"] == "1")
            lit_thongbao.Text = "Biểu mẫu thử nghiệm đã gửi thành công.";

        // Điền sẵn thông tin khi khách đã đăng nhập.
        DanhTinhTaiKhoan taiKhoan = XacThucTaiKhoan.HienTai(Context);
        if (taiKhoan != null)
        {
            txt_hoten.Text = taiKhoan.HoTen;
            txt_email.Text = taiKhoan.Email;
            txt_dienthoai.Text = taiKhoan.DienThoai;
        }
    }

    protected void btn_gui_Click(object sender, EventArgs e)
    {
        if (Request.HttpMethod != "POST")
            throw new HttpException(405, "Thao tác yêu cầu POST.");

        if (!Page.IsValid)
        {
            BaoLoiBieuMau("Vui lòng điền các trường bắt buộc.");
            return;
        }

        string loi;
        if (!ThongTinLienHe.HopLe(txt_hoten.Text, txt_email.Text, txt_dienthoai.Text,
            ddl_chude.SelectedValue, txt_noidung.Text, out loi))
        {
            BaoLoiBieuMau(loi);
            return;
        }

        ChuyenTrang("~/LienHe.aspx?gui=1");
    }

    private void BaoLoiBieuMau(string loi)
    {
        Response.StatusCode = 400;
        Response.TrySkipIisCustomErrors = true;
        lit_thongbao.Text = loi;
    }
}
