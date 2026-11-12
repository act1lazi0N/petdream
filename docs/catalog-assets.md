# Ảnh minh họa catalog

Tạo ngày 11/11/2026 bằng công cụ Imagegen tích hợp. Đây là ảnh AI cho đồ án, không phải ảnh chụp các cá thể đang được bán. Không sử dụng ảnh chụp màn hình tham khảo làm asset.

| Tệp trong Web Site | Nội dung theo hàng, từ trái sang phải |
| --- | --- |
| `Images/pets/dogs.png` | Poodle, Golden, Corgi, Husky, Phốc Sóc; Beagle, Samoyed, Shiba, Bulldog Pháp, Border Collie |
| `Images/pets/cats.png` | Anh lông ngắn, Ba Tư, Scottish Fold, Xiêm, mèo vàng; Maine Coon, Ragdoll, mèo đen, tam thể, Bengal |
| `Images/pets/hamsters.png` | Syrian vàng, Winter White, Roborovski, Campbell, Syrian kem; Syrian đen trắng, Roborovski nâu, Winter White ngọc trai, Syrian chocolate, Campbell xám trắng |

Brief đã dùng cho mỗi lần tạo: contact sheet ngang tỷ lệ 5:2, đúng 5 cột × 2 hàng, 10 ô vuông bằng nhau; mỗi ô một thú cưng khác nhau theo danh sách trên; ảnh studio chân thực, bố cục chân dung gần, nền hồng phấn/lavender, ánh sáng mềm; không chữ, logo, watermark, viền hoặc khoảng cách giữa các ô.

Ảnh gốc được chép vào repository, không sửa/cắt bằng chương trình. CSS chọn ô bằng `background-size:500% 200%`; cột là `OAnh % 5`, hàng là `OAnh / 5` (chia nguyên). Giá trị `OAnh` từ 0 đến 9 được ràng buộc trong SQL. Mỗi hồ sơ seed có một ảnh đại diện; gallery chỉ hiện thumbnails khi có nhiều bản ghi ảnh.

`HienThiThuCung.Anh` hiện chỉ cho phép ba đường dẫn trên. Khi triển khai upload ảnh thật ở module quản trị, phải mở rộng mô hình ảnh và helper có kiểm tra đường dẫn, định dạng, kích thước; không đưa đường dẫn tùy ý vào CSS.
