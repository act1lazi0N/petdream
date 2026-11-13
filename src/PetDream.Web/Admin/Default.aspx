<%@ Page Title="PetDream | Khung quản trị" Language="C#" MasterPageFile="~/Admin/Admin.master" %>
<asp:Content ID="content_quantri" ContentPlaceHolderID="AdminContent" runat="server">
    <h1>Quản trị PetDream</h1>
    <p>Chọn chức năng quản trị phù hợp với quyền của bạn.</p>
    <ul class="module-list">
        <li><a href="<%= ResolveUrl("~/Admin/Loai.aspx") %>">Danh mục loài</a></li>
        <li><a href="<%= ResolveUrl("~/Admin/ThuCung.aspx") %>">Hồ sơ thú cưng</a></li>
        <li>Tài khoản</li>
        <li>Đơn hàng</li>
        <li>Đánh giá</li>
    </ul>
</asp:Content>
