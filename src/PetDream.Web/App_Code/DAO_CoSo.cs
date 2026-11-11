using System.Configuration;
using System.Data.SqlClient;

/// <summary>
/// Cung cấp kết nối cho các DAO; không tự mở kết nối hoặc tạo database.
/// </summary>
public abstract class DAO_CoSo
{
    protected SqlConnection TaoKetNoi()
    {
        ConnectionStringSettings cauHinh = ConfigurationManager.ConnectionStrings["PetDream"];

        if (cauHinh == null || string.IsNullOrWhiteSpace(cauHinh.ConnectionString))
        {
            throw new ConfigurationErrorsException("Chưa cấu hình kết nối PetDream.");
        }

        return new SqlConnection(cauHinh.ConnectionString);
    }
}
