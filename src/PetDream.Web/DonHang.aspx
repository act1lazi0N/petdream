<%@ Page Title="Đơn hàng của tôi | PetDream" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="DonHang.aspx.cs" Inherits="DonHang" %>
<asp:Content ID="content_donhang" ContentPlaceHolderID="MainContent" runat="server">
    <section class="orders" aria-labelledby="tieude">
        <h1 id="tieude">Đơn hàng của tôi</h1>
        <div class="account-message" role="status"><asp:Literal ID="lit_thongbao" runat="server" Mode="Encode" /></div>
        <asp:Panel ID="pnl_trong" runat="server" CssClass="empty-state" Visible="false">
            <h2>Bạn chưa có đơn hàng nào</h2>
            <a class="button" href="ThuCung.aspx">Khám phá thú cưng</a>
        </asp:Panel>
        <ul class="order-list">
            <asp:Repeater ID="rpt_donhang" runat="server">
                <ItemTemplate>
                    <li class="order-card">
                        <div class="order-card-head">
                            <a href='ChiTietDonHang.aspx?id=<%# Eval("Id") %>'>Đơn <%#: Eval("Ma") %></a>
                            <span class='<%# HienThiDonHang.LopTrangThai(Eval("TrangThai")) %>'><%#: HienThiDonHang.TrangThai(Eval("TrangThai")) %></span>
                        </div>
                        <p class="order-pets"><%#: Eval("DanhSachTen") %></p>
                        <div class="order-card-foot">
                            <span>Đặt lúc <%#: HienThiDonHang.Ngay(Eval("NgayDat")) %> · <%#: Eval("SoBe") %> bé</span>
                            <strong><%#: HienThiThuCung.Gia(Eval("TongTien")) %></strong>
                        </div>
                    </li>
                </ItemTemplate>
            </asp:Repeater>
        </ul>
        <div class="account-links">
            <a href="TaiKhoan.aspx">Về tài khoản</a>
        </div>
    </section>
</asp:Content>
