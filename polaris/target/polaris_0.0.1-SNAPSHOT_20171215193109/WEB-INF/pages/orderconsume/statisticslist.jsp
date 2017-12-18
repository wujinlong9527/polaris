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
            var strDate = date.getFullYear() + "-";
            strDate += date.getMonth() + 1 + "-";
            strDate += date.getDate() + " ";
            strDate += date.getHours() + ":";
            strDate += date.getMinutes() + ":";
            strDate += date.getSeconds();
            return strDate;
        };

        window.onload = function () {
            $('#insertTime').datetimebox('setValue', formatterDate(new Date()));
            $('#finalTime').datetimebox('setValue', formatterDate(new Date()));
            $("#datagrid").datagrid("options").url = "${path}/orderconsume/consumeStatistics?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
            $('#sourceSubchannel').combobox({
                editable: true, //编辑状态
                cache: false,
                valueField: 'id',
                textField: 'text'
            });

            $('#dealSubChannel').combobox({
                editable: true, //编辑状态
                cache: false,
                valueField: 'dealSubChannel',
                textField: 'dealSubChannel'
            });
            $.ajax({
                type: "POST",
                url: "${path}/orderconsume/selectDealSubChannel",
                cache: false,
                dataType: "json",
                success: function (data) {
                    $("#dealSubChannel").combobox("loadData", data.rows);
                    //$("#dlgmsg").combobox("loadData", data.rows);
                }
            });
        }

        function searchOrder() {
            var px = $("input[name='px']:checked").map(function () {
                return $(this).val();

            }).get().join(',');
            $("#types").val(px);
            if ($("input[id='ckdealChannel']:checked").val() == 'dealSubChannel') {
                $("#datagrid").datagrid('showColumn', 'dealSubChannel');
            }
            else {
                $("#datagrid").datagrid('hideColumn', 'dealSubChannel');
            }
            if ($("input[id='ckcardBankName']:checked").val() == 'cardBankName') {
                $("#datagrid").datagrid('showColumn', 'cardBankName');
            }
            else {
                $("#datagrid").datagrid('hideColumn', 'cardBankName');
            }
            if ($("input[id='cksourceSubchannel']:checked").val() == 'sourceSubchannel') {
                $("#datagrid").datagrid('showColumn', 'sourceSubchannel');
            }
            else {
                $("#datagrid").datagrid('hideColumn', 'sourceSubchannel');
            }

            if(null == $("#sourceSubchannel").combobox("getValue")) {
                $("#sourceSubchannel").combobox("setValue", $("#sourceSubchannel").combobox("getText"));
            }
            $("#dealSubChannel").combobox("setValue", $("#dealSubChannel").combobox("getText"));
            $("#datagrid").datagrid("options").url = "${path}/orderconsume/consumeStatistics?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        function onReset() {
            $('#insertTime').datetimebox('setValue', formatterDate(new Date()));
            $('#finalTime').datetimebox('setValue', formatterDate(new Date()));
            $("#sourceSubchannel").combobox('setValue', "");
            $("#dealSubChannel").textbox('setValue', "");
            $("#datagrid").datagrid("options").url = "${path}/orderconsume/consumeStatistics?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        function formatdata(val, row) {
            return '<a onclick="editRow(\'' + row.cardBankName + '\',\'' + row.dealChannel + '\',\'' + row.sourceSubchannel + '\')" href="javascript:void(0)">查看</a>';
        }

        function editRow(cardBankName, dealChannel, sourceSubChannel) {
            if (cardBankName == 'undefined') {
                cardBankName = "";
            }
            if (dealChannel == 'undefined') {
                dealChannel = "";
            }
            if (sourceSubChannel == 'undefined') {
                sourceSubChannel = "";
            }

            $('#iframe1')[0].src = '${path}/orderconsume/returnmsg?dealChannel=' + dealChannel
                    + '&cardBankName=' + cardBankName + '&sourceSubchannel=' + sourceSubChannel + '&insertTime='
                    + $("#insertTime").datetimebox('getValue') + '&finalTime=' + $("#finalTime").datetimebox('getValue');
            $('#openRoleDiv').dialog('open');

        }

    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 消费信息列表 -->
    <table id="datagrid" title="统计查询" class="easyui-datagrid" fit="true"
    <%--url="${path}/orderconsume/datagrid" --%>
           toolbar="#toolbar" pagination="false"
           fitColumns="false" singleSelect="true" rownumbers="true"
           border="false" nowrap="true">
        <thead>
        <tr>
            <th field="sourceSubchannel" width="100" hidden="true">来源子渠道</th>
            <th field="dealSubChannel" width="100" hidden="true">处理子渠道</th>
            <th field="cardBankName" width="150" hidden="true">银行</th>
            <th field="cnt" width="100">总笔数</th>
            <th field="sucCnt" width="100">成功笔数</th>
            <th field="sumMoney" width="100" align="right">成功金额</th>
            <th field="retNum" width="100">成功率</th>
            <th field="sumCharge" width="100">手续费</th>
            <th field="opt" width="100" formatter="formatdata">操作</th>
        </tr>
        </thead>
    </table>

    <!-- 按钮 -->

    <div id="toolbar" class="easyui-layout"
         style="width:100%;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <form id="fmorder" name="fmorder" method="post">
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <label>开始日期:</label> <input id="insertTime" name="insertTime" class="easyui-datetimebox"
                                            style="width: 100px">
                <label>结束日期:</label> <input id="finalTime" name="finalTime" class="easyui-datetimebox"
                                            style="width: 100px">
                <label>来源子渠道:</label>
                <input id="sourceSubchannel" name="sourceSubchannel" style="width: 155px" class="easyui-combobox" data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'harbor',text:'借款2.0(harbor)'},{id:'harbor_sms',text:'借款2.0(harbor_sms)'},{id:'loan',text:'借款1.0(loan)'},
					{id:'loan_force',text:'借款1.0强扣(loan_force)'},{id:'storm',text:'理财2.0(storm)'},{id:'deduct',text:'理财1.0(deduct)'},{id:'taurus',text:'闪电分期(taurus)'}]">
                <label>处理子渠道:</label> <input id="dealSubChannel" name="dealSubChannel" class="easyui-textbox"
                                            style="width: 120px">
                <input id="types" name="types" type="hidden"></td>
                <label>查询方式:</label> <input type="checkbox" id="ckdealChannel" name="px" value="dealSubChannel"/>按渠道
                <input type="checkbox" id="ckcardBankName" name="px" value="cardBankName"/>按银行
                <input type="checkbox" id="cksourceSubchannel" name="px" value="sourceSubchannel"/>按来源
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchOrder();">查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
            </div>

        </form>

    </div>

    <div id="openRoleDiv" class="easyui-dialog" closed="true" modal="true" title="错误原因"
         style="width:500px;height:420px;">
        <iframe scrolling="auto" id='iframe1' frameborder="0"
                style="width:100%;height:100%;"></iframe>
    </div>

</div>

</body>
</html>
