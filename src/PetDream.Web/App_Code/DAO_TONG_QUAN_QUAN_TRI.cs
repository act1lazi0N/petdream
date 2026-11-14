using System.Data;
using System.Data.SqlClient;

public class DAO_TONG_QUAN_QUAN_TRI : DAO_CoSo
{
    public DataSet TongQuan(DanhTinhTaiKhoan nguoi)
    {
        using (SqlConnection ketNoi = TaoKetNoi())
        using (SqlCommand lenh = new SqlCommand("dbo.sp_Admin_TongQuan", ketNoi))
        using (SqlDataAdapter adapter = new SqlDataAdapter(lenh))
        {
            lenh.CommandType = CommandType.StoredProcedure;
            lenh.CommandTimeout = 15;
            lenh.Parameters.Add("@NguoiId", SqlDbType.Int).Value = nguoi == null ? 0 : nguoi.Id;
            lenh.Parameters.Add("@PhienBanNguoi", SqlDbType.Int).Value = nguoi == null ? 0 : nguoi.PhienBan;
            DataSet duLieu = new DataSet();
            ketNoi.Open();
            adapter.Fill(duLieu);
            return duLieu;
        }
    }
}
