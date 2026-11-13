using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web;

public partial class ChiTietThuCung : TrangCoCsrf
{
    protected override bool BaoVeBieuMau
    {
        get { return Request.IsSecureConnection; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack) return;
        int id;
        if (!DocId(out id))
        {
            BaoLoi(404, "Hồ sơ bạn tìm không tồn tại hoặc không còn được giới thiệu.");
            return;
        }
        try
        {
            DataSet duLieu = new DAO_THU_CUNG().ChiTiet(id);
            if (duLieu.Tables[0].Rows.Count == 0)
            {
                BaoLoi(404, "Hồ sơ bạn tìm không tồn tại hoặc không còn được giới thiệu.");
                return;
            }
            DataRow pet = duLieu.Tables[0].Rows[0];
            btn_themgio.Visible = Request.IsSecureConnection && DangBan(pet);
            Title = Convert.ToString(pet["Ten"]) + " | PetDream";
            lit_breadcrumb.Text = lit_ten.Text = Convert.ToString(pet["Ten"]);
            lit_giong.Text = Convert.ToString(pet["Giong"]);
            lit_ma.Text = Convert.ToString(pet["Ma"]);
            lit_gia.Text = HienThiThuCung.Gia(pet["Gia"]);
            lit_gioitinh.Text = HienThiThuCung.GioiTinh(pet["GioiTinh"]);
            lit_tuoi.Text = HienThiThuCung.Tuoi(pet["NgaySinh"]);
            lit_trangthai.Text = HienThiThuCung.TrangThai(pet["TrangThai"]);
            lit_cannang.Text = Convert.ToDecimal(pet["CanNang"]).ToString("0.##", CultureInfo.GetCultureInfo("vi-VN"));
            lit_mota.Text = Convert.ToString(pet["MoTa"]);
            lit_dacdiem.Text = Convert.ToString(pet["DacDiem"]);
            lit_tiemchung.Text = Convert.ToString(pet["TiemChung"]);
            lit_kichthuoc.Text = Convert.ToString(pet["KichThuoc"]);
            lnk_loai.NavigateUrl = "ThuCung.aspx?loai=" + pet["LoaiId"];
            DataTable anh = duLieu.Tables[1];
            anh_chinh.Attributes["aria-label"] = "Ảnh minh họa " + Convert.ToString(pet["Ten"]);
            if (anh.Rows.Count > 0)
            {
                DataRow chon = anh.Rows[0];
                int anhId;
                if (int.TryParse(Request.QueryString["anh"], out anhId))
                    foreach (DataRow row in anh.Rows)
                        if (Convert.ToInt32(row["Id"]) == anhId) chon = row;
                anh_chinh.Attributes["style"] = HienThiThuCung.Anh(chon["DuongDan"], chon["OAnh"]);
                rpt_anh.Visible = anh.Rows.Count > 1;
                rpt_anh.DataSource = anh;
                rpt_anh.DataBind();
            }
            ds_goiy.HienThi(duLieu.Tables[2]);
            pnl_goiy.Visible = duLieu.Tables[2].Rows.Count > 0;
        }
        catch (SqlException ex) { LoiDuLieu(ex); }
        catch (ConfigurationErrorsException ex) { LoiDuLieu(ex); }
    }

    protected void btn_themgio_Click(object sender, EventArgs e)
    {
        if (!Request.IsSecureConnection || Request.HttpMethod != "POST")
            throw new HttpException(403, "Vui lòng mở trang bằng HTTPS để thêm vào giỏ.");

        int id;
        if (!DocId(out id))
        {
            BaoLoi(404, "Hồ sơ bạn tìm không tồn tại hoặc không còn được giới thiệu.");
            return;
        }

        try
        {
            DataTable ketQua = new DAO_THU_CUNG().DocGioHang(new[] { id });
            if (ketQua.Rows.Count == 0 || !DangBan(ketQua.Rows[0]))
            {
                ChuyenTrang("~/GioHang.aspx?them=khongcon");
                return;
            }

            GioHangPhien.Them(Session, id);
            ChuyenTrang("~/GioHang.aspx?them=1");
        }
        catch (SqlException ex) { LoiDuLieu(ex); }
        catch (ConfigurationErrorsException ex) { LoiDuLieu(ex); }
    }

    private bool DocId(out int id)
    {
        return int.TryParse(Request.QueryString["id"], NumberStyles.None, CultureInfo.InvariantCulture, out id) && id > 0;
    }

    private static bool DangBan(DataRow pet)
    {
        return Convert.ToString(pet["TrangThai"]) == "dang_ban";
    }

    private void LoiDuLieu(Exception ex)
    {
        Trace.Warn("Catalog", "Không đọc được hồ sơ.", ex);
        BaoLoi(503, "Hồ sơ tạm thời chưa sẵn sàng. Vui lòng quay lại sau ít phút.");
    }

    private void BaoLoi(int ma, string thongBao)
    {
        Response.StatusCode = ma;
        Response.TrySkipIisCustomErrors = true;
        pnl_chitiet.Visible = false;
        pnl_loi.Visible = true;
        lit_loi.Text = thongBao;
        lit_breadcrumb.Text = "Không tìm thấy hồ sơ";
    }
}
