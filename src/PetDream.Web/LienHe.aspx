<%@ Page Title="Liên hệ | PetDream" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="LienHe.aspx.cs" Inherits="LienHe" %>
<asp:Content ID="content_lienhe" ContentPlaceHolderID="MainContent" runat="server">
    <section class="contact" aria-labelledby="tieude">
        <p class="eyebrow">LIÊN HỆ</p>
        <h1 id="tieude">Trò chuyện cùng PetDream</h1>
        <p class="contact-lead">Bạn cần tư vấn chọn bé, hỏi về đơn hàng hay cách chăm sóc thú cưng? Để lại lời nhắn, chúng mình sẽ phản hồi sớm nhất.</p>
        <div class="contact-layout">
            <aside class="contact-info" aria-labelledby="tieude_thongtin">
                <h2 id="tieude_thongtin">Thông tin cửa hàng</h2>
                <dl>
                    <dt>Giờ mở cửa</dt><dd>8:00 – 20:00, thứ Hai đến Chủ nhật</dd>
                    <dt>Email</dt><dd>lienhe@petdream.test</dd>
                    <dt>Điện thoại</dt><dd>0900 000 000</dd>
                    <dt>Địa chỉ</dt><dd>Cửa hàng mẫu của đồ án PetDream</dd>
                </dl>
                <p class="contact-note">Website đồ án: biểu mẫu chỉ kiểm tra thông tin rồi thông báo thành công, không gửi email hay lưu nội dung.</p>
            </aside>
            <div class="contact-form">
                <h2>Gửi lời nhắn</h2>
                <div class="account-message" role="status"><asp:Literal ID="lit_thongbao" runat="server" Mode="Encode" /></div>
                <div class="account-field">
                    <asp:Label runat="server" AssociatedControlID="txt_hoten" Text="Họ tên" />
                    <asp:TextBox ID="txt_hoten" runat="server" MaxLength="100" autocomplete="name" ValidateRequestMode="Disabled" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txt_hoten" Display="Dynamic"
                        CssClass="field-error" ErrorMessage="Vui lòng nhập họ tên." />
                </div>
                <div class="contact-row">
                    <div class="account-field">
                        <asp:Label runat="server" AssociatedControlID="txt_email" Text="Email" />
                        <asp:TextBox ID="txt_email" runat="server" TextMode="Email" MaxLength="254" autocomplete="email" ValidateRequestMode="Disabled" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txt_email" Display="Dynamic"
                            CssClass="field-error" ErrorMessage="Vui lòng nhập email." />
                    </div>
                    <div class="account-field">
                        <asp:Label runat="server" AssociatedControlID="txt_dienthoai" Text="Số điện thoại (không bắt buộc)" />
                        <asp:TextBox ID="txt_dienthoai" runat="server" TextMode="Phone" MaxLength="13" autocomplete="tel" ValidateRequestMode="Disabled" />
                    </div>
                </div>
                <div class="account-field">
                    <asp:Label runat="server" AssociatedControlID="ddl_chude" Text="Chủ đề" />
                    <asp:DropDownList ID="ddl_chude" runat="server" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ddl_chude" InitialValue="" Display="Dynamic"
                        CssClass="field-error" ErrorMessage="Vui lòng chọn chủ đề." />
                </div>
                <div class="account-field">
                    <asp:Label runat="server" AssociatedControlID="txt_noidung" Text="Nội dung" />
                    <asp:TextBox ID="txt_noidung" runat="server" TextMode="MultiLine" Rows="6" MaxLength="2000" ValidateRequestMode="Disabled" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txt_noidung" Display="Dynamic"
                        CssClass="field-error" ErrorMessage="Vui lòng nhập nội dung." />
                </div>
                <asp:Button ID="btn_gui" runat="server" CssClass="button" Text="Gửi lời nhắn" OnClick="btn_gui_Click" />
            </div>
        </div>
    </section>
</asp:Content>
