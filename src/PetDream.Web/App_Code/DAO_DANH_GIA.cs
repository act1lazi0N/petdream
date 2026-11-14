using System;
using System.Data;
using System.Data.SqlClient;

public class DAO_DANH_GIA : DAO_CoSo
{
    public DataTable CongKhai(int id)
    {
        return Doc("sp_DanhGia_CongKhai", Int("@ThuCungId", id));
    }

    public DataRow ChiTiet(DanhTinhTaiKhoan nguoi, int id, bool quanTri, int? donHangId)
    {
        DataTable bang = Doc("sp_DanhGia_ChiTiet", Int("@NguoiId", nguoi.Id),
            Int("@PhienBanNguoi", nguoi.PhienBan), Int("@ChiTietId", id),
            new SqlParameter("@QuanTri", SqlDbType.Bit) { Value = quanTri },
            new SqlParameter("@DonHangId", SqlDbType.Int) { Value = (object)donHangId ?? DBNull.Value });
        return bang.Rows.Count == 0 ? null : bang.Rows[0];
    }

    public DataTable DanhSach(DanhTinhTaiKhoan nguoi)
    {
        return Doc("sp_DanhGia_QuanTri", Int("@NguoiId", nguoi.Id), Int("@PhienBanNguoi", nguoi.PhienBan));
    }

    public DataTable CoTheThem(DanhTinhTaiKhoan nguoi)
    {
        return Doc("sp_DanhGia_CoTheThem", Int("@NguoiId", nguoi.Id), Int("@PhienBanNguoi", nguoi.PhienBan));
    }

    public string Ghi(DanhTinhTaiKhoan nguoi, int id, bool quanTri, string thaoTac,
        byte[] phienBan, byte? soSao, string noiDung)
    {
        return (string)Doc("sp_DanhGia_Ghi", Int("@NguoiId", nguoi.Id), Int("@PhienBanNguoi", nguoi.PhienBan),
            Int("@ChiTietId", id), new SqlParameter("@QuanTri", SqlDbType.Bit) { Value = quanTri },
            new SqlParameter("@ThaoTac", SqlDbType.VarChar, 10) { Value = thaoTac },
            new SqlParameter("@PhienBan", SqlDbType.Binary, 8) { Value = (object)phienBan ?? DBNull.Value },
            new SqlParameter("@SoSao", SqlDbType.TinyInt) { Value = (object)soSao ?? DBNull.Value },
            new SqlParameter("@NoiDung", SqlDbType.NVarChar, 1000) { Value = (object)noiDung ?? DBNull.Value }).Rows[0][0];
    }

    private DataTable Doc(string thuTuc, params SqlParameter[] thamSo)
    {
        using (SqlConnection ketNoi = TaoKetNoi())
        using (SqlCommand lenh = new SqlCommand("dbo." + thuTuc, ketNoi))
        using (SqlDataAdapter adapter = new SqlDataAdapter(lenh))
        {
            lenh.CommandType = CommandType.StoredProcedure;
            lenh.CommandTimeout = 15;
            lenh.Parameters.AddRange(thamSo);
            DataTable bang = new DataTable();
            adapter.Fill(bang);
            return bang;
        }
    }

    private static SqlParameter Int(string ten, int giaTri)
    {
        return new SqlParameter(ten, SqlDbType.Int) { Value = giaTri };
    }
}
