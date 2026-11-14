using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web;

public partial class QuanTriChiTietDonHang : TrangTaiKhoan
{
    private int donHangId;

    private bool LaAdmin
    {
        get { return TaiKhoanHienTai != null && TaiKhoanHienTai.VaiTro == "admin"; }
    }

    protected override string ThongBaoLoiDuLieu
    {
        get { return "Không thể tải thông tin đơn hàng. Vui lòng thử lại sau."; }
    }

    protected override void OnInit(EventArgs e)
    {
        if (!XacThucTaiKhoan.LaQuanTri(TaiKhoanHienTai))
            throw new HttpException(403, "Bạn không có quyền quản lý đơn hàng.");
        if (!int.TryParse(Request.QueryString["id"], NumberStyles.None, CultureInfo.InvariantCulture, out donHangId) || donHangId <= 0)
            throw new HttpException(404, "Không tìm thấy đơn hàng.");
        base.OnInit(e);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["moi"] == "1")
                lit_thongbao.Text = "Đã tạo đơn hàng. Các bé trong đơn đang được giữ chỗ.";
            else if (Request.QueryString["capnhat"] == "1")
                lit_thongbao.Text = "Đã cập nhật trạng thái đơn hàng.";
            HienThiDon();
        }
        else
            HienThiHanhDong(ViewState["TrangThaiCu"] as string, ViewState["DaLuuTru"] is bool && (bool)ViewState["DaLuuTru"]);
    }

    protected void btn_tieptuc_Click(object sender, EventArgs e)
    {
        ThucHien(lit_thongbao, () =>
        {
            string trangThaiCu = ViewState["TrangThaiCu"] as string;
            string trangThaiMoi = TrangThaiTiepTheo(trangThaiCu);
            if (trangThaiMoi == null)
            {
                BaoTrangThaiDoi();
                return;
            }
            XuLy(new DAO_QUAN_TRI_DON_HANG().ChuyenTrangThai(TaiKhoanHienTai, donHangId, trangThaiCu, trangThaiMoi), false);
        });
    }

    protected void btn_huy_Click(object sender, EventArgs e)
    {
        ThucHien(lit_thongbao, () =>
        {
            string trangThaiCu = ViewState["TrangThaiCu"] as string;
            if (trangThaiCu != "cho_xac_nhan" && trangThaiCu != "da_xac_nhan" && trangThaiCu != "dang_giao")
            {
                BaoTrangThaiDoi();
                return;
            }
            XuLy(new DAO_QUAN_TRI_DON_HANG().ChuyenTrangThai(TaiKhoanHienTai, donHangId, trangThaiCu, "da_huy"), false);
        });
    }

    protected void btn_luutru_Click(object sender, EventArgs e)
    {
        if (!LaAdmin)
            throw new HttpException(403, "Chỉ quản trị viên được lưu trữ đơn hàng.");
        ThucHien(lit_thongbao, () =>
        {
            if ((ViewState["TrangThaiCu"] as string) != "da_huy")
            {
                BaoTrangThaiDoi();
                return;
            }
            XuLy(new DAO_QUAN_TRI_DON_HANG().LuuTru(TaiKhoanHienTai, donHangId), true);
        });
    }

    private void HienThiDon()
    {
        try
        {
            DataSet duLieu = new DAO_QUAN_TRI_DON_HANG().ChiTiet(TaiKhoanHienTai, donHangId);
            if (duLieu.Tables.Count < 2 || duLieu.Tables[0].Rows.Count == 0)
                throw new HttpException(404, "Không tìm thấy đơn hàng.");

            DataRow don = duLieu.Tables[0].Rows[0];
            string trangThai = Convert.ToString(don["TrangThai"]);
            bool daLuuTru = Convert.ToBoolean(don["DaLuuTru"]);
            ViewState["TrangThaiCu"] = trangThai;
            ViewState["DaLuuTru"] = daLuuTru;
            lit_ma.Text = Convert.ToString(don["Ma"]);
            Title = "Đơn " + lit_ma.Text + " | PetDream";
            lbl_trangthai.Text = HienThiDonHang.TrangThai(trangThai);
            lbl_trangthai.CssClass = HienThiDonHang.LopTrangThai(trangThai);
            lit_ngaydat.Text = HienThiDonHang.Ngay(don["NgayDat"]);
            lit_ten.Text = Convert.ToString(don["TenNguoiNhan"]);
            lit_dienthoai.Text = Convert.ToString(don["DienThoai"]);
            lit_diachi.Text = Convert.ToString(don["DiaChi"]);
            lit_ghichu.Text = string.IsNullOrWhiteSpace(Convert.ToString(don["GhiChu"])) ? "Không có" : Convert.ToString(don["GhiChu"]);
            lit_khach.Text = Convert.ToString(don["KhachHoTen"]);
            lit_nguoitao.Text = Convert.ToString(don["NguoiTaoHoTen"]);
            lit_tienhang.Text = HienThiThuCung.Gia(don["TienHang"]);
            lit_phigiao.Text = HienThiThuCung.Gia(don["PhiGiao"]);
            lit_tong.Text = HienThiThuCung.Gia(don["TongTien"]);
            rpt_be.DataSource = duLieu.Tables[1];
            rpt_be.DataBind();
            pnl_daluu.Visible = daLuuTru;
            pnl_don.Visible = true;
            HienThiHanhDong(trangThai, daLuuTru);
        }
        catch (SqlException ex) { BaoLoiDuLieu(lit_thongbao, ex); }
        catch (ConfigurationErrorsException ex) { BaoLoiDuLieu(lit_thongbao, ex); }
    }

    private void HienThiHanhDong(string trangThai, bool daLuuTru)
    {
        string keTiep = TrangThaiTiepTheo(trangThai);
        btn_tieptuc.Visible = !daLuuTru && keTiep != null;
        btn_huy.Visible = !daLuuTru && (trangThai == "cho_xac_nhan" || trangThai == "da_xac_nhan" || trangThai == "dang_giao");
        btn_luutru.Visible = !daLuuTru && trangThai == "da_huy" && LaAdmin;
        pnl_thaotac.Visible = btn_tieptuc.Visible || btn_huy.Visible || btn_luutru.Visible;

        switch (trangThai)
        {
            case "cho_xac_nhan":
                lit_huongdan.Text = "Kiểm tra thông tin với khách trước khi xác nhận đơn.";
                btn_tieptuc.Text = "Xác nhận đơn";
                btn_tieptuc.OnClientClick = "return confirm('Xác nhận đơn hàng này?');";
                break;
            case "da_xac_nhan":
                lit_huongdan.Text = "Chuyển đơn sang đang giao khi bàn giao cho đơn vị vận chuyển.";
                btn_tieptuc.Text = "Chuyển sang đang giao";
                btn_tieptuc.OnClientClick = "return confirm('Chuyển đơn hàng sang đang giao?');";
                break;
            case "dang_giao":
                lit_huongdan.Text = "Đánh dấu đã giao khi việc giao nhận hoàn tất.";
                btn_tieptuc.Text = "Xác nhận đã giao";
                btn_tieptuc.OnClientClick = "return confirm('Xác nhận đã giao đơn hàng này?');";
                break;
            case "da_huy":
                lit_huongdan.Text = "Đơn đã hủy có thể được lưu trữ để giữ danh sách gọn gàng.";
                break;
        }
    }

    private static string TrangThaiTiepTheo(string trangThai)
    {
        switch (trangThai)
        {
            case "cho_xac_nhan": return "da_xac_nhan";
            case "da_xac_nhan": return "dang_giao";
            case "dang_giao": return "da_giao";
            default: return null;
        }
    }

    private void XuLy(string ketQua, bool luuTru)
    {
        switch (ketQua)
        {
            case "thanh_cong":
                ChuyenTrang(luuTru ? "~/Admin/DonHang.aspx?luutru=1"
                    : "~/Admin/ChiTietDonHang.aspx?id=" + donHangId.ToString(CultureInfo.InvariantCulture) + "&capnhat=1");
                return;
            case "khong_du_quyen": throw new HttpException(403, "Bạn không có quyền xử lý đơn hàng.");
            case "khong_tim_thay": throw new HttpException(404, "Không tìm thấy đơn hàng.");
            case "trang_thai_doi":
            case "chi_don_da_huy":
                BaoTrangThaiDoi();
                return;
            default:
                Response.StatusCode = 409;
                Response.TrySkipIisCustomErrors = true;
                lit_thongbao.Text = "Không thể cập nhật đơn hàng. Vui lòng kiểm tra lại trạng thái.";
                return;
        }
    }

    private void BaoTrangThaiDoi()
    {
        HienThiDon();
        Response.StatusCode = 409;
        Response.TrySkipIisCustomErrors = true;
        lit_thongbao.Text = "Trạng thái đơn hàng đã thay đổi. Vui lòng kiểm tra lại trước khi tiếp tục.";
    }
}
