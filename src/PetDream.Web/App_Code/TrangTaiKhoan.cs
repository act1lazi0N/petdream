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
                thongBao.Text = "Email hoặc số điện thoại đã được sử dụng.";
            else
                BaoLoiDuLieu(thongBao, ex);
        }
        catch (ConfigurationErrorsException ex)
        {
            BaoLoiDuLieu(thongBao, ex);
        }
    }

    private void BaoLoiDuLieu(Literal thongBao, Exception ex)
    {
        Trace.Warn("TaiKhoan", "Không xử lý được thao tác tài khoản.", ex);
        Response.StatusCode = 503;
        Response.TrySkipIisCustomErrors = true;
        thongBao.Text = "Tài khoản tạm thời chưa sẵn sàng. Vui lòng thử lại sau.";
    }
}
