using System;
using System.Data;
using System.Data.SqlClient;

public class HoSoQuanTriThuCung
{
    public string Ma { get; set; }
    public int LoaiId { get; set; }
    public string Ten { get; set; }
    public string Giong { get; set; }
    public string GioiTinh { get; set; }
    public DateTime NgaySinh { get; set; }
    public decimal CanNang { get; set; }
    public string KichThuoc { get; set; }
    public decimal Gia { get; set; }
    public string MoTa { get; set; }
    public string TiemChung { get; set; }
    public string DacDiem { get; set; }
    public string TrangThai { get; set; }
    public bool NoiBat { get; set; }
}

public class DAO_QUAN_TRI_DANH_MUC : DAO_CoSo
{
    public DataTable DanhSachLoai() { return Doc("sp_QuanTriLoai_DanhSach"); }
    public DataRow ChiTietLoai(int id) { return Dong(Doc("sp_QuanTriLoai_ChiTiet", So("@Id", id))); }
    public string LuuLoai(DanhTinhTaiKhoan nguoi, int id, string ma, string ten, string moTa, int thuTu)
    {
        return KetQua(Doc("sp_QuanTriLoai_Luu", Nguoi(nguoi), PhienBan(nguoi), So("@Id", id),
            Chuoi("@Ma", SqlDbType.VarChar, 20, ma), Chuoi("@Ten", SqlDbType.NVarChar, 60, ten),
            Chuoi("@MoTa", SqlDbType.NVarChar, 250, moTa), So("@ThuTu", thuTu)));
    }
    public string XoaLoai(DanhTinhTaiKhoan nguoi, int id)
    {
        return KetQua(Doc("sp_QuanTriLoai_Xoa", Nguoi(nguoi), PhienBan(nguoi), So("@Id", id)));
    }
    public DataTable DanhSachThuCung() { return Doc("sp_QuanTriThuCung_DanhSach"); }
    public DataRow ChiTietThuCung(int id) { return Dong(Doc("sp_QuanTriThuCung_ChiTiet", So("@Id", id))); }
    public DataRow LuuThuCung(DanhTinhTaiKhoan nguoi, int id, HoSoQuanTriThuCung hoSo, string duongDanAnh)
    {
        return Dong(Doc("sp_QuanTriThuCung_Luu", Nguoi(nguoi), PhienBan(nguoi), So("@Id", id),
            Chuoi("@Ma", SqlDbType.VarChar, 30, hoSo.Ma), So("@LoaiId", hoSo.LoaiId),
            Chuoi("@Ten", SqlDbType.NVarChar, 80, hoSo.Ten), Chuoi("@Giong", SqlDbType.NVarChar, 100, hoSo.Giong),
            Chuoi("@GioiTinh", SqlDbType.Char, 1, hoSo.GioiTinh),
            new SqlParameter("@NgaySinh", SqlDbType.Date) { Value = hoSo.NgaySinh.Date },
            new SqlParameter("@CanNang", SqlDbType.Decimal) { Precision = 6, Scale = 2, Value = hoSo.CanNang },
            Chuoi("@KichThuoc", SqlDbType.NVarChar, 100, hoSo.KichThuoc),
            new SqlParameter("@Gia", SqlDbType.Decimal) { Precision = 18, Scale = 0, Value = hoSo.Gia },
            Chuoi("@MoTa", SqlDbType.NVarChar, 2000, hoSo.MoTa),
            Chuoi("@TiemChung", SqlDbType.NVarChar, 1000, hoSo.TiemChung),
            Chuoi("@DacDiem", SqlDbType.NVarChar, 1000, hoSo.DacDiem),
            Chuoi("@TrangThai", SqlDbType.VarChar, 20, hoSo.TrangThai),
            new SqlParameter("@NoiBat", SqlDbType.Bit) { Value = hoSo.NoiBat },
            Chuoi("@DuongDanAnh", SqlDbType.NVarChar, 250, duongDanAnh)));
    }
    public string XoaThuCung(DanhTinhTaiKhoan nguoi, int id)
    {
        return KetQua(Doc("sp_QuanTriThuCung_Xoa", Nguoi(nguoi), PhienBan(nguoi), So("@Id", id)));
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
    private static DataRow Dong(DataTable bang) { return bang.Rows.Count == 0 ? null : bang.Rows[0]; }
    private static string KetQua(DataTable bang)
    {
        DataRow dong = Dong(bang);
        return dong == null ? "khong_hop_le" : Convert.ToString(dong["KetQua"]);
    }
    private static SqlParameter Nguoi(DanhTinhTaiKhoan nguoi) { return So("@NguoiId", nguoi == null ? 0 : nguoi.Id); }
    private static SqlParameter PhienBan(DanhTinhTaiKhoan nguoi) { return So("@PhienBanNguoi", nguoi == null ? 0 : nguoi.PhienBan); }
    private static SqlParameter So(string ten, int giaTri) { return new SqlParameter(ten, SqlDbType.Int) { Value = giaTri }; }
    private static SqlParameter Chuoi(string ten, SqlDbType kieu, int doDai, string giaTri)
    {
        return new SqlParameter(ten, kieu, doDai) { Value = (object)giaTri ?? DBNull.Value };
    }
}
