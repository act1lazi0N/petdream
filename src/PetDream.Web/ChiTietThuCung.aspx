<%@ Page Title="Hồ sơ thú cưng | PetDream" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="ChiTietThuCung.aspx.cs" Inherits="ChiTietThuCung" %>
<%@ Register Src="~/Controls/TheThuCung.ascx" TagPrefix="pet" TagName="DanhSach" %>
<asp:Content ID="content_chitiet" ContentPlaceHolderID="MainContent" runat="server">
    <nav class="breadcrumb" aria-label="Đường dẫn">
        <a href="Default.aspx">
            Trang chủ
        </a>
        <span>
            /
        </span>
        <a href="ThuCung.aspx">
            Thú cưng
        </a>
        <span>
            /
        </span>
        <asp:Literal ID="lit_breadcrumb" runat="server" Mode="Encode" />
    </nav>
    <asp:Panel ID="pnl_loi" runat="server" Visible="false" CssClass="empty-state" role="alert">
        <h1>
            Hẹn gặp một người bạn khác nhé
        </h1>
        <p>
            <asp:Literal ID="lit_loi" runat="server" Mode="Encode" />
        </p>
        <a class="button" href="ThuCung.aspx">
            Khám phá thú cưng
        </a>
    </asp:Panel>
    <asp:Panel ID="pnl_chitiet" runat="server">
        <div class="pet-detail">
            <div>
                <div id="anh_chinh" runat="server" class="pet-photo detail-photo" role="img">
                </div>
                <div class="gallery">
                    <asp:Repeater ID="rpt_anh" runat="server">
                        <ItemTemplate>
                            <a class="pet-photo thumbnail" href='ChiTietThuCung.aspx?id=<%# Eval("ThuCungId") %>&amp;anh=<%# Eval("Id") %>' style='<%# System.Web.HttpUtility.HtmlAttributeEncode(HienThiThuCung.Anh(Eval("DuongDan"), Eval("OAnh"))) %>' aria-label='<%# "Xem ảnh " + (Container.ItemIndex + 1) %>'>
                            </a>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <p class="image-caption">
                    Ảnh minh họa AI · Hồ sơ mẫu cho đồ án
                </p>
            </div>
            <div class="detail-copy">
                <p class="eyebrow">
                    MỘT NGƯỜI BẠN ĐẶC BIỆT
                </p>
                <span class="pet-status">
                    <asp:Literal ID="lit_trangthai" runat="server" Mode="Encode" />
                </span>
                <h1>
                    <asp:Literal ID="lit_ten" runat="server" Mode="Encode" />
                </h1>
                <p class="detail-breed">
                    <asp:Literal ID="lit_giong" runat="server" Mode="Encode" />
                </p>
                <p class="detail-price">
                    <asp:Literal ID="lit_gia" runat="server" Mode="Encode" />
                </p>
                <dl class="pet-facts">
                    <div>
                        <dt>
                            Giới tính
                        </dt>
                        <dd>
                            <asp:Literal ID="lit_gioitinh" runat="server" Mode="Encode" />
                        </dd>
                    </div>
                    <div>
                        <dt>
                            Độ tuổi
                        </dt>
                        <dd>
                            <asp:Literal ID="lit_tuoi" runat="server" Mode="Encode" />
                        </dd>
                    </div>
                    <div>
                        <dt>
                            Cân nặng
                        </dt>
                        <dd>
                            <asp:Literal ID="lit_cannang" runat="server" Mode="Encode" />
                            kg
                        </dd>
                    </div>
                    <div>
                        <dt>
                            Mã hồ sơ
                        </dt>
                        <dd>
                            <asp:Literal ID="lit_ma" runat="server" Mode="Encode" />
                        </dd>
                    </div>
                </dl>
                <p class="preserve-lines">
                    <asp:Literal ID="lit_mota" runat="server" Mode="Encode" />
                </p>
                <asp:HyperLink ID="lnk_loai" runat="server" CssClass="button button-light" Text="Gặp những người bạn cùng loài ↗" />
            </div>
        </div>
        <section class="detail-notes" aria-label="Thông tin chăm sóc">
            <article>
                <p class="eyebrow">
                    01 / LÀM QUEN
                </p>
                <h2>
                    Tính cách &amp; đặc điểm
                </h2>
                <p class="preserve-lines">
                    <asp:Literal ID="lit_dacdiem" runat="server" Mode="Encode" />
                </p>
                <p>
                    <strong>
                        Kích thước:
                    </strong>
                    <asp:Literal ID="lit_kichthuoc" runat="server" Mode="Encode" />
                </p>
            </article>
            <article>
                <p class="eyebrow">
                    02 / QUAN TÂM
                </p>
                <h2>
                    Sức khỏe &amp; chăm sóc
                </h2>
                <p class="preserve-lines">
                    <asp:Literal ID="lit_tiemchung" runat="server" Mode="Encode" />
                </p>
                <p>
                    Hãy xác minh hồ sơ sức khỏe và lịch chăm sóc thực tế trước khi quyết định đón thú cưng.
                </p>
            </article>
        </section>
        <asp:Panel ID="pnl_goiy" runat="server" CssClass="section">
            <div class="section-heading">
                <div>
                    <p class="eyebrow">
                        CÒN NHIỀU ĐIỀU DỄ THƯƠNG
                    </p>
                    <h2>
                        Có thể bạn cũng sẽ thích
                    </h2>
                </div>
            </div>
            <div class="pet-grid related-grid">
                <pet:DanhSach ID="ds_goiy" runat="server" />
            </div>
        </asp:Panel>
    </asp:Panel>
</asp:Content>
