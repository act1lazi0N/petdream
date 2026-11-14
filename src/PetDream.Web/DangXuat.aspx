<%@ Page Title="Đăng xuất | PetDream" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="DangXuat.aspx.cs" Inherits="DangXuat" %>
<asp:Content ID="content_taikhoan" ContentPlaceHolderID="MainContent" runat="server">
    <section class="account-card" aria-labelledby="tieude">
        <h1 id="tieude">Đăng xuất</h1>
        <p>Bạn có muốn kết thúc phiên trên trình duyệt này?</p>
        <div class="account-message" role="status"><asp:Literal ID="lit_thongbao" runat="server" Mode="Encode" /></div>
        <asp:Button ID="btn_thuchien" runat="server" CssClass="button" Text="Xác nhận đăng xuất" OnClick="btn_thuchien_Click" />
        <div class="account-links">
            <a href="TaiKhoan.aspx">Về tài khoản</a>
        </div>
    </section>
</asp:Content>
