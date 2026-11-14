using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;

public partial class QuanTriTaoDonHang : TrangDonHang
{
    private const string KhoaMaGuiLap = "TaoHo.MaGuiLap";
    private const string KhoaGiaDaXem = "TaoHo.GiaDaXem";
    private const string KhoaGiaDaChon = "TaoHo.GiaDaChon";
    private const string KhoaKhach = "TaoHo.Khach";
    private const decimal TongToiDa = 999999999999999999m;

    protected override void OnInit(EventArgs e)
    {
        if (!XacThucTaiKhoan.LaQuanTri(TaiKhoanHienTai))
            throw new HttpException(403, "Bạn không có quyền tạo đơn hàng.");
        base.OnInit(e);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
            return;

        ViewState[KhoaMaGuiLap] = Guid.NewGuid();
        NapLuaChon();
    }

    protected void btn_xem_Click(object sender, EventArgs e)
    {
        if (Request.HttpMethod != "POST")
            throw new HttpException(405, "Thao tác yêu cầu POST.");

        int khachId;
        if (!int.TryParse(ddl_khach.SelectedValue, NumberStyles.None, CultureInfo.InvariantCulture, out khachId) || khachId <= 0)
        {
            lit_thongbao.Text = "Vui lòng chọn tài khoản khách hàng.";
            return;
        }

        Dictionary<int, decimal> giaDaXem = DocGia(ViewState[KhoaGiaDaXem] as string);
        var daChon = new List<KeyValuePair<int, decimal>>();
        foreach (GridViewRow dong in grv_thucung.Rows)
        {
            CheckBox chon = dong.FindControl("chk_chon") as CheckBox;
            if (chon == null || !chon.Checked)
                continue;

            int id = Convert.ToInt32(grv_thucung.DataKeys[dong.RowIndex].Value, CultureInfo.InvariantCulture);
            decimal gia;
            if (!giaDaXem.TryGetValue(id, out gia))
            {
                lit_thongbao.Text = "Danh sách thú cưng đã thay đổi. Vui lòng tải lại trang.";
                return;
            }
            daChon.Add(new KeyValuePair<int, decimal>(id, gia));
        }

        if (daChon.Count == 0)
        {
            lit_thongbao.Text = "Vui lòng chọn ít nhất một thú cưng.";
            return;
        }
        if (daChon.Select(be => be.Key).Distinct().Count() != daChon.Count)
        {
            lit_thongbao.Text = "Mỗi thú cưng chỉ được chọn một lần.";
            return;
        }
        decimal tienHang = daChon.Sum(be => be.Value);
        if (tienHang > TongToiDa - DAO_DON_HANG.PhiGiao)
        {
            lit_thongbao.Text = "Tổng đơn hàng vượt giới hạn cho phép. Vui lòng giảm số thú cưng đã chọn.";
            return;
        }

        DocDuLieu(lit_thongbao, () =>
        {
            DAO_QUAN_TRI_DON_HANG dao = new DAO_QUAN_TRI_DON_HANG();
            DataRow khach = dao.DanhSachKhach(TaiKhoanHienTai).Rows.Cast<DataRow>()
                .FirstOrDefault(dong => Convert.ToInt32(dong["Id"], CultureInfo.InvariantCulture) == khachId);
            if (khach == null)
            {
                NapLuaChon();
                lit_thongbao.Text = "Tài khoản khách hàng không còn hoạt động. Vui lòng chọn lại.";
                return;
            }

            Dictionary<int, DataRow> hienTai = dao.DanhSachThuCung(TaiKhoanHienTai).Rows.Cast<DataRow>()
                .ToDictionary(dong => Convert.ToInt32(dong["Id"], CultureInfo.InvariantCulture));
            if (daChon.Any(be => !hienTai.ContainsKey(be.Key) || Convert.ToDecimal(hienTai[be.Key]["Gia"], CultureInfo.InvariantCulture) != be.Value))
            {
                NapLuaChon();
                lit_thongbao.Text = "Giá hoặc trạng thái của thú cưng vừa thay đổi. Vui lòng kiểm tra và chọn lại.";
                return;
            }

            DataTable tomTat = new DataTable();
            tomTat.Columns.Add("Ma", typeof(string));
            tomTat.Columns.Add("Ten", typeof(string));
            tomTat.Columns.Add("Gia", typeof(decimal));
            foreach (KeyValuePair<int, decimal> be in daChon)
                tomTat.Rows.Add(Convert.ToString(hienTai[be.Key]["Ma"]), Convert.ToString(hienTai[be.Key]["Ten"]), be.Value);
            rpt_chon.DataSource = tomTat;
            rpt_chon.DataBind();
            ViewState[KhoaKhach] = khachId;
            ViewState[KhoaGiaDaChon] = GhiGia(daChon);
            lit_khach.Text = Convert.ToString(khach["HoTen"]);
            txt_ten.Text = Convert.ToString(khach["HoTen"]);
            txt_dienthoai.Text = Convert.ToString(khach["DienThoai"]);
            lit_tienhang.Text = HienThiThuCung.Gia(tienHang);
            lit_phigiao.Text = HienThiThuCung.Gia(DAO_DON_HANG.PhiGiao);
            lit_tong.Text = HienThiThuCung.Gia(tienHang + DAO_DON_HANG.PhiGiao);
            lit_thongbao.Text = "";
            pnl_chon.Visible = false;
            pnl_xacnhan.Visible = true;
        });
    }

    protected void btn_thaydoi_Click(object sender, EventArgs e)
    {
        if (Request.HttpMethod != "POST")
            throw new HttpException(405, "Thao tác yêu cầu POST.");
        TroVeLuaChon();
    }

    protected void btn_tao_Click(object sender, EventArgs e)
    {
        ThucHien(lit_thongbao, () =>
        {
            if (!(ViewState[KhoaKhach] is int) || !(ViewState[KhoaMaGuiLap] is Guid))
            {
                lit_thongbao.Text = "Phiên tạo đơn đã hết hạn. Vui lòng chọn lại thông tin.";
                return;
            }

            Dictionary<int, decimal> gia = DocGia(ViewState[KhoaGiaDaChon] as string);
            if (gia.Count == 0)
            {
                lit_thongbao.Text = "Vui lòng chọn lại thú cưng trước khi tạo đơn.";
                return;
            }
            if (KiemTraVanBanQuanTri.CoDauNgoacNhon(txt_ten.Text)
                || KiemTraVanBanQuanTri.CoDauNgoacNhon(txt_diachi.Text)
                || KiemTraVanBanQuanTri.CoDauNgoacNhon(txt_ghichu.Text))
            {
                lit_thongbao.Text = "Thông tin nhận hàng chỉ hỗ trợ văn bản thuần, không chứa dấu < hoặc >.";
                return;
            }

            ThongTinNhanHang nhanHang;
            string loi;
            if (!ThongTinNhanHang.ThuDoc(txt_ten.Text, txt_dienthoai.Text, txt_diachi.Text, txt_ghichu.Text, out nhanHang, out loi))
            {
                lit_thongbao.Text = loi;
                return;
            }

            KetQuaDatHang ketQua = new DAO_QUAN_TRI_DON_HANG().DatHo(TaiKhoanHienTai, (int)ViewState[KhoaKhach],
                (Guid)ViewState[KhoaMaGuiLap], nhanHang, gia);
            switch (ketQua.KetQua)
            {
                case "thanh_cong":
                case "da_ton_tai":
                    if (!ketQua.DonHangId.HasValue)
                    {
                        lit_thongbao.Text = "Không thể xác định đơn hàng. Vui lòng xem danh sách đơn.";
                        return;
                    }
                    ChuyenTrang("~/Admin/ChiTietDonHang.aspx?id=" + ketQua.DonHangId.Value.ToString(CultureInfo.InvariantCulture) + "&moi=1");
                    return;
                case "gia_doi":
                    TroVeLuaChon();
                    lit_thongbao.Text = "Giá của một số thú cưng vừa thay đổi. Vui lòng kiểm tra và chọn lại trước khi xác nhận.";
                    return;
                case "khong_kha_dung":
                    TroVeLuaChon();
                    lit_thongbao.Text = "Một số thú cưng không còn nhận đặt. Vui lòng kiểm tra và chọn lại.";
                    return;
                case "khong_du_quyen":
                    throw new HttpException(403, "Bạn không có quyền tạo đơn hàng.");
                default:
                    lit_thongbao.Text = "Không thể tạo đơn với thông tin hiện tại. Vui lòng kiểm tra khách hàng và thử lại.";
                    return;
            }
        });
    }

    private void TroVeLuaChon()
    {
        pnl_xacnhan.Visible = false;
        pnl_chon.Visible = true;
        ViewState[KhoaKhach] = null;
        ViewState[KhoaGiaDaChon] = null;
        ViewState[KhoaMaGuiLap] = Guid.NewGuid();
        lit_thongbao.Text = "";
        NapLuaChon();
    }

    private void NapLuaChon()
    {
        btn_xem.Enabled = false;
        DocDuLieu(lit_thongbao, () =>
        {
            DAO_QUAN_TRI_DON_HANG dao = new DAO_QUAN_TRI_DON_HANG();
            DataTable khach = dao.DanhSachKhach(TaiKhoanHienTai);
            DataTable thuCung = dao.DanhSachThuCung(TaiKhoanHienTai);
            ddl_khach.Items.Clear();
            ddl_khach.Items.Add(new ListItem("Chọn khách hàng", ""));
            foreach (DataRow dong in khach.Rows)
                ddl_khach.Items.Add(new ListItem(Convert.ToString(dong["HoTen"]) + " · " + Convert.ToString(dong["DienThoai"]),
                    Convert.ToString(dong["Id"], CultureInfo.InvariantCulture)));

            var gia = thuCung.Rows.Cast<DataRow>().Select(dong => new KeyValuePair<int, decimal>(
                Convert.ToInt32(dong["Id"], CultureInfo.InvariantCulture), Convert.ToDecimal(dong["Gia"], CultureInfo.InvariantCulture))).ToList();
            grv_thucung.DataSource = thuCung;
            grv_thucung.DataBind();
            ViewState[KhoaGiaDaXem] = GhiGia(gia);
            btn_xem.Enabled = khach.Rows.Count > 0 && thuCung.Rows.Count > 0;
            if (khach.Rows.Count == 0)
                lit_thongbao.Text = "Chưa có tài khoản khách hàng đang hoạt động.";
            else if (thuCung.Rows.Count == 0)
                lit_thongbao.Text = "Hiện chưa có thú cưng nhận đặt.";
        });
    }

    private static string GhiGia(IEnumerable<KeyValuePair<int, decimal>> gia)
    {
        return string.Join(",", gia.Select(be => be.Key.ToString(CultureInfo.InvariantCulture) + ":" + be.Value.ToString("0", CultureInfo.InvariantCulture)));
    }

    private static Dictionary<int, decimal> DocGia(string duLieu)
    {
        var ketQua = new Dictionary<int, decimal>();
        foreach (string phan in (duLieu ?? "").Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
        {
            string[] cap = phan.Split(':');
            int id;
            decimal gia;
            if (cap.Length != 2 || !int.TryParse(cap[0], NumberStyles.None, CultureInfo.InvariantCulture, out id) || id <= 0
                || !decimal.TryParse(cap[1], NumberStyles.None, CultureInfo.InvariantCulture, out gia) || gia < 0 || ketQua.ContainsKey(id))
                return new Dictionary<int, decimal>();
            ketQua.Add(id, gia);
        }
        return ketQua;
    }
}
