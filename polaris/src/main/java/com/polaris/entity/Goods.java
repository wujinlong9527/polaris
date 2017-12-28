
package com.polaris.entity;
import com.polaris.tool.easyui.PageHelper;

/**
 * 项目名称：polaris
 * 类名称：商品库存表
 * 创建人：武金龙
 */
public class Goods extends PageHelper {

    private static final long serialVersionUID = 1L;
    /**
     * 自增ID
     *
     * ***/
    private Integer id;
    /**
     * 商品编号
     *
     * ***/
    private String goodsid;
    /**
     * 商户号
     *
     * ***/
    private String groupid;
    /**
     * 单价
     *
     * ***/
    private double price;
    /**
     * 商品数量
     *
     * ***/
    private int count;
    /**
     * 商品
     *
     * ***/
    private String goodsname;

    /**
     * 商品创建时间
     *
     * ***/
    private String inserttime;
    /**
     * 商品照片存放地址
     *
     * ***/
    private String phaddress;

    private String aab301;

    private String aab302;

    private String finaltime;

    private String gtype;

    private String gtypename;

    private String groupname;

    private String account;

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    public String getGroupname() {
        return groupname;
    }

    public void setGroupname(String groupname) {
        this.groupname = groupname;
    }

    public String getGtypename() {
        return gtypename;
    }

    public void setGtypename(String gtypename) {
        this.gtypename = gtypename;
    }

    public String getGtype() {
        return gtype;
    }

    public void setGtype(String gtype) {
        this.gtype = gtype;
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

    public String getGoodsid() {
        return goodsid;
    }

    public void setGoodsid(String goodsid) {
        this.goodsid = goodsid;
    }

    public String getGroupid() {
        return groupid;
    }

    public void setGroupid(String groupid) {
        this.groupid = groupid;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public String getGoodsname() {
        return goodsname;
    }

    public void setGoodsname(String goodsname) {
        this.goodsname = goodsname;
    }

    public String getInserttime() {
        return inserttime;
    }

    public void setInserttime(String inserttime) {
        this.inserttime = inserttime;
    }

    public String getPhaddress() {
        return phaddress;
    }

    public void setPhaddress(String phaddress) {
        this.phaddress = phaddress;
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

    public String getFinaltime() {
        return finaltime;
    }

    public void setFinaltime(String finaltime) {
        this.finaltime = finaltime;
    }

    @Override
    public String toString() {
        return "Goods{" +
                "id=" + id +
                ", goodsid='" + goodsid + '\'' +
                ", groupid='" + groupid + '\'' +
                ", price=" + price +
                ", count=" + count +
                ", goodsname='" + goodsname + '\'' +
                ", inserttime='" + inserttime + '\'' +
                ", phaddress='" + phaddress + '\'' +
                ", aab301='" + aab301 + '\'' +
                ", aab302='" + aab302 + '\'' +
                ", finaltime='" + finaltime + '\'' +
                ", gtype='" + gtype + '\'' +
                ", gtypename='" + gtypename + '\'' +
                '}';
    }
}
