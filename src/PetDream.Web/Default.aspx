<%@ Page Title="PetDream | Trang chủ" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="TrangChu" %>
<%@ Register Src="~/Controls/TheThuCung.ascx" TagPrefix="pet" TagName="DanhSach" %>
<asp:Content ID="content_trangchu" ContentPlaceHolderID="MainContent" runat="server">
    <section class="hero">
        <div class="hero-copy">
            <p class="eyebrow">
                CHÀO MỪNG ĐẾN PETDREAM
            </p>
            <h1>
                Một người bạn nhỏ.
                <br />
                Một niềm vui
                <em>
                    thật lớn.
                </em>
            </h1>
            <p>
                Gặp gỡ những chiếc đuôi hạnh phúc và tìm người bạn khiến mỗi ngày của bạn dịu dàng hơn.
            </p>
            <a class="button" href="ThuCung.aspx">
                Tìm người bạn nhỏ ↗
            </a>
            <p class="hero-note">
                Chó · Mèo · Hamster
            </p>
        </div>
        <div class="hero-art" aria-hidden="true">
            <div class="hero-orbit">
            </div>
            <div class="hero-pet hero-dog">
            </div>
            <div class="hero-pet hero-cat">
            </div>
            <span class="hero-sticker">
                Một chút yêu thương
                <br />
                mỗi ngày ♡
            </span>
        </div>
    </section>
    <asp:Panel ID="pnl_loi" runat="server" Visible="false" CssClass="notice" role="alert">
        <asp:Literal ID="lit_loi" runat="server" Mode="Encode" />
    </asp:Panel>
    <asp:Panel ID="pnl_dulieu" runat="server">
        <section class="section" aria-labelledby="loai-tieu-de">
            <div class="section-heading">
                <div>
                    <p class="eyebrow">
                        NHỎ XINH, ĐẦY CÁ TÍNH
                    </p>
                    <h2 id="loai-tieu-de">
                        Bạn muốn gặp ai hôm nay?
                    </h2>
                </div>
            </div>
            <div class="category-grid">
                <asp:Repeater ID="rpt_loai" runat="server">
                    <ItemTemplate>
                        <a class='category-card category-<%# HienThiThuCung.H(Eval("Ma")) %>' href='ThuCung.aspx?loai=<%# Eval("Id") %>'>
                            <span class="category-illustration" aria-hidden="true">
                                <%# BieuTuong(Eval("Ma")) %>
                            </span>
                            <div>
                                <h3>
                                    <%# HienThiThuCung.H(Eval("Ten")) %>
                                </h3>
                                <p>
                                    <%# HienThiThuCung.H(Eval("MoTa")) %>
                                </p>
                                <span>
                                    <%# Eval("SoLuong") %>
                                    người bạn ↗
                                </span>
                            </div>
                        </a>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </section>
        <section class="section" aria-labelledby="noibat-tieu-de">
            <div class="section-heading">
                <div>
                    <p class="eyebrow">
                        NHỮNG GƯƠNG MẶT ĐÁNG YÊU
                    </p>
                    <h2 id="noibat-tieu-de">
                        Một ánh nhìn, một thương mến
                    </h2>
                </div>
                <a class="text-link" href="ThuCung.aspx">
                    Gặp tất cả ↗
                </a>
            </div>
            <p id="txt_trong" runat="server" visible="false" class="notice">
                Các người bạn nhỏ đang được cập nhật. Hẹn bạn quay lại nhé.
            </p>
            <div class="pet-grid">
                <pet:DanhSach ID="ds_noibat" runat="server" />
            </div>
        </section>
    </asp:Panel>
    <aside class="care-note">
        <span aria-hidden="true">
            ♡
        </span>
        <div>
            <h2>
                Yêu thương bắt đầu từ sự thấu hiểu
            </h2>
            <p>
                Dành thời gian tìm hiểu tính cách, sức khỏe và nhu cầu chăm sóc trước khi đón một người bạn về nhà.
            </p>
        </div>
    </aside>
</asp:Content>
