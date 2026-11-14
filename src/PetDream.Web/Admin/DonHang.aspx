<%@ Page Title="Đơn hàng | PetDream" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="DonHang.aspx.cs" Inherits="QuanTriDonHang" %>
<asp:Content ID="content_donhang" ContentPlaceHolderID="AdminContent" runat="server">
    <section class="admin-orders">
        <div class="admin-orders-heading">
            <div><p class="dashboard-kicker">QUẢN LÝ CỬA HÀNG</p><h1>Đơn hàng</h1><p>Theo dõi và xử lý các đơn hàng của cửa hàng.</p></div>
            <a class="dashboard-action" href="TaoDonHang.aspx"><span aria-hidden="true">＋</span> Tạo đơn cho khách</a>
        </div>
        <div class="admin-orders-message" role="status"><asp:Literal ID="lit_thongbao" runat="server" Mode="Encode" /></div>
        <div class="admin-orders-filters">
            <div class="admin-orders-field">
                <asp:Label runat="server" AssociatedControlID="txt_timkiem" Text="Tìm theo mã đơn, tên hoặc số điện thoại" />
                <asp:TextBox ID="txt_timkiem" runat="server" MaxLength="100" ValidateRequestMode="Disabled" placeholder="Nhập mã đơn, tên hoặc số điện thoại" />
            </div>
            <div class="admin-orders-field">
                <asp:Label runat="server" AssociatedControlID="ddl_trangthai" Text="Trạng thái" />
                <asp:DropDownList ID="ddl_trangthai" runat="server">
                    <asp:ListItem Value="">Tất cả trạng thái</asp:ListItem>
                    <asp:ListItem Value="cho_xac_nhan">Chờ xác nhận</asp:ListItem>
                    <asp:ListItem Value="da_xac_nhan">Đã xác nhận</asp:ListItem>
                    <asp:ListItem Value="dang_giao">Đang giao</asp:ListItem>
                    <asp:ListItem Value="da_giao">Đã giao</asp:ListItem>
                    <asp:ListItem Value="da_huy">Đã hủy</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="admin-orders-field">
                <asp:Label runat="server" AssociatedControlID="ddl_luutru" Text="Danh sách" />
                <asp:DropDownList ID="ddl_luutru" runat="server">
                    <asp:ListItem Value="0">Đơn đang quản lý</asp:ListItem>
                    <asp:ListItem Value="1">Đơn đã lưu trữ</asp:ListItem>
                </asp:DropDownList>
            </div>
            <asp:Button ID="btn_tim" runat="server" CssClass="dashboard-action" Text="Tìm đơn hàng" OnClick="btn_tim_Click" />
        </div>
        <p class="admin-orders-hint">Vuốt ngang hoặc dùng phím mũi tên để xem thêm thông tin đơn hàng.</p>
        <div class="admin-orders-table-wrap" role="region" aria-label="Danh sách đơn hàng có thể cuộn ngang" tabindex="0">
            <asp:GridView ID="grv_donhang" runat="server" CssClass="admin-orders-table" AutoGenerateColumns="false" GridLines="None" BorderWidth="0"
                AllowPaging="true" PageSize="15" OnPageIndexChanging="grv_donhang_PageIndexChanging" EmptyDataText="Không có đơn hàng phù hợp.">
                <Columns>
                    <asp:BoundField DataField="Ma" HeaderText="Mã đơn" HtmlEncode="true" />
                    <asp:HyperLinkField HeaderText="Thao tác" Text="Xem chi tiết" DataNavigateUrlFields="Id" DataNavigateUrlFormatString="ChiTietDonHang.aspx?id={0}" />
                    <asp:BoundField DataField="TenNguoiNhan" HeaderText="Người nhận" HtmlEncode="true" />
                    <asp:BoundField DataField="DienThoai" HeaderText="Điện thoại" HtmlEncode="true" />
                    <asp:TemplateField HeaderText="Ngày đặt"><ItemTemplate><%#: HienThiDonHang.Ngay(Eval("NgayDat")) %></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="Tổng tiền"><ItemTemplate><%#: HienThiThuCung.Gia(Eval("TongTien")) %></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="Trạng thái"><ItemTemplate><span class='<%#: HienThiDonHang.LopTrangThai(Eval("TrangThai")) %>'><%#: HienThiDonHang.TrangThai(Eval("TrangThai")) %></span></ItemTemplate></asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </section>
</asp:Content>
