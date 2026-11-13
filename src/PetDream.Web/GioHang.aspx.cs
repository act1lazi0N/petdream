using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;

public partial class GioHang : TrangCoCsrf
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
            return;

        if (Request.QueryString["them"] == "1")
            lit_thongbao.Text = "Bé đã có trong giỏ.";
        else if (Request.QueryString["them"] == "khongcon")
            lit_thongbao.Text = "Bé hiện không còn nhận thêm vào giỏ.";

        HienThiGioHang();
    }

    protected void rpt_giohang_ItemCommand(object sender, RepeaterCommandEventArgs e)
    {
        if (Request.HttpMethod != "POST")
            throw new HttpException(405, "Thao tác yêu cầu POST.");

        int id;
        if (e.CommandName == "Xoa" && int.TryParse(Convert.ToString(e.CommandArgument), out id))
        {
            GioHangPhien.Xoa(Session, id);
            ChuyenTrang("~/GioHang.aspx");
        }
    }

    private void HienThiGioHang()
    {
        var ids = GioHangPhien.DanhSachId(Session);
        pnl_trong.Visible = ids.Count == 0;
        if (ids.Count == 0)
            return;

        try
        {
            DataTable duLieu = new DAO_THU_CUNG().DocGioHang(ids);
            var theoId = duLieu.Rows.Cast<DataRow>().ToDictionary(row => (int)row["Id"]);
            var cacDong = ids.Select(id =>
            {
                DataRow be;
                theoId.TryGetValue(id, out be);
                bool dangBan = be != null && (string)be["TrangThai"] == "dang_ban";
                decimal? gia = dangBan ? (decimal?)be["Gia"] : null;
                return new
                {
                    Id = id,
                    CongKhai = be != null,
                    Ten = be == null ? "Hồ sơ không còn hiển thị" : (string)be["Ten"],
                    KieuAnh = be == null ? "" : HienThiThuCung.Anh(be["DuongDan"], be["OAnh"]),
                    TrangThai = be == null ? "Không còn nhận đặt" : HienThiThuCung.TrangThai(be["TrangThai"]),
                    Gia = gia.HasValue ? HienThiThuCung.Gia(gia.Value) : "",
                    Tien = gia
                };
            }).ToList();

            rpt_giohang.DataSource = cacDong;
            rpt_giohang.DataBind();
            lit_tong.Text = HienThiThuCung.Gia(cacDong.Sum(dong => dong.Tien ?? 0));
            pnl_thaydoi.Visible = cacDong.Any(dong => !dong.Tien.HasValue);
            lnk_dangnhap.Visible = XacThucTaiKhoan.HienTai(Context) == null;
            pnl_giohang.Visible = true;
        }
        catch (SqlException ex) { BaoLoiDuLieu(ex); }
        catch (ConfigurationErrorsException ex) { BaoLoiDuLieu(ex); }
    }

    private void BaoLoiDuLieu(Exception ex)
    {
        Trace.Warn("GioHang", "Không đọc được giỏ hàng.", ex);
        Response.StatusCode = 503;
        Response.TrySkipIisCustomErrors = true;
        lit_thongbao.Text = "Giỏ hàng tạm thời chưa sẵn sàng. Vui lòng thử lại sau.";
    }
}
