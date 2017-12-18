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
            end = new Date();
            $('#beginTime').datebox('setValue', formatterDate(new Date(end.valueOf() - 5 * 24 * 60 * 60 * 1000)));
            $('#endTime').datebox('setValue', formatterDate(new Date()));
            return;
            $("#datagrid").datagrid("options").url = "${path}/dotask/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }


        function searchOrder() {

            var name = document.getElementById("name").value;
            var phone = document.getElementById("phone").value;
            var cardNo = document.getElementById("cardNo").value;
            var payOrderid = document.getElementById("payOrderid").value;
            if((name== null || name == '')&&(phone == null || phone == '')&&(cardNo == null || cardNo == '')&&(payOrderid == null || payOrderid == ''))
            {
                alert("姓名、手机号、银行卡号、银联流水号,请至少输入一项进行查询!");
                return;
            }

            $("#datagrid").datagrid("options").url = "${path}/dotask/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        function onReset() {
            $('#beginTime').datebox('setValue', formatterDate(new Date()));
            $('#endTime').datebox('setValue', formatterDate(new Date()));
            $("#name").textbox('setValue', "");
            $("#cardNo").textbox('setValue', "");
            $("#cardBankName").textbox('setValue', "");
            $("#phone").textbox('setValue', "");
            $("#payMoney").textbox('setValue', "");
            $("#dealChannel").textbox('setValue', "");
            $("#payOrderid").textbox('setValue', "");
            $("#sourceSubChannel").textbox('setValue', "");

            return;

            $("#datagrid").datagrid("options").url = "${path}/dotask/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        function dotask() {
            $.messager.confirm("处理", "是否将查询次数大于5的更新为当前时间！", function (r) {
                if (r) {
                    $.post('${path}/dotask/updateDoTask',
                            {sendTimes: 5},
                            function (result) {
                                var result = eval('(' + result + ')');
                                if (result.success) {
                                    $.messager.alert('消息提示', "处理完成");
                                    $("#datagrid").datagrid("options").url = "${path}/dotask/datagrid?" + $("#fmorder").serialize();
                                    $("#datagrid").datagrid("load");
                                } else {
                                    $.messager.alert('错误提示', "处理失败");
                                }
                            });
                }
            });
        }

        //
        function formatCardType(val, row) {
            if (val == 1) {
                return '<span>' + '借记卡' + '</span>';
            } else if (val == 2) {
                return '<span>' + '信用卡' + '</span>';
            }
        }

        function formatIsGet(val, row) {
            if (val == 0) {
                return '<span>' + '否' + '</span>';
            } else if (val == 1) {
                return '<span>' + '是' + '</span>';
            }
        }

        function formatIsSuc(val, row) {
            if (val == 0) {
                return '<span>' + '处理中' + '</span>';
            } else if (val == 1) {
                return '<span>' + '成功' + '</span>';
            } else if (val == -1) {
                return '<span>' + '失败' + '</span>';
            }
        }
        function formatIschannel(val, row) {
            if (val == 'deduct') {
                return '<span>' + '理财1.0(deduct)' + '</span>';
            } else if (val =='harbor') {
                return '<span>' + '借款2.0(harbor)' + '</span>';
            } else if (val =='loan') {
                return '<span>' + '借款1.0(loan)' + '</span>';
            }
            else if (val =='loan_force') {
                return '<span>' + '借款强扣1.0(loan_force)' + '</span>';
            }
            else if (val =='storm') {
                return '<span>' + '理财2.0(storm)' + '</span>';
            }
            else if (val =='taurus') {
                return '<span>' + '闪电分期(taurus)' + '</span>';
            }
            else {
                return '<span>' + val + '</span>';
            }
        }

    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 任务信息列表 -->
    <table id="datagrid" title="任务查询" class="easyui-datagrid" fit="true"
    <%--url="${path}/dotask/datagrid" --%>
           toolbar="#toolbar" pagination="true"
           fitColumns="false" singleSelect="true" rownumbers="true"
           border="false" nowrap="true">
        <thead frozen="true">
        <tr>
            <th field="name" width="80">姓名</th>
        </tr>
        </thead>
        <thead>
        <tr>
            <th field="payOrderid" width="180">银联流水号</th>
            <th field="idCard" width="150">身份证号</th>
            <th field="phone" width="120">手机号</th>
            <th field="payMoney" width="100" align="right">金额(元)</th>
            <th field="orderAction" width="80">类型</th>
            <th field="sourceSubChannel" width="100" formatter="formatIschannel">来源子渠道</th>
            <!--
            <th field="dealChannel" width="100">处理渠道</th>
            -->
            <th field="cardNo" width="150">银行卡号</th>
            <th field="cardType" width="80" formatter="formatCardType">银行卡类型</th>
            <th field="cardBankName" width="150">银行</th>
            <th field="isGet" width="80" formatter="formatIsGet">是否取走</th>
            <th field="sucFlag" width="80" formatter="formatIsSuc">成功标识</th>
            <th field="sendTimes" width="80" align="right">查询次数</th>
            <th field="nextSendTime" width="140">下次处理时间</th>
            <th field="insertTime" width="140">创建时间</th>
            <th field="expand1" width="120">expand1</th>
            <th field="expand2" width="120">expand2</th>
            <th field="expand3" width="120">expand3</th>
        </tr>
        </thead>
    </table>

    <!-- 按钮 -->

    <div id="toolbar" class="easyui-layout"
         style="width:100%;height:80px;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <form id="fmorder" name="fmorder" method="post">
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <label>开始日期:</label> <input id="beginTime" name="beginTime" class="easyui-datebox" style="width: 100px">
                <label>结束日期:</label> <input id="endTime" name="endTime" class="easyui-datebox" style="width: 100px">
                <label>&nbsp&nbsp&nbsp&nbsp姓名:</label> <input id="name" name="name" class="easyui-textbox"
                                                              style="width: 120px">
                <label>&nbsp&nbsp手机号:</label> <input id="phone" name="phone" class="easyui-textbox"
                                                     style="width: 100px">

                <!--
                <label>&nbsp&nbsp&nbsp&nbsp开户行:</label> <input id="cardBankName" name="cardBankName"
                                                               class="easyui-textbox" style="width: 120px">
                 -->
            </div>
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <label>&nbsp&nbsp银行卡号:</label> <input id="cardNo" name="cardNo" class="easyui-textbox"
                                                      style="width: 150px">
                <!--
                <label>消费金额:</label> <input id="payMoney" name="payMoney" class="easyui-textbox" style="width: 100px">
                <label>处理渠道:</label> <input id="dealChannel" name="dealChannel" class="easyui-textbox"
                                            style="width: 120px">
                <label>来源子渠道:</label> <input id="sourceSubChannel" name="sourceSubChannel" class="easyui-textbox"
                                             style="width: 120px">
                -->
                <label>银联流水号:</label> <input id="payOrderid" name="payOrderid" class="easyui-textbox"
                                             style="width: 150px">
                <!--
                <label>来源子渠道:</label>
                <input id="sourceSubChannel" name="sourceSubChannel" style="width: 155px" class="easyui-combobox" data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'harbor',text:'借款2.0(harbor)'},{id:'loan',text:'借款1.0(loan)'},
					{id:'loan_force',text:'借款1.0强扣(loan_force)'},{id:'storm',text:'理财2.0(storm)'},{id:'deduct',text:'理财1.0(deduct)'},{id:'taurus',text:'闪电分期(taurus)'}]">
                -->
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchOrder();">查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
                <!--
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="dotask();">处理</a>
                -->

            </div>
        </form>

    </div>

</div>

</body>
</html>
