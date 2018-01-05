
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
public class Express extends PageHelper {

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
     * 商品
     *
     * ***/
    private String goodsid;

    private String expressid;
    /**
     * 派送中途地址
     *
     * ***/
    private String exptime;

    private String endtime;

    private String expname;

    private String exphone;
    private String expaddress;

    private String exprealaddr;

    private String finaltime;

    private String inserttime;

    private String account;

    public String getInserttime() {
        return inserttime;
    }

    public void setInserttime(String inserttime) {
        this.inserttime = inserttime;
    }

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
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

    public String getGoodsid() {
        return goodsid;
    }

    public void setGoodsid(String goodsid) {
        this.goodsid = goodsid;
    }

    public String getExpressid() {
        return expressid;
    }

    public void setExpressid(String expressid) {
        this.expressid = expressid;
    }

    public String getExptime() {
        return exptime;
    }

    public void setExptime(String exptime) {
        this.exptime = exptime;
    }

    public String getEndtime() {
        return endtime;
    }

    public void setEndtime(String endtime) {
        this.endtime = endtime;
    }

    public String getExpname() {
        return expname;
    }

    public void setExpname(String expname) {
        this.expname = expname;
    }

    public String getExphone() {
        return exphone;
    }

    public void setExphone(String exphone) {
        this.exphone = exphone;
    }

    public String getExpaddress() {
        return expaddress;
    }

    public void setExpaddress(String expaddress) {
        this.expaddress = expaddress;
    }

    public String getExprealaddr() {
        return exprealaddr;
    }

    public void setExprealaddr(String exprealaddr) {
        this.exprealaddr = exprealaddr;
    }

    public String getFinaltime() {
        return finaltime;
    }

    public void setFinaltime(String finaltime) {
        this.finaltime = finaltime;
    }

    @Override
    public String toString() {
        return "Express{" +
                "id=" + id +
                ", orderid='" + orderid + '\'' +
                ", groupid='" + groupid + '\'' +
                ", goodsid='" + goodsid + '\'' +
                ", expressid='" + expressid + '\'' +
                ", exptime='" + exptime + '\'' +
                ", endtime='" + endtime + '\'' +
                ", expname='" + expname + '\'' +
                ", exphone='" + exphone + '\'' +
                ", expaddress='" + expaddress + '\'' +
                ", exprealaddr='" + exprealaddr + '\'' +
                ", finaltime='" + finaltime + '\'' +
                '}';
    }
}
