<%@ Page Title="Đăng nhập | PetDream" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="DangNhap.aspx.cs" Inherits="DangNhap" %>
<asp:Content ID="content_taikhoan" ContentPlaceHolderID="MainContent" runat="server">
    <section class="account-card" aria-labelledby="tieude">
        <h1 id="tieude">Đăng nhập</h1>
        <div class="account-message" role="status"><asp:Literal ID="lit_thongbao" runat="server" Mode="Encode" /></div>
        <div class="account-field">
            <asp:Label runat="server" AssociatedControlID="txt_dinhdanh" Text="Email hoặc số điện thoại" />
            <asp:TextBox ID="txt_dinhdanh" runat="server" MaxLength="254" autocomplete="username" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txt_dinhdanh" Display="Dynamic"
                CssClass="field-error" ErrorMessage="Vui lòng nhập email hoặc số điện thoại." />
        </div>
        <div class="account-field">
            <asp:Label runat="server" AssociatedControlID="txt_matkhau" Text="Mật khẩu" />
            <asp:TextBox ID="txt_matkhau" runat="server" TextMode="Password" MaxLength="128" autocomplete="current-password" ValidateRequestMode="Disabled" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txt_matkhau" Display="Dynamic"
                CssClass="field-error" ErrorMessage="Vui lòng nhập mật khẩu." />
        </div>
        <asp:Button ID="btn_thuchien" runat="server" CssClass="button" Text="Đăng nhập" OnClick="btn_thuchien_Click" />
        <div class="account-links">
            <a href="DangKy.aspx">Tạo tài khoản</a>
        </div>
    </section>
</asp:Content>
