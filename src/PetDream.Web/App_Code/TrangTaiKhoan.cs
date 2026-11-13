using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI.WebControls;

public abstract class TrangTaiKhoan : TrangCoCsrf
{
    protected DanhTinhTaiKhoan TaiKhoanHienTai
    {
        get { return XacThucTaiKhoan.HienTai(Context); }
    }

    protected virtual string ThongBaoTrungDuLieu
    {
        get { return "Email hoặc số điện thoại đã được sử dụng."; }
    }

    protected virtual string ThongBaoLoiDuLieu
    {
        get { return "Tài khoản tạm thời chưa sẵn sàng. Vui lòng thử lại sau."; }
    }

    protected void ThucHien(Literal thongBao, Action thaoTac)
    {
        if (Request.HttpMethod != "POST")
            throw new HttpException(405, "Thao tác yêu cầu POST.");

        Page.Validate();
        if (!Page.IsValid)
            return;

        try
        {
            thaoTac();
        }
        catch (SqlException ex)
        {
            if (ex.Number == 2601 || ex.Number == 2627)
                thongBao.Text = ThongBaoTrungDuLieu;
            else if (ex.Number == 1205)
            {
                // Deadlock: giao dịch đã rollback toàn bộ, khách có thể gửi lại an toàn.
                Response.StatusCode = 409;
                Response.TrySkipIisCustomErrors = true;
                thongBao.Text = "Có thao tác khác đang xử lý cùng lúc. Vui lòng thử lại.";
            }
            else
                BaoLoiDuLieu(thongBao, ex);
        }
        catch (ConfigurationErrorsException ex)
        {
            BaoLoiDuLieu(thongBao, ex);
        }
    }

    protected void BaoLoiDuLieu(Literal thongBao, Exception ex)
    {
        Trace.Warn(GetType().Name, "Không xử lý được thao tác dữ liệu.", ex);
        Response.StatusCode = 503;
        Response.TrySkipIisCustomErrors = true;
        thongBao.Text = ThongBaoLoiDuLieu;
    }
}
