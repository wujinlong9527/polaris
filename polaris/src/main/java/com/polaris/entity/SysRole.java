/**
 *
 */
package com.polaris.entity;

/**
 * 项目名称：SpringMvcDemo
 * 类名称：SysRole
 * 类描述：角色类
 * 创建人：武金龙
 * 创建时间：2015年11月7日 上午10:53:19
 * 修改人：武金龙
 * 修改时间：2015年11月7日 上午10:53:19
 * 修改备注：
 */
public class SysRole {

    /**
     *
     */
    private int id;

    /**
     *
     */
    private String rolename;

    /**
     *
     */
    private String memo;

    /**
     *
     */
    private String roleid;

    /**
     *
     */
    private String menu_id;

    /**
     *
     */
    private String menu_button;

    /**
     *
     */
    private Boolean isSelected;


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getRolename() {
        return rolename;
    }

    public void setRolename(String rolename) {
        this.rolename = rolename;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

    public String getRoleid() {
        return roleid;
    }

    public void setRoleid(String roleid) {
        this.roleid = roleid;
    }

    public String getMenu_id() {
        return menu_id;
    }

    public void setMenu_id(String menu_id) {
        this.menu_id = menu_id;
    }

    public String getMenu_button() {
        return menu_button;
    }

    public void setMenu_button(String menu_button) {
        this.menu_button = menu_button;
    }

    public Boolean getIsSelected() {
        return isSelected;
    }

    public void setIsSelected(Boolean isSelected) {
        this.isSelected = isSelected;
    }


    @Override
    public String toString() {
        return "SysRole{" +
                "id=" + id +
                ", rolename='" + rolename + '\'' +
                ", memo='" + memo + '\'' +
                ", roleid='" + roleid + '\'' +
                ", menu_id='" + menu_id + '\'' +
                ", menu_button='" + menu_button + '\'' +
                ", isSelected=" + isSelected +
                '}';
    }
}
