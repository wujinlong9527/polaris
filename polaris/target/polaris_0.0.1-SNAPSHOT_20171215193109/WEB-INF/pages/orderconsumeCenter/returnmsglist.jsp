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
            $("#datagrid").datagrid("options").url
                    = "${path}/orderconsume/msgdatagrid?dealChannel=" + $('#dealChannel').val() + "&cardBankName=" + $('#cardBankName').val()
                    + "&sourceSubchannel=" + $('#sourceSubchannel').val() + "&insertTime=" + $('#insertTime').val()
                    + "&finalTime=" + $('#finalTime').val();
            $("#datagrid").datagrid("load");
        }

    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 策略信息列表 -->
    <table id="datagrid" class="easyui-datagrid" fit="true"
           url="" toolbar="#toolbar" pagination="false"
           fitColumns="false" singleSelect="true" rownumbers="true"
           border="false" nowrap="true">
        <thead>
        <tr>
            <th field="returnMsg" width="300">错误信息</th>
            <th field="cnt" width="100">笔数</th>
        </tr>
        </thead>
    </table>


    <div id="toolbar" class="easyui-layout"
         style="width:100%;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <span style="color:green; float: left;font-size:14px"><span
                        style="color:black;"></span>${orderconsume.insertTime}&nbsp&nbsp
                    <span
                            style="color:black;">至：</span>
                        ${orderconsume.finalTime}&nbsp&nbsp</span>

        <input id="cardBankName" name="cardBankName" type="hidden" value="${orderconsume.cardBankName}">
        <input id="sourceSubchannel" name="sourceSubchannel" type="hidden" value="${orderconsume.sourceSubchannel}">
        <input id="dealChannel" name="dealChannel" type="hidden" value="${orderconsume.dealChannel}">
        <input id="insertTime" name="insertTime" type="hidden" value="${orderconsume.insertTime}">
        <input id="finalTime" name="finalTime" type="hidden" value="${orderconsume.finalTime}">

    </div>


</div>

</body>
</html>
