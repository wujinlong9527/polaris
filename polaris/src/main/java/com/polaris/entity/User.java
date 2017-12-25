/**
 *
 */
package com.polaris.entity;

/**
 * 项目名称：SpringMvcDemo
 * 类名称：User
 * 类描述：用户类
 * 修改备注：
 */
public class User {

    /**
     *
     */
    private int id;

    /**
     *
     */
    private String account;

    /**
     *
     */
    private String username;

    /**
     *
     */
    private String password;

    /**
     *
     */
    private String email;

    /**
     *
     */
    private String sex;

    /**
     *
     */
    private String telphone;

    /**
     *
     */
    private String userId;

    /**
     *
     */
    private String roleId;

    /**
     *
     */
    private String roleName;

    /**
     *
     */
    private String newpassword;

    /***
     *
     * 行政区划代码
     *
     * **/
    private String  aab301 ;
    /***
     *
     * 行政区划名称
     *
     * **/
    private String  aab302 ;
    /***
     *
     * 常住地地址
     *
     * **/
    private String  AAB303 ;
    /***
     *
     * 预留字段
     *
     * **/
    private String  AAB304 ;
    /***
     *
     * 预留字段
     *
     * **/
    private String  AAB305 ;

    private String groupname;

    private String groupid;

    private String inserttime;

    public String getInserttime() {
        return inserttime;
    }

    public void setInserttime(String inserttime) {
        this.inserttime = inserttime;
    }

    public String getGroupname() {
        return groupname;
    }

    public void setGroupname(String groupname) {
        this.groupname = groupname;
    }

    public String getGroupid() {
        return groupid;
    }

    public void setGroupid(String groupid) {
        this.groupid = groupid;
    }

    public String getAab301() {
        return aab301;
    }

    public void setAab301(String aab301) {
        this.aab301 = aab301;
    }

    public String getAab302() {
        return aab302;
    }

    public void setAab302(String aab302) {
        this.aab302 = aab302;
    }

    public String getAAB303() {
        return AAB303;
    }

    public void setAAB303(String AAB303) {
        this.AAB303 = AAB303;
    }

    public String getAAB304() {
        return AAB304;
    }

    public void setAAB304(String AAB304) {
        this.AAB304 = AAB304;
    }

    public String getAAB305() {
        return AAB305;
    }

    public void setAAB305(String AAB305) {
        this.AAB305 = AAB305;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    public String getSex() {
        return sex;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }

    public String getTelphone() {
        return telphone;
    }

    public void setTelphone(String telphone) {
        this.telphone = telphone;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getRoleId() {
        return roleId;
    }

    public void setRoleId(String roleId) {
        this.roleId = roleId;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public String getNewpassword() {
        return newpassword;
    }

    public void setNewpassword(String newpassword) {
        this.newpassword = newpassword;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", account='" + account + '\'' +
                ", username='" + username + '\'' +
                ", password='" + password + '\'' +
                ", email='" + email + '\'' +
                ", sex='" + sex + '\'' +
                ", telphone='" + telphone + '\'' +
                ", userId='" + userId + '\'' +
                ", roleId='" + roleId + '\'' +
                ", roleName='" + roleName + '\'' +
                ", newpassword='" + newpassword + '\'' +
                ", aab301='" + aab301 + '\'' +
                ", aab302='" + aab302 + '\'' +
                ", AAB303='" + AAB303 + '\'' +
                ", AAB304='" + AAB304 + '\'' +
                ", AAB305='" + AAB305 + '\'' +
                '}';
    }
}
