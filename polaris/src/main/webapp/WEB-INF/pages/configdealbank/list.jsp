<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>用户管理</title>
    <%@include file="/WEB-INF/pages/include/easyui.jsp" %>
    <!-- 对话框的样式 -->
    <link href="${path}/css/userList.css" rel="stylesheet" type="text/css"/>

    <script type="text/javascript">
        var url;
        var mesTitle;

        window.onload = function () {

            $('#openRoleDiv').dialog({
                onClose: function () {
                    $("#datagrid").datagrid("options").url = "${path}/configdealbank/datagrid?" + $("#fmorder").serialize();
                    $("#datagrid").datagrid("load");
                }
            });

            $('#dlgdealChannel').combobox({
                editable: true, //编辑状态
                cache: false,
                panelHeight: 'auto',//自动高度适合
                valueField: 'dealChannel',
                textField: 'dealChannel'
            });

            $.ajax({
                type: "POST",
                url: "${path}/configdeal/getDealchannel",
                cache: false,
                dataType: "json",
                success: function (data) {

                    $("#dlgdealChannel").combobox("loadData", data.rows);
                }
            });

            $('#dlgdealSubChannel').combobox({
                editable: true, //编辑状态
                cache: false,
                panelHeight: 'auto',//自动高度适合
                valueField: 'dealSubChannel',
                textField: 'dealSubChannel'
            });

            $.ajax({
                type: "POST",
                url: "${path}/configdeal/getDealSubChannel",
                cache: false,
                dataType: "json",
                success: function (data) {

                    $("#dlgdealSubChannel").combobox("loadData", data.rows);
                }
            });

            $('#dlgstrategy').combobox({
                editable: true, //不可编辑状态
                cache: false,
                panelHeight: 'auto',//自动高度适合
                valueField: 'strategy',
                textField: 'strategy'
            });

            $.ajax({
                type: "POST",
                url: "${path}/configdeal/getStrategy",
                cache: false,
                dataType: "json",
                success: function (data) {

                    $("#dlgstrategy").combobox("loadData", data.rows);
                }
            });

            $('#dlgcardBankName').combobox({
                editable: true, //不可编辑状态
                cache: false,
                panelHeight: 'auto',//自动高度适合
                valueField: 'cardBankName',
                textField: 'cardBankName'
            });

            $.ajax({
                type: "POST",
                url: "${path}/configdeal/getCardBnkName",
                cache: false,
                dataType: "json",
                success: function (data) {

                    $("#dlgcardBankName").combobox("loadData", data.rows);
                }
            });

        }

        //格式换显示状态
        function formatdata(val, row) {
            return '<a class="editcls" onclick="editRow(\'' + row.cardBankName + '\',\'' + row.cardType + '\')" href="javascript:void(0)">查看</a>';
        }

        //查询列表
        function searchOrder() {
            $("#datagrid").datagrid("options").url = "${path}/configdealbank/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        //重置
        function onReset() {
            $("#strategy").textbox('setValue', "");
            $("#dealSubChannel").textbox('setValue', "");
            //$("#cardType").combobox("setValue", "");
            $("#cardBankName").textbox('setValue', "");
            $("#isdel").combobox("setValue", "");
            $("#datagrid").datagrid("options").url = "${path}/configdealbank/datagrid";
            $("#datagrid").datagrid("load");
        }

        function editRow(cardBankName, cardType) {
            $('#iframe1')[0].src = '${path}/configdealbank/dealinfo?cardBankName=' + cardBankName
                    + '&cardType=' + cardType + '&menu_button=' + $("#menu_button").val();
            $('#openRoleDiv').dialog('open');
        }

        //弹出新增界面
        function addConfig() {
            $('#configdlg').dialog('open').dialog('setTitle', '添加路由策略');
            $('#configfm').form('clear');
            mesTitle = '保存成功';
        }

        //新增保存
        function saveConfig() {

            $('#dlgdealChannel').combobox("setValue", $("#dlgdealChannel").combobox("getText"));
            $("#dlgdealSubChannel").combobox("setValue", $("#dlgdealSubChannel").combobox("getText"));
            $("#dlgstrategy").combobox("setValue", $("#dlgstrategy").combobox("getText"));
            $("#dlgcardBankName").combobox("setValue", $("#dlgcardBankName").combobox("getText"));

            $('#configfm').form('submit', {
                url: path + "/configdeal/addConfigDeal",
                onSubmit: function () {
                    return $(this).form('validate');
                },
                success: function (result) {
                    var result = eval('(' + result + ')');
                    if (result.success) {
                        $('#configdlg').dialog('close');
                        $("#datagrid").datagrid("options").url = "${path}/configdealbank/datagrid";
                        $('#datagrid').datagrid('reload');
                    } else {
                        mesTitle = '新增路由策略失败';
                    }
                    $.messager.show({
                        title: mesTitle,
                        msg: result.msg
                    });
                }
            });
        }

        function formatCardType(val, row) {
            if (val == 1) {
                return '<span>' + '借记卡' + '</span>';
            } else if (val == 2) {
                return '<span>' + '信用卡' + '</span>';
            }
        }

    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 策略信息列表 -->
    <table id="datagrid" title="路由策略管理" class="easyui-datagrid" fit="true"
           url="${path}/configdealbank/datagrid" toolbar="#toolbar" pagination="true"
           fitColumns="false" singleSelect="true" rownumbers="true"
           border="false" nowrap="false">
        <thead>
        <tr>
            <th field="cardBankName" width="150">开户行</th>
            <th field="cardType" width="100" formatter="formatCardType">卡别</th>
            <%--<th field="dealSubChannel" width="150">处理子渠道</th>--%>
            <%--<th field="strategy" width="100">策略名称</th>--%>
            <%--<th field="sourceSubChannel" width="300">来源子渠道</th>--%>
            <%--<th field="merName" width="150">商户名称</th>--%>
            <%--<th field="merId" width="150">商户号</th>--%>
            <th field="opt" width="100" formatter="formatdata">操作</th>
        </tr>
        </thead>
    </table>

    <!-- 按钮 -->

    <div id="toolbar" class="easyui-layout"
         style="width:100%;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <form id="fmorder" name="fmorder" method="post">
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <label>策略名称:</label> <input id="strategy" name="strategy" class="easyui-textbox" style="width: 100px">
                <label>卡别:</label> <input id="cardType" name="cardType" class="easyui-combobox" style="width: 80px"
                data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
                data:[{id:'',text:'不限'},{id:'1',text:'借记卡'},{id:'2',text:'信用卡'}]">
                <label>处理子渠道:</label> <input id="dealSubChannel" name="dealSubChannel" class="easyui-textbox"
                                             style="width: 100px">
                <label>银行名称:</label> <input id="cardBankName" name="cardBankName" class="easyui-textbox"
                                            style="width: 100px">
                <label>删除标识:</label> <input id="isdel" name="isdel" class="easyui-combobox" style="width: 80px"
                                            data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'',text:'不限'},{id:'0',text:'未删除'},{id:'1',text:'已删除'}]">

                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchOrder();">查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
            </div>
        </form>
        <input id="menu_button" name="menu_button" type="hidden" value="${menu_button}"></td>
        <c:if test="${button.size()>0}">
            <div id="toolbar1">
                <c:forEach var="button" items="${button}">
                    <c:if test="${button.menu_button == 'add'}">
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           iconCls="icon-add" plain="true" onclick="addConfig();">添加</a>
                    </c:if>
                </c:forEach>
            </div>
        </c:if>

    </div>


    <div id="openRoleDiv" class="easyui-dialog" closed="true" modal="true" title="路由策略信息"
         style="width:1000px;height:420px;">
        <iframe scrolling="auto" id='iframe1' frameborder="0"
        <%--     src="${path}/configdeal/dealinfo"  --%>
                style="width:100%;height:100%;"></iframe>
    </div>


    <!-- 对话框 -->
    <div id="configdlg" class="easyui-dialog"
         style="width:310px;height:360px;padding:10px 20px" closed="true"
         buttons="#configdlg-buttons">
        <form id="configfm" method="post" novalidate>
            <table>
                <input id="gid" name="gid" type="hidden"></td>
                <input id="province" name="province" type="hidden" value="所有"></td>
                <input id="city" name="city" type="hidden" value="所有"></td>
                <tr>
                    <td align="right">*处理渠道:</td>
                    <td><input id="dlgdealChannel" name="dealChannel" style="width: 150px" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*处理子渠道:</td>
                    <td><input id="dlgdealSubChannel" name="dealSubChannel" style="width: 150px" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*商户号:</td>
                    <td><input id="dlgmerId" name="merId" type="text" style="width: 145px" class="easyui-validatebox"
                               required="true"></td>
                </tr>
                <tr>
                    <td align="right">*商户名称:</td>
                    <td><input id="dlgmerName" name="merName" type="text" style="width: 145px"
                               class="easyui-validatebox" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*策略名称:</td>
                    <td><input id="dlgstrategy" name="strategy" style="width: 150px" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*开户行:</td>
                    <td><input id="dlgcardBankName" name="cardBankName" style="width: 150px" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*卡别:</td>
                    <td><input id="dlgcardType" name="cardType" style="width: 150px" class="easyui-combobox"
                               data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'1',text:'借记卡'},{id:'2',text:'信用卡'}]" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*最小金额:</td>
                    <td><input id="dlgminMoney" name="minMoney" type="text" style="width: 145px"
                               class="easyui-validatebox" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*最大金额:</td>
                    <td><input id="dlgmaxMoney" name="maxMoney" type="text" style="width: 145px"
                               class="easyui-validatebox" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*优先级:</td>
                    <td><input id="dlglevel" name="level" type="text" style="width: 145px" class="easyui-validatebox"
                               required="true"></td>
                </tr>
            </table>
        </form>
    </div>

    <!-- 对话框按钮 -->
    <div id="configdlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="saveConfig()" style="width:60px">保存</a> <a
            href="javascript:void(0)" class="easyui-linkbutton"
            iconCls="icon-cancel" onclick="javascript:$('#configdlg').dialog('close')"
            style="width:60px">取消</a>
    </div>

</div>

</body>
</html>
