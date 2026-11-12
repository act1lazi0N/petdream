using System;
using System.Collections.Specialized;
using System.Globalization;
using System.Web;

public class BoLocThuCung
{
    public string TuKhoa { get; set; }
    public int? LoaiId { get; set; }
    public string GioiTinh { get; set; }
    public decimal? GiaTu { get; set; }
    public decimal? GiaDen { get; set; }
    public string SapXep { get; set; }
    public int Trang { get; set; }

    public static BoLocThuCung TuQuery(NameValueCollection query)
    {
        BoLocThuCung loc = new BoLocThuCung();
        loc.TuKhoa = (query["q"] ?? "").Trim();
        if (loc.TuKhoa.Length > 100) throw new FormatException("Từ khóa tối đa 100 ký tự.");
        loc.LoaiId = DocSoNguyen(query["loai"], "Loài");
        loc.GioiTinh = query["gioitinh"] ?? "";
        if (loc.GioiTinh != "" && loc.GioiTinh != "D" && loc.GioiTinh != "C")
            throw new FormatException("Giới tính không hợp lệ.");
        loc.GiaTu = DocGia(query["min"]);
        loc.GiaDen = DocGia(query["max"]);
        if (loc.GiaTu.HasValue && loc.GiaDen.HasValue && loc.GiaTu > loc.GiaDen)
            throw new FormatException("Giá tối thiểu không được lớn hơn giá tối đa.");
        loc.SapXep = string.IsNullOrEmpty(query["sort"]) ? "moi" : query["sort"];
        if (loc.SapXep != "moi" && loc.SapXep != "gia_tang" && loc.SapXep != "gia_giam")
            throw new FormatException("Kiểu sắp xếp không hợp lệ.");
        loc.Trang = DocSoNguyen(query["page"], "Trang") ?? 1;
        return loc;
    }

    private static int? DocSoNguyen(string value, string ten)
    {
        if (string.IsNullOrEmpty(value)) return null;
        int so;
        if (!int.TryParse(value, NumberStyles.None, CultureInfo.InvariantCulture, out so) || so < 1)
            throw new FormatException(ten + " phải là số nguyên dương.");
        return so;
    }

    private static decimal? DocGia(string value)
    {
        if (string.IsNullOrWhiteSpace(value)) return null;
        decimal gia;
        if (!decimal.TryParse(value, NumberStyles.None, CultureInfo.InvariantCulture, out gia) || gia < 0 || gia > 1000000000000m)
            throw new FormatException("Giá phải là số nguyên từ 0 đến 1.000.000.000.000 đồng.");
        return gia;
    }

    public string TaoQuery(int trang)
    {
        NameValueCollection query = HttpUtility.ParseQueryString("");
        if (TuKhoa != "") query["q"] = TuKhoa;
        if (LoaiId.HasValue) query["loai"] = LoaiId.Value.ToString(CultureInfo.InvariantCulture);
        if (GioiTinh != "") query["gioitinh"] = GioiTinh;
        if (GiaTu.HasValue) query["min"] = GiaTu.Value.ToString(CultureInfo.InvariantCulture);
        if (GiaDen.HasValue) query["max"] = GiaDen.Value.ToString(CultureInfo.InvariantCulture);
        query["sort"] = SapXep;
        query["page"] = trang.ToString(CultureInfo.InvariantCulture);
        return query.ToString();
    }
}
