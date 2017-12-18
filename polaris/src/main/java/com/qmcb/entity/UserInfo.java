/**
 *
 */
package com.qmcb.entity;

import com.qmcb.tool.easyui.PageHelper;

/**
 * 类名称：OrderFreedom
 * 类描述：鉴权验证表
 * 创建人：武金龙
 * 创建时间：2015/11/11 12:00
 * 修改备注：
 */
public class UserInfo extends PageHelper {

    /**
     *
     */
    private static final long serialVersionUID = 1L;

    /**
     *
     */
    private String orderGid;

    /**
     * 开始时间
     */
    private String insertTime;

    /**
     * 操作时间
     */
    private String operateTime;

    /**
     * 结束时间
     */
    private String finalTime;

    /**
     * 来源渠道
     */
    private String sourceChannel;

    /**
     * 来源子渠道
     */
    private String sourceSubChannel;

    /**
     *
     */
    private String fcOrderid;

    /**
     * 金额
     */
    private String payMoney;

    /**
     * 卡号
     */
    private String cardNo;

    /**
     * 开户行
     */
    private String cardBankName;

    /**
     * 卡类型
     */
    private String cardType;

    /**
     * 处理渠道
     */
    private String dealChannel;

    /**
     * 处理子渠道
     */
    private String dealSubChannel;

    /**
     * 姓名
     */
    private String fullName;

    /**
     * 身份证号
     */
    private String idCard;

    /**
     * 电话
     */
    private String phone;

    /**
     *
     */
    private String province;

    /**
     *
     */
    private String city;

    /**
     *
     */
    private String remark1;

    /**
     *
     */
    private String remark2;

    /**
     *
     */
    private String remark3;

    /**
     * 成功标识
     */
    private String sucFlag;

    /**
     *
     */
    private String isFinal;

    /**
     *
     */
    private String code;

    /**
     * 返回信息
     */
    private String returnMsg;

    /**
     * 银行返回信息
     */
    private String bankReturnMsg;

    /**
     * 商户订单号
     */
    private String payOrderid;

    /**
     * 商户号
     */
    private String merId;

    /**
     *
     */
    private String terminalNumber;

    /**
     *
     */
    private String channelRate;

    /**
     *
     */
    private String channelCharge;

    /**
     *
     */
    private String cancelFlag;

    /**
     *
     */
    private String merOrderid;

    /**
     *
     */
    private String merSettleDate;

    /*
 * 新添加字段 错误码表的有关
 */
    private String err_code;
    private String err_msg;
    private Integer id;
    private String customerId;

    public String getCustomerId() {
        return customerId;
    }

    public void setCustomerId(String customerId) {
        this.customerId = customerId;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getOrderGid() {
        return orderGid;
    }

    public void setOrderGid(String orderGid) {
        this.orderGid = orderGid;
    }

    public String getInsertTime() {
        return insertTime;
    }

    public void setInsertTime(String insertTime) {
        this.insertTime = insertTime;
    }

    public String getOperateTime() {
        return operateTime;
    }

    public void setOperateTime(String operateTime) {
        this.operateTime = operateTime;
    }

    public String getFinalTime() {
        return finalTime;
    }

    public void setFinalTime(String finalTime) {
        this.finalTime = finalTime;
    }

    public String getSourceChannel() {
        return sourceChannel;
    }

    public void setSourceChannel(String sourceChannel) {
        this.sourceChannel = sourceChannel;
    }

    public String getSourceSubChannel() {
        return sourceSubChannel;
    }

    public void setSourceSubChannel(String sourceSubChannel) {
        this.sourceSubChannel = sourceSubChannel;
    }

    public String getFcOrderid() {
        return fcOrderid;
    }

    public void setFcOrderid(String fcOrderid) {
        this.fcOrderid = fcOrderid;
    }

    public String getPayMoney() {
        return payMoney;
    }

    public void setPayMoney(String payMoney) {
        this.payMoney = payMoney;
    }

    public String getCardNo() {
        return cardNo;
    }

    public void setCardNo(String cardNo) {
        this.cardNo = cardNo;
    }

    public String getCardBankName() {
        return cardBankName;
    }

    public void setCardBankName(String cardBankName) {
        this.cardBankName = cardBankName;
    }

    public String getCardType() {
        return cardType;
    }

    public void setCardType(String cardType) {
        this.cardType = cardType;
    }

    public String getDealChannel() {
        return dealChannel;
    }

    public void setDealChannel(String dealChannel) {
        this.dealChannel = dealChannel;
    }

    public String getDealSubChannel() {
        return dealSubChannel;
    }

    public void setDealSubChannel(String dealSubChannel) {
        this.dealSubChannel = dealSubChannel;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getRemark1() {
        return remark1;
    }

    public void setRemark1(String remark1) {
        this.remark1 = remark1;
    }

    public String getRemark2() {
        return remark2;
    }

    public void setRemark2(String remark2) {
        this.remark2 = remark2;
    }

    public String getRemark3() {
        return remark3;
    }

    public void setRemark3(String remark3) {
        this.remark3 = remark3;
    }

    public String getSucFlag() {
        return sucFlag;
    }

    public void setSucFlag(String sucFlag) {
        this.sucFlag = sucFlag;
    }

    public String getIsFinal() {
        return isFinal;
    }

    public void setIsFinal(String isFinal) {
        this.isFinal = isFinal;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getReturnMsg() {
        return returnMsg;
    }

    public void setReturnMsg(String returnMsg) {
        this.returnMsg = returnMsg;
    }

    public String getBankReturnMsg() {
        return bankReturnMsg;
    }

    public void setBankReturnMsg(String bankReturnMsg) {
        this.bankReturnMsg = bankReturnMsg;
    }

    public String getPayOrderid() {
        return payOrderid;
    }

    public void setPayOrderid(String payOrderid) {
        this.payOrderid = payOrderid;
    }

    public String getMerId() {
        return merId;
    }

    public void setMerId(String merId) {
        this.merId = merId;
    }

    public String getIdCard() {
        return idCard;
    }

    public void setIdCard(String idCard) {
        this.idCard = idCard;
    }

    public String getTerminalNumber() {
        return terminalNumber;
    }

    public void setTerminalNumber(String terminalNumber) {
        this.terminalNumber = terminalNumber;
    }

    public String getChannelRate() {
        return channelRate;
    }

    public void setChannelRate(String channelRate) {
        this.channelRate = channelRate;
    }

    public String getChannelCharge() {
        return channelCharge;
    }

    public void setChannelCharge(String channelCharge) {
        this.channelCharge = channelCharge;
    }

    public String getCancelFlag() {
        return cancelFlag;
    }

    public void setCancelFlag(String cancelFlag) {
        this.cancelFlag = cancelFlag;
    }

    public String getMerOrderid() {
        return merOrderid;
    }

    public void setMerOrderid(String merOrderid) {
        this.merOrderid = merOrderid;
    }

    public String getMerSettleDate() {
        return merSettleDate;
    }

    public void setMerSettleDate(String merSettleDate) {
        this.merSettleDate = merSettleDate;
    }

    public String getErr_code() {
        return err_code;
    }

    public void setErr_code(String err_code) {
        this.err_code = err_code;
    }

    public String getErr_msg() {
        return err_msg;
    }

    public void setErr_msg(String err_msg) {
        this.err_msg = err_msg;
    }

    @Override
    public String toString() {
        return "OrderFreedom{" +
                "orderGid='" + orderGid + '\'' +
                ", insertTime='" + insertTime + '\'' +
                ", operateTime='" + operateTime + '\'' +
                ", finalTime='" + finalTime + '\'' +
                ", sourceChannel='" + sourceChannel + '\'' +
                ", sourceSubChannel='" + sourceSubChannel + '\'' +
                ", fcOrderid='" + fcOrderid + '\'' +
                ", payMoney='" + payMoney + '\'' +
                ", cardNo='" + cardNo + '\'' +
                ", cardBankName='" + cardBankName + '\'' +
                ", cardType='" + cardType + '\'' +
                ", dealChannel='" + dealChannel + '\'' +
                ", dealSubChannel='" + dealSubChannel + '\'' +
                ", fullName='" + fullName + '\'' +
                ", idCard='" + idCard + '\'' +
                ", phone='" + phone + '\'' +
                ", province='" + province + '\'' +
                ", city='" + city + '\'' +
                ", remark1='" + remark1 + '\'' +
                ", remark2='" + remark2 + '\'' +
                ", remark3='" + remark3 + '\'' +
                ", sucFlag='" + sucFlag + '\'' +
                ", isFinal='" + isFinal + '\'' +
                ", code='" + code + '\'' +
                ", returnMsg='" + returnMsg + '\'' +
                ", bankReturnMsg='" + bankReturnMsg + '\'' +
                ", payOrderid='" + payOrderid + '\'' +
                ", merId='" + merId + '\'' +
                ", terminalNumber='" + terminalNumber + '\'' +
                ", channelRate='" + channelRate + '\'' +
                ", channelCharge='" + channelCharge + '\'' +
                ", cancelFlag='" + cancelFlag + '\'' +
                ", merOrderid='" + merOrderid + '\'' +
                ", merSettleDate='" + merSettleDate + '\'' +
                ", err_code='" + err_code + '\'' +
                ", err_msg='" + err_msg + '\'' +
                '}';
    }
}
