using System;

public partial class DangKy : TrangTaiKhoan
{
    protected void btn_thuchien_Click(object sender, EventArgs e)
    {
        ThucHien(lit_thongbao, () =>
        {
            HoSoTaiKhoan hoSo;
            string loi;
            if (!HoSoTaiKhoan.ThuDoc(txt_hoten.Text, txt_email.Text, txt_dienthoai.Text, out hoSo, out loi))
            {
                lit_thongbao.Text = loi;
                return;
            }

            if (!XacThucTaiKhoan.MatKhauMoiHopLe(txt_matkhau.Text, txt_xacnhan.Text))
            {
                lit_thongbao.Text = "Mật khẩu cần từ 12 đến 128 ký tự và khớp với phần xác nhận.";
                return;
            }

            new DAO_TAI_KHOAN().DangKy(hoSo, XacThucTaiKhoan.Bam(txt_matkhau.Text));
            ChuyenTrang("~/DangNhap.aspx?moi=1");
        });
    }
}
