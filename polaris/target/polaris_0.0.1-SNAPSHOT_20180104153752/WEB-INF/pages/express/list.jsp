<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>物流管理</title>
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
            $("#datagrid").datagrid("options").url = "${path}/express/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");

        }

        function searchGoods() {
            var inserttime = $("#inserttime").datebox("getValue");
            var finaltime = $("#finaltime").datebox("getValue");
            if(inserttime > finaltime){
                $.messager.alert("提示","开始日期不能大于结束日期！","warning")
                return;
            }
            $("#datagrid").datagrid("options").url = "${path}/express/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");

        }

        function onReset() {
            $('#inserttime').datebox('setValue', formatterDate(new Date()));
            $('#finaltime').datebox('setValue', formatterDate(new Date()));
            $("#expressid").textbox('setValue', "");
            $("#datagrid").datagrid("options").url = "${path}/express/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        //确认订单
        function finalexp(val, row) {
            if(row.endtime=='' || row.endtime==null ){
                return '<a class="editcls" href="javascript:void(0)" onclick="editRow(\'' + row.id + ',' + row.orderid + ',' + row.goodsid + '\')" >派送完成确认</a>';
            }
        }

        function editRow(id) {
            $.messager.confirm("提示", "如果已经确认客户收货，请确认？", function (r) {
                if (r) {
                    $.post('${path}/express/confirmFinalExp',
                    {tj: id},
                    function (result) {
                        var result = eval('(' + result + ')');
                        if (result.success) {
                            $.messager.alert('消息提示', result.msg,"info");
                            $("#datagrid").datagrid("options").url = "${path}/express/datagrid?" + $("#fmorder").serialize();
                            $("#datagrid").datagrid("load");
                        } else {
                            $.messager.alert('错误提示',  result.msg,"error");
                        }
                    });
                }
            });
        }
    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 信息列表 -->
    <table id="datagrid" title="物流查询" class="easyui-datagrid" fit="true" toolbar="#toolbar" pagination="true"
           fitColumns="false"  singleSelect="true" rownumbers="true" border="false" nowrap="true" width="100%">

        <thead>
        <tr>
            <th field="id" width="130" align="center" hidden="true">id</th>
            <th field="expressid" width="130" align="center">运单号</th>
            <th field="orderid" width="130" align="center">订单号</th>
            <th field="goodsid" width="130" align="center">商品编号</th>
            <th field="goodsname" width="130"  align="center">商品名称</th>
            <th field="exptime" width="140" align="center">配送开始时间</th>
            <th field="endtime" width="140" align="center">配送完成时间</th>
            <th field="expzt" width="80" align="center" >配送状态</th>
            <th field="expname" width="100" align="center" >配送员姓名</th>
            <th field="exphone" width="100" align="center" >配送员电话</th>
            <th field="expaddress" width="240" align="center" >配送地址</th>
            <th field="opt" width="100" align="center" formatter="finalexp">操作</th>
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
                &nbsp;
                <label>运单号:</label> <input id="expressid" name="expressid" class="easyui-textbox" style="width: 160px">

            </div>

            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchGoods();" >查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();" >重置</a>

                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-remove" plain="true" onclick="onReset();" >分派快递员</a>
            </div>
        </form>

    </div>

</div>

</body>
</html>
