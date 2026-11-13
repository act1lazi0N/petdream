using System;
using System.Data;
using System.Globalization;

public partial class ChiTietDonHang : TrangDonHang
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
            return;

        if (Request.QueryString["moi"] == "1")
            lit_thongbao.Text = "Đặt hàng thành công! Các bé đã được giữ chỗ cho bạn. PetDream sẽ liên hệ để xác nhận đơn.";
        else if (Request.QueryString["huy"] == "1")
            lit_thongbao.Text = "Đã hủy đơn hàng.";

        HienThiDon();
    }

    protected void btn_huy_Click(object sender, EventArgs e)
    {
        int id;
        if (!DocIdDon(out id))
        {
            KhongTimThay();
            return;
        }

        ThucHien(lit_thongbao, () =>
        {
            // Khách chỉ được hủy đơn của mình khi còn chờ xác nhận; procedure kiểm tra lại cả hai điều kiện.
            string ketQua = new DAO_DON_HANG().ChuyenTrangThai(id, "cho_xac_nhan", "da_huy", TaiKhoanHienTai.Id);
            switch (ketQua)
            {
                case "thanh_cong":
                    ChuyenTrang("~/ChiTietDonHang.aspx?id=" + id.ToString(CultureInfo.InvariantCulture) + "&huy=1");
                    break;
                case "khong_tim_thay":
                    KhongTimThay();
                    break;
                default:
                    Response.StatusCode = 409;
                    Response.TrySkipIisCustomErrors = true;
                    HienThiDon();
                    lit_thongbao.Text = "Đơn hàng đã được PetDream xử lý nên không thể tự hủy. Vui lòng liên hệ cửa hàng.";
                    break;
            }
        });
    }

    private void HienThiDon()
    {
        int id;
        if (!DocIdDon(out id))
        {
            KhongTimThay();
            return;
        }

        DocDuLieu(lit_thongbao, () =>
        {
            DataSet duLieu = new DAO_DON_HANG().ChiTiet(id, TaiKhoanHienTai.Id);
            if (duLieu.Tables[0].Rows.Count == 0)
            {
                KhongTimThay();
                return;
            }

            DataRow don = duLieu.Tables[0].Rows[0];
            string trangThai = (string)don["TrangThai"];
            Title = "Đơn " + (string)don["Ma"] + " | PetDream";
            lit_ma.Text = (string)don["Ma"];
            lbl_trangthai.Text = HienThiDonHang.TrangThai(trangThai);
            lbl_trangthai.CssClass = HienThiDonHang.LopTrangThai(trangThai);
            lit_ngaydat.Text = HienThiDonHang.Ngay(don["NgayDat"]);
            lit_ten.Text = (string)don["TenNguoiNhan"];
            lit_dienthoai.Text = (string)don["DienThoai"];
            lit_diachi.Text = (string)don["DiaChi"];
            lit_ghichu.Text = (string)don["GhiChu"] == "" ? "Không có" : (string)don["GhiChu"];
            lit_tienhang.Text = HienThiThuCung.Gia(don["TienHang"]);
            lit_phigiao.Text = HienThiThuCung.Gia(don["PhiGiao"]);
            lit_tong.Text = HienThiThuCung.Gia(don["TongTien"]);
            pnl_huy.Visible = trangThai == "cho_xac_nhan";

            rpt_be.DataSource = duLieu.Tables[1];
            rpt_be.DataBind();
            pnl_don.Visible = true;
        });
    }

    private void KhongTimThay()
    {
        Response.StatusCode = 404;
        Response.TrySkipIisCustomErrors = true;
        lit_thongbao.Text = "";
        pnl_don.Visible = false;
        pnl_khongthay.Visible = true;
    }
}
