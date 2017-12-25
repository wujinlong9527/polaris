/**
 *
 */
package com.polaris.entity;

/**
 * 项目名称：SpringMvcDemo
 * 类名称：SysMenu
 * 类描述：  系统菜单类
 * 武金龙
 * 修改备注：
 */
public class SysMenu {
    /**
     * 菜单ID
     */
    private int id;

    /**
     * 菜单名称
     */
    private String text;

    /**
     * 父级菜单ID 0表示根节点
     */
    private int parentId;

    /**
     * treegrade 需要传入的节点信息
     */
    //private int __parentId;
    private int _parentId;

    /**
     * 菜单顺序
     */
    private String sequence;

    /**
     * 菜单图标样式
     */
    private String iconCls;

    /**
     * 菜单链接地址
     */
    private String url;

    /**
     * 状态
     */
    private String state;

    /**
     * 是否根节点
     */
    private String isParentId;

    /**
     *
     *
     */
    private String eName;

    /**
     *
     */
    private String cName;

    /**
     *
     */
    private String menuId;

    /**
     *
     */
    private Boolean isSelected;

    /**
     *
     */
    private String menu_button;

    private String roleId;

    private String menuid;
    private String icon;
    private String menuname;

    private String dlgmenuId;

    private int isdel;

    public String getDlgmenuId() {
        return dlgmenuId;
    }

    public void setDlgmenuId(String dlgmenuId) {
        this.dlgmenuId = dlgmenuId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public int getParentId() {
        return parentId;
    }

    public void setParentId(int parentId) {
        this.parentId = parentId;
    }

    public String getSequence() {
        return sequence;
    }

    public void setSequence(String sequence) {
        this.sequence = sequence;
    }

    public String getIconCls() {
        return iconCls;
    }

    public void setIconCls(String iconCls) {
        this.iconCls = iconCls;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public int get_parentId() {
        return _parentId;
    }

    public void set_parentId(int _parentId) {
        this._parentId = _parentId;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getIsParentId() {
        return isParentId;
    }

    public void setIsParentId(String isParentId) {
        this.isParentId = isParentId;
    }

    public String getcName() {
        return cName;
    }

    public void setcName(String cName) {
        this.cName = cName;
    }

    public String geteName() {
        return eName;
    }

    public void seteName(String eName) {
        this.eName = eName;
    }

    public String getMenuId() {
        return menuId;
    }

    public void setMenuId(String menuId) {
        this.menuId = menuId;
    }

    public Boolean getIsSelected() {
        return isSelected;
    }

    public void setIsSelected(Boolean isSelected) {
        this.isSelected = isSelected;
    }

    public String getMenu_button() {
        return menu_button;
    }

    public void setMenu_button(String menu_button) {
        this.menu_button = menu_button;
    }

    public String getRoleId() {
        return roleId;
    }

    public void setRoleId(String roleId) {
        this.roleId = roleId;
    }

    public String getMenuid() {
        return menuid;
    }

    public void setMenuid(String menuid) {
        this.menuid = menuid;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public String getMenuname() {
        return menuname;
    }

    public void setMenuname(String menuname) {
        this.menuname = menuname;
    }

    public int getIsdel() {
        return isdel;
    }

    public void setIsdel(int isdel) {
        this.isdel = isdel;
    }


    @Override
    public String toString() {
        return "SysMenu{" +
                "id=" + id +
                ", text='" + text + '\'' +
                ", parentId=" + parentId +
                ", _parentId=" + _parentId +
                ", sequence='" + sequence + '\'' +
                ", iconCls='" + iconCls + '\'' +
                ", url='" + url + '\'' +
                ", state='" + state + '\'' +
                ", isParentId='" + isParentId + '\'' +
                ", eName='" + eName + '\'' +
                ", cName='" + cName + '\'' +
                ", menuId='" + menuId + '\'' +
                ", isSelected=" + isSelected +
                ", menu_button='" + menu_button + '\'' +
                ", roleId='" + roleId + '\'' +
                ", menuid='" + menuid + '\'' +
                ", icon='" + icon + '\'' +
                ", menuname='" + menuname + '\'' +
                ", isdel=" + isdel +
                '}';
    }
}
