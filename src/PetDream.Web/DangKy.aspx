<%@ Page Title="Đăng ký | PetDream" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="DangKy.aspx.cs" Inherits="DangKy" %>
<asp:Content ID="content_taikhoan" ContentPlaceHolderID="MainContent" runat="server">
    <section class="account-card" aria-labelledby="tieude">
        <h1 id="tieude">Đăng ký</h1>
        <p>Mật khẩu cần từ 12 đến 128 ký tự.</p>
        <div class="account-message" role="status"><asp:Literal ID="lit_thongbao" runat="server" Mode="Encode" /></div>
        <div class="account-field">
            <asp:Label runat="server" AssociatedControlID="txt_hoten" Text="Họ tên" />
            <asp:TextBox ID="txt_hoten" runat="server" MaxLength="100" autocomplete="name" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txt_hoten" Display="Dynamic"
                CssClass="field-error" ErrorMessage="Vui lòng nhập họ tên." />
        </div>
        <div class="account-field">
            <asp:Label runat="server" AssociatedControlID="txt_email" Text="Email" />
            <asp:TextBox ID="txt_email" runat="server" TextMode="Email" MaxLength="254" autocomplete="email" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txt_email" Display="Dynamic"
                CssClass="field-error" ErrorMessage="Vui lòng nhập email." />
        </div>
        <div class="account-field">
            <asp:Label runat="server" AssociatedControlID="txt_dienthoai" Text="Số điện thoại" />
            <asp:TextBox ID="txt_dienthoai" runat="server" TextMode="Phone" MaxLength="13" autocomplete="tel" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txt_dienthoai" Display="Dynamic"
                CssClass="field-error" ErrorMessage="Vui lòng nhập số điện thoại." />
        </div>
        <div class="account-field">
            <asp:Label runat="server" AssociatedControlID="txt_matkhau" Text="Mật khẩu" />
            <asp:TextBox ID="txt_matkhau" runat="server" TextMode="Password" MaxLength="128" autocomplete="new-password" ValidateRequestMode="Disabled" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txt_matkhau" Display="Dynamic"
                CssClass="field-error" ErrorMessage="Vui lòng nhập mật khẩu." />
        </div>
        <div class="account-field">
            <asp:Label runat="server" AssociatedControlID="txt_xacnhan" Text="Xác nhận mật khẩu" />
            <asp:TextBox ID="txt_xacnhan" runat="server" TextMode="Password" MaxLength="128" autocomplete="new-password" ValidateRequestMode="Disabled" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txt_xacnhan" Display="Dynamic"
                CssClass="field-error" ErrorMessage="Vui lòng nhập xác nhận mật khẩu." />
        </div>
        <asp:Button ID="btn_thuchien" runat="server" CssClass="button" Text="Tạo tài khoản" OnClick="btn_thuchien_Click" />
        <div class="account-links">
            <a href="DangNhap.aspx">Đã có tài khoản? Đăng nhập</a>
        </div>
    </section>
</asp:Content>
