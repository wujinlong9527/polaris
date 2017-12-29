<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>库存管理</title>
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
            $("#datagrid").datagrid("options").url = "${path}/goods/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");

        }

        function searchGoods() {
            var inserttime = $("#inserttime").datebox("getValue");
            var finaltime = $("#finaltime").datebox("getValue");
            if(inserttime > finaltime){
                $.messager.alert("提示","开始日期不能大于结束日期！","warning")
                return;
            }
          //  document.getElementById("iframeId").src="${path}/ReportServer?reportlet=/goods/1.cpt"; //调用finereport

            $("#datagrid").datagrid("options").url = "${path}/goods/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");

        }

        function onReset() {
            $('#inserttime').datebox('setValue', formatterDate(new Date()));
            $('#finaltime').datebox('setValue', formatterDate(new Date()));
            $("#goodsid").textbox('setValue', "");
            $("#datagrid").datagrid("options").url = "${path}/goods/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 信息列表 -->
    <table id="datagrid" title="出入库明细查询" class="easyui-datagrid" fit="true" toolbar="#toolbar" pagination="true"
           fitColumns="false"  singleSelect="true" rownumbers="true" border="false" nowrap="true" width="100%">

        <thead>
        <tr>
            <th field="id" width="130" align="center" hidden="true">id</th>
            <th field="goodsid" width="130" align="center">商品编号</th>
            <th field="groupid" width="10" align="center" hidden="true">groupid</th>
            <th field="groupname" width="260" align="center">所属经销商</th>
            <th field="goodsname" width="130"  align="center">商品名称</th>
            <th field="price" width="100" align="center">单价（元）</th>
            <th field="count" width="100"  align="center">商品数量</th>
            <th field="inserttime" width="140" align="center">新增日期</th>
            <th field="gtype" width="140" align="center" hidden="true">gtype</th>
            <th field="gtypename" width="140" align="center" >商品类别</th>
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
                <label>商品编号:</label> <input id="goodsid" name="goodsid" class="easyui-textbox" style="width: 160px">

            </div>

            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchGoods();" >查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();" >重置</a>
            </div>
        </form>
    </div>
<%--
    <iframe id="iframeId" src="" height="410" width="100%"  scrolling="yes" frameborder="0"></iframe>
--%>

</div>

</body>

</html>
