
package com.polaris.entity;

/**
 * 项目名称：SpringMvcDemo
 * 类名称：商户管理
 * 类描述：角色类
 * 创建人：武金龙
 * 创建时间：2015年11月7日 上午10:53:19
 * 修改人：武金龙
 * 修改时间：2015年11月7日 上午10:53:19
 * 修改备注：
 */
public class SysGroup {

    private int id;

    private String groupname;

    private String groupid;

    private String inserttime;

    private String account ;

    private String tj;

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

    public String getTj() {
        return tj;
    }

    public void setTj(String tj) {
        this.tj = tj;
    }

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    public String getInserttime() {
        return inserttime;
    }

    public void setInserttime(String inserttime) {
        this.inserttime = inserttime;
    }

    @Override
    public String toString() {
        return "SysGroup{" +
                "id=" + id +
                ", groupname='" + groupname + '\'' +
                ", groupid='" + groupid + '\'' +
                ", inserttime='" + inserttime + '\'' +
                ", account='" + account + '\'' +
                ", tj='" + tj + '\'' +
                ", aab301='" + aab301 + '\'' +
                ", aab302='" + aab302 + '\'' +
                '}';
    }
}
