using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web;

public partial class QuanTriTaiKhoanSua : TrangTaiKhoan
{
    private int taiKhoanId;

    protected override void OnInit(EventArgs e)
    {
        if (TaiKhoanHienTai == null || TaiKhoanHienTai.VaiTro != "admin")
            throw new HttpException(403, "Bạn không có quyền quản lý tài khoản.");

        string ma = Request.QueryString["id"];
        if (ma != null && (!int.TryParse(ma, NumberStyles.None, CultureInfo.InvariantCulture, out taiKhoanId) || taiKhoanId <= 0))
            throw new HttpException(404, "Không tìm thấy tài khoản.");

        base.OnInit(e);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        bool taoMoi = taiKhoanId == 0;
        lit_tieude.Text = taoMoi ? "Thêm tài khoản" : "Thông tin tài khoản";
        pnl_matkhau.Visible = taoMoi;
        pnl_trangthai.Visible = !taoMoi;
        btn_xoa.Visible = !taoMoi;

        if (!IsPostBack && !taoMoi)
            NapTaiKhoan();
    }

    private void NapTaiKhoan()
    {
        try
        {
            DataRow dong = new DAO_QUAN_TRI_TAI_KHOAN().ChiTiet(TaiKhoanHienTai, taiKhoanId);
            if (dong == null)
                throw new HttpException(404, "Không tìm thấy tài khoản.");

            txt_hoten.Text = Convert.ToString(dong["HoTen"]);
            txt_email.Text = Convert.ToString(dong["Email"]);
            txt_dienthoai.Text = Convert.ToString(dong["DienThoai"]);
            ViewState["PhienBanMucTieu"] = Convert.ToInt32(dong["PhienBanXacThuc"]);
            ddl_vaitro.SelectedValue = Convert.ToString(dong["VaiTro"]);
            ddl_trangthai.SelectedValue = Convert.ToBoolean(dong["HoatDong"]) ? "1" : "0";
            if (Convert.ToBoolean(dong["DaXoa"]))
            {
                pnl_bieumau.Enabled = false;
                lit_thongbao.Text = "Tài khoản này đã được xóa mềm và chỉ có thể xem.";
            }
        }
        catch (SqlException ex) { BaoLoiDuLieu(lit_thongbao, ex); }
        catch (ConfigurationErrorsException ex) { BaoLoiDuLieu(lit_thongbao, ex); }
    }

    protected void btn_luu_Click(object sender, EventArgs e)
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

            string vaiTro = ddl_vaitro.SelectedValue;
            if (vaiTro != "admin" && vaiTro != "staff" && vaiTro != "khach")
            {
                lit_thongbao.Text = "Vai trò không hợp lệ.";
                return;
            }

            DAO_QUAN_TRI_TAI_KHOAN dao = new DAO_QUAN_TRI_TAI_KHOAN();
            string ketQua;
            if (taiKhoanId == 0)
            {
                if (!XacThucTaiKhoan.MatKhauMoiHopLe(txt_matkhau.Text, txt_xacnhan.Text))
                {
                    lit_thongbao.Text = "Mật khẩu cần từ 12 đến 128 ký tự và khớp với phần xác nhận.";
                    return;
                }
                ketQua = dao.Tao(TaiKhoanHienTai, hoSo, XacThucTaiKhoan.Bam(txt_matkhau.Text), vaiTro);
            }
            else
            {
                if (ddl_trangthai.SelectedValue != "0" && ddl_trangthai.SelectedValue != "1")
                {
                    lit_thongbao.Text = "Trạng thái không hợp lệ.";
                    return;
                }
                ketQua = dao.CapNhat(TaiKhoanHienTai, taiKhoanId, PhienBanMucTieu(), hoSo, vaiTro, ddl_trangthai.SelectedValue == "1", false);
            }
            XuLyKetQua(ketQua);
        });
    }

    protected void btn_xoa_Click(object sender, EventArgs e)
    {
        // Không dùng giá trị biểu mẫu cho thao tác xóa; đọc lại hồ sơ từ cơ sở dữ liệu.
        if (Request.HttpMethod != "POST")
            throw new HttpException(405, "Thao tác yêu cầu POST.");
        if (taiKhoanId == 0)
            throw new HttpException(404, "Không tìm thấy tài khoản.");

        try
        {
            DAO_QUAN_TRI_TAI_KHOAN dao = new DAO_QUAN_TRI_TAI_KHOAN();
            DataRow dong = dao.ChiTiet(TaiKhoanHienTai, taiKhoanId);
            if (dong == null)
                throw new HttpException(404, "Không tìm thấy tài khoản.");
            HoSoTaiKhoan hoSo = new HoSoTaiKhoan
            {
                HoTen = Convert.ToString(dong["HoTen"]),
                Email = Convert.ToString(dong["Email"]),
                DienThoai = Convert.ToString(dong["DienThoai"])
            };
            XuLyKetQua(dao.CapNhat(TaiKhoanHienTai, taiKhoanId, PhienBanMucTieu(), hoSo, Convert.ToString(dong["VaiTro"]), false, true));
        }
        catch (SqlException ex) { BaoLoiDuLieu(lit_thongbao, ex); }
        catch (ConfigurationErrorsException ex) { BaoLoiDuLieu(lit_thongbao, ex); }
    }

    private int PhienBanMucTieu()
    {
        return ViewState["PhienBanMucTieu"] is int ? (int)ViewState["PhienBanMucTieu"] : 0;
    }

    private void XuLyKetQua(string ketQua)
    {
        switch (ketQua)
        {
            case "thanh_cong":
                ChuyenTrang("~/Admin/TaiKhoan.aspx?luu=1");
                return;
            case "khong_du_quyen":
                throw new HttpException(403, "Bạn không có quyền quản lý tài khoản.");
            case "khong_tim_thay":
                throw new HttpException(404, "Không tìm thấy tài khoản.");
            case "admin_cuoi":
                lit_thongbao.Text = "Không thể khóa, xóa hoặc đổi quyền quản trị viên hoạt động cuối cùng.";
                return;
            case "trang_thai_doi":
                lit_thongbao.Text = "Quyền hoặc trạng thái tài khoản đã thay đổi. Vui lòng tải lại trang trước khi lưu.";
                return;
            default:
                lit_thongbao.Text = "Không thể lưu tài khoản. Hãy kiểm tra lại dữ liệu và trạng thái tài khoản.";
                return;
        }
    }
}
