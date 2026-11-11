# PetDream

Khung đồ án website bán thú cưng bằng **ASP.NET Web Forms, C#, .NET Framework 4.8 và SQL Server**.
Phong cách giao diện hồng/tím pastel, lấy cảm hứng từ mẫu PetDream.

## Hiện có

- Solution Web Site dùng đường dẫn tương đối.
- Master Page khách và quản trị; trang chủ tĩnh responsive và trang khung quản trị.
- Lớp cơ sở DAO dùng ADO.NET, cấu hình LocalDB tách riêng theo máy.
- Script khởi tạo cấu hình, biên dịch và chạy IIS Express.
- Quy ước mã nguồn, thư mục database và tài liệu kiến trúc.
- Dependency cố định phiên bản, tự restore qua NuGet và phục vụ JavaScript local.

Chưa có đăng nhập, CRUD, database/schema, dữ liệu thú cưng hoặc đặt hàng. Các trang khung chạy mà không mở kết nối SQL Server.

## Yêu cầu môi trường

- Windows, .NET Framework 4.8 Developer Pack và IIS Express.
- Visual Studio với công cụ ASP.NET/.NET Framework nếu mở solution bằng IDE.
- SQL Server LocalDB cho giai đoạn triển khai dữ liệu; khung giao diện chưa yêu cầu database.
- Kết nối Internet khi restore lần đầu; các lần sau dùng package cache trong `.artifacts/`.

## Chạy local

Tại thư mục repository:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\Build.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\Start-Local.ps1
```

Mở `http://localhost:8088/` hoặc `/Admin/Default.aspx`. Dừng server bằng Ctrl+C.
Đổi cổng bằng `-Port 8090`. Có thể mở `PetDream.sln` bằng Visual Studio sau khi chạy `scripts\Initialize-Local.ps1`.

## Thư viện

| Thư viện | Phiên bản | Mục đích |
| --- | --- | --- |
| [BCrypt.Net-Next](https://www.nuget.org/packages/BCrypt.Net-Next/4.2.0) | 4.2.0 | Băm và xác minh mật khẩu khi triển khai tài khoản |
| [jQuery](https://www.nuget.org/packages/jQuery/3.7.1) | 3.7.1 | Script mapping cho Web Forms unobtrusive validation, được nạp local qua hai Master Page |

Các dependency bắc cầu của BCrypt được cố định trong `src/PetDream.Web/packages.config`: System.Buffers 4.6.1, System.Memory 4.6.3, System.Numerics.Vectors 4.6.1, System.Runtime.CompilerServices.Unsafe 6.1.2. ADO.NET và các control/validator Web Forms dùng thư viện có sẵn trong .NET Framework.

`Initialize-Local.ps1` (được gọi từ build/start) tự restore. Có thể chạy riêng:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\Restore-Dependencies.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\Test-Dependencies.ps1
```

NuGet CLI 6.14.0 được tải từ `dist.nuget.org`, kiểm tra SHA-256 trước khi chạy; package chỉ lấy từ nguồn khai báo trong `NuGet.Config`. Script copy DLL tương thích .NET Framework vào `Bin` và jQuery vào `Scripts/vendor`; không dùng CDN lúc chạy website. Các thư mục này cùng package cache không commit.

Khi đổi phiên bản, cập nhật `packages.config`, asset mapping trong script restore, script mapping trong `Global.asax.cs` nếu đổi jQuery, và binding redirect nếu phiên bản assembly thay đổi. Chạy lại build và kiểm tra dependency. Không dùng `dotnet add package` trực tiếp vì đây là Web Site không có `.csproj`.

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
