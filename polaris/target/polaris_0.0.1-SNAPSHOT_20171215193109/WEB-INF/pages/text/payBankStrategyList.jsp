<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--<%@ include file="/commons/taglibs.jsp" %>--%>
<%--<%@ page trimDirectiveWhitespaces="true" %>--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>${bankStrategy.bankName}-策略管理</title>
    <%@include file="/WEB-INF/pages/include/easyui.jsp" %>
    <!-- 对话框的样式 -->
    <link href="${path}/css/userList.css" rel="stylesheet" type="text/css"/>
    <%--<script type="text/javascript" src="${path}/js/payBankStrategy.js"/>--%>
    <script type="text/javascript">
        var url;
        var mesTitle;
        var path;

        window.onload = function () {
        //path = $("#path").val();

        <%--$("#datagrid").datagrid("options").url =  "${path}/payBankStrategy/toPayBankStrategyList?" + $("#fmorder").serialize();--%>
        <%--$("#datagrid").datagrid("load");--%>

        /*新建弹窗--商户--下拉框*/
        $("#dlgPartner").combobox({
        editable: false, //不可编辑状态
        cache: false,
        panelHeight: 'auto',//自动高度适合
        valueField: 'accesskey',
        textField: 'partnerName'
        })

        $("#dlgChannelName").combobox({
        editable: false, //不可编辑状态
        cache: false,
        panelHeight: 'auto',//自动高度适合
        valueField: 'gid',
        textField: 'channelName'
        });
        $.ajax({
        type: "POST",
        url: path + "/payBankStrategy/getPayChannel",
        data: {isdel: 0},
        cache: false,
        dataType: "json",
        success: function (data) {
        $("#dlgChannelName").combobox("loadData", data.rows);
        }
        });

        $("#dlgProvince").combobox({
        //editable: false, //不可编辑状态
        cache: false,
        panelHeight: 'auto',//自动高度适合
        valueField: 'areaName',
        textField: 'areaName',
        onChange: function (n, o) {
        //alert("n : " + n + ",o : " + o);
        $.ajax({
        type: "POST",
        url: path + "/payBankStrategy/getAreaCode?areaName=" + n.trim(),
        cache: false,
        dataType: "json",
        success: function (data) {
        $("#dlgProvince").combobox("loadData", data.rows);
        }
        });
        }
        });

        $.ajax({
        type: "POST",
        url: path + "/payBankStrategy/getAreaCode",
        cache: false,
        dataType: "json",
        success: function (data) {
        $("#dlgProvince").combobox("loadData", data.rows);
        }
        });

        }

        function searchOrder() {
        //alert("path=="+path)
        $("#datagrid").datagrid("options").url = path + "/payBankStrategy/toPayBankStrategyList?" + $("#fmorder").serialize();
        $("#datagrid").datagrid("load");
        }

        function onReset() {
        $('#insertTime').datebox('setValue', "");
        $('#finalTime').datebox('setValue', "");
        $("#strategyName").textbox('setValue', "");
        $("#isdel").combobox("setValue", "").combobox("setText", "不限");
        //$("#datagrid").datagrid("options").url = path + "/payBankStrategy/toPayBankStrategyList?bankId="+$("#bankId").val();
        $("#datagrid").datagrid("options").url = path + "/payBankStrategy/toPayBankStrategyList?" + $("#fmorder").serialize();
        $("#datagrid").datagrid("load");
        }

        function addConfig() {
        $(".dlgchannel:eq(0)~tr").remove();
        $('#configfm').form('clear');
        getPayChannel();
        getPayPartner();
        $("#fmbankId").val($("#bankId").val());
        $("#fmbankName").val($("#bankName").val())
        $("#areatd").next().empty();
        $("#dlgChannelName").combobox({
        required: true,
        onLoadSuccess: function () {
        if ("" == $("#dlgChannelName +span>input:last").val()) {
        $("#dlgChannelName").combobox("setValue", "").combobox("setText", "选择渠道");
        }
        }
        });
        $("#dlgChannelLevel").combobox({required: true});
        $("#dlgisdel").combobox({required: true});
        $('#configdlg').dialog('open').dialog('setTitle', '新增策略');
        }

        function editConfig(gid, isdel) {
        //var row = $('#datagrid').datagrid('getSelected');
        $(".dlgchannel:eq(0)~tr").remove();
        $('#configfm').form('clear');
        getPayChannel();
        getPayPartner();
        $("#areatd").next().empty();
        $("#dlgChannelName").combobox({
        required: false,
        onLoadSuccess: function () {
        if ("" == $("#dlgChannelName +span>input:last").val()) {
        $("#dlgChannelName").combobox("setValue", "").combobox("setText", "选择渠道");
        }
        }
        });
        $("#dlgChannelLevel").combobox({required: false});
        $("#dlgisdel").combobox({required: false});

        $.post(path + '/payBankStrategy/findPayBankStrategyById',
        {gid: gid},
        function (result) {
        //alert("result(editConfig)---------"+result)
        //var result = eval('(' + result + ')');//返回值为啥不一样？
        if (result.success) {
        //alert("obj==" + JSON.stringify(result.obj))
        $("#gid").val(result.obj.gid);
        $("#fmbankId").val(result.obj.bankId);
        $("#fmbankName").val(result.obj.bankName);
        $("#dlgStrategyName").val(result.obj.strategyName);
        $("#dlgTradeType").combobox("setValue", result.obj.tradeType).combobox("setText", result.obj.tradeType);
        $("#dlgPartner").combobox("setValue", result.obj.accessKey).combobox("setText", result.obj.partnerName);
        $("#dlgStrategyLevel").combobox("setValue", result.obj.level).combobox("setText", result.obj.level);
        //$("#dlgMinMoney").textbox("setValue",result.obj.minMoney);
        //$("#dlgMaxMoney").textbox("setValue",result.obj.maxMoney);
        $("#dlgMinMoney").val(result.obj.minMoney);
        $("#dlgMaxMoney").val(result.obj.maxMoney);
        switch (result.obj.cardType) {
        case "10" :
        $("#dlgCardType").combobox("setValue", result.obj.cardType).combobox("setText", "全部");
        break;
        case "0" :
        $("#dlgCardType").combobox("setValue", result.obj.cardType).combobox("setText", "借记卡");
        break;
        case "1" :
        $("#dlgCardType").combobox("setValue", result.obj.cardType).combobox("setText", "存折");
        break;
        case "2" :
        $("#dlgCardType").combobox("setValue", result.obj.cardType).combobox("setText", "贷记卡");
        break;
        case "3" :
        $("#dlgCardType").combobox("setValue", result.obj.cardType).combobox("setText", "公司账号");
        break;
        }
        $("#dlgRemark").textbox("setValue", result.obj.remark);
        if (result.obj.noInProvince != null && result.obj.noInProvince != "") {
        $("#dlgnoInProvince").val("," + result.obj.noInProvince);
        var noProvinces = result.obj.noInProvince.split(",");
        for (var i = 0; i < noProvinces.length; i++) {
        //alert(noProvinces.length)
        //alert(noProvinces[i])
        var aa = $("<span class='span1'>" + noProvinces[i] + "<a id='" + noProvinces[i] + "' onclick='removeArea(id)' href='javascript:void(0)' >X</a></span>&nbsp;&nbsp;");
        aa.appendTo($("#areatd").next());
        }
        }

        var channels = result.obj.strategyChannels;
        for (var i = 0; i < channels.length; i++) {
        var $id = $(".dlgchannel:last").attr("id") + "1";
        //alert("$id : "+ $id)
        var isdelName = (channels[i].isdel == 0) ? '启用' : '禁用';
        //alert(channels[i].channelName+","+ channels[i].level+","+isdelName+"," + channels[i].channelId+","+channels[i].isdel)
        var $addChannel = $("<tr id='" + $id + "' class='dlgchannel' style='height: 30px'>" +
        "<td align='right' style'width: 0px'></td>" +
        "<td noWrap='noWrap'>" +
        "<input value='" + channels[i].channelName + "' type='text' readOnly='readOnly' style='width: 80px'>&nbsp;&nbsp;" +
        "<input value='" + channels[i].level + "' type='text' name='channelLevel' class='' style='width: 60px'>&nbsp;&nbsp;" +
        "<input value='" + isdelName + "' type='text' readOnly='readOnly' style='width: 80px'>&nbsp;&nbsp;" +
        "<input value='" + channels[i].isdel + "' type='hidden' name='isdelChannel'>" +
        "<input value='" + channels[i].channelId + "' type='hidden' name='channelCode'>" +
        //"&nbsp;&nbsp;<a href='javascript:void(0)' name='" + $id + "' onclick='removeChannel(name);' >删除</a>" +
        "</td></tr>");
        var $delChannel;
        if (channels[i].isdel == 0) {
        //alert("000")
        $delChannel = $("<a href='javascript:void(0)' id='" + channels[i].channelId + "' name='" + channels[i].isdel + "' onclick='stopChannel(id,name);' >禁用</a>");
        } else {
        //alert("111")
        $delChannel = $("<a href='javascript:void(0)' id='" + channels[i].channelId + "' name='" + channels[i].isdel + "' onclick='startChannel(id,name);' >启用</a>");
        }


        $addChannel.appendTo($("#configfm >table"));
        //alert($("#"+$id).attr("class"));
        $delChannel.appendTo($("#" + $id).children("td").eq(1));
        }
        $('#configdlg').dialog('open').dialog('setTitle', '编辑');
        } else {
        $.messager.alert('错误提示', "编辑失败");
        }
        });

        }

        function saveConfig() {
        $("#configfm").form("submit", {
        url: path + "/payBankStrategy/addPayBankStrategy",
        onSubmit: function () {
        return $(this).form("validate");
        },
        success: function (result) {
        var result = eval('(' + result + ')');
        if (result.success) {
        mesTitle = "保存成功";
        $('#configdlg').dialog('close');
        $('#datagrid').datagrid('reload');
        } else {
        mesTitle = '保存失败';
        }
        $.messager.show({
        title: mesTitle,
        msg: result.msg
        });

        }
        });
        }

        function removeConfig(gid, isdel) {
        $("#delGid").val(gid);
        if (isdel == 1) {
        $.messager.alert('错误提示', "数据已经禁用,不需要再次禁用！");
        return;
        }
        $.messager.confirm("禁用", "是否禁用策略", function (r) {
        if (r) {
        $('#delreasondlg').dialog('open').dialog('setTitle', '禁用原因');
        $('#delReason').val("");
        }
        });

        }

        function save() {
        $.post(path + '/payBankStrategy/deletePayBankStrategy',
        {delReason: $('#delReason').val(), gid: $("#delGid").val()},
        function (result) {
        if (result.result) {
        $('#delreasondlg').dialog('close');
        $.messager.alert('消息提示', "禁用策略成功");
        $("#datagrid").datagrid("options").url = path + "/payBankStrategy/toPayBankStrategyList?" + $("#fmorder").serialize();
        $("#datagrid").datagrid("load");
        } else {
        $.messager.alert('错误提示', "禁用策略失败");
        }
        });
        }

        function recoverConfig(gid, isdel) {
        if (isdel == 0) {
        $.messager.alert('错误提示', "数据为未禁用状态,不需要启用！");
        return;
        }
        $.messager.confirm("启用", "是否启用策略", function (r) {
        if (r) {

        $.post(path + '/payBankStrategy/recoveryPayBankStrategy',
        {gid: gid},
        function (result) {
        //var result = eval('('+result+')');0
        if (result.success) {
        $.messager.alert('消息提示', result.msg);
        $("#datagrid").datagrid("options").url = path + "/payBankStrategy/toPayBankStrategyList?" + $("#fmorder").serialize();
        $("#datagrid").datagrid("load");
        } else {
        $.messager.alert('错误提示', result.msg);
        }
        });
        }
        });

        }

        function viewConfig(gid) {
        $("#viewdlg>table>tbody>.viewchannel").remove();
        $.post(path + '/payBankStrategy/findPayBankStrategyById',
        {gid: gid},
        function (result) {
        //alert("result(editConfig)---------"+result)
        //var result = eval('(' + result + ')');//返回值为啥不一样？
        if (result.success) {
        //alert("obj==" + JSON.stringify(result.obj))
        $("#viewstrategyName").text(result.obj.strategyName);
        $("#viewbankName").text(result.obj.bankName);
        $("#viewpartnerName").text(result.obj.partnerName);
        $("#viewtradeType").text(result.obj.tradeType);
        $("#viewminMoney").text(result.obj.minMoney);
        $("#viewmaxMoney").text(result.obj.maxMoney);
        switch (result.obj.cardType) {
        case "10" :
        $("#viewcardType").text("全部");
        break;
        case "0" :
        $("#viewcardType").text("借记卡");
        break;
        case "1" :
        $("#viewcardType").text("存折");
        break;
        case "2" :
        $("#viewcardType").text("贷记卡");
        break;
        case "3" :
        $("#viewcardType").text("公司账号");
        break;
        }
        $("#viewremark").text(result.obj.remark);
        $("#viewnoInProvince").text(result.obj.noInProvince);

        var channels = result.obj.strategyChannels;
        for (var i = 0; i < channels.length; i++) {
        var isdelName = (channels[i].isdel == 0) ? '启用' : '禁用';
        //alert(channels[i].channelName+","+ channels[i].level+","+isdelName+"," + channels[i].channelId+","+channels[i].isdel)
        var $addChannel = $("<tr class='viewchannel' style='height: 30px'>" +
        "<td align='right'>渠道：</td>" +
        "<td noWrap='noWrap'>" +
        "<span> " + channels[i].channelName + "<span>&nbsp;&nbsp;" +
        "<span> " + channels[i].level + "<span>&nbsp;&nbsp;" +
        "<span>" + isdelName + "<span>&nbsp;&nbsp;" +
        "</td></tr>");

        $addChannel.appendTo($("#viewdlg >table"));
        }
        $('#viewdlg').dialog('open').dialog('setTitle', '查看');
        } else {
        $.messager.alert('错误提示', "查看失败");
        }
        });
        }

        function addArea() {
        var dlgnoInProvince = $("#dlgnoInProvince").val();
        var noInProvince = $("#dlgProvince +span>input:last").attr("value");
        //alert(dlgnoInProvince.indexOf(noInProvince))
        if (dlgnoInProvince.indexOf(noInProvince) == -1) {
        dlgnoInProvince = dlgnoInProvince + "," + noInProvince;
        $("#dlgnoInProvince").val(dlgnoInProvince);
        $("#dlgProvince").combobox("clear");
        var aa = $("<span class='span1'>" + noInProvince + "<a id='" + noInProvince + "' onclick='removeArea(id)' href='javascript:void(0)' >X</a></span>&nbsp;&nbsp;")
        aa.appendTo($("#areatd").next());
        }

        }

        function removeArea(noInProvince) {
        var province = $("#dlgnoInProvince").val();
        province = province.replace("," + noInProvince, "");
        $("#dlgnoInProvince").val(province);
        $("#" + noInProvince).parent().remove();
        }

        function addChannel() {

        var $id = $(".dlgchannel:last").attr("id") + "1";

        var channelCode = $("#dlgChannelName").combobox("getValue");
        var channelName = $("#dlgChannelName").combobox("getText");
        var channelLevel = $("#dlgChannelLevel").combobox("getText");
        var isdelCode = $("#dlgisdel").combobox("getValue");
        var isdelName = $("#dlgisdel").combobox("getText");
        //alert(channelCode)
        if (channelCode == '') {
        return $.messager.alert("提示", "请选择渠道！");
        }
        //alert(level)
        if (channelLevel == '优先级') {
        return $.messager.alert("提示", "请选择优先级！");
        }
        //alert(isdelCode)
        if (isdelCode == '') {
        return $.messager.alert("提示", "请选择状态！");
        }
        var $addChannel = $("<tr id='" + $id + "' class='dlgchannel' style='height: 30px'>" +
        "<td align='right' style'width: 0px'></td>" +
        "<td noWrap='noWrap'>" +
        "<input value='" + channelName + "' type='text' readOnly='readOnly' style='width: 80px'>&nbsp;&nbsp;" +
        "<input value='" + channelLevel + "' type='text' name='channelLevel' class='' readOnly='readOnly' style='width: 60px'>&nbsp;&nbsp;" +
        "<input value='" + isdelName + "' type='text' readOnly='readOnly'  style='width: 80px'>" +
        "<input value='" + isdelCode + "' type='hidden' name='isdelChannel'>" +
        "<input value='" + channelCode + "' type='hidden' name='channelCode'>" +
        "&nbsp;&nbsp;<a href='javascript:void(0)' name='" + $id + "' onclick='removeChannel(name);' >删除</a>" +
        "</td></tr>");

        $addChannel.appendTo($("#configfm >table"));
        }

        /*新增策略页面，删除已选渠道功能*/
        function removeChannel(id) {
        $("#" + id).remove();
        }
        /*编辑策略页面，禁用渠道功能*/
        function stopChannel(channelId, isdel) {

        $("#delChannelGid").val(channelId);
        if (isdel == 1) {
        $.messager.alert('错误提示', "数据已经禁用,不需要再次禁用！");
        return;
        }
        $.messager.confirm("禁用", "是否禁用" + $("#bankName").val() + "-" + $("#dlgStrategyName").val() + "的渠道", function (r) {
        if (r) {
        $('#delChanneldlg').dialog('open').dialog('setTitle', '禁用原因');
        $('#delChannelReason').val("");
        }
        });
        }

        function saveDelChannel() {
        var channelId = $("#delChannelGid").val();
        $.post(path + '/payBankStrategy/deletePayStrategyChannel',
        {delReason: $('#delReason').val(), strategyId: $("#gid").val(), channelId: $("#delChannelGid").val()},
        function (result) {
        //alert("result==="+JSON.stringify(result))
        //var result = eval('('+result+')');
        if (result.result) {
        $('#delChanneldlg').dialog('close');
        $.messager.alert('消息提示', "禁用渠道成功");
        $("#" + channelId).prevAll('input[type=text]:first').val("禁用");
        $("#" + channelId).prevAll('input[type=hidden]:last').val(1);
        $("#" + channelId).attr("name", 1);
        $("#" + channelId).attr("onclick", "startChannel(id,name);").text("启用");
        //$("#datagrid").datagrid("options").url = path + "/payBankStrategy/toPayBankStrategyList?" + $("#fmorder").serialize();
        //$("#datagrid").datagrid("load");
        } else {
        $.messager.alert('错误提示', "禁用渠道失败");
        }
        });
        }

        function startChannel(channelId, isdel) {
        if (isdel == 0) {
        $.messager.alert('错误提示', "数据为未禁用状态,不需要启用！");
        return;
        }
        $.messager.confirm("启用", "是否启用" + $("#bankName").val() + "-" + $("#dlgStrategyName").val() + "的渠道", function (r) {
        if (r) {

        $.post(path + '/payBankStrategy/recoveryPayStrategyChannel',
        {strategyId: $("#gid").val(), channelId: channelId},
        function (result) {
        //var result = eval('('+result+')');0
        if (result.success) {
        $.messager.alert('消息提示', "启用渠道成功");
        $("#" + channelId).prevAll('input[type=text]:first').val("启用");
        $("#" + channelId).prevAll('input[type=hidden]:last').val(0);
        $("#" + channelId).attr("name", 0);
        $("#" + channelId).attr("onclick", "stopChannel(id,name);").text("禁用");
        //$("#datagrid").datagrid("options").url = path + "/payBankStrategy/toStrategyList?" + $("#fmorder").serialize();
        //$("#datagrid").datagrid("load");
        } else {
        $.messager.alert('错误提示', "启用策略失败");
        }
        });
        }
        });
        }
        formatData = function (val, row) {
        switch (row.isdel) {
        case 0 :
        //return '<span id="' + row.gid + '"><a class="editcls"  onclick="removeConfig(\'' + row.gid + '\',\'' + row.isdel + '\')" href="javascript:void(0)">禁用</a>&nbsp;&nbsp;&nbsp;<a class="editcls"  onclick="doConfiguration(\'' + row.gid + '\',\'' + row.isdel + '\',\'' + row.bankName + '\')" href="javascript:void(0)">配置</a></span>';
        return '<span id="' + row.gid + '"><a class="editcls"  onclick="removeConfig(\'' + row.gid + '\',\'' + row.isdel + '\')" href="javascript:void(0)">禁用</a>&nbsp;&nbsp;&nbsp;<a class="editcls"  onclick="editConfig(\'' + row.gid + '\',\'' + row.isdel + '\')" href="javascript:void(0)">编辑</a>&nbsp;&nbsp;&nbsp;<a class="editcls"  onclick="viewConfig(\'' + row.gid + '\')" href="javascript:void(0)">查看</a></span>';

        case 1 :
        //return '<span id="' + row.gid + '"><a class="editcls"  onclick="recoverConfig(\'' + row.gid + '\',\'' + row.isdel + '\')" href="javascript:void(0)">启用</a>&nbsp;&nbsp;&nbsp;<a class="editcls"  onclick="doConfiguration(\'' + row.gid + '\',\'' + row.isdel + '\',\'' + row.bankName + '\')" href="javascript:void(0)">配置</a></span>';
        return '<span id="' + row.gid + '"><a class="editcls"  onclick="recoverConfig(\'' + row.gid + '\',\'' + row.isdel + '\')" href="javascript:void(0)">启用</a>&nbsp;&nbsp;&nbsp;<a class="editcls"  onclick="editConfig(\'' + row.gid + '\',\'' + row.isdel + '\')" href="javascript:void(0)">编辑</a>&nbsp;&nbsp;&nbsp;<a class="editcls"  onclick="viewConfig(\'' + row.gid + '\')" href="javascript:void(0)">查看</a></span>';
        }
        }

        function getPayChannel() {
        $.post(path + "/payBankStrategy/getPayChannel", {isdel: 0}, function (data) {
        //alert("data==" + JSON.stringify(data))
        $("#dlgChannelName").combobox("loadData", data.rows);
        }, "json"
        );
        }

        function getPayPartner() {
        $.ajax({
        type: "POST",
        url: path + "/payBankStrategy/getPayPartner?isdel=0",
        cache: false,
        dataType: "json",
        success: function (data) {
        //alert("data==" + JSON.stringify(data))
        data.rows.unshift({"accesskey": "ALL", "partnerName": "ALL"})
        $("#dlgPartner").combobox("loadData", data.rows);
        }
        });
        }


    </script>

</head>
<body class="easyui-layout" fit="true">
<input id="path" value="${ctx}" type="hidden">
<input id="bankId" value="${bankStrategy.bankId}" type="hidden">
<input type="hidden" id="bankName" value="${bankStrategy.bankName}">

<div region="center" border="false" style="overflow: hidden;">

    <!-- 搜索栏 -->
    <div id="toolbar"
    <%--class="easyui-layout"--%>
         style="width:100%;height:80px;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <form id="fmorder" name="fmorder" method="post">
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <label>开始日期:</label> <input id="insertTime" name="startDate" class="easyui-datebox" editable="false"
                                            style="width: 100px">
                <label>结束日期:</label> <input id="finalTime" name="endDate" class="easyui-datebox" style="width: 100px"
                                            editable="false">
                <label>策略名称:</label> <input id="strategyName" name="strategyName" class="easyui-textbox"
                                            style="width: 150px">
                <label>使用状态:</label> <input id="isdel" name="isdel" class="easyui-combobox" style="width: 100px"
                                            data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
                                            data:[{id:'',text:'不限'},{id:'0',text:'使用中'},{id:'1',text:'已禁用'}]">
                <input type="hidden" name="bankId" value="${bankStrategy.bankId}">
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchOrder();">查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
            </div>
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-add" plain="true" onclick="addConfig();">添加</a>
            </div>

        </form>

    </div>

    <!-- 消费信息列表 -->
    <table id="datagrid" title="${bankStrategy.bankName}-策略管理" class="easyui-datagrid" fit="true"
    <%--url="${ctx}/payBankStrategy/toPayBankStrategyList"--%>
           toolbar="#toolbar" pagination="true"
           fitColumns="false" singleSelect="true" rownumbers="true"
           border="false" nowrap="true" checkOnSelect="true" selectOnCheck="true"
    <%--data-options="pageSize:1,pageNumber:1,pageList:[1,2]"--%>
            <%-->--%>
        <thead>
        <tr>
            <%--<th field="ck" checkbox="true"></th>--%>
            <%--<th field="gid" width="180">Gid</th>--%>
            <th field="strategyName" width="150" align="center">策略名称</th>
            <th field="minMoney" width="180" align="center">单笔最小金额(分)</th>
            <th field="maxMoney" width="180" align="center">单笔最大金额(分)</th>
            <th field="useChannel" width="180" align="center">启用渠道</th>
            <th field="noUseChannel" width="180" align="center">禁用渠道</th>
            <th field="insertTime" width="180" align="center">插入时间</th>
            <th field="operateTime" width="180" align="center">操作时间</th>
            <th field="level" width="100" align="center">策略优先级</th>
            <th field="isdel" width="80" formatter="formatIsdel" align="center">使用状态</th>
            <th field="delReason" width="200" align="center">禁用原因</th>
            <th field="opt" width="100" formatter="formatData" align="center">操作</th>
        </tr>
        </thead>
    </table>
    <!-- 对话框 -->
    <div id="configdlg" class="easyui-dialog"
         style="width:600px;height:450px;padding:10px 20px" closed="true"
         buttons="#configdlg-buttons">
        <form id="configfm" method="post" novalidate>

            <table>
                <input id="gid" name="gid" type="hidden"></td>
                <input id="fmbankId" type="hidden" name="bankId">
                <input id="fmbankName" type="hidden" name="bankName">
                <tr style="height: 50px">
                    <td align="right" noWrap="noWrap">*策略名称:</td>
                    <td noWrap="noWrap"><input id="dlgStrategyName" name="strategyName" style="width: 160px"
                                               class="easyui-validatebox"
                                               required="true">&nbsp;&nbsp;&nbsp;${bankStrategy.bankName}</td>
                </tr>
                <tr style="height: 50px">
                    <td align="right">*业务类型:</td>
                    <td><input id="dlgTradeType" name="tradeType" class="easyui-combobox" style="width: 160px"
                               required="true" value="请选择业务类型"
                               data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
                                            data:[{id:'ALL',text:'ALL'},{id:'卡验证',text:'卡验证'},{id:'提现',text:'提现'}]">
                    </td>
                </tr>
                <tr style="height: 50px">
                    <td align="right">*商户名称:</td>
                    <td><input id="dlgPartner" name="accessKey" class="easyui-combobox" required="true"
                               style="width: 160px">
                    </td>
                </tr>
                <tr style="height: 50px" noWrap="noWrap">
                    <td align="right">*单笔金额:</td>
                    <td><input id="dlgMinMoney" name="minMoney" class="easyui-validatebox" required="true"
                               style="width: 80px">&nbsp;&nbsp;-&nbsp;&nbsp;
                        <input id="dlgMaxMoney" name="maxMoney" class="easyui-validatebox" required="true"
                               style="width: 80px">&nbsp;&nbsp;<span style="color: red">单位：分</span>
                    </td>
                </tr>
                <tr style="height: 50px">
                    <td align="right">*选择卡别:</td>
                    <td><input id="dlgCardType" name="cardType" class="easyui-combobox" style="width: 160px"
                               required="true"
                               data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
                                            data:[{id:'10',text:'全部'},{id:'0',text:'借记卡'},{id:'1',text:'存折'},{id:'2',text:'贷记卡'},{id:'3',text:'公司账号'}]">
                    </td>
                </tr>
                <tr style="height: 50px">
                    <td align="right">*策略优先级:</td>
                    <td><input id="dlgStrategyLevel" name="level" class="easyui-combobox" style="width: 160px"
                               required="true" value="请选择优先级"
                               data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
                                            data:[{id:'1',text:'1'},{id:'2',text:'2'},{id:'3',text:'3'},{id:'4',text:'4'}]">
                    </td>
                </tr>
                <tr style="height: 100px">
                    <td align="right">备注:</td>
                    <td><input id="dlgRemark" name="remark" class="easyui-textbox" multiline="true"
                               style="width: 160px;height: 80px">
                    </td>
                </tr>
                <tr style="height: 50px">
                    <td align="right">不支持省份:</td>
                    <td>
                        <input id="dlgProvince">&nbsp;&nbsp;<input type="button" value="确定" onclick="addArea();">&nbsp;&nbsp;<span
                            style="color: red">不填表示支持全国</span>
                    </td>

                </tr>
                <tr style="height: 30px">
                    <td id="areatd" noWrap="noWrap" align="right">
                        <input id="dlgnoInProvince" name="noInProvince" type="hidden"><br/>
                        <%--<span id='noInProvinceCode'>noInProvince<a onclick='removeArea();'>X</a></span>--%>
                    </td>
                    <td></td>
                </tr>
                <tr id="dlgchannel" class="dlgchannel" style="height: 50px">
                    <td align="right" style="width: 0px"></td>
                    <td noWrap="noWrap">
                        <input id="dlgChannelName" class="easyui-combobox" required="true">
                        <input id="dlgChannelLevel" class="easyui-combobox" style="width: 80px" required="true"
                               data-options="panelHeight:'160px', editable:false,valueField:'id',textField:'text',
                               data:[{id:'',text:'优先级'},{id:'1',text:'1'},{id:'2',text:'2'},{id:'3',text:'3'},{id:'4',text:'4'},{id:'5',text:'5'},{id:'6',text:'6'},{id:'7',text:'7'},{id:'8',text:'8'},{id:'9',text:'9'},{id:'10',text:'10'}]">
                        <input id="dlgisdel" class="easyui-combobox" style="width: 80px" required="true"
                               data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
                                            data:[{id:'',text:'状态'},{id:'0',text:'开启'},{id:'1',text:'禁用'}]">
                        <a onclick='addChannel()' href='javascript:void(0)'>+确定</a>
                        <%--<a class="abcs" href='javascript:void(0)'>+增加渠道</a>--%>
                        <%--<input type="button" class="abcs" value="aa"/>--%>
                    </td>
                </tr>

            </table>
        </form>
    </div>
    <div id="delreasondlg" class="easyui-dialog"
         style="width:300px;height:120px;padding:10px 20px" closed="true"
         buttons="#delreason-buttons">
        <input id="delGid" type="hidden">
        <tr>
            <td>*禁用原因:</td>
            <td><input id="delReason" name="delReason" type="text"></td>
        </tr>
    </div>

    <!-- 对话框按钮 -->
    <div id="configdlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="saveConfig()" style="width:60px">保存</a> <a
            href="javascript:void(0)" class="easyui-linkbutton"
            iconCls="icon-cancel" onclick="javascript:$('#configdlg').dialog('close')"
            style="width:60px">取消</a>
    </div>

    <!-- 对话框按钮 -->
    <div id="delreason-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="save()" style="width:60px">保存</a> <a
            href="javascript:void(0)" class="easyui-linkbutton"
            iconCls="icon-cancel" onclick="javascript:$('#delreasondlg').dialog('close')"
            style="width:60px">取消</a>
    </div>

    <div id="delChanneldlg" class="easyui-dialog"
         style="width:300px;height:120px;padding:10px 20px" closed="true"
         buttons="#delChannel-buttons">
        <input id="delChannelGid" type="hidden">
        <tr>
            <td>*禁用原因:</td>
            <td><input id="delChannelReason" name="delReason" type="text"></td>
        </tr>
    </div>

    <!-- 对话框按钮 -->
    <div id="delChannel-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="saveDelChannel()" style="width:60px">保存</a> <a
            href="javascript:void(0)" class="easyui-linkbutton"
            iconCls="icon-cancel" onclick="javascript:$('#delChanneldlg').dialog('close')"
            style="width:60px">取消</a>
    </div>

    <!-- 对话框 -->
    <div id="viewdlg" class="easyui-dialog"
         style="width:500px;height:380px;padding:10px 20px" closed="true"
         buttons="#viewdlg-buttons">
        <table>
            <tr style="height: 30px">
                <td align="right">策略名称：</td>
                <td id="viewstrategyName"></td>
                <td>银行名称：</td>
                <td id="viewbankName"></td>
            </tr>
            <tr style="height: 30px">
                <td align="right">商户名称：</td>
                <td id="viewpartnerName"></td>
            </tr>
            <tr style="height: 30px">
                <td align="right">业务类型：</td>
                <td id="viewtradeType"></td>
            </tr>
            <tr style="height: 30px">
                <td align="right">卡类型：</td>
                <td id="viewcardType"></td>
            </tr>
            <tr style="height: 30px">
                <td align="right">金额(分)：</td>
                <td><span id="viewminMoney"></span>-<span id="viewmaxMoney"></span></td>
            </tr>
            <tr style="height: 30px">
                <td align="right">不支持省份：</td>
                <td id="viewnoInProvince"></td>
            </tr>
            <tr style="height: 30px">
                <td align="right">备注：</td>
                <td id="viewremark"></td>
            </tr>
        </table>
    </div>
    <!-- 对话框按钮 -->
    <div id="viewdlg-buttons">
        <%--<a href="javascript:void(0)" class="easyui-linkbutton c6"--%>
        <%--iconCls="icon-ok" onclick="saveConfig()" style="width:60px">保存</a> --%>
        <a href="javascript:void(0)" class="easyui-linkbutton"
           iconCls="icon-cancel" onclick="javascript:$('#viewdlg').dialog('close')"
           style="width:60px">取消</a>
    </div>
</div>
</body>
</html>
