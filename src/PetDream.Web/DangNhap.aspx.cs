using System;

public partial class DangNhap : TrangTaiKhoan
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack && Request.QueryString["moi"] == "1")
            lit_thongbao.Text = "Đã tạo tài khoản. Bạn có thể đăng nhập.";
        else if (!IsPostBack && Request.QueryString["doimatkhau"] == "1")
            lit_thongbao.Text = "Đã đổi mật khẩu. Vui lòng đăng nhập lại.";
    }

    protected void btn_thuchien_Click(object sender, EventArgs e)
    {
        ThucHien(lit_thongbao, () =>
        {
            string email = HoSoTaiKhoan.ChuanHoaEmail(txt_dinhdanh.Text);
            string dienThoai = HoSoTaiKhoan.ChuanHoaDienThoai(txt_dinhdanh.Text);
            string matKhau = txt_matkhau.Text;
            if ((email == null && dienThoai == null) || matKhau.Length == 0 || matKhau.Length > 128)
            {
                lit_thongbao.Text = "Thông tin đăng nhập không hợp lệ.";
                return;
            }

            KetQuaDangNhap ketQua = XacThucTaiKhoan.ThuDangNhap(Context, email, dienThoai, matKhau);
            if (ketQua == KetQuaDangNhap.QuaGioiHan)
            {
                Response.StatusCode = 429;
                Response.TrySkipIisCustomErrors = true;
                Response.Headers["Retry-After"] = "300";
                lit_thongbao.Text = "Bạn đã thử đăng nhập nhiều lần. Vui lòng đợi vài phút rồi thử lại.";
                return;
            }

            if (ketQua == KetQuaDangNhap.SaiThongTin)
            {
                lit_thongbao.Text = "Thông tin đăng nhập không hợp lệ.";
                return;
            }

            switch (Request.QueryString["tiep"])
            {
                case "quantri":
                    ChuyenTrang("~/Admin/Default.aspx");
                    break;
                case "giohang":
                    ChuyenTrang("~/GioHang.aspx");
                    break;
                default:
                    ChuyenTrang("~/TaiKhoan.aspx");
                    break;
            }
        });
    }
}
