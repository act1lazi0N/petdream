using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI.WebControls;

/// <summary>
/// Trang đơn hàng của khách: yêu cầu đăng nhập (Global.asax), HTTPS và CSRF như trang tài khoản.
/// </summary>
public abstract class TrangDonHang : TrangTaiKhoan
{
    protected override string ThongBaoTrungDuLieu
    {
        get { return "Đơn hàng đã được gửi. Vui lòng xem lại lịch sử đơn."; }
    }

    protected override string ThongBaoLoiDuLieu
    {
        get { return "Đơn hàng tạm thời chưa sẵn sàng. Vui lòng thử lại sau."; }
    }

    /// <summary>Đọc dữ liệu khi tải trang; lỗi SQL/cấu hình trả 503 với thông báo chung.</summary>
    protected bool DocDuLieu(Literal thongBao, Action thaoTac)
    {
        try
        {
            thaoTac();
            return true;
        }
        catch (SqlException ex) { BaoLoiDuLieu(thongBao, ex); }
        catch (ConfigurationErrorsException ex) { BaoLoiDuLieu(thongBao, ex); }
        return false;
    }

    protected bool DocIdDon(out int id)
    {
        return int.TryParse(Request.QueryString["id"], NumberStyles.None, CultureInfo.InvariantCulture, out id) && id > 0;
    }
}
