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
            $('#insertTime').datebox('setValue', formatterDate(new Date()));
            $('#finalTime').datebox('setValue', formatterDate(new Date()));

            $("#datagrid").datagrid("options").url = "${path}/orderfreeze/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");

//            $('#sourceSubChannel').combobox({
//                editable: false, //不可编辑状态
//                cache: false,
//                panelHeight: 'auto',//自动高度适合
//                valueField: 'sourceSubChannel',
//                textField: 'sourceSubChannel'
//            });

            <%--$.ajax({--%>
            <%--type: "POST",--%>
            <%--url: "${path}/orderconsume/getConfigSource?orderAction=" + "预授权",--%>
            <%--cache: false,--%>
            <%--dataType: "json",--%>
            <%--success: function (data) {--%>
            <%--$("#sourceSubChannel").combobox("loadData", data.rows);--%>
            <%--}--%>
            <%--});--%>

            $('#datagrid').datagrid({
                view: detailview,
                detailFormatter: function (rowIndex, rowData) {
                    return '<table>'
                            + '<tr>'
                            + '<td style="border:0;padding:3px"><b>返回数据：</b></td>'
                            + '</tr>'
                            + '<tr>'
                            + '<td style="border:0;padding:3px"><xmp>' + rowData.bankReturnMsg + '</xmp></td>'
                            + '</tr>'
                            + '</table>';
                }
            });

            //页面加载时即加载所有渠道，用于查询条件中渠道下拉
            getDealchannel();
            //页面加载时即加载总金额、成功率、单笔成本
            getPageDisplay();

            $('#sourceSubChannel').combobox({
                editable: true, //编辑状态
                cache: false,
                valueField: 'id',
                textField: 'text'
            });
        }


        function searchOrder() {
            $("#dealChannel").combobox("setValue", $("#dealChannel").combobox("getText"));
            if(null == $("#sourceSubChannel").combobox("getValue")) {
                $("#sourceSubChannel").combobox("setValue", $("#sourceSubChannel").combobox("getText"));
            }
            $("#datagrid").datagrid("options").url = "${path}/orderfreeze/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
            //查询结果出来后加载总金额、成功率、单笔成本
            getPageDisplay();
        }

        function onReset() {
            $('#insertTime').datebox('setValue', formatterDate(new Date()));
            $('#finalTime').datebox('setValue', formatterDate(new Date()));
            $("#fcOrderid").textbox('setValue', "");
            $("#fullName").textbox('setValue', "");
            $("#cardNo").textbox('setValue', "");
            $("#cardBankName").textbox('setValue', "");
            $("#phone").textbox('setValue', "");
            $("#payMoney").textbox('setValue', "");
            $("#dealChannel").combobox('setValue', "");
            $("#payOrderid").textbox('setValue', "");
            $("#orifcOrderId").textbox('setValue', "");
            $("#sucFlag").combobox("setValue", "");
            $("#orderAction").combobox("setValue", "");
            $("#sourceSubChannel").combobox("setValue", "");
            $("#payMoneyBottom").textbox('setValue','');
            $("#payMoneyTop").textbox('setValue','');
            $("#datagrid").datagrid("options").url = "${path}/orderfreeze/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");

            //查询结果出来后加载总金额、成功率、单笔成本
            getPageDisplay();
        }

        //
        function formatCardType(val, row) {
            if (val == 1) {
                return '<span>' + '借记卡' + '</span>';
            } else if (val == 2) {
                return '<span>' + '信用卡' + '</span>';
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
            } else if (val =='harbor_sms') {
                return '<span>' + '借款2.0(harbor_sms)' + '</span>';
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

        //获取所有渠道，给渠道combobox赋值
        function getDealchannel() {
            $('#dealChannel').combobox({
                editable: true, //编辑状态
                cache: false,
                valueField: 'dealChannel',
                textField: 'dealChannel',
                value:'全部'//默认显示全部选项
            });
            $.ajax({
                type: "POST",
                url: "${path}/orderfreeze/getDealChannel",
                cache: false,
                async: true,
                dataType: "json",
                success: function (data) {
                    data.rows.unshift({"dealChannel":"全部"});
                    $("#dealChannel").combobox("loadData", data.rows);
                }
            })
        }

        //加载总金额、成功率、单笔成本
        function getPageDisplay() {
            document.getElementById('totalAmount').innerHTML = "总金额（元）:0";
            document.getElementById('successRate').innerHTML = "成功率:";
            document.getElementById('singleCost').innerHTML = "单笔成本（元）:";
            $.ajax({
                type: "POST",
                url: "${path}/orderfreeze/getPageDisplay",
                data:$('#fmorder').serialize(),
                cache: false,
                async: true,
                dataType: "json",
                success: function (data) {
                    if(null != data.totalAmount) {
                        document.getElementById('totalAmount').innerHTML = "总金额（元）:"+data.totalAmount;
                    }
                    if(null != data.successRate) {
                        document.getElementById('successRate').innerHTML = " 成功率:"+data.successRate;
                    }
                    if(null != data.singleCost) {
                        document.getElementById('singleCost').innerHTML = " 单笔成本（元）:"+data.singleCost;
                    }
                }
            })
        }
    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 任务信息列表 -->
    <table id="datagrid" title="预授权查询" class="easyui-datagrid" fit="true"
    <%--url="${path}/orderfreeze/datagrid" --%>
           toolbar="#toolbar" pagination="true"
           fitColumns="false" singleSelect="true" rownumbers="true"
           border="false" nowrap="true">
        <thead frozen="true">
        <tr>
            <th field="fullName" width="80">姓名</th>
        </tr>
        </thead>
        <thead>
        <tr>
            <th field="fcOrderid" width="150">fcOrderid</th>
            <th field="payOrderid" width="130">银联流水号</th>
            <th field="orifcOrderId" width="130">oriFcOrderId</th>
            <th field="idCard" width="120">身份证号</th>
            <th field="phone" width="100">手机号</th>
            <th field="payMoney" width="100" align="right">金额(元)</th>
            <th field="insertTime" width="140">创建时间</th>
            <th field="finalTime" width="140">结束时间</th>
            <th field="sucFlag" width="60" formatter="formatIsSuc">成功标识</th>
            <th field="orderAction" width="80">类型</th>
            <th field="sourceSubChannel" width="80" formatter="formatIschannel">来源子渠道</th>
            <th field="dealChannel" width="80">处理渠道</th>
            <th field="dealSubChannel" width="100">处理子渠道</th>
            <th field="cardNo" width="150">银行卡号</th>
            <th field="cardType" width="80" formatter="formatCardType">银行卡类型</th>
            <th field="cardBankName" width="150">银行</th>
            <th field="code" width="100">code</th>
            <th field="returnMsg" width="300">returnMsg</th>
            <th field="err_code" width="100">错误码</th>
            <th field="err_msg" width="300">错误提示</th>
            <th field="remark1" width="150">remark1</th>
            <th field="remark3" width="150">remark3</th>
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
                <label>结束日期:</label> <input id="finalTime" name="finalTime" class="easyui-datetimebox" style="width: 100px">
                <label>fcOrderId:</label> <input id="fcOrderid" name="fcOrderid" class="easyui-textbox"
                                                 style="width: 150px">
                <label>姓名:</label> <input id="fullName" name="fullName" class="easyui-textbox" style="width: 100px">
                <label>银行卡号:</label> <input id="cardNo" name="cardNo" class="easyui-textbox" style="width: 150px">
                <label>开户行:</label> <input id="cardBankName" name="cardBankName" class="easyui-textbox"
                                                     style="width: 100px">
            </div>
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <label>手机号:</label> <input id="phone" name="phone" class="easyui-textbox" style="width: 100px">
                <label>消费金额:</label> <input id="payMoney" name="payMoney" class="easyui-textbox" style="width: 100px">
                <label>处理渠道:</label> <input id="dealChannel" name="dealChannel" class="easyui-textbox" style="width: 120px">
                <label>银联流水号:</label> <input id="payOrderid" name="payOrderid" class="easyui-textbox"
                                             style="width: 100px">
                <label>orifcOrderId:</label> <input id="orifcOrderId" name="orifcOrderId" class="easyui-textbox"
                                             style="width: 100px">
                <label>业务类型:</label> <input id="orderAction" name="orderAction" style="width: 100px"
                                            class="easyui-combobox"
                                            data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'',text:'不限'},{id:'预授权',text:'预授权'},{id:'预授权完成',text:'预授权完成'}
					,{id:'预授权撤销',text:'预授权撤销'},{id:'预授权完成撤销',text:'预授权完成撤销'}]">
            </div>
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <label>成功标识:</label> <input id="sucFlag" name="sucFlag" class="easyui-combobox" style="width: 80px"
                                            data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'',text:'全部'},{id:'1',text:'成功'},{id:'0',text:'处理中'},{id:'-1',text:'失败'}]">

                <label>来源子渠道:</label>
                <input id="sourceSubChannel" name="sourceSubChannel" style="width: 155px" class="easyui-combobox" data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'',text:'全部'},{id:'harbor',text:'借款2.0(harbor)'},{id:'harbor_sms',text:'借款2.0(harbor_sms)'},{id:'loan',text:'借款1.0(loan)'},
					{id:'loan_force',text:'借款1.0强扣(loan_force)'},{id:'storm',text:'理财2.0(storm)'},{id:'deduct',text:'理财1.0(deduct)'},{id:'taurus',text:'闪电分期(taurus)'}]">
                <label>金额区间（元）:</label> <input id="payMoneyBottom" name="payMoneyBottom" class="easyui-textbox" style="width: 100px">
                <label>-</label> <input id="payMoneyTop" name="payMoneyTop" class="easyui-textbox" style="width: 100px">
                <c:forEach var="button" items="${button}">
                    <c:if test="${button.menu_button == 'pageDisplay'}">
                        <label id="totalAmount"></label>
                        <label id="successRate"></label>
                        <label id="singleCost"></label>
                    </c:if>
                </c:forEach>
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
