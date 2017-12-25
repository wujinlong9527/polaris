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

        formatterDate = function (date) {
            var day = date.getDate() > 9 ? date.getDate() : "0" + date.getDate();
            var month = (date.getMonth() + 1) > 9 ? (date.getMonth() + 1) : "0"
            + (date.getMonth() + 1);
            return date.getFullYear() + '-' + month + '-' + day;
        };

        window.onload = function () {
            $('#inserttime').datebox('setValue', formatterDate(new Date()));
            $('#finaltime').datebox('setValue', formatterDate(new Date()));
            $("#datagrid").datagrid("options").url = "${path}/order/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");

        }

        function searchOrder() {
            var inserttime = $("#inserttime").datebox("getValue");
            var finaltime = $("#finaltime").datebox("getValue");
            if(inserttime > finaltime){
                $.messager.alert("提示","开始日期不能大于结束日期！","warning")
                return;
            }
            $("#datagrid").datagrid("options").url = "${path}/order/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        function onReset() {
            $('#inserttime').datebox('setValue', formatterDate(new Date()));
            $('#finaltime').datebox('setValue', formatterDate(new Date()));
            $("#ddzt").combobox('setValue', "");
            $("#orderid").textbox('setValue', "");
            $("#datagrid").datagrid("options").url = "${path}/order/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        function formatIsSuc(val, row) {
            if (val == '01') {
                return '<span>' + '已完成' + '</span>';
            } else if (val == '02') {
                return '<span>' + '处理中' + '</span>';
            } else if (val == '03') {
                return '<span>' + '未处理' + '</span>';
            }
        }

        function formatjsfs(val, row) {
            if (val == '01') {
                return '<span>' + '支付宝' + '</span>';
            } else if (val == '02') {
                return '<span>' + '微信支付' + '</span>';
            } else if (val == '03') {
                return '<span>' + '手机银行支付' + '</span>';
            } else if (val == '04') {
                return '<span>' + '现金支付' + '</span>';
            } else if (val == '05') {
                return '<span>' + '银行转账' + '</span>';
            }
        }

        function formatjszt(val, row) {
            if (val == '01') {
                return '<span>' + '已支付' + '</span>';
            } else if (val == '02') {
                return '<span>' + '待支付' + '</span>';
            } else if (val == '03') {
                return '<span>' + '月结' + '</span>';
            } else if (val == '04') {
                return '<span>' + '半月结' + '</span>';
            }
        }

    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 信息列表 -->
    <table id="datagrid" title="订单查询" class="easyui-datagrid" fit="true" toolbar="#toolbar" pagination="true"
           fitColumns="false"  singleSelect="true" rownumbers="true" border="false" nowrap="true" width="100%">

        <thead>
        <tr>
            <th field="id" width="130" align="center" hidden="true">id</th>
            <th field="orderid" width="130" align="center">订单编号</th>
            <th field="groupid" width="130" align="center">经销商编号</th>
            <th field="account" width="110" align="center">操作员</th>
            <th field="username" width="110" align="center">客户姓名</th>
            <th field="goods" width="120" align="center">商品</th>
            <th field="price" width="80" align="center">单价（元）</th>
            <th field="count" width="80"  align="center">商品数量</th>
            <th field="amount" width="80"  align="center">订单总额</th>
            <th field="ddzt" width="80" formatter="formatIsSuc" align="center">订单状态</th>
            <th field="inserttime" width="130" align="center">下单时间</th>
            <th field="endtime" width="130" align="center">订单完成时间</th>
            <th field="phone" width="90" align="center">手机号码</th>
            <th field="tel" width="110" align="center">联系电话</th>
            <th field="jsfs" width="80" formatter="formatjsfs" align="center">结算方式</th>
            <th field="jszt" width="80" formatter="formatjszt" align="center">结算状态</th>
            <th field="expressname" width="80" align="center">派送员</th>
            <th field="expressid" width="80" align="center" >派送员编号</th>
            <th field="readdress" width="400" align="center">收货地址</th>
        </tr>
        </thead>
    </table>

    <!-- 按钮 -->

    <div id="toolbar" class="easyui-layout"
         style="width:100%;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <form id="fmorder" name="fmorder" method="post">
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">

                <label>开始日期:</label> <input id="inserttime" name="inserttime" class="easyui-datebox" data-options="editable:false" style="width: 100px">
                &nbsp;
                <label>结束日期:</label> <input id="finaltime" name="finaltime" class="easyui-datebox" data-options="editable:false" style="width: 100px">
                &nbsp;
                <label>订单状态:</label> <input id="ddzt" name="ddzt" class="easyui-combobox" style="width: 80px"
                   data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'',text:'全部'},{id:'01',text:'已完成'},{id:'02',text:'处理中'},{id:'03',text:'未处理'}]">
                &nbsp;
                <label>订单编号:</label> <input id="orderid" name="orderid" class="easyui-textbox" style="width: 160px">


            </div>
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-left: 6px" align="left">
               <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchOrder();" >查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
            </div>
        </form>
    </div>

</div>

</body>
</html>
