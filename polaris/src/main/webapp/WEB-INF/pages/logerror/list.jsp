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
        }


        function searchOrder() {
            $("#datagrid").datagrid("options").url = "${path}/logerror/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        function onReset() {
            $("#orderId").textbox('setValue', "");
            $("#errorName").textbox('setValue', "");
            $("#datagrid").datagrid("options").url = "${path}/logerror/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 任务信息列表 -->
    <table id="datagrid" title="日志查询" class="easyui-datagrid" fit="true"
           url="${path}/logerror/datagrid"
           toolbar="#toolbar" pagination="true"
           fitColumns="false" singleSelect="true" rownumbers="true"
           border="false" nowrap="false">
        <thead>
        <tr>
            <th field="insertTime" width="150">插入时间</th>
            <th field="orderId" width="80">操作人</th>
            <th field="errorName" width="150">操作类型</th>
            <th field="errorMsg" width="750">说明</th>
        </tr>
        </thead>
    </table>

    <!-- 按钮 -->

    <div id="toolbar" class="easyui-layout"
         style="width:100%;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <form id="fmorder" name="fmorder" method="post">
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <label>操作人姓名:</label> <input id="orderId" name="orderId" class="easyui-textbox" style="width: 100px">
                <label>类型:</label> <input id="errorName" name="errorName" class="easyui-textbox" style="width: 100px">
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchOrder();">查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
            </div>
        </form>
    </div>

</div>

</body>
</html>
