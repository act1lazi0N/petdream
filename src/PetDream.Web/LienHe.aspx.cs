using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;

public partial class LienHe : TrangCoCsrf
{
    // Trang mở được cả HTTP lẫn HTTPS; cookie Session chỉ đi qua HTTPS nên CSRF chỉ áp dụng khi có HTTPS,
    // giống trang chi tiết thú cưng. Trang không ghi dữ liệu nào.
    protected override bool BaoVeBieuMau
    {
        get { return Request.IsSecureConnection; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
            return;

        ddl_chude.Items.Add(new ListItem("Chọn chủ đề", ""));
        foreach (KeyValuePair<string, string> chuDe in ThongTinLienHe.ChuDe)
            ddl_chude.Items.Add(new ListItem(chuDe.Value, chuDe.Key));

        if (Request.QueryString["gui"] == "1")
            lit_thongbao.Text = "Chức năng tiếp nhận lời nhắn hiện chưa khả dụng.";

        // Điền sẵn thông tin khi khách đã đăng nhập (chỉ có trên HTTPS).
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
        // Chưa có kênh tiếp nhận; không thông báo gửi thành công khi chưa lưu hoặc gửi lời nhắn.
        Response.StatusCode = 503;
        Response.TrySkipIisCustomErrors = true;
        lit_thongbao.Text = "Chức năng tiếp nhận lời nhắn hiện chưa khả dụng.";
        return;
    }

}
