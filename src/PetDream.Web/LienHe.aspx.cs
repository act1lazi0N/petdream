using System;
using System.Collections.Generic;
using System.Web;
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
            lit_thongbao.Text = "Cảm ơn bạn! Lời nhắn đã được gửi thành công, PetDream sẽ phản hồi sớm nhất.";

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
        if (Request.HttpMethod != "POST")
            throw new HttpException(405, "Thao tác yêu cầu POST.");

        Page.Validate();
        if (!Page.IsValid)
            return;

        ThongTinLienHe thongTin;
        string loi;
        if (!ThongTinLienHe.ThuDoc(txt_hoten.Text, txt_email.Text, txt_dienthoai.Text, ddl_chude.SelectedValue,
            txt_noidung.Text, out thongTin, out loi))
        {
            Response.StatusCode = 400;
            Response.TrySkipIisCustomErrors = true;
            lit_thongbao.Text = loi;
            return;
        }

        // V1 không gửi email/lưu yêu cầu: chuyển hướng sau POST để F5 không gửi lại biểu mẫu và form được làm trống.
        ChuyenTrang("~/LienHe.aspx?gui=1");
    }
}
