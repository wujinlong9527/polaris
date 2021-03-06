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
            document.getElementById("iframeId").src="${path}/ReportServer?reportlet=/goods/ckdetail.cpt"; //调用finereport
        }

        function searchGoods() {
            var goodsid = $("#goodsid").textbox('getValue');
            var orderid = $("#orderid").textbox('getValue');
            var inserttime = $("#inserttime").datebox("getValue");
            var finaltime = $("#finaltime").datebox("getValue");
            if(inserttime > finaltime){
                $.messager.alert("提示","开始日期不能大于结束日期！","warning")
                return;
            }
            finaltime = finaltime+ " 23:59:59";
            document.getElementById("iframeId").src="${path}/ReportServer?reportlet=/goods/ckdetail.cpt&goodsid="
                    +goodsid+"&orderid="+orderid+"&inserttime="+inserttime+"&finaltime="+finaltime; //调用finereport
        }

        function onReset() {
            $('#inserttime').datebox('setValue', formatterDate(new Date()));
            $('#finaltime').datebox('setValue', formatterDate(new Date()));
            $("#goodsid").textbox('setValue', "");
            $("#orderid").textbox('setValue', "");
            document.getElementById("iframeId").src="${path}/ReportServer?reportlet=/goods/ckdetail.cpt"; //调用finereport
        }

    </script>

</head>
<body class="easyui-layout" fit="true">
    <!-- 按钮 -->
    <div id="toolbar" class="easyui-layout"
         style="width:100%;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <form id="fmorder" name="fmorder" method="post">
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">

                <label style="font-size: 11px">开始日期:</label> <input id="inserttime" name="inserttime" class="easyui-datebox" data-options="editable:false" style="width: 100px">
                &nbsp;
                <label style="font-size: 11px">结束日期:</label> <input id="finaltime" name="finaltime" class="easyui-datebox" data-options="editable:false" style="width: 100px">
                &nbsp;
                &nbsp;
                <label style="font-size: 11px">商品编号:</label> <input id="goodsid" name="goodsid" class="easyui-textbox" style="width: 160px">
                &nbsp;
                &nbsp;
                <label style="font-size: 11px">订单编号:</label> <input id="orderid" name="orderid" class="easyui-textbox" style="width: 160px">

            </div>

            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchGoods();" >查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();" >重置</a>
            </div>
        </form>
    </div>
    <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <iframe id="iframeId" src="" height="410" width="100%"  scrolling="yes" frameborder="0"></iframe>
    </div>
</body>

</html>
