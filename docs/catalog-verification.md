# Kiểm chứng feature pet-catalog

Ngày kiểm tra: 11/11/2026. Môi trường: Windows, .NET Framework 4.8, SQL Server LocalDB, IIS Express và Chromium headless.

## Đã kiểm tra

- Chạy schema, procedure và seed thành công; seed lần hai vẫn có đúng 3 loài, 30 hồ sơ, 30 bản ghi ảnh.
- MSBuild và Visual Studio IDE biên dịch toàn bộ Web Site thành công (1 project, 0 failed).
- 19 kiểm tra .NET/SQL trực tiếp: roundtrip query có tiếng Việt/ký tự đặc biệt; đầu vào số/giá/sắp xếp sai; mã hóa HTML; từ chối đường dẫn ảnh lạ; DAO trả đủ dữ liệu; 6 hồ sơ nổi bật; tìm không dấu với chữ đ; trạng thái ngừng bán/giữ chỗ/đã bán; xóa mềm và tổng kết quả. Thay đổi trạng thái khi kiểm thử nằm trong transaction và đã rollback.
- Trình duyệt kiểm tra form postback chuyển sang GET; tìm `poodle` và `bong`; lọc kết hợp loài/giới tính/giá; thứ tự giá; hai trang không trùng hồ sơ; trang vượt giới hạn về trang cuối; kết quả rỗng.
- HTTP 400 cho bộ lọc sai, HTTP 404 cho ID sai/không có; chuỗi giống SQL injection và ký tự % được tìm như văn bản, không làm thay đổi truy vấn.
- Đã quan sát HTTP 503 với thông báo chung khi cấu hình kết nối không tương thích LocalDB; sau khi chỉnh cấu hình local, trang chủ trả 200 và 6 thẻ dữ liệu.
- Trang chủ, danh mục và chi tiết được chụp ở 390, 768, 1440px; kiểm tra không tràn ngang, ảnh nền thẻ hợp lệ, asset trả 200 và không có lỗi JavaScript. Đã xem ảnh chụp desktop/mobile/tablet.

## Kiểm tra lại trong IDE

1. Làm theo README để restore NuGet, chạy ba file SQL, Build và F5.
2. Mở danh mục, thử `bong`, chọn Chó/Cái/6.000.000–8.000.000 (nhập giá không dấu phân cách): có 3 hồ sơ; sắp giá tăng: 6.300.000, 7.500.000, 7.800.000đ.
3. Xóa lọc, sang trang 2 rồi trang 3; mỗi trang có 10 hồ sơ.
4. Mở một hồ sơ, đối chiếu tên/giá/ảnh với danh mục và xem gợi ý cùng loài.
5. Thử `ThuCung.aspx?page=0` và `ChiTietThuCung.aspx?id=999999` để xem thông báo lỗi.

## Giới hạn

Kiểm tra hiện tại dành cho catalog đọc dữ liệu; không chứng minh các luồng tài khoản/đặt hàng/quản trị/đánh giá chưa triển khai. Chưa kiểm tra Safari/Firefox, triển khai máy chủ từ xa hoặc clone trên một máy Windows khác. Ảnh và hồ sơ seed chỉ là minh họa.
