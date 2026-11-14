<%@ Page Title="Thông tin loài | PetDream" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="LoaiSua.aspx.cs" Inherits="QuanTriLoaiSua" %>
<asp:Content ID="content_loai" ContentPlaceHolderID="AdminContent" runat="server">
    <section class="account-card admin-catalog-form">
        <a href="Loai.aspx">← Danh sách loài</a>
        <h1><asp:Literal ID="lit_tieude" runat="server" Mode="Encode" /></h1>
        <div role="status"><asp:Literal ID="lit_thongbao" runat="server" Mode="Encode" /></div>
        <div class="account-field"><asp:Label runat="server" AssociatedControlID="txt_ma" Text="Mã loài" /><asp:TextBox ValidateRequestMode="Disabled" ID="txt_ma" runat="server" ReadOnly="true" Text="Tự động tạo khi lưu" /><p class="admin-catalog-help">Mã được cấp tự động và không thay đổi.</p></div>
        <div class="account-field"><asp:Label runat="server" AssociatedControlID="txt_ten" Text="Tên loài" /><asp:TextBox ValidateRequestMode="Disabled" ID="txt_ten" runat="server" MaxLength="60" /></div>
        <div class="account-field"><asp:Label runat="server" AssociatedControlID="txt_mota" Text="Mô tả" /><asp:TextBox ValidateRequestMode="Disabled" ID="txt_mota" runat="server" TextMode="MultiLine" MaxLength="250" /></div>
        <div class="account-field"><asp:Label runat="server" AssociatedControlID="txt_thutu" Text="Thứ tự hiển thị" /><asp:TextBox ValidateRequestMode="Disabled" ID="txt_thutu" runat="server" TextMode="Number" Text="0" /></div>
        <div class="admin-catalog-actions">
            <asp:Button ID="btn_luu" runat="server" CssClass="button" Text="Lưu loài" OnClick="btn_luu_Click" />
            <asp:Button ID="btn_xoa" runat="server" CssClass="button button-light" Text="Lưu trữ loài" CausesValidation="false" OnClientClick="return confirm('Lưu trữ loài này? Loài sẽ không còn xuất hiện trong danh mục.');" OnClick="btn_xoa_Click" />
        </div>
    </section>
</asp:Content>
