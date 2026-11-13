<%@ Page Title="Đặt hàng | PetDream" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="DatHang.aspx.cs" Inherits="DatHang" %>
<asp:Content ID="content_dathang" ContentPlaceHolderID="MainContent" runat="server">
    <section class="checkout" aria-labelledby="tieude">
        <h1 id="tieude">Đặt hàng</h1>
        <div class="account-message" role="status"><asp:Literal ID="lit_thongbao" runat="server" Mode="Encode" /></div>
        <div class="checkout-layout">
            <div class="checkout-form">
                <h2>Thông tin nhận bé</h2>
                <div class="account-field">
                    <asp:Label runat="server" AssociatedControlID="txt_ten" Text="Tên người nhận" />
                    <asp:TextBox ID="txt_ten" runat="server" ValidateRequestMode="Disabled" MaxLength="100" autocomplete="name" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txt_ten" Display="Dynamic"
                        CssClass="field-error" ErrorMessage="Vui lòng nhập tên người nhận." />
                </div>
                <div class="account-field">
                    <asp:Label runat="server" AssociatedControlID="txt_dienthoai" Text="Số điện thoại" />
                    <asp:TextBox ID="txt_dienthoai" runat="server" TextMode="Phone" MaxLength="13" autocomplete="tel" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txt_dienthoai" Display="Dynamic"
                        CssClass="field-error" ErrorMessage="Vui lòng nhập số điện thoại." />
                </div>
                <div class="account-field">
                    <asp:Label runat="server" AssociatedControlID="txt_diachi" Text="Địa chỉ giao hàng" />
                    <asp:TextBox ID="txt_diachi" runat="server" ValidateRequestMode="Disabled" MaxLength="300" autocomplete="street-address" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txt_diachi" Display="Dynamic"
                        CssClass="field-error" ErrorMessage="Vui lòng nhập địa chỉ giao hàng." />
                </div>
                <div class="account-field">
                    <asp:Label runat="server" AssociatedControlID="txt_ghichu" Text="Ghi chú (không bắt buộc)" />
                    <asp:TextBox ID="txt_ghichu" runat="server" ValidateRequestMode="Disabled" TextMode="MultiLine" Rows="3" MaxLength="500" />
                </div>
                <p class="checkout-cod">Thanh toán khi nhận bé (COD). Các bé được giữ chỗ ngay khi bạn xác nhận.</p>
            </div>
            <aside class="checkout-summary" aria-labelledby="tieude_don">
                <h2 id="tieude_don">Đơn của bạn</h2>
                <ul class="cart-items">
                    <asp:Repeater ID="rpt_be" runat="server">
                        <ItemTemplate>
                            <li class="cart-item checkout-item">
                                <div aria-hidden="true" class="pet-photo cart-photo"
                                    style='<%# System.Web.HttpUtility.HtmlAttributeEncode(Convert.ToString(Eval("KieuAnh"))) %>'></div>
                                <div class="cart-item-copy">
                                    <%#: Eval("Ten") %>
                                    <p><%#: Eval("TrangThai") %></p>
                                </div>
                                <strong class="cart-price"><%#: Eval("Gia") %></strong>
                            </li>
                        </ItemTemplate>
                    </asp:Repeater>
                </ul>
                <dl class="checkout-totals">
                    <dt>Tiền hàng</dt><dd><asp:Literal ID="lit_tienhang" runat="server" Mode="Encode" /></dd>
                    <dt>Phí giao hàng</dt><dd><asp:Literal ID="lit_phigiao" runat="server" Mode="Encode" /></dd>
                    <dt class="checkout-total">Tổng thanh toán</dt><dd class="checkout-total"><asp:Literal ID="lit_tong" runat="server" Mode="Encode" /></dd>
                </dl>
                <div class="cart-actions">
                    <a class="button button-light" href="GioHang.aspx">Quay lại giỏ</a>
                    <asp:Button ID="btn_dathang" runat="server" CssClass="button" Text="Xác nhận đặt hàng"
                        UseSubmitBehavior="false" OnClick="btn_dathang_Click"
                        OnClientClick="if (typeof Page_ClientValidate === 'function' && !Page_ClientValidate()) return false; this.disabled = true; this.value = 'Đang đặt hàng…';" />
                </div>
            </aside>
        </div>
    </section>
</asp:Content>
