using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

public partial class DatHang : TrangDonHang
{
    private const string KhoaMaGuiLap = "MaGuiLap";
    private const string KhoaGiaDaXem = "GiaDaXem";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
            return;

        // Một mã cho mỗi lần mở trang xác nhận: gửi lại form (nhấn hai lần, F5, Back) trả về cùng một đơn.
        ViewState[KhoaMaGuiLap] = Guid.NewGuid();
        DanhTinhTaiKhoan taiKhoan = TaiKhoanHienTai;
        txt_ten.Text = taiKhoan.HoTen;
        txt_dienthoai.Text = taiKhoan.DienThoai;
        NapGio();
    }

    protected void btn_dathang_Click(object sender, EventArgs e)
    {
        ThucHien(lit_thongbao, () =>
        {
            ThongTinNhanHang nhanHang;
            string loi;
            if (!ThongTinNhanHang.ThuDoc(txt_ten.Text, txt_dienthoai.Text, txt_diachi.Text, txt_ghichu.Text,
                out nhanHang, out loi))
            {
                lit_thongbao.Text = loi;
                return;
            }

            List<KeyValuePair<int, decimal>> giaDaXem = DocGiaDaXem();
            if (giaDaXem.Count == 0)
            {
                ChuyenTrang("~/GioHang.aspx");
                return;
            }

            DanhTinhTaiKhoan taiKhoan = TaiKhoanHienTai;
            KetQuaDatHang ketQua = new DAO_DON_HANG().DatHang(taiKhoan.Id, taiKhoan.Id,
                (Guid)ViewState[KhoaMaGuiLap], nhanHang, giaDaXem);

            switch (ketQua.KetQua)
            {
                case "thanh_cong":
                case "da_ton_tai":
                    foreach (KeyValuePair<int, decimal> be in giaDaXem)
                        GioHangPhien.Xoa(Session, be.Key);
                    ChuyenTrang("~/ChiTietDonHang.aspx?id="
                        + ketQua.DonHangId.Value.ToString(CultureInfo.InvariantCulture) + "&moi=1");
                    break;
                case "gia_doi":
                    NapGio();
                    lit_thongbao.Text = "Giá của một số bé vừa thay đổi. Vui lòng xem lại tổng tiền rồi xác nhận lần nữa.";
                    break;
                case "khong_kha_dung":
                    NapGio();
                    lit_thongbao.Text = "Có bé vừa được giữ chỗ hoặc ngừng giới thiệu. Đơn chưa được tạo, vui lòng quay lại giỏ để cập nhật.";
                    break;
                case "gio_trong":
                    ChuyenTrang("~/GioHang.aspx");
                    break;
                default:
                    lit_thongbao.Text = "Không thể tạo đơn với thông tin hiện tại. Vui lòng tải lại trang.";
                    break;
            }
        });
    }

    /// <summary>
    /// Đọc lại giỏ từ database và ghi nhớ giá khách đang xem; sp_DonHang_Dat so sánh giá này khi xác nhận.
    /// </summary>
    private void NapGio()
    {
        if (GioHangPhien.DanhSachId(Session).Count == 0)
        {
            ChuyenTrang("~/GioHang.aspx");
            return;
        }

        DocDuLieu(lit_thongbao, () =>
        {
            List<DongGioHang> cacDong = DongGioHang.Doc(GioHangPhien.DanhSachId(Session));
            decimal tienHang = cacDong.Sum(dong => dong.Tien ?? 0);
            bool coTheDat = cacDong.All(dong => dong.DangBan);

            rpt_be.DataSource = cacDong;
            rpt_be.DataBind();
            lit_tienhang.Text = HienThiThuCung.Gia(tienHang);
            lit_phigiao.Text = HienThiThuCung.Gia(DAO_DON_HANG.PhiGiao);
            lit_tong.Text = HienThiThuCung.Gia(tienHang + DAO_DON_HANG.PhiGiao);
            btn_dathang.Enabled = coTheDat;
            ViewState[KhoaGiaDaXem] = coTheDat
                ? string.Join(",", cacDong.Select(dong => dong.Id.ToString(CultureInfo.InvariantCulture)
                    + ":" + dong.Tien.Value.ToString("0", CultureInfo.InvariantCulture)))
                : "";

            if (!coTheDat)
                lit_thongbao.Text = "Giỏ có bé không còn nhận đặt. Vui lòng quay lại giỏ và xóa các bé đó trước khi đặt hàng.";
        });
    }

    private List<KeyValuePair<int, decimal>> DocGiaDaXem()
    {
        var ketQua = new List<KeyValuePair<int, decimal>>();
        foreach (string phan in (ViewState[KhoaGiaDaXem] as string ?? "").Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
        {
            string[] cap = phan.Split(':');
            int id;
            decimal gia;
            if (cap.Length != 2
                || !int.TryParse(cap[0], NumberStyles.None, CultureInfo.InvariantCulture, out id)
                || !decimal.TryParse(cap[1], NumberStyles.None, CultureInfo.InvariantCulture, out gia))
                return new List<KeyValuePair<int, decimal>>();

            ketQua.Add(new KeyValuePair<int, decimal>(id, gia));
        }

        return ketQua;
    }
}
