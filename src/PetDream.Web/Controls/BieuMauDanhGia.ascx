<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BieuMauDanhGia.ascx.cs" Inherits="BieuMauDanhGia" %>
<p>Trạng thái <strong><asp:Literal ID="lit_trangthai" runat="server" Mode="Encode" /></strong></p>
<asp:PlaceHolder ID="pnl_nguoinhap" runat="server" Visible="false">
    <p><asp:Literal ID="lit_nguoinhap" runat="server" Mode="Encode" /></p>
</asp:PlaceHolder>
<div class="account-field">
    <asp:Label runat="server" AssociatedControlID="ddl_sao" Text="Số sao" />
    <asp:DropDownList ID="ddl_sao" runat="server">
        <asp:ListItem Value="">Chọn số sao</asp:ListItem>
        <asp:ListItem Value="5">5 sao</asp:ListItem>
        <asp:ListItem Value="4">4 sao</asp:ListItem>
        <asp:ListItem Value="3">3 sao</asp:ListItem>
        <asp:ListItem Value="2">2 sao</asp:ListItem>
        <asp:ListItem Value="1">1 sao</asp:ListItem>
    </asp:DropDownList>
</div>
<div class="account-field">
    <asp:Label runat="server" AssociatedControlID="txt_noidung" Text="Nội dung đánh giá" />
    <asp:TextBox ID="txt_noidung" runat="server" TextMode="MultiLine" Rows="5" maxlength="1000" ValidateRequestMode="Disabled" />
</div>
