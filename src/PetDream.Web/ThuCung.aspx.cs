using System;
using System.Collections.Specialized;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class DanhMucThuCung : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack) return;
        try
        {
            BoLocThuCung loc = BoLocThuCung.TuQuery(Request.QueryString);
            DAO_THU_CUNG dao = new DAO_THU_CUNG();
            ddl_loai.DataSource = dao.DanhSachLoai();
            ddl_loai.DataValueField = "Id";
            ddl_loai.DataTextField = "Ten";
            ddl_loai.DataBind();
            ddl_loai.Items.Insert(0, new ListItem("Tất cả", ""));
            if (loc.LoaiId.HasValue && ddl_loai.Items.FindByValue(loc.LoaiId.Value.ToString()) == null)
                throw new FormatException("Loài được chọn không tồn tại.");
            txt_tukhoa.Text = loc.TuKhoa;
            ddl_loai.SelectedValue = loc.LoaiId.HasValue ? loc.LoaiId.Value.ToString() : "";
            ddl_gioitinh.SelectedValue = loc.GioiTinh;
            txt_giatu.Text = loc.GiaTu.HasValue ? loc.GiaTu.Value.ToString(CultureInfo.InvariantCulture) : "";
            txt_giaden.Text = loc.GiaDen.HasValue ? loc.GiaDen.Value.ToString(CultureInfo.InvariantCulture) : "";
            ddl_sapxep.SelectedValue = loc.SapXep;
            DataSet ketQua = dao.DanhSach(loc, 10, null);
            DataRow thongTin = ketQua.Tables[0].Rows[0];
            int tong = Convert.ToInt32(thongTin["Tong"]);
            int trang = Convert.ToInt32(thongTin["Trang"]);
            int soTrang = Convert.ToInt32(thongTin["SoTrang"]);
            ds_thucung.HienThi(ketQua.Tables[1]);
            lit_tong.Text = tong + " hồ sơ phù hợp";
            pnl_trong.Visible = tong == 0;
            lit_trang.Text = tong == 0 ? "" : "Trang " + trang + " / " + soTrang;
            lnk_truoc.Visible = trang > 1;
            lnk_sau.Visible = trang < soTrang;
            lnk_truoc.NavigateUrl = "ThuCung.aspx?" + loc.TaoQuery(trang - 1);
            lnk_sau.NavigateUrl = "ThuCung.aspx?" + loc.TaoQuery(trang + 1);
        }
        catch (FormatException ex) { BaoLoi(400, ex.Message); pnl_boloc.Visible = false; }
        catch (SqlException ex) { LoiDuLieu(ex); }
        catch (ConfigurationErrorsException ex) { LoiDuLieu(ex); }
    }

    protected void btn_loc_Click(object sender, EventArgs e)
    {
        NameValueCollection query = new NameValueCollection();
        query["q"] = txt_tukhoa.Text;
        query["loai"] = ddl_loai.SelectedValue;
        query["gioitinh"] = ddl_gioitinh.SelectedValue;
        query["min"] = txt_giatu.Text;
        query["max"] = txt_giaden.Text;
        query["sort"] = ddl_sapxep.SelectedValue;
        try
        {
            BoLocThuCung loc = BoLocThuCung.TuQuery(query);
            Response.Redirect("ThuCung.aspx?" + loc.TaoQuery(1), false);
            Context.ApplicationInstance.CompleteRequest();
        }
        catch (FormatException ex) { BaoLoi(400, ex.Message); }
    }

    private void LoiDuLieu(Exception ex)
    {
        Trace.Warn("Catalog", "Không đọc được danh mục.", ex);
        BaoLoi(503, "Danh mục tạm thời chưa sẵn sàng. Vui lòng quay lại sau ít phút.");
        pnl_boloc.Visible = false;
    }

    private void BaoLoi(int ma, string thongBao)
    {
        Response.StatusCode = ma;
        Response.TrySkipIisCustomErrors = true;
        pnl_loi.Visible = true;
        lit_loi.Text = thongBao;
        pnl_ketqua.Visible = false;
    }
}
