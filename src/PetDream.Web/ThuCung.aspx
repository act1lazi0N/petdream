<%@ Page Title="Gặp gỡ thú cưng | PetDream" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="ThuCung.aspx.cs" Inherits="DanhMucThuCung" %>
<%@ Register Src="~/Controls/TheThuCung.ascx" TagPrefix="pet" TagName="DanhSach" %>
<asp:Content ID="content_danhmuc" ContentPlaceHolderID="MainContent" runat="server">
    <div class="page-intro">
        <p class="eyebrow">
            TÌM MỘT NGƯỜI BẠN
        </p>
        <h1>
            Nhỏ bé thôi.
            <br />
            <em>
                Thương nhớ thật nhiều.
            </em>
        </h1>
        <p>
            Mỗi bạn nhỏ là một cá tính riêng. Người bạn của bạn đang ở đây.
        </p>
    </div>
    <asp:Panel ID="pnl_loi" runat="server" Visible="false" CssClass="notice" role="alert">
        <asp:Literal ID="lit_loi" runat="server" Mode="Encode" />
        <a href="ThuCung.aspx">
            Xem lại danh mục
        </a>
    </asp:Panel>
    <asp:Panel ID="pnl_boloc" runat="server" CssClass="filter-panel" DefaultButton="btn_loc">
        <div class="filter-search">
            <asp:Label runat="server" AssociatedControlID="txt_tukhoa" Text="Tên hoặc giống thú cưng" />
            <asp:TextBox ID="txt_tukhoa" runat="server" MaxLength="100" placeholder="Thử tìm Poodle, Miu..." />
        </div>
        <div>
            <asp:Label runat="server" AssociatedControlID="ddl_loai" Text="Loài" />
            <asp:DropDownList ID="ddl_loai" runat="server" />
        </div>
        <div>
            <asp:Label runat="server" AssociatedControlID="ddl_gioitinh" Text="Giới tính" />
            <asp:DropDownList ID="ddl_gioitinh" runat="server">
                <asp:ListItem Value="">
                    Tất cả
                </asp:ListItem>
                <asp:ListItem Value="D">
                    Đực
                </asp:ListItem>
                <asp:ListItem Value="C">
                    Cái
                </asp:ListItem>
            </asp:DropDownList>
        </div>
        <div>
            <asp:Label runat="server" AssociatedControlID="txt_giatu" Text="Giá từ (đ)" />
            <asp:TextBox ID="txt_giatu" runat="server" MaxLength="13" inputmode="numeric" placeholder="0" />
        </div>
        <div>
            <asp:Label runat="server" AssociatedControlID="txt_giaden" Text="Giá đến (đ)" />
            <asp:TextBox ID="txt_giaden" runat="server" MaxLength="13" inputmode="numeric" placeholder="Không giới hạn" />
        </div>
        <div>
            <asp:Label runat="server" AssociatedControlID="ddl_sapxep" Text="Sắp xếp" />
            <asp:DropDownList ID="ddl_sapxep" runat="server">
                <asp:ListItem Value="moi">
                    Mới nhất
                </asp:ListItem>
                <asp:ListItem Value="gia_tang">
                    Giá tăng dần
                </asp:ListItem>
                <asp:ListItem Value="gia_giam">
                    Giá giảm dần
                </asp:ListItem>
            </asp:DropDownList>
        </div>
        <div class="filter-actions">
            <asp:Button ID="btn_loc" runat="server" CssClass="button" Text="Tìm bạn nhỏ" OnClick="btn_loc_Click" />
            <a href="ThuCung.aspx">
                Xóa bộ lọc
            </a>
        </div>
    </asp:Panel>
    <asp:Panel ID="pnl_ketqua" runat="server">
        <div class="results-heading">
            <h2>
                Những người bạn nhỏ
            </h2>
            <p>
                <asp:Literal ID="lit_tong" runat="server" Mode="Encode" />
            </p>
        </div>
        <asp:Panel ID="pnl_trong" runat="server" Visible="false" CssClass="empty-state">
            <span aria-hidden="true">
                ♡
            </span>
            <h2>
                Chưa tìm thấy bạn nhỏ phù hợp
            </h2>
            <p>
                Thử một từ khóa khác hoặc nới rộng khoảng giá nhé.
            </p>
            <a class="button" href="ThuCung.aspx">
                Xem tất cả thú cưng
            </a>
        </asp:Panel>
        <div class="pet-grid">
            <pet:DanhSach ID="ds_thucung" runat="server" />
        </div>
        <nav class="pagination" aria-label="Phân trang">
            <asp:HyperLink ID="lnk_truoc" runat="server" Text="← Trang trước" />
            <asp:Literal ID="lit_trang" runat="server" Mode="Encode" />
            <asp:HyperLink ID="lnk_sau" runat="server" Text="Trang sau →" />
        </nav>
    </asp:Panel>
</asp:Content>
