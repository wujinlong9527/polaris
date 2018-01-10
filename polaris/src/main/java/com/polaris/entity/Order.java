
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
public class Order extends PageHelper {

    private static final long serialVersionUID = 1L;
    /**
     * 自增ID
     *
     * ***/
    private Integer id;
    /**
     * 订单编号
     *
     * ***/
    private String orderid;
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
     * 商品总价
     *
     * ***/
    private String amount;
    /**
     * 商品数量
     *
     * ***/
    private int count;
    /**
     * 商品
     *
     * ***/
    private String goodsid;

    private String goodsname;
    /**
     * 收货地址
     *
     * ***/
    private String readdress;

    /**
     * 登录名
     *
     * ***/
    private String account;

    /**
     *用户名
     *
     * ***/
    private String username;

    private String phone;

    private String tel;
    /**
     * 订单创建时间
     *
     * ***/
    private String inserttime;
    /**
     * 订单状态
     *
     * ***/
    private String ddzt;
    /**
     * 配送员姓名
     *
     * ***/
    private String expressname;
    /**
     * 派送员ID
     *
     * ***/
    private String expressid;
    /**
     * 结算方式
     *
     * ***/
    private String jsfs;
    /**
     * 结算状态
     *
     * ***/
    private String jszt;

    /**
     * 订单完成时间
     *
     * ***/
    private String endtime;
    /**
     * 派送开始时间
     *
     * ***/
    private String expbegintime;
    /**
     * 派送完成时间
     *
     * ***/
    private String expendtime;
    /**
     * 派送中途地址
     *
     * ***/
    private String expaddr;

    private String aab301;

    private String aab302;

    private String aaa001;
    private String aaa002;

    private String aaa003;

    private String finaltime;

    private String groupname;

    private String gtype;

    private String gtypename;

    private Integer gcount;

    private String sfqr;

    private String ckqr;

    private String ddbz;

    private String wlqr;

    private String lqbz;

    private String thbz;

    private String ddbzmc;

    public String getThbz() {
        return thbz;
    }

    public void setThbz(String thbz) {
        this.thbz = thbz;
    }

    public String getDdbzmc() {
        return ddbzmc;
    }

    public void setDdbzmc(String ddbzmc) {
        this.ddbzmc = ddbzmc;
    }

    public String getLqbz() {
        return lqbz;
    }

    public void setLqbz(String lqbz) {
        this.lqbz = lqbz;
    }

    public String getWlqr() {
        return wlqr;
    }

    public void setWlqr(String wlqr) {
        this.wlqr = wlqr;
    }

    public String getDdbz() {
        return ddbz;
    }

    public void setDdbz(String ddbz) {
        this.ddbz = ddbz;
    }

    public String getCkqr() {
        return ckqr;
    }

    public void setCkqr(String ckqr) {
        this.ckqr = ckqr;
    }

    public String getSfqr() {
        return sfqr;
    }

    public void setSfqr(String sfqr) {
        this.sfqr = sfqr;
    }

    public Integer getGcount() {
        return gcount;
    }

    public void setGcount(Integer gcount) {
        this.gcount = gcount;
    }

    public String getGtype() {
        return gtype;
    }

    public void setGtype(String gtype) {
        this.gtype = gtype;
    }

    public String getGtypename() {
        return gtypename;
    }

    public void setGtypename(String gtypename) {
        this.gtypename = gtypename;
    }

    public String getGroupname() {
        return groupname;
    }

    public void setGroupname(String groupname) {
        this.groupname = groupname;
    }

    public String getFinaltime() {
        return finaltime;
    }

    public void setFinaltime(String finaltime) {
        this.finaltime = finaltime;
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

    public String getOrderid() {
        return orderid;
    }

    public void setOrderid(String orderid) {
        this.orderid = orderid;
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

    public String getAmount() {
        return amount;
    }

    public void setAmount(String amount) {
        this.amount = amount;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public String getReaddress() {
        return readdress;
    }

    public void setReaddress(String readdress) {
        this.readdress = readdress;
    }

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getTel() {
        return tel;
    }

    public void setTel(String tel) {
        this.tel = tel;
    }

    public String getInserttime() {
        return inserttime;
    }

    public void setInserttime(String inserttime) {
        this.inserttime = inserttime;
    }

    public String getDdzt() {
        return ddzt;
    }

    public void setDdzt(String ddzt) {
        this.ddzt = ddzt;
    }

    public String getExpressname() {
        return expressname;
    }

    public void setExpressname(String expressname) {
        this.expressname = expressname;
    }

    public String getExpressid() {
        return expressid;
    }

    public void setExpressid(String expressid) {
        this.expressid = expressid;
    }

    public String getJsfs() {
        return jsfs;
    }

    public void setJsfs(String jsfs) {
        this.jsfs = jsfs;
    }

    public String getJszt() {
        return jszt;
    }

    public void setJszt(String jszt) {
        this.jszt = jszt;
    }

    public String getEndtime() {
        return endtime;
    }

    public void setEndtime(String endtime) {
        this.endtime = endtime;
    }

    public String getExpbegintime() {
        return expbegintime;
    }

    public void setExpbegintime(String expbegintime) {
        this.expbegintime = expbegintime;
    }

    public String getExpendtime() {
        return expendtime;
    }

    public void setExpendtime(String expendtime) {
        this.expendtime = expendtime;
    }

    public String getExpaddr() {
        return expaddr;
    }

    public void setExpaddr(String expaddr) {
        this.expaddr = expaddr;
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

    public String getAaa001() {
        return aaa001;
    }

    public void setAaa001(String aaa001) {
        this.aaa001 = aaa001;
    }

    public String getAaa002() {
        return aaa002;
    }

    public void setAaa002(String aaa002) {
        this.aaa002 = aaa002;
    }

    public String getAaa003() {
        return aaa003;
    }

    public void setAaa003(String aaa003) {
        this.aaa003 = aaa003;
    }

    public String getGoodsid() {
        return goodsid;
    }

    public void setGoodsid(String goodsid) {
        this.goodsid = goodsid;
    }

    public String getGoodsname() {
        return goodsname;
    }

    public void setGoodsname(String goodsname) {
        this.goodsname = goodsname;
    }

    @Override
    public String toString() {
        return "Order{" +
                "id=" + id +
                ", orderid='" + orderid + '\'' +
                ", groupid='" + groupid + '\'' +
                ", price=" + price +
                ", amount='" + amount + '\'' +
                ", count=" + count +
                ", goodsid='" + goodsid + '\'' +
                ", goodsname='" + goodsname + '\'' +
                ", readdress='" + readdress + '\'' +
                ", account='" + account + '\'' +
                ", username='" + username + '\'' +
                ", phone='" + phone + '\'' +
                ", tel='" + tel + '\'' +
                ", inserttime='" + inserttime + '\'' +
                ", ddzt='" + ddzt + '\'' +
                ", expressname='" + expressname + '\'' +
                ", expressid='" + expressid + '\'' +
                ", jsfs='" + jsfs + '\'' +
                ", jszt='" + jszt + '\'' +
                ", endtime='" + endtime + '\'' +
                ", expbegintime='" + expbegintime + '\'' +
                ", expendtime='" + expendtime + '\'' +
                ", expaddr='" + expaddr + '\'' +
                ", aab301='" + aab301 + '\'' +
                ", aab302='" + aab302 + '\'' +
                ", aaa001='" + aaa001 + '\'' +
                ", aaa002='" + aaa002 + '\'' +
                ", aaa003='" + aaa003 + '\'' +
                ", finaltime='" + finaltime + '\'' +
                ", groupname='" + groupname + '\'' +
                ", gtype='" + gtype + '\'' +
                ", gtypename='" + gtypename + '\'' +
                ", gcount='" + gcount + '\'' +
                ", sfqr='" + sfqr + '\'' +
                ", ckqr='" + ckqr + '\'' +
                ", ddbz='" + ddbz + '\'' +
                ", wlqr='" + wlqr + '\'' +
                ", lqbz='" + lqbz + '\'' +
                '}';
    }
}
