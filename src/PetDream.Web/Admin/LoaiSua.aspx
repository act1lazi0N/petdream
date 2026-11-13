<%@ Page Title="Thông tin loài | PetDream" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="LoaiSua.aspx.cs" Inherits="QuanTriLoaiSua" %>
<asp:Content ID="content_loai" ContentPlaceHolderID="AdminContent" runat="server">
    <section class="account-card admin-catalog-form">
        <a href="Loai.aspx">← Danh sách loài</a>
        <h1><asp:Literal ID="lit_tieude" runat="server" Mode="Encode" /></h1>
        <div role="status"><asp:Literal ID="lit_thongbao" runat="server" Mode="Encode" /></div>
        <div class="account-field"><asp:Label runat="server" AssociatedControlID="txt_ma" Text="Mã loài" /><asp:TextBox ID="txt_ma" runat="server" MaxLength="20" /><p class="admin-catalog-help">Chữ cái không dấu, chữ số, dấu gạch dưới hoặc gạch ngang.</p></div>
        <div class="account-field"><asp:Label runat="server" AssociatedControlID="txt_ten" Text="Tên loài" /><asp:TextBox ID="txt_ten" runat="server" MaxLength="60" /></div>
        <div class="account-field"><asp:Label runat="server" AssociatedControlID="txt_mota" Text="Mô tả" /><asp:TextBox ID="txt_mota" runat="server" TextMode="MultiLine" MaxLength="250" /></div>
        <div class="account-field"><asp:Label runat="server" AssociatedControlID="txt_thutu" Text="Thứ tự hiển thị" /><asp:TextBox ID="txt_thutu" runat="server" TextMode="Number" Text="0" /></div>
        <div class="admin-catalog-actions">
            <asp:Button ID="btn_luu" runat="server" CssClass="button" Text="Lưu loài" OnClick="btn_luu_Click" />
            <asp:Button ID="btn_xoa" runat="server" CssClass="button button-light" Text="Xóa loài" CausesValidation="false" OnClientClick="return confirm('Xóa loài này? Không thể xóa loài còn hồ sơ thú cưng.');" OnClick="btn_xoa_Click" />
        </div>
    </section>
</asp:Content>
