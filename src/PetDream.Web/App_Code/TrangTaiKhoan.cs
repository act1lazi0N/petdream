using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public abstract class TrangTaiKhoan : Page
{
    public const string KhoaCsrf = "PetDream.Csrf";
    private const string TruongCsrf = "petdream_csrf";

    protected DanhTinhTaiKhoan TaiKhoanHienTai
    {
        get { return XacThucTaiKhoan.HienTai(Context); }
    }

    protected override void OnInit(EventArgs e)
    {
        string token = Session[KhoaCsrf] as string;
        bool post = Request.HttpMethod == "POST";
        if (post && !BangNhau(token, Request.Form[TruongCsrf]))
            throw new HttpException(403, "Biểu mẫu đã hết hạn. Vui lòng tải lại trang.");

        if (token == null)
        {
            byte[] duLieu = new byte[32];
            using (RandomNumberGenerator rng = RandomNumberGenerator.Create())
                rng.GetBytes(duLieu);

            token = Convert.ToBase64String(duLieu);
            Session[KhoaCsrf] = token;
        }

        ViewStateUserKey = token;
        ClientScript.RegisterHiddenField(TruongCsrf, token);
        base.OnInit(e);
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

    protected void ChuyenTrang(string duongDan)
    {
        Response.Redirect(ResolveUrl(duongDan), false);
        Context.ApplicationInstance.CompleteRequest();
    }

    private void BaoLoiDuLieu(Literal thongBao, Exception ex)
    {
        Trace.Warn("TaiKhoan", "Không xử lý được thao tác tài khoản.", ex);
        Response.StatusCode = 503;
        Response.TrySkipIisCustomErrors = true;
        thongBao.Text = "Tài khoản tạm thời chưa sẵn sàng. Vui lòng thử lại sau.";
    }

    private static bool BangNhau(string token, string nhanDuoc)
    {
        if (token == null || nhanDuoc == null || token.Length != nhanDuoc.Length)
            return false;

        int khac = 0;
        for (int i = 0; i < token.Length; i++)
            khac |= token[i] ^ nhanDuoc[i];

        return khac == 0;
    }
}
