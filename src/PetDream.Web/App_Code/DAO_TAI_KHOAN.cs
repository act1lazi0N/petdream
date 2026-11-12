using System;
using System.Data;
using System.Data.SqlClient;

public class DAO_TAI_KHOAN : DAO_CoSo
{
    public void DangKy(HoSoTaiKhoan hoSo, string matKhauBam)
    {
        Doc("sp_TaiKhoan_DangKy", HoTen(hoSo.HoTen), Email(hoSo.Email),
            DienThoai(hoSo.DienThoai), MatKhauBam(matKhauBam));
    }

    public DataRow TimDangNhap(string email, string dienThoai)
    {
        return DocDong("sp_TaiKhoan_TimDangNhap", Email(email), DienThoai(dienThoai));
    }

    public DanhTinhTaiKhoan DanhTinh(int id)
    {
        DataRow dong = DocDong("sp_TaiKhoan_DanhTinh", Id(id));
        if (dong == null)
            return null;

        return new DanhTinhTaiKhoan
        {
            Id = (int)dong["Id"],
            HoTen = (string)dong["HoTen"],
            Email = (string)dong["Email"],
            DienThoai = (string)dong["DienThoai"],
            VaiTro = (string)dong["VaiTro"],
            PhienBan = (int)dong["PhienBanXacThuc"]
        };
    }

    public string MatKhau(DanhTinhTaiKhoan taiKhoan)
    {
        DataRow dong = DocDong("sp_TaiKhoan_MatKhau", Id(taiKhoan.Id), PhienBan(taiKhoan.PhienBan));
        return dong == null ? null : (string)dong["MatKhauBam"];
    }

    public bool CapNhat(DanhTinhTaiKhoan taiKhoan, HoSoTaiKhoan hoSo)
    {
        DataRow dong = DocDong("sp_TaiKhoan_CapNhat", Id(taiKhoan.Id), PhienBan(taiKhoan.PhienBan),
            HoTen(hoSo.HoTen), Email(hoSo.Email), DienThoai(hoSo.DienThoai));
        return (int)dong[0] == 1;
    }

    public bool DoiMatKhau(DanhTinhTaiKhoan taiKhoan, string matKhauBam)
    {
        DataRow dong = DocDong("sp_TaiKhoan_DoiMatKhau", Id(taiKhoan.Id),
            PhienBan(taiKhoan.PhienBan), MatKhauBam(matKhauBam));
        return (int)dong[0] == 1;
    }

    private DataRow DocDong(string thuTuc, params SqlParameter[] thamSo)
    {
        DataTable bang = Doc(thuTuc, thamSo);
        return bang.Rows.Count == 0 ? null : bang.Rows[0];
    }

    private DataTable Doc(string thuTuc, params SqlParameter[] thamSo)
    {
        using (SqlConnection ketNoi = TaoKetNoi())
        using (SqlCommand lenh = new SqlCommand("dbo." + thuTuc, ketNoi))
        {
            lenh.CommandType = CommandType.StoredProcedure;
            lenh.CommandTimeout = 15;
            lenh.Parameters.AddRange(thamSo);
            ketNoi.Open();
            using (SqlDataReader reader = lenh.ExecuteReader())
            {
                DataTable bang = new DataTable();
                bang.Load(reader);
                return bang;
            }
        }
    }

    private static SqlParameter HoTen(string giaTri)
    {
        return new SqlParameter("@HoTen", SqlDbType.NVarChar, 100) { Value = giaTri };
    }

    private static SqlParameter Email(string giaTri)
    {
        return new SqlParameter("@Email", SqlDbType.NVarChar, 254) { Value = (object)giaTri ?? DBNull.Value };
    }

    private static SqlParameter DienThoai(string giaTri)
    {
        return new SqlParameter("@DienThoai", SqlDbType.VarChar, 10) { Value = (object)giaTri ?? DBNull.Value };
    }

    private static SqlParameter MatKhauBam(string giaTri)
    {
        return new SqlParameter("@MatKhauBam", SqlDbType.VarChar, 100) { Value = giaTri };
    }

    private static SqlParameter Id(int giaTri)
    {
        return new SqlParameter("@Id", SqlDbType.Int) { Value = giaTri };
    }

    private static SqlParameter PhienBan(int giaTri)
    {
        return new SqlParameter("@PhienBan", SqlDbType.Int) { Value = giaTri };
    }
}
