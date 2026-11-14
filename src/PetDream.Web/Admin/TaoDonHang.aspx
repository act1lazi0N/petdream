<%@ Page Title="Tạo đơn hàng | PetDream" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="TaoDonHang.aspx.cs" Inherits="QuanTriTaoDonHang" %>
<asp:Content ID="content_taodon" ContentPlaceHolderID="AdminContent" runat="server">
    <section class="admin-catalog">
        <div class="admin-catalog-heading">
            <div><p class="dashboard-kicker">ĐƠN HÀNG</p><h1>Tạo đơn cho khách</h1><p>Chọn khách hàng và thú cưng, sau đó kiểm tra thông tin trước khi xác nhận.</p></div>
            <a class="button button-light" href="DonHang.aspx">Quay lại đơn hàng</a>
        </div>
        <div class="account-message" role="status"><asp:Literal ID="lit_thongbao" runat="server" Mode="Encode" /></div>

        <asp:Panel ID="pnl_chon" runat="server">
            <div class="account-card admin-catalog-form">
                <h2>Khách hàng</h2>
                <div class="account-field">
                    <asp:Label runat="server" AssociatedControlID="ddl_khach" Text="Chọn tài khoản khách hàng" />
                    <asp:DropDownList ID="ddl_khach" runat="server" />
                </div>
            </div>
            <section class="dashboard-panel" aria-labelledby="tieude_thucung">
                <div class="dashboard-panel-heading"><div><p class="dashboard-kicker">LỰA CHỌN</p><h2 id="tieude_thucung">Thú cưng đang nhận đặt</h2></div></div>
                <p>Chọn những bé khách muốn đón. Mỗi bé chỉ có thể được đặt một lần.</p>
                <p class="admin-catalog-hint">Vuốt ngang hoặc dùng phím mũi tên để xem các cột trong bảng.</p>
                <div class="admin-catalog-table-wrap" role="region" aria-label="Danh sách thú cưng đang nhận đặt" tabindex="0">
                    <asp:GridView ID="grv_thucung" runat="server" CssClass="admin-catalog-table" AutoGenerateColumns="false" DataKeyNames="Id" EmptyDataText="Hiện chưa có thú cưng nhận đặt.">
                        <Columns>
                            <asp:TemplateField HeaderText="Chọn"><ItemTemplate><asp:CheckBox ID="chk_chon" runat="server" aria-label='<%# "Chọn " + Convert.ToString(Eval("Ten")) %>' /></ItemTemplate></asp:TemplateField>
                            <asp:BoundField DataField="Ma" HeaderText="Mã hồ sơ" HtmlEncode="true" />
                            <asp:BoundField DataField="Ten" HeaderText="Tên" HtmlEncode="true" />
                            <asp:BoundField DataField="Giong" HeaderText="Giống" HtmlEncode="true" />
                            <asp:TemplateField HeaderText="Giá"><ItemTemplate><%#: HienThiThuCung.Gia(Eval("Gia")) %></ItemTemplate></asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
                <div class="admin-catalog-actions"><asp:Button ID="btn_xem" runat="server" CssClass="button" Text="Kiểm tra đơn hàng" CausesValidation="false" OnClick="btn_xem_Click" /></div>
            </section>
        </asp:Panel>

        <asp:Panel ID="pnl_xacnhan" runat="server" Visible="false">
            <div class="checkout-layout">
                <div class="checkout-form admin-catalog-form">
                    <h2>Thông tin nhận bé</h2>
                    <p>Đơn được tạo cho: <strong><asp:Literal ID="lit_khach" runat="server" Mode="Encode" /></strong></p>
                    <div class="account-field"><asp:Label runat="server" AssociatedControlID="txt_ten" Text="Tên người nhận" /><asp:TextBox ID="txt_ten" runat="server" ValidateRequestMode="Disabled" MaxLength="100" autocomplete="name" /></div>
                    <div class="account-field"><asp:Label runat="server" AssociatedControlID="txt_dienthoai" Text="Số điện thoại" /><asp:TextBox ID="txt_dienthoai" runat="server" ValidateRequestMode="Disabled" TextMode="Phone" MaxLength="13" autocomplete="tel" /></div>
                    <div class="account-field"><asp:Label runat="server" AssociatedControlID="txt_diachi" Text="Địa chỉ giao hàng" /><asp:TextBox ID="txt_diachi" runat="server" ValidateRequestMode="Disabled" MaxLength="300" autocomplete="street-address" /></div>
                    <div class="account-field"><asp:Label runat="server" AssociatedControlID="txt_ghichu" Text="Ghi chú (không bắt buộc)" /><asp:TextBox ID="txt_ghichu" runat="server" ValidateRequestMode="Disabled" TextMode="MultiLine" Rows="3" MaxLength="500" /></div>
                    <p class="checkout-cod">Thanh toán khi nhận bé (COD). Các bé được giữ chỗ ngay khi tạo đơn.</p>
                </div>
                <aside class="checkout-summary" aria-labelledby="tieude_don">
                    <h2 id="tieude_don">Kiểm tra đơn hàng</h2>
                    <ul class="cart-items"><asp:Repeater ID="rpt_chon" runat="server"><ItemTemplate>
                        <li class="cart-item checkout-item"><div class="cart-item-copy"><strong><%#: Eval("Ten") %></strong><p><%#: Eval("Ma") %></p></div><strong class="cart-price"><%#: HienThiThuCung.Gia(Eval("Gia")) %></strong></li>
                    </ItemTemplate></asp:Repeater></ul>
                    <dl class="checkout-totals">
                        <dt>Tiền hàng</dt><dd><asp:Literal ID="lit_tienhang" runat="server" Mode="Encode" /></dd>
                        <dt>Phí giao hàng</dt><dd><asp:Literal ID="lit_phigiao" runat="server" Mode="Encode" /></dd>
                        <dt class="checkout-total">Tổng thanh toán</dt><dd class="checkout-total"><asp:Literal ID="lit_tong" runat="server" Mode="Encode" /></dd>
                    </dl>
                    <div class="admin-catalog-actions">
                        <asp:Button ID="btn_thaydoi" runat="server" CssClass="button button-light" Text="Thay đổi lựa chọn" CausesValidation="false" OnClick="btn_thaydoi_Click" />
                        <asp:Button ID="btn_tao" runat="server" CssClass="button" Text="Xác nhận tạo đơn" UseSubmitBehavior="false" OnClick="btn_tao_Click" OnClientClick="this.disabled = true; this.value = 'Đang tạo đơn…';" />
                    </div>
                </aside>
            </div>
        </asp:Panel>
    </section>
</asp:Content>
