# Kế hoạch xây dựng PetDream

Ngày cập nhật 12/11/2026. Tài liệu được chỉnh sửa và commit trên `develop`. Các nhánh feature đồng bộ từ `develop`. `main` dùng kiểm tra `main-no-plans`.

## 1. Mục tiêu và các quyết định đã chốt

Xây dựng đồ án bán thú cưng chạy local, gồm giao diện khách, quản trị, SQL Server, dữ liệu mẫu và hướng dẫn demo theo bảng chấm: **4 điểm khách + 6 điểm quản trị**.

- Stack: ASP.NET Web Forms, C#, .NET Framework 4.8, SQL Server, IIS Express.
- Cách tổ chức: `.aspx` → code-behind → DAO → stored procedure, bám mẫu LTWEB và chuẩn hóa cách viết.
- Dạng dự án: Web Site, mở `PetDream.sln` bằng Visual Studio, restore NuGet rồi Build/F5. Không có `.csproj`, không dùng script PowerShell để chạy dự án.
- Sản phẩm: 30 hồ sơ cá thể, gồm 10 chó, 10 mèo, 10 hamster. Mỗi bé chỉ bán một lần; số lượng của một bé trong giỏ luôn bằng 1.
- Khách được xem và thêm giỏ trước khi đăng nhập; bắt buộc đăng nhập khi xác nhận đặt hàng.
- Thanh toán COD; phí giao hàng cố định 30.000đ/đơn.
- Quản trị gồm 5 module: danh mục loài, thú cưng, tài khoản, đơn hàng, đánh giá.
- Hai cấp quản trị: admin toàn quyền; nhân viên vận hành theo bảng quyền bên dưới.
- Giao diện bám bố cục và tinh thần mẫu, tạo asset mới phù hợp thay vì cắt nguyên ảnh chụp màn hình.
- Ngoài V1: hosting, tin tức, chính sách, mã giảm giá, yêu thích, thanh toán trực tuyến, khôi phục mật khẩu qua email, đổi trả.

Nguồn yêu cầu đã đọc: tài liệu “Các chức năng phát triển”, hai ảnh bảng chấm, chín ảnh giao diện PetDream và mã mẫu LTWEB. Ảnh mẫu có một số chức năng ngoài phạm vi; áp dụng các quyết định đã chốt trong tài liệu này.

## 2. Hiện trạng và phần đã hoàn thành

- [x] Khung Web Site .NET Framework 4.8, solution dùng đường dẫn tương đối.
- [x] Master Page khách và quản trị, trang chủ tĩnh pastel, trang khởi đầu quản trị.
- [x] Lớp `DAO_CoSo` tạo SqlConnection chưa mở; DAO nghiệp vụ catalog đã có trong nhánh feature bên dưới.
- [x] BCrypt.Net-Next 4.2.0 và jQuery 3.7.1, cố định dependency trong `packages.config`.
- [x] NuGet restore vào `packages`; `Bin/*.dll.refresh` giúp IDE lấy DLL; jQuery và license lưu trong repo.
- [x] Cấu hình kết nối mẫu không chứa mật khẩu, mặc định `(localdb)\MSSQLLocalDB`, database `PetDream`.
- [x] Bỏ các script PowerShell; README hướng dẫn restore/build/chạy trên Visual Studio.
- [x] Khung đã build bằng Visual Studio; dependency đã được kiểm tra trên .NET Framework và IIS Express.
- [x] Schema catalog, 3 stored procedure, seed 30 hồ sơ/3 loài và ảnh local: đã triển khai trên `features/pet-catalog`.
- [x] Kết nối LocalDB thật, trang chủ, tìm/lọc/phân trang và chi tiết: đã kiểm tra trên nhánh feature.
- [x] Catalog đã merge vào `develop` qua PR #1, merge commit `2dc29c4`.

Các commit nền tảng: `c4eaa2c` (khung), `c924c27` (dependency), `22688fa` (quy trình IDE). Đây là trạng thái ban đầu của kế hoạch; kết quả build khung không chứng minh chức năng hoặc database đã hoàn thành.

Tiến độ mới: `features/pet-catalog`, commit `1777ada`, đã build bằng Visual Studio/MSBuild, đạt 19 kiểm tra .NET/SQL và kiểm tra trình duyệt ở 390/768/1440px. Đã kiểm tra seed lặp, lọc kết hợp, tìm không dấu, phân trang, 400/404/503 và xóa mềm. Bằng chứng chi tiết ở `docs/catalog-verification.md` trên nhánh feature. Chưa triển khai tài khoản/giỏ/đơn hàng/quản trị/đánh giá.

LocalDB thử nghiệm không hỗ trợ mã hóa khi kết nối ADO.NET với `Encrypt=True`; mẫu cấu hình của feature dùng `Encrypt=False` chỉ cho instance trên cùng máy. SQL Server từ xa phải có cấu hình riêng với `Encrypt=True` và chứng chỉ hợp lệ.

Không sao chép thông tin đăng nhập được trao đổi trong chat vào source, SQL, tài liệu hoặc commit.

## 3. Kiến trúc, coding style và dữ liệu

### 3.1 Cấu trúc và thư viện

- Giao diện khách dùng HTML/CSS, Repeater và server controls; quản trị dùng GridView, form nhập và validator.
- Dùng hai Master Page khách/quản trị và CSS dùng chung; JavaScript cho tương tác nhỏ, jQuery hỗ trợ Web Forms validation.
- DAO đặt trong `App_Code`, kế thừa `DAO_CoSo`, dùng ADO.NET `System.Data.SqlClient`, DataSet/DataTable và stored procedure.
- Không phụ thuộc DLL SqlDataAccess hoặc FreeTextBox không có source từ mẫu LTWEB. Mô tả V1 là văn bản nhiều dòng, không nhập HTML tự do.
- Mật khẩu dùng cặp `BCrypt.Net.BCrypt.EnhancedHashPassword` / `EnhancedVerify` nhất quán, để thư viện tự sinh salt; không lưu mật khẩu thô.
- `Web.config` mặc định trỏ file mẫu không chứa bí mật. Khi cần cấu hình riêng, làm theo README và giữ file chứa bí mật ngoài Git.

### 3.2 Quy ước viết code

- Lớp DAO theo dạng `DAO_THU_CUNG`; control dùng tiền tố `txt_`, `btn_`, `lbl_`, `ddl_`, `grv_`, `rpt_`.
- Hàm và biến nghiệp vụ dùng tiếng Việt không dấu, tên rõ nghĩa; thụt bốn dấu cách; ngoặc C# xuống dòng; comment tiếng Việt giải thích nghiệp vụ.
- Page_Load chỉ nạp dữ liệu ban đầu khi `!IsPostBack`; thao tác ghi phải kiểm tra hợp lệ và quyền phía server.
- Code-behind xử lý giao diện, DAO xử lý dữ liệu. Giao dịch đặt/hủy đơn thực hiện trong stored procedure.
- SqlParameter khai báo kiểu rõ ràng; không nối đầu vào vào SQL; dùng `using` để giải phóng kết nối và command.
- Không viết `catch` chỉ để `throw ex`; lỗi hiển thị cho khách không chứa thông tin nội bộ hoặc chuỗi kết nối.

### 3.3 Mô hình dữ liệu

Thực thể chính: `LOAI`, `THU_CUNG`, `ANH_THU_CUNG`, `TAI_KHOAN`, `DON_HANG`, `CHI_TIET_DON_HANG`, `DANH_GIA`.

- Hồ sơ thú cưng gồm mã, loài, giống, tên, giới tính, ngày sinh, kích thước/cân nặng, giá, mô tả, thông tin tiêm chủng, ảnh và trạng thái.
- Tài khoản có email và số điện thoại duy nhất, mật khẩu băm, vai trò, trạng thái hoạt động.
- Chi tiết đơn lưu bản chụp tên thú cưng và giá tại thời điểm đặt; sửa sản phẩm không thay đổi lịch sử đơn.
- Có khóa ngoại, ràng buộc dữ liệu và xóa mềm cho bản ghi đã được tham chiếu.
- Tách SQL schema, procedure và seed; chạy lại không nhân đôi dữ liệu hoặc tự xóa database.
- Dữ liệu đơn phục vụ kiểm thử tách khỏi seed 30 bé, để có thể chuẩn bị lại trạng thái demo.

## 4. Chức năng và quy tắc nghiệp vụ

### 4.1 Giao diện khách

- Trang chủ có banner, thú cưng nổi bật và các bé đang tìm chủ.
- Trang loài và danh sách hỗ trợ tìm tên/giống; lọc loài, giới tính, khoảng giá; sắp xếp mới nhất hoặc giá; phân trang 10 hồ sơ.
- Trang chi tiết có gallery, thông tin cá thể, mô tả, tiêm chủng, đánh giá và gợi ý cùng loài.
- Giỏ hàng lưu trong Session, giữ qua bước đăng nhập. Thêm một bé nhiều lần không sinh dòng trùng; chỉ có thao tác xóa, không tăng số lượng.
- Đăng ký bằng họ tên, email, điện thoại, mật khẩu và xác nhận mật khẩu; đăng nhập bằng email hoặc điện thoại. Có đăng xuất, sửa hồ sơ và đổi mật khẩu.
- Checkout thu tên người nhận, điện thoại, địa chỉ, ghi chú; hiển thị tiền hàng, phí giao và tổng tiền.
- Có xác nhận đặt thành công, lịch sử đơn, chi tiết đơn và hủy đơn đủ điều kiện.
- Liên hệ kiểm tra dữ liệu rồi thông báo gửi thành công; không gửi email hoặc lưu yêu cầu hỗ trợ.

### 4.2 Đặt hàng và chống bán trùng

- Trạng thái thú cưng: đang bán, đã giữ chỗ, đã bán, ngừng bán.
- Thêm vào giỏ không giữ chỗ. Khi xác nhận, server đọc lại giá và trạng thái; giá thay đổi thì yêu cầu khách xem lại trước khi đặt.
- Tạo đơn và giữ tất cả thú cưng trong cùng transaction. Nếu một bé không còn khả dụng, không tạo đơn dở dang.
- Mỗi lần checkout có mã chống gửi lặp; nhấn hai lần không tạo hai đơn.
- Luồng đơn: **Chờ xác nhận → Đã xác nhận → Đang giao → Đã giao**. Có trạng thái **Đã hủy** cho đơn chưa giao xong.
- Khách chỉ hủy khi chờ xác nhận. Nhân viên/admin xử lý hủy các bước tiếp theo trước khi đã giao.
- Hủy đơn mở bán lại bé đúng một lần; giao thành công chuyển bé thành đã bán. Không tự hết hạn giữ chỗ trong V1.
- Không chỉnh trạng thái giữ/bán của bé trực tiếp để né quy tắc giao dịch.

### 4.3 Đánh giá

- Khách chỉ đánh giá bé trong đơn đã giao của mình: 1–5 sao và nội dung, tối đa một đánh giá mỗi bé.
- Khách được sửa/xóa đánh giá của mình; đánh giá mới hoặc sửa phải chờ duyệt.
- Nhân viên duyệt/ẩn. Chỉ đánh giá được duyệt xuất hiện và tính điểm trung bình.
- Admin được nhập đánh giá gắn với đơn đã giao để có thao tác thêm trong quản trị; hiển thị rõ “do quản trị nhập”, lưu người nhập, không giả thành bài khách tự đăng.

### 4.4 Quản trị và quyền

| Module | Admin | Nhân viên |
| --- | --- | --- |
| Loài/danh mục | Danh sách, thêm, sửa, xóa | Xem |
| Thú cưng | Toàn bộ thao tác theo ràng buộc đơn hàng | Thêm, sửa, ngừng bán |
| Tài khoản | Tạo, sửa, phân quyền, khóa/xóa mềm | Không truy cập |
| Đơn hàng | Tạo hộ khách, xem, cập nhật, hủy, lưu trữ | Tạo hộ khách, xem, xử lý trạng thái, hủy |
| Đánh giá | Danh sách, thêm, sửa, xóa, duyệt/ẩn | Xem, duyệt/ẩn |

- Đơn tạo trong quản trị dùng chung quy tắc tồn kho và giá với checkout.
- Xóa đơn là lưu trữ đơn đã hủy, không xóa lịch sử giao dịch.
- Không xóa danh mục còn thú cưng hoặc hồ sơ đang thuộc đơn hoạt động.
- Không khóa/hạ quyền admin hoạt động cuối cùng.
- Trang quản trị hiện chỉ là nội dung tĩnh. Phải thêm xác thực và kiểm tra quyền phía server trước khi bổ sung dữ liệu/thao tác nhạy cảm.

## 5. Thiết kế và thứ tự triển khai

### 5.1 Thiết kế

Giữ tinh thần mộng mơ của mẫu: nền hồng/lavender, nút gradient tím, giá hồng đậm, thẻ bo góc, footer tím than, mây và dấu chân. Điều chỉnh bố cục theo mô hình mỗi bé một cá thể; bỏ nút tăng số lượng và các tính năng ngoài phạm vi V1.

Tạo banner, logo/mascot và ảnh nhất quán cho 30 hồ sơ. Lưu asset, font, icon local để demo không phụ thuộc mạng; ghi nguồn và quyền sử dụng asset bên ngoài. Giao diện hỗ trợ desktop, tablet, điện thoại, nhãn form, trạng thái lỗi và điều hướng bàn phím.

### 5.2 Các mốc còn lại

1. **Database:** xác minh `(localdb)\MSSQLLocalDB`; tạo schema, procedure, seed và kiểm tra kết nối bằng DAO. Không đổi sang SQLEXPRESS hoặc dữ liệu giả để che lỗi kết nối.
2. **Giao diện và dữ liệu:** hoàn thiện asset/CSS, seed 3 loài/30 hồ sơ; trang chủ, danh sách, lọc/tìm và chi tiết lấy dữ liệu thật.
3. **Tài khoản và mua hàng:** đăng ký/đăng nhập, phân quyền, giỏ, checkout, transaction giữ chỗ, lịch sử và hủy đơn.
4. **Quản trị và đánh giá:** hoàn thiện 5 module, luồng nhân viên/admin, đánh giá/duyệt và liên hệ.
5. **Nghiệm thu:** kiểm thử nghiệp vụ, đối chiếu mẫu, sửa lỗi responsive, hoàn thiện hướng dẫn IDE và kịch bản chấm điểm.

Mỗi mốc phải kiểm tra chạy được trước khi chuyển tiếp. Tiếp tục từ khung đã có, không dựng lại project hoặc đưa các script chạy local đã bỏ trở lại.

### 5.3 Phân chia công việc theo feature

Chia theo gói công việc để mỗi nhánh có đầu ra độc lập, có thể review và kiểm thử. Chưa có danh sách tên thành viên nên cột phụ trách là vai trò công việc, không phải người đã được chỉ định; người nhận việc ghi tên vào plan trên `develop` trước khi bắt đầu. Một người có thể kiêm nhiều vai trò. Không tự tạo đồng loạt các nhánh chưa có người làm.

| Mã | Nhánh | Phụ trách theo vai trò | Công việc và đầu ra | Phụ thuộc / trạng thái |
| --- | --- | --- | --- | --- |
| F01 | `features/pet-catalog` | Catalog + nền dữ liệu | Schema 3 bảng, seed 30 bé, asset, trang chủ/danh sách/chi tiết, bộ lọc, phân trang, xử lý lỗi | Đã kiểm tra và merge vào develop qua PR #1 |
| F02 | `features/accounts-auth` | Tài khoản + bảo mật | TAI_KHOAN, đăng ký, đăng nhập bằng email/điện thoại, đăng xuất, hồ sơ, đổi mật khẩu, BCrypt, phiên, khóa tài khoản, role guard admin/staff, CSRF cho thao tác ghi | Đủ phụ thuộc F01, xem kế hoạch ở mục 5.5 |
| F03 | `features/session-cart` | Giỏ hàng khách | Giỏ Session, thêm/xóa mỗi bé một lần, quantity luôn 1, kiểm tra trạng thái hiển thị, giữ giỏ qua đăng nhập; tổng tiền dự kiến | Sau F01; tích hợp bước đăng nhập khi F02 sẵn sàng |
| F04 | `features/cod-orders` | Đơn hàng + giao dịch SQL | DON_HANG/CHI_TIET_DON_HANG; checkout COD, phí 30.000đ, snapshot tên/giá, transaction giữ chỗ, mã chống gửi lặp, lịch sử/chi tiết/hủy đơn của khách | Sau F02 + F03; cung cấp nghiệp vụ đơn dùng chung cho quản trị |
| F05 | `features/admin-catalog` | Quản trị loài/thú cưng | GridView và form thêm/sửa/xóa mềm/ẩn; upload ảnh có kiểm tra; phân quyền admin/staff; ràng buộc danh mục và hồ sơ trong đơn | Sau F01 + F02 + F04; không cho sửa trạng thái để né giữ chỗ/bán |
| F06 | `features/admin-accounts` | Quản trị tài khoản | Danh sách/tạo/sửa/phân quyền/khóa/xóa mềm; bảo vệ admin hoạt động cuối; xử lý phiên của tài khoản bị khóa/đổi quyền | Sau F02; admin toàn quyền, staff không truy cập |
| F07 | `features/admin-orders` | Vận hành đơn hàng | Tạo hộ khách qua cùng procedure checkout, xem/cập nhật trạng thái/hủy, lưu trữ đơn đã hủy; giao thành công chuyển bé đã bán | Sau F02 + F04; dùng chung giao dịch, không viết luồng giữ chỗ thứ hai |
| F08 | `features/pet-reviews` | Đánh giá khách + kiểm duyệt | DANH_GIA; khách thêm/sửa/xóa sau giao; một đánh giá mỗi bé; duyệt/ẩn, điểm trung bình; admin nhập có nhãn và người nhập | Sau F02 + F04 + F07; gắn vào chi tiết F01, module quản trị thứ năm |
| F09 | `features/contact-form` | Giao diện liên hệ | Trang liên hệ, kiểm tra trường nhập, thông báo gửi thành công, điều hướng và responsive; không gửi email/lưu yêu cầu | Sau F01; làm độc lập với đơn hàng |
| F10 | `features/demo-acceptance` | Tích hợp + nghiệm thu | Kiểm thử xuyên suốt, đối chiếu bảng chấm, dữ liệu đơn demo riêng, tài khoản demo ba vai trò, README IDE và checklist bàn giao | Sau F01–F09; chỉ kết thúc khi luồng nghiệm thu mục 6 đạt |

Thứ tự nhận việc: F01 → F02/F03/F09 → F04/F06 → F05/F07 → F08 → F10. Có thể làm song song các gói không phụ thuộc nhau; chỉ bắt đầu phần tích hợp khi nhánh phụ thuộc đã merge vào `develop`. Nhánh hiện tại không tự triển khai các F02–F10.

### 5.4 Ranh giới sở hữu và bàn giao

- Mỗi feature sở hữu trang/code-behind, DAO, procedure và kiểm thử của mình. Khi cần sửa `Site.master`, `Admin.master`, CSS dùng chung, `Web.config` hoặc DAO chung, ghi rõ trong mô tả PR để tránh ghi đè thay đổi của nhóm khác.
- SQL mới dùng tiền tố số duy nhất. Giữ `001–003` cho catalog; dành `004–006` cho F02, `007–009` cho F04, `010–012` cho F05, `013–015` cho F06, `016–018` cho F07, `019–021` cho F08. F03/F09 không cần bảng mới. Nếu cần thêm số, cập nhật phân bổ trên develop trước.
- Không sửa schema/seed cũ để xóa dữ liệu đã có. Thay đổi tiếp theo dùng migration tăng dần, chạy lại an toàn, ghi thứ tự chạy trong database/README. Procedure có thể CREATE OR ALTER; không reset đơn/trạng thái khi seed lại.
- F02 công bố cách lấy người dùng hiện tại, kiểm tra vai trò và kiểm tra CSRF. Mọi trang quản trị dùng cùng guard phía server trước khi đọc/ghi dữ liệu; ẩn link menu không thay thế phân quyền.
- F04 sở hữu giao dịch đặt/hủy/chuyển trạng thái và quy tắc snapshot giá. F07 gọi lại hợp đồng này; F05 không tự sửa `giu_cho`/`da_ban` ngoài nghiệp vụ đơn.
- Khi F05 hỗ trợ ảnh upload thật, mở rộng ANH_THU_CUNG/helper render hiện dùng sprite; giữ tương thích 30 ảnh demo và chặn đường dẫn/định dạng không hợp lệ.
- Bàn giao mỗi feature: code + SQL/asset cần thiết + hướng dẫn IDE + kết quả kiểm tra. Build phải đạt; kiểm thử trường hợp thành công, đầu vào sai, lỗi dữ liệu và phân quyền nếu có. PR mô tả phạm vi, dependency, cách kiểm tra và phần chưa làm.

### 5.5 Kế hoạch triển khai F02 · Tài khoản và xác thực

Nhánh `features/accounts-auth` bắt đầu từ `develop` sau PR #1. F02 cung cấp tài khoản khách và xác thực cho quản trị. Giỏ Session, checkout và quản trị tài khoản lần lượt thuộc F03, F04 và F06.

Ở commit `2dc29c4`, `Web.config` dùng .NET Framework 4.8, `Global.asax.cs` đã có điểm khởi động ứng dụng và hai master đã có server form. `DAO_CoSo` cấp SqlConnection, `DAO_THU_CUNG` là mẫu ADO.NET gọi procedure có tham số, `packages.config` đã có BCrypt.Net-Next 4.2.0. Các nhận định dựa trên đọc mã trực tiếp vì PetDream chưa có chỉ mục GitNexus.

#### Thiết kế và phạm vi

- `database/004_accounts_schema.sql` thêm `TAI_KHOAN` với Id, họ tên, email chuẩn hóa, điện thoại chuẩn hóa, mật khẩu băm, vai trò `khach`/`staff`/`admin`, trạng thái và phiên bản xác thực. Dùng UNIQUE riêng cho email và điện thoại. Chuẩn hóa email bằng trim/lower invariant, điện thoại lưu chuỗi số với quy tắc VN nhất quán cho đăng ký, đăng nhập và cập nhật. Dùng email tối đa 254 ký tự và điện thoại Việt Nam ở dạng 0 + 9 chữ số. Chấp nhận đầu vào +84 tương đương và lưu cùng một dạng.
- `database/005_accounts_procedures.sql` thêm đăng ký khách, tra thông tin xác thực theo email hoặc điện thoại, đọc danh tính hiện hành theo Id, cập nhật hồ sơ và đổi mật khẩu. Đăng ký gán vai trò khách trong SQL. Cập nhật dựa trên Id phía server và phiên bản hiện hành, xử lý trùng từ constraint. Đổi mật khẩu xác minh mật khẩu cũ rồi cập nhật hash và tăng phiên bản trong cùng thao tác có điều kiện. `006` dành cho dữ liệu demo nếu cần, tạo theo hướng dẫn local với mật khẩu người chạy tự đặt.
- Thêm `DAO_TAI_KHOAN` theo mẫu DAO hiện có và dịch vụ xác thực dùng `EnhancedHashPassword`/`EnhancedVerify`. Giữ nguyên nội dung mật khẩu khi so khớp, kiểm tra độ dài trước khi băm và không đưa hash vào model hiển thị. Đăng nhập sai trả thông báo chung. Giới hạn thử đăng nhập theo tài khoản và nguồn, áp dụng ngưỡng tạm thời và kiểm tra trường hợp tài khoản không tồn tại.
- Thêm các trang `DangKy.aspx`, `DangNhap.aspx`, `TaiKhoan.aspx`, `DoiMatKhau.aspx` và thao tác đăng xuất POST trong master. Dùng validator Web Forms và xác nhận lại dữ liệu ở server. Tất cả thao tác ghi, kể cả đăng nhập và đăng xuất, kiểm tra token CSRF gắn với phiên. Tạo token mới khi danh tính thay đổi. Mặc định điều hướng về đích nội bộ cố định, dùng danh sách đích cho phép nếu cần quay lại checkout.
- Cấu hình Forms Authentication cho Web Forms với cookie HttpOnly, Secure qua HTTPS IIS Express, SameSite Lax, thời hạn cố định đề xuất 30 phút, không ghi nhớ mặc định. Ticket chỉ mang Id và phiên bản xác thực. Nạp lại tài khoản trong pipeline trước phân quyền, gắn principal từ vai trò SQL và kiểm tra phiên bản. Hủy ticket nếu tài khoản bị khóa, bị xóa hoặc phiên bản đã đổi. Khi SQL lỗi, route yêu cầu quyền trả 503 với thông báo chung. Đăng xuất xóa cookie của trình duyệt hiện tại. Đổi mật khẩu buộc đăng nhập lại và vô hiệu hóa các ticket cũ.
- Bảo vệ cả thư mục Admin trước khi chạy page handler, dùng principal đã xác minh. Phân biệt khách chưa đăng nhập cần chuyển đến trang đăng nhập và tài khoản đã đăng nhập thiếu quyền cần trả 403. Công bố hợp đồng lấy Id tài khoản hiện tại và guard dùng chung để F04/F06 dùng lại.
- Tham chiếu System.Web cho cấu hình cookie và pipeline. [SameSite trên ASP.NET 4.8](https://learn.microsoft.com/aspnet/samesite/system-web-samesite), [FormsAuthentication.RequireSSL](https://learn.microsoft.com/dotnet/api/system.web.security.formsauthentication.requiressl), [ASP.NET Security Overview](https://learn.microsoft.com/en-us/troubleshoot/developer/webapps/aspnet/development/security-overview).

#### Thứ tự triển khai

1. Từ `develop` đã đồng bộ, tạo `features/accounts-auth`. Chốt chuẩn hóa đầu vào, mã trạng thái SQL và vòng đời ticket rồi triển khai migration/DAO.
2. Viết đăng ký, đăng nhập và tra principal trên mỗi request. Chạy trang công khai và kiểm tra IIS Express HTTPS trước khi gắn guard quản trị.
3. Thêm sửa hồ sơ, đổi mật khẩu, đăng xuất và guard. Dùng Id hiện hành trên server khi ghi. Kiểm tra hai trình duyệt để xác nhận ticket cũ bị từ chối sau đổi mật khẩu hoặc khóa.
4. Cập nhật hướng dẫn SQL/Visual Studio, kiểm tra catalog và mở PR về `develop` sau khi đạt các ca kiểm thử bên dưới.

#### Kiểm thử trước PR

| Luồng | Kết quả cần kiểm tra |
| --- | --- |
| Đăng ký hợp lệ, trùng email/số điện thoại, hai request đồng thời | Chỉ một bản ghi hợp lệ, vai trò khách, mật khẩu đã băm, thông báo dễ hiểu |
| Đăng nhập bằng email và điện thoại, sai mật khẩu, tài khoản khóa, thử lặp | Đúng thì cấp cookie qua HTTPS, lỗi thì thông báo chung, giới hạn thử áp dụng |
| Hồ sơ và đổi mật khẩu | Chỉ sửa tài khoản hiện hành, dữ liệu trùng được xử lý, mật khẩu cũ và ticket cũ mất hiệu lực |
| Phiên và CSRF | Thiếu/sai token bị từ chối, logout GET không ghi, ticket hết hạn yêu cầu đăng nhập lại |
| Truy cập trực tiếp quản trị | Khách chưa đăng nhập được chuyển đến đăng nhập, khách đã đăng nhập nhận 403, admin/staff đúng quyền, SQL lỗi trả 503 |
| Hồi quy catalog | Trang chủ, danh mục, chi tiết và filter postback vẫn hoạt động khi ẩn danh và sau đăng nhập |

Trước khi mở PR, xác minh binding HTTPS của IIS Express và quy trình F5 trong Visual Studio. Chạy migration hai lần trên LocalDB đã có catalog và ghi kết quả kiểm thử thực tế vào PR. Bộ dữ liệu demo có thể được tạo cục bộ khi cần kiểm tra ba vai trò.

## 6. Kiểm thử và tiêu chí bàn giao

- Build toàn bộ solution bằng Visual Studio; các trang chạy trên IIS Express sau restore NuGet từ bản clone sạch.
- Có đủ 30 hồ sơ; kiểm tra lọc kết hợp, phân trang, kết quả rỗng và mã hồ sơ không tồn tại.
- Kiểm tra đăng ký trùng, đăng nhập sai, tài khoản khóa, phiên hết hạn và truy cập trực tiếp URL quản trị sai quyền.
- Đặt đơn thành công, giá thay đổi, bé đã được giữ, gửi lặp và hai tài khoản cùng đặt một bé: chỉ một đơn thành công.
- Kiểm tra rollback, hủy trả trạng thái đúng một lần, chuyển trạng thái sai, bảo toàn giá lịch sử.
- Kiểm tra từng thao tác quản trị, khóa ngoại, xóa mềm, upload sai định dạng/quá dung lượng và quyền phía server.
- Kiểm tra đánh giá trước/sau khi giao, đánh giá trùng, duyệt/ẩn và tính điểm.
- Kiểm tra đầu vào độc hại, mã hóa nội dung xuất ra, chống CSRF cho thao tác ghi và mật khẩu không lưu thô.
- Kiểm tra giao diện ở độ rộng 390, 768 và 1440px; không tràn ngang, ảnh/nút/form hoạt động.

Bàn giao gồm source, SQL, asset local, tài khoản demo cho ba vai trò, dữ liệu đơn kiểm thử riêng, hướng dẫn Visual Studio và checklist ánh xạ bảng chấm. Không đưa mật khẩu môi trường thật vào Git.

Chỉ đánh dấu đồ án hoàn thành khi luồng **đăng ký → chọn bé → đặt COD → quản trị xử lý → giao thành công → đánh giá** chạy xuyên suốt trên SQL Server thật. Báo cáo phân biệt kiểm tra đã chạy với kiểm tra chưa chạy.

## 7. Quy tắc Git cho tài liệu này

### 7.1 Đặt tên nhánh và nhận việc

- Nhánh chức năng bắt buộc theo mẫu **`features/<ten-feature>`**, dùng đúng tiền tố số nhiều `features/`. Phần tên dùng tiếng Anh ngắn, chữ thường ASCII, số nếu cần và dấu gạch ngang: `^[a-z0-9]+(-[a-z0-9]+)*$`.
- Ví dụ hợp lệ: `features/pet-catalog`, `features/accounts-auth`, `features/cod-orders`. Không dùng khoảng trắng, tiếng Việt có dấu, dấu ngoặc nhọn, tên thành viên hoặc tên mơ hồ như `features/test`, `features/update`.
- Một nhánh ứng với một gói công việc trong bảng 5.3; tên nhánh phải mô tả phạm vi cuối cùng. Dùng đúng tên đã phân bổ để tránh hai người làm trùng.
- Tạo nhánh từ `develop` đã cập nhật, không từ `main` hoặc nhánh feature đang làm dở. Working tree phải sạch trước khi đổi nhánh; commit phần việc có chủ đích, không dùng reset/force để bỏ thay đổi.

```bash
git switch develop
git pull --ff-only origin develop
git switch -c features/accounts-auth
# Thực hiện và kiểm tra feature
git add <cac-file-thuoc-feature>
git commit -m "feat(auth): add account registration and login"
git push -u origin features/accounts-auth
```

### 7.2 Cập nhật plan và đồng bộ feature

- Chỉnh sửa plan và commit tài liệu **trên develop**, tách khỏi commit code feature. Nhánh feature được phép chứa bản kế thừa của plan khi pull/merge develop; điều cấm là đưa plan vào main.
- Khi thêm file lần đầu trên develop, dùng `git add -f docs/plans/petdream-implementation.md`; file đã tracked thì dùng `git add -u -- docs/plans/petdream-implementation.md` để chỉ stage bản cập nhật, không vướng thư mục cha bị ignore. `/docs/plans/` vẫn ignore để tránh thêm mới ngoài ý muốn.
- Sau khi push commit plan lên develop, quay lại nhánh đang làm và kéo develop về bằng merge. Không rebase/force-push lịch sử nhánh đã chia sẻ.

```bash
git switch develop
git pull --ff-only origin develop
# Chỉnh plan: phạm vi, người nhận việc, dependency, trạng thái và kết quả kiểm tra
git add -u -- docs/plans/petdream-implementation.md
git commit -m "docs(plan): assign feature work and branch conventions"
git push origin develop
git switch features/pet-catalog
git pull --no-rebase origin develop
git push -u origin features/pet-catalog
```

- Nếu có conflict: giữ cả yêu cầu mới và phần triển khai liên quan, giải quyết theo từng file, kiểm tra lại phần bị ảnh hưởng rồi commit merge. Không chọn nguyên `ours/theirs` để bỏ toàn bộ phía còn lại.
- PR feature luôn có **base = develop**. Trước khi merge, cập nhật develop vào feature, kiểm tra diff/build và ghi bằng chứng kiểm thử. Sau merge mới cập nhật trạng thái “đã tích hợp develop” trong plan.

### 7.3 Đưa bản nghiệm thu lên main

- `.gitignore` không ngăn file đã tracked đi theo merge. Workflow `main-no-plans` kiểm tra cây file; main đang yêu cầu PR và required check này, áp dụng cả admin.
- Tạo nhánh `release/<phien-ban>` từ main rồi chỉ cherry-pick commit triển khai đã nghiệm thu. Commit đồng bộ/biên tập plan không được cherry-pick; không merge nguyên develop hoặc features có plan vào main.
- Đối chiếu danh sách file trước PR lên main: không có `docs/plans/`, secret, database runtime, packages hoặc build output. Việc đồng bộ plan vào feature không thay đổi quy tắc này.
