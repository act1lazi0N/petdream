# PetDream

Khung đồ án website bán thú cưng bằng **ASP.NET Web Forms, C#, .NET Framework 4.8 và SQL Server**.
Phong cách giao diện hồng/tím pastel, lấy cảm hứng từ mẫu PetDream.

## Hiện có

- Solution Web Site dùng đường dẫn tương đối, mở và chạy trực tiếp trong Visual Studio.
- Master Page khách và quản trị; trang chủ tĩnh responsive và trang khung quản trị.
- Lớp cơ sở DAO dùng ADO.NET, cấu hình LocalDB mẫu không chứa mật khẩu.
- Dependency cố định phiên bản, restore bằng NuGet trong IDE; JavaScript được phục vụ local.
- Quy ước mã nguồn, thư mục database và tài liệu kiến trúc.

Chưa có đăng nhập, CRUD, database/schema, dữ liệu thú cưng hoặc đặt hàng. Các trang khung chạy mà không mở kết nối SQL Server.

## Chạy bằng Visual Studio

Yêu cầu Windows, Visual Studio với workload **ASP.NET and web development**, .NET Framework 4.8 Developer Pack và IIS Express. Visual Studio Code không thay thế Visual Studio cho quy trình này.

1. Mở `PetDream.sln`.
2. Chuột phải solution → **Restore NuGet Packages**. Cần Internet cho lần tải package đầu tiên.
3. Chọn `PetDream.Web` làm **StartUp Project**, chọn `Default.aspx` làm **Start Page** nếu IDE chưa chọn sẵn.
4. Chọn **Build Solution**, rồi nhấn **F5** hoặc **Ctrl+F5** để chạy với IIS Express.

Trang quản trị khởi đầu ở `/Admin/Default.aspx`. Cổng gợi ý là 8088; dùng địa chỉ thực tế IDE mở. Không cần chạy script hoặc tạo database để xem các trang khung.

Nếu IDE không tự restore, vào **Tools → Options → NuGet Package Manager → General** và bật hai tùy chọn cho phép tải package còn thiếu và tự kiểm tra package khi build.

## Thư viện

| Thư viện | Phiên bản | Mục đích |
| --- | --- | --- |
| [BCrypt.Net-Next](https://www.nuget.org/packages/BCrypt.Net-Next/4.2.0) | 4.2.0 | Băm và xác minh mật khẩu khi triển khai tài khoản |
| [jQuery](https://www.nuget.org/packages/jQuery/3.7.1) | 3.7.1 | Script mapping cho Web Forms unobtrusive validation, nạp local qua hai Master Page |

Các dependency bắc cầu của BCrypt được cố định trong `src/PetDream.Web/packages.config`: System.Buffers 4.6.1, System.Memory 4.6.3, System.Numerics.Vectors 4.6.1, System.Runtime.CompilerServices.Unsafe 6.1.2. ADO.NET và các control/validator Web Forms có sẵn trong .NET Framework.

NuGet restore vào thư mục `packages` cạnh solution. Các file `Bin/*.dll.refresh` được commit để Visual Studio lấy đúng DLL khi build; DLL và package tải về không commit. Các đường dẫn trong file `.refresh` tính từ `src/PetDream.Web`, không phải từ `Bin`.

jQuery và source map trong `Scripts/vendor` được commit cùng license header vì package restore không khôi phục content vào Web Site. Khi nâng phiên bản trong **Manage NuGet Packages**, kiểm tra lại tham chiếu `.dll.refresh`, binding redirect và cập nhật jQuery trong `Scripts/vendor` cùng mapping ở `Global.asax.cs`. Không dùng `dotnet add package` hoặc `dotnet run` cho Web Site này.

## Cấu hình database

`Web.config` mặc định dùng `ConnectionStrings.example.config`, chứa Windows Authentication đến `(localdb)\MSSQLLocalDB`, database `PetDream`. Không có mật khẩu trong cấu hình được commit. Chưa tạo database hoặc xác minh kết nối.

Để dùng cấu hình riêng, sao chép file mẫu thành `ConnectionStrings.config` trong cùng thư mục bằng IDE, rồi đổi `configSource` trong `Web.config` sang `ConnectionStrings.config`. File local được Git bỏ qua. Trước khi chia sẻ thay đổi, giữ `Web.config` trỏ về file mẫu để người khác clone vẫn chạy được.

Nếu môi trường yêu cầu SQL Authentication, chỉ chỉnh **file local**: bỏ `Integrated Security=True`, thêm `User ID` và `Password` của máy chạy. Không đưa mật khẩu thật vào file mẫu hoặc README.
Mẫu giữ `Encrypt=True;TrustServerCertificate=False`; cấu hình chứng chỉ/kết nối phải được xác minh khi triển khai database. `Command Timeout` từ SSMS không phải khóa connection string của `System.Data.SqlClient`; đặt timeout trên `SqlCommand` khi triển khai DAO.

## Quy tắc nhánh

- Phát triển trên `develop`. Kế hoạch nằm tại `docs/plans/petdream-implementation.md` và chỉ được theo dõi trên nhánh này.
- `/docs/plans/` được ignore để tránh vô tình thêm file mới. Khi chủ động thêm kế hoạch trên `develop`, dùng `git add -f` cho đúng file; sửa file đã được theo dõi thì stage bình thường.
- `.gitignore` không chặn file đã được theo dõi đi theo merge. Workflow `main-no-plans` kiểm tra toàn bộ cây file của PR vào `main` và báo lỗi nếu còn `docs/plans`.
- Khi đưa code lên `main`, tạo nhánh release từ `main`, cherry-pick các commit triển khai không chứa kế hoạch rồi mở PR. Không merge trực tiếp toàn bộ `develop` có file kế hoạch vào `main`.
- GitHub phải bật required check `main-no-plans` và yêu cầu PR cho `main` để quy tắc được cưỡng chế trước khi merge; chỉ có workflow hoặc ignore là chưa đủ.

## Cấu trúc

```text
PetDream.sln
NuGet.Config
src/PetDream.Web/
  App_Code/              # DAO và lớp dùng chung
  Admin/                 # Master Page và trang khung quản trị
  Bin/*.dll.refresh      # Tham chiếu DLL cho Visual Studio
  App_Data/              # Dữ liệu local, không commit
  Content/               # CSS
  Images/                # Asset hình ảnh
  Scripts/vendor/        # jQuery local
  Site.master
  Default.aspx
  Web.config
  packages.config
database/                # Dành cho SQL ở giai đoạn sau
docs/architecture.md
```

Thư mục `packages`, DLL trong `Bin`, cấu hình IDE `.vs` và output `.artifacts` được Git bỏ qua.
