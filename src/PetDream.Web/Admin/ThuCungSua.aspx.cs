using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI.WebControls;

public partial class QuanTriThuCungSua : TrangTaiKhoan
{
    private int id;
    private bool LaAdmin { get { return TaiKhoanHienTai != null && TaiKhoanHienTai.VaiTro == "admin"; } }
    protected override string ThongBaoLoiDuLieu { get { return "Hồ sơ thú cưng tạm thời chưa sẵn sàng. Vui lòng thử lại sau."; } }
    protected override string ThongBaoTrungDuLieu { get { return "Không thể lưu hồ sơ. Vui lòng thử lại."; } }

    protected override void OnInit(EventArgs e)
    {
        if (!XacThucTaiKhoan.LaQuanTri(TaiKhoanHienTai)) throw new HttpException(403, "Bạn không có quyền truy cập.");
        string ma = Request.QueryString["id"];
        if (ma != null && (!int.TryParse(ma, NumberStyles.None, CultureInfo.InvariantCulture, out id) || id <= 0)) throw new HttpException(404, "Không tìm thấy hồ sơ.");
        base.OnInit(e);
    }

    protected override void OnPreRender(EventArgs e)
    {
        if (Page.Form != null) Page.Form.Enctype = "multipart/form-data";
        base.OnPreRender(e);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        lit_tieude.Text = id == 0 ? "Thêm thú cưng" : "Thông tin thú cưng";
        btn_xoa.Visible = id != 0 && LaAdmin;
        if (!IsPostBack) NapDuLieu();
        string trangThaiGoc = ViewState["TrangThaiGoc"] as string;
        ddl_trangthai.Items.FindByValue("giu_cho").Enabled = trangThaiGoc == "giu_cho";
        ddl_trangthai.Items.FindByValue("da_ban").Enabled = trangThaiGoc == "da_ban";
    }

    private void NapDuLieu()
    {
        try
        {
            DAO_QUAN_TRI_DANH_MUC dao = new DAO_QUAN_TRI_DANH_MUC();
            ddl_loai.DataSource = dao.DanhSachLoai(); ddl_loai.DataTextField = "Ten"; ddl_loai.DataValueField = "Id"; ddl_loai.DataBind();
            if (id == 0) return;
            DataRow dong = dao.ChiTietThuCung(id);
            if (dong == null) throw new HttpException(404, "Không tìm thấy hồ sơ.");
            txt_ma.Text = Convert.ToString(dong["Ma"]);
            string loaiId = Convert.ToString(dong["LoaiId"]);
            if (ddl_loai.Items.FindByValue(loaiId) == null)
                ddl_loai.Items.Add(new ListItem(Convert.ToString(dong["TenLoai"]) + " (đã lưu trữ)", loaiId));
            ddl_loai.SelectedValue = loaiId;
            txt_ten.Text = Convert.ToString(dong["Ten"]); txt_giong.Text = Convert.ToString(dong["Giong"]);
            ddl_gioitinh.SelectedValue = Convert.ToString(dong["GioiTinh"]);
            txt_ngaysinh.Text = Convert.ToDateTime(dong["NgaySinh"]).ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);
            txt_cannang.Text = Convert.ToDecimal(dong["CanNang"]).ToString("0.##", CultureInfo.InvariantCulture);
            txt_kichthuoc.Text = Convert.ToString(dong["KichThuoc"]); txt_gia.Text = Convert.ToDecimal(dong["Gia"]).ToString("0", CultureInfo.InvariantCulture);
            txt_mota.Text = Convert.ToString(dong["MoTa"]); txt_tiemchung.Text = Convert.ToString(dong["TiemChung"]); txt_dacdiem.Text = Convert.ToString(dong["DacDiem"]);
            if (dong["DuongDan"] != DBNull.Value)
            {
                anh_hientai.Visible = true;
                anh_hientai.Attributes["aria-label"] = "Ảnh hiện tại của " + Convert.ToString(dong["Ten"]);
                anh_hientai.Attributes["style"] = HienThiThuCung.Anh(dong["DuongDan"], dong["OAnh"]);
            }
            string trangThai = Convert.ToString(dong["TrangThai"]);
            ViewState["TrangThaiGoc"] = trangThai; ddl_trangthai.SelectedValue = trangThai;
            ddl_trangthai.Enabled = trangThai == "dang_ban" || trangThai == "ngung_ban";
            chk_noibat.Checked = Convert.ToBoolean(dong["NoiBat"]);
            if (Convert.ToBoolean(dong["DaXoa"]))
            {
                pnl_bieumau.Enabled = false;
                lit_thongbao.Text = "Hồ sơ đã được lưu trữ và chỉ có thể xem.";
            }
        }
        catch (SqlException ex) { BaoLoiDuLieu(lit_thongbao, ex); }
        catch (ConfigurationErrorsException ex) { BaoLoiDuLieu(lit_thongbao, ex); }
    }

    protected void btn_luu_Click(object sender, EventArgs e)
    {
        ThucHien(lit_thongbao, () =>
        {
            HoSoQuanTriThuCung hoSo;
            string loi;
            if (!ThuDocHoSo(out hoSo, out loi)) { lit_thongbao.Text = loi; return; }

            string anh;
            if (!TaiAnhThuCung.ThuLuu(fu_anh.PostedFile, out anh, out loi)) { lit_thongbao.Text = loi; return; }
            DataRow ketQua;
            try { ketQua = new DAO_QUAN_TRI_DANH_MUC().LuuThuCung(TaiKhoanHienTai, id, hoSo, anh); }
            catch (SqlException ex)
            {
                // Trùng khóa và deadlock đã rollback; timeout/mất kết nối có thể đã commit.
                if (ex.Number == 2601 || ex.Number == 2627 || ex.Number == 1205) TaiAnhThuCung.XoaAnhMoi(anh);
                throw;
            }
            string maKetQua = ketQua == null ? "khong_hop_le" : Convert.ToString(ketQua["KetQua"]);
            if (maKetQua != "thanh_cong") TaiAnhThuCung.XoaAnhMoi(anh);
            XuLy(maKetQua);
        });
    }

    protected void btn_xoa_Click(object sender, EventArgs e)
    {
        if (!LaAdmin) throw new HttpException(403, "Chỉ quản trị viên được xóa hồ sơ.");
        if (id == 0) throw new HttpException(404, "Không tìm thấy hồ sơ.");
        ThucHien(lit_thongbao, () => XuLy(new DAO_QUAN_TRI_DANH_MUC().XoaThuCung(TaiKhoanHienTai, id)));
    }

    private bool ThuDocHoSo(out HoSoQuanTriThuCung hoSo, out string loi)
    {
        hoSo = null;
        string ten = (txt_ten.Text ?? "").Trim(), giong = (txt_giong.Text ?? "").Trim();
        string kichThuoc = (txt_kichthuoc.Text ?? "").Trim(), moTa = (txt_mota.Text ?? "").Trim(), tiemChung = (txt_tiemchung.Text ?? "").Trim(), dacDiem = (txt_dacdiem.Text ?? "").Trim();
        if (KiemTraVanBanQuanTri.CoDauNgoacNhon(ten))
        { loi = "Tên thú cưng không được chứa dấu < hoặc >."; return false; }
        if (KiemTraVanBanQuanTri.CoDauNgoacNhon(giong))
        { loi = "Tên giống không được chứa dấu < hoặc >."; return false; }
        if (KiemTraVanBanQuanTri.CoDauNgoacNhon(kichThuoc))
        { loi = "Kích thước không được chứa dấu < hoặc >."; return false; }
        if (KiemTraVanBanQuanTri.CoDauNgoacNhon(moTa))
        { loi = "Mô tả chỉ hỗ trợ văn bản thuần, không chứa dấu < hoặc >."; return false; }
        if (KiemTraVanBanQuanTri.CoDauNgoacNhon(tiemChung))
        { loi = "Thông tin tiêm chủng chỉ hỗ trợ văn bản thuần, không chứa dấu < hoặc >."; return false; }
        if (KiemTraVanBanQuanTri.CoDauNgoacNhon(dacDiem))
        { loi = "Đặc điểm chỉ hỗ trợ văn bản thuần, không chứa dấu < hoặc >."; return false; }
        int loai; DateTime ngaySinh; decimal canNang, gia;
        string trangThai = ddl_trangthai.SelectedValue;
        string trangThaiGoc = ViewState["TrangThaiGoc"] as string;
        if (trangThaiGoc == "giu_cho" || trangThaiGoc == "da_ban") trangThai = trangThaiGoc;
        bool trangThaiHopLe = trangThai == "dang_ban" || trangThai == "ngung_ban" || (id != 0 && (trangThai == "giu_cho" || trangThai == "da_ban") && trangThai == trangThaiGoc);
        if (!int.TryParse(ddl_loai.SelectedValue, NumberStyles.None, CultureInfo.InvariantCulture, out loai) || loai <= 0)
        { loi = "Vui lòng chọn loài thú cưng."; return false; }
        if (ten.Length < 1 || ten.Length > 80 || Regex.IsMatch(ten, @"\p{C}"))
        { loi = "Nhập tên thú cưng từ 1 đến 80 ký tự hợp lệ."; return false; }
        if (giong.Length < 1 || giong.Length > 100 || Regex.IsMatch(giong, @"\p{C}"))
        { loi = "Nhập giống thú cưng từ 1 đến 100 ký tự hợp lệ."; return false; }
        if (kichThuoc.Length < 1 || kichThuoc.Length > 100 || Regex.IsMatch(kichThuoc, @"\p{C}"))
        { loi = "Nhập kích thước từ 1 đến 100 ký tự hợp lệ."; return false; }
        if (ddl_gioitinh.SelectedValue != "D" && ddl_gioitinh.SelectedValue != "C")
        { loi = "Vui lòng chọn giới tính hợp lệ."; return false; }
        if (!DateTime.TryParseExact(txt_ngaysinh.Text, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out ngaySinh) || ngaySinh.Date > DateTime.UtcNow.AddHours(7).Date)
        { loi = "Ngày sinh không hợp lệ hoặc ở trong tương lai."; return false; }
        if (!decimal.TryParse(txt_cannang.Text, NumberStyles.AllowDecimalPoint, CultureInfo.InvariantCulture, out canNang) || canNang <= 0 || canNang > 9999.99m || decimal.Round(canNang, 2) != canNang)
        { loi = "Cân nặng phải lớn hơn 0, tối đa 9.999,99 kg và có tối đa hai chữ số thập phân."; return false; }
        if (!decimal.TryParse(txt_gia.Text, NumberStyles.None, CultureInfo.InvariantCulture, out gia) || gia < 0 || gia > 999999999999999999m)
        { loi = "Giá phải là số nguyên từ 0 đến 999.999.999.999.999.999 đồng."; return false; }
        if (moTa.Length > 2000 || tiemChung.Length > 1000 || dacDiem.Length > 1000)
        { loi = "Mô tả tối đa 2.000 ký tự; tiêm chủng và đặc điểm tối đa 1.000 ký tự."; return false; }
        if (!trangThaiHopLe)
        { loi = "Trạng thái không hợp lệ. Vui lòng tải lại hồ sơ."; return false; }
        hoSo = new HoSoQuanTriThuCung { LoaiId = loai, Ten = ten, Giong = giong, GioiTinh = ddl_gioitinh.SelectedValue,
            NgaySinh = ngaySinh.Date, CanNang = canNang, KichThuoc = kichThuoc, Gia = gia, MoTa = moTa,
            TiemChung = tiemChung, DacDiem = dacDiem, TrangThai = trangThai, NoiBat = chk_noibat.Checked };
        loi = null; return true;
    }

    private void XuLy(string ketQua)
    {
        switch (ketQua)
        {
            case "thanh_cong": ChuyenTrang("~/Admin/ThuCung.aspx?luu=1"); return;
            case "khong_du_quyen": throw new HttpException(403, "Bạn không có quyền thay đổi hồ sơ.");
            case "khong_tim_thay": throw new HttpException(404, "Không tìm thấy hồ sơ.");
            case "dang_trong_don": lit_thongbao.Text = "Không thể thay đổi hoặc xóa hồ sơ đang thuộc đơn hàng hoạt động."; return;
            case "trang_thai_doi": lit_thongbao.Text = "Trạng thái hồ sơ đã thay đổi. Vui lòng tải lại trang để kiểm tra."; return;
            default: lit_thongbao.Text = "Không thể lưu hồ sơ. Vui lòng kiểm tra lại dữ liệu và loài."; return;
        }
    }
}
