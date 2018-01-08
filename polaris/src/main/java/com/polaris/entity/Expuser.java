
package com.polaris.entity;
import com.polaris.tool.easyui.PageHelper;

/**
 * 项目名称：SpringMvcDemo
 * 类名称：Order
 * 创建人：武金龙
 * 创建时间：2015年11月7日 上午11:04:15
 * 修改人：武金龙
 * 修改时间：2015年11月7日 上午11:04:15
 * 修改备注：
 */
public class Expuser extends PageHelper {

    private static final long serialVersionUID = 1L;
    /**
     * 自增ID
     *
     * ***/
    private Integer id;

    private String expuserid;

    private String expusername;

    private int sex;

    private String exphone;

    private int teamid;

    private String teamname;

    private String inserttime;

    private String finaltime;

    private String tj;

    private String userid = "";

    private String username = "";

    public String getUserid() {
        return userid;
    }

    public void setUserid(String userid) {
        this.userid = userid;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getTj() {
        return tj;
    }

    public void setTj(String tj) {
        this.tj = tj;
    }

    public static long getSerialVersionUID() {
        return serialVersionUID;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getExpuserid() {
        return expuserid;
    }

    public void setExpuserid(String expuserid) {
        this.expuserid = expuserid;
    }

    public int getSex() {
        return sex;
    }

    public void setSex(int sex) {
        this.sex = sex;
    }

    public String getExphone() {
        return exphone;
    }

    public void setExphone(String exphone) {
        this.exphone = exphone;
    }

    public int getTeamid() {
        return teamid;
    }

    public void setTeamid(int teamid) {
        this.teamid = teamid;
    }

    public String getTeamname() {
        return teamname;
    }

    public void setTeamname(String teamname) {
        this.teamname = teamname;
    }

    public String getInserttime() {
        return inserttime;
    }

    public void setInserttime(String inserttime) {
        this.inserttime = inserttime;
    }

    public String getFinaltime() {
        return finaltime;
    }

    public void setFinaltime(String finaltime) {
        this.finaltime = finaltime;
    }

    public String getExpusername() {
        return expusername;
    }

    public void setExpusername(String expusername) {
        this.expusername = expusername;
    }

    @Override
    public String toString() {
        return "Expuser{" +
                "id=" + id +
                ", expuserid='" + expuserid + '\'' +
                ", expusername='" + expusername + '\'' +
                ", sex=" + sex +
                ", exphone='" + exphone + '\'' +
                ", teamid=" + teamid +
                ", teamname='" + teamname + '\'' +
                ", inserttime='" + inserttime + '\'' +
                ", finaltime='" + finaltime + '\'' +
                '}';
    }
}
