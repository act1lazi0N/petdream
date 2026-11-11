# PetDream

Khung đồ án website bán thú cưng bằng **ASP.NET Web Forms, C#, .NET Framework 4.8 và SQL Server**.
Phong cách giao diện hồng/tím pastel, lấy cảm hứng từ mẫu PetDream.

## Hiện có

- Solution Web Site dùng đường dẫn tương đối.
- Master Page khách và quản trị; trang chủ tĩnh responsive và trang khung quản trị.
- Lớp cơ sở DAO dùng ADO.NET, cấu hình LocalDB tách riêng theo máy.
- Script khởi tạo cấu hình, biên dịch và chạy IIS Express.
- Quy ước mã nguồn, thư mục database và tài liệu kiến trúc.

Chưa có đăng nhập, CRUD, database/schema, dữ liệu thú cưng hoặc đặt hàng. Các trang khung chạy mà không mở kết nối SQL Server.

## Yêu cầu môi trường

- Windows, .NET Framework 4.8 Developer Pack và IIS Express.
- Visual Studio với công cụ ASP.NET/.NET Framework nếu mở solution bằng IDE.
- SQL Server LocalDB cho giai đoạn triển khai dữ liệu; khung giao diện chưa yêu cầu database.

## Chạy local

Tại thư mục repository:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\Build.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\Start-Local.ps1
```

Mở `http://localhost:8088/` hoặc `/Admin/Default.aspx`. Dừng server bằng Ctrl+C.
Đổi cổng bằng `-Port 8090`. Có thể mở `PetDream.sln` bằng Visual Studio sau khi chạy `scripts\Initialize-Local.ps1`.

## Cấu hình database

Script tự sao chép `ConnectionStrings.example.config` thành `ConnectionStrings.config` nếu chưa có; không ghi đè bản đang dùng.
File local nằm trong `src/PetDream.Web`, được Git bỏ qua. Mẫu dùng Windows Authentication đến `(localdb)\MSSQLLocalDB`, database `PetDream`, không chứa mật khẩu và chưa được xác minh kết nối.

Nếu môi trường yêu cầu SQL Authentication, chỉnh **file local**: bỏ `Integrated Security=True`, thêm `User ID` và `Password` của máy chạy. Không đưa mật khẩu thật vào file mẫu hoặc README.
Mẫu giữ `Encrypt=True;TrustServerCertificate=False`; cấu hình chứng chỉ/kết nối phải được xác minh trước khi dùng database.
`Command Timeout` từ SSMS không phải khóa connection string của `System.Data.SqlClient`; cấu hình timeout câu lệnh trên `SqlCommand` khi triển khai DAO.

## Cấu trúc

```text
PetDream.sln
src/PetDream.Web/
  App_Code/              # DAO và lớp dùng chung
  Admin/                 # Master Page và trang khung quản trị
  App_Data/              # Dữ liệu local, không commit
  Content/               # CSS
  Images/                # Asset hình ảnh
  Site.master
  Default.aspx
  Web.config
scripts/                 # Khởi tạo, biên dịch, chạy local
database/                # Dành cho SQL ở giai đoạn sau
docs/architecture.md
```

Output biên dịch nằm trong `.artifacts/` và không được commit. Không dùng `dotnet run` cho dự án Web Forms này.
