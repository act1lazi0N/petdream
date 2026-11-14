using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Text.RegularExpressions;
using System.Web;

public partial class QuanTriLoaiSua : TrangTaiKhoan
{
    private int id;
    protected override string ThongBaoLoiDuLieu { get { return "Danh mục loài tạm thời chưa sẵn sàng. Vui lòng thử lại sau."; } }
    protected override string ThongBaoTrungDuLieu { get { return "Không thể lưu danh mục. Vui lòng thử lại."; } }

    protected override void OnInit(EventArgs e)
    {
        if (TaiKhoanHienTai == null || TaiKhoanHienTai.VaiTro != "admin") throw new HttpException(403, "Chỉ quản trị viên được thay đổi loài.");
        string ma = Request.QueryString["id"];
        if (ma != null && (!int.TryParse(ma, NumberStyles.None, CultureInfo.InvariantCulture, out id) || id <= 0)) throw new HttpException(404, "Không tìm thấy loài.");
        base.OnInit(e);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        lit_tieude.Text = id == 0 ? "Thêm loài" : "Sửa loài";
        btn_xoa.Visible = id != 0;
        if (!IsPostBack && id != 0) NapLoai();
    }

    private void NapLoai()
    {
        try
        {
            DataRow dong = new DAO_QUAN_TRI_DANH_MUC().ChiTietLoai(id);
            if (dong == null) throw new HttpException(404, "Không tìm thấy loài.");
            txt_ma.Text = Convert.ToString(dong["Ma"]); txt_ten.Text = Convert.ToString(dong["Ten"]);
            txt_mota.Text = Convert.ToString(dong["MoTa"]); txt_thutu.Text = Convert.ToString(dong["ThuTu"], CultureInfo.InvariantCulture);
        }
        catch (SqlException ex) { BaoLoiDuLieu(lit_thongbao, ex); }
        catch (ConfigurationErrorsException ex) { BaoLoiDuLieu(lit_thongbao, ex); }
    }

    protected void btn_luu_Click(object sender, EventArgs e)
    {
        ThucHien(lit_thongbao, () =>
        {
            string ten = (txt_ten.Text ?? "").Trim(); string moTa = (txt_mota.Text ?? "").Trim(); int thuTu;
            if (KiemTraVanBanQuanTri.CoDauNgoacNhon(ten))
            { lit_thongbao.Text = "Tên loài không được chứa dấu < hoặc >."; return; }
            if (KiemTraVanBanQuanTri.CoDauNgoacNhon(moTa))
            { lit_thongbao.Text = "Mô tả chỉ hỗ trợ văn bản thuần, không chứa dấu < hoặc >."; return; }
            if (ten.Length < 1 || ten.Length > 60 || Regex.IsMatch(ten, @"\p{C}"))
            { lit_thongbao.Text = "Nhập tên loài từ 1 đến 60 ký tự hợp lệ."; return; }
            if (moTa.Length > 250)
            { lit_thongbao.Text = "Mô tả không được dài quá 250 ký tự."; return; }
            if (!int.TryParse(txt_thutu.Text, NumberStyles.Integer, CultureInfo.InvariantCulture, out thuTu))
            { lit_thongbao.Text = "Thứ tự hiển thị phải là một số nguyên hợp lệ."; return; }
            XuLy(new DAO_QUAN_TRI_DANH_MUC().LuuLoai(TaiKhoanHienTai, id, null, ten, moTa, thuTu));
        });
    }

    protected void btn_xoa_Click(object sender, EventArgs e)
    {
        if (id == 0) throw new HttpException(404, "Không tìm thấy loài.");
        ThucHien(lit_thongbao, () => XuLy(new DAO_QUAN_TRI_DANH_MUC().XoaLoai(TaiKhoanHienTai, id)));
    }

    private void XuLy(string ketQua)
    {
        switch (ketQua)
        {
            case "thanh_cong": ChuyenTrang("~/Admin/Loai.aspx?luu=1"); return;
            case "khong_du_quyen": throw new HttpException(403, "Bạn không có quyền thay đổi loài.");
            case "khong_tim_thay": throw new HttpException(404, "Không tìm thấy loài.");
            case "trung_ten": lit_thongbao.Text = "Tên loài đã tồn tại. Vui lòng chọn tên khác."; return;
            case "loai_con_thu_cung": lit_thongbao.Text = "Loài vẫn còn hồ sơ thú cưng. Hãy lưu trữ các hồ sơ trước."; return;
            default: lit_thongbao.Text = "Không thể lưu. Vui lòng kiểm tra lại dữ liệu."; return;
        }
    }
}
