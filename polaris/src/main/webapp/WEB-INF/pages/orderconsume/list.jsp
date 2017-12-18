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
            $("#datagrid").datagrid("options").url = "${path}/orderconsume/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");

            <%--$('#sourceSubchannel').combobox({--%>
                <%--editable: false, //不可编辑状态--%>
                <%--cache: false,--%>
                <%--panelHeight: 'auto',//自动高度适合--%>
                <%--valueField: 'sourceSubchannel',--%>
                <%--textField: 'sourceSubchannel'--%>
            <%--});--%>

            <%--$.ajax({--%>
                <%--type: "POST",--%>
                <%--url: "${path}/orderconsume/getConfigSource?orderAction=" + "消费",--%>
                <%--cache: false,--%>
                <%--dataType: "json",--%>
                <%--success: function (data) {--%>
                    <%--//$("#sourceSubchannel").combobox("loadData", data.rows);--%>
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

            $('#sourceSubchannel').combobox({
                editable: true, //编辑状态
                cache: false,
                valueField: 'id',
                textField: 'text'
            });
        }

        function searchOrder() {
            $("#dealChannel").combobox("setValue", $("#dealChannel").combobox("getText"));
            if(null == $("#sourceSubchannel").combobox("getValue")) {
                $("#sourceSubchannel").combobox("setValue", $("#sourceSubchannel").combobox("getText"));
            }
            $("#datagrid").datagrid("options").url = "${path}/orderconsume/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
            //查询结果出来后加载总金额、成功率、单笔成本
            getPageDisplay();
        }

        function onReset() {
            $('#insertTime').datebox('setValue', formatterDate(new Date()));
            $('#finalTime').datebox('setValue', formatterDate(new Date()));
            $("#fcOrderid").textbox('setValue', "");
            $("#fullName").textbox('setValue', "");
            $("#phone").textbox('setValue', "");
            $("#cardNo").textbox('setValue', "");
            $("#payMoney").textbox('setValue', "");
            $("#dealChannel").combobox('setValue', "");
            $("#payOrderid").textbox('setValue', "");
            $("#cardBankName").textbox('setValue', "");
            $("#sucFlag").combobox("setValue", "");
            $("#sourceSubchannel").combobox("setValue", "");
            $("#cardType").textbox('setValue', "");
            $("#payMoneyBottom").textbox('setValue','');
            $("#payMoneyTop").textbox('setValue','');
            $("#datagrid").datagrid("options").url = "${path}/orderconsume/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");

            //查询结果出来后加载总金额、成功率、单笔成本
            getPageDisplay();
        }

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
            }else if (val =='loan') {
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
                value:"全部" //默认显示全部选项
            });
            $.ajax({
                type: "POST",
                url: "${path}/orderconsume/getDealChannel",
                cache: false,
                async: true,
                dataType: "json",
                success: function (data) {
                    data.rows.unshift({ "dealChannel": "全部" });//第一列加上全部选项
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
                url: "${path}/orderconsume/getPageDisplay",
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

        var url = "";
        function manualUpdate() {
            $("#dlgPayOrderid").attr("readOnly", true);
            //$("#dlgPayOrderid").attr('disabled','disabled');
            var row = $('#datagrid').datagrid('getSelected');
            if (row) {
                $('#configdlg').dialog('open').dialog('setTitle', '手动处理订单');
                $('#configfm').form('load', row);
                url = path + "/orderconsume/manualUpdate";
                mesTitle = '手动处理成功';
                if(0 == row.sucFlag) {
                    $("#dealResult").show();
                    $("#points").hide();
                    $("#dlgSucFlag").combobox('setValue', "");
                } else {
                    $("#dealResult").hide();
                    $("#points").show();
                }
            } else {
                $.messager.alert('提示', '请选择要手动处理的记录！', 'error');
            }
        }

        function saveConfig() {
            $('#configfm').form('submit', {
                url: url,
                success: function (result) {
                    var result = eval('(' + result + ')');
                    if (result.success) {
                        $('#configdlg').dialog('close');
                        $("#datagrid").datagrid("options").url = "${path}/orderconsume/datagrid?" + $("#fmorder").serialize();
                        $("#datagrid").datagrid("load");
                    } else {
                        mesTitle = '手动处理失败';
                    }
                    $.messager.show({
                        title: mesTitle,
                        msg: result.msg
                    });
                }
            });
        }
    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 消费信息列表 -->
    <table id="datagrid" title="扣款查询" class="easyui-datagrid" fit="true"
    <%--url="${path}/orderconsume/datagrid" --%>
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
            <th field="payOrderid" width="140">银联流水号</th>
            <th field="idCard" width="150">身份证号</th>
            <th field="phone" width="110">手机号</th>
            <th field="payMoney" width="90" align="right">金额(元)</th>
            <th field="sucFlag" width="60" formatter="formatIsSuc">成功标识</th>
            <th field="insertTime" width="140">创建时间</th>
            <th field="finalTime" width="140">结束时间</th>
            <th field="cardNo" width="140">银行卡号</th>
            <th field="cardType" width="80" formatter="formatCardType">银行卡类型</th>
            <th field="cardBankName" width="160">银行</th>
            <th field="sourceSubchannel" width="100" formatter="formatIschannel">来源子渠道</th>
            <th field="dealChannel" width="100">处理渠道</th>
            <th field="dealSubChannel" width="100">处理子渠道</th>
            <th field="code" width="100">code</th>
            <th field="returnMsg" width="400">returnMsg</th>
            <th field="err_code" width="100">错误码</th>
            <th field="err_msg" width="400">错误提示</th>
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
                <label>fcorderid:</label> <input id="fcOrderid" name="fcOrderid" class="easyui-textbox"
                                                 style="width: 150px">
                <label>姓名:</label> <input id="fullName" name="fullName" class="easyui-textbox" style="width: 100px">
                <label>手机号:</label> <input id="phone" name="phone" class="easyui-textbox" style="width: 100px">
                <label>银行卡号:</label> <input id="cardNo" name="cardNo" class="easyui-textbox" style="width: 150px">
            </div>
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <label>开户行:</label> <input id="cardBankName" name="cardBankName" class="easyui-textbox"
                                                     style="width: 100px">
                <label>消费金额:</label> <input id="payMoney" name="payMoney" class="easyui-textbox" style="width: 100px">
                <label>处理渠道:</label> <input id="dealChannel" name="dealChannel" class="easyui-textbox" style="width: 120px">
                <label>卡别:</label> <input id="cardType" name="cardType" class="easyui-combobox" style="width: 80px"
                                          data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'',text:'不限'},{id:'1',text:'借记卡'},{id:'2',text:'信用卡'}]">
                <label>银联流水号:</label> <input id="payOrderid" name="payOrderid" class="easyui-textbox"
                                             style="width: 100px">
                <label>成功标志:</label> <input id="sucFlag" name="sucFlag" class="easyui-combobox" style="width: 80px"
                                            data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'',text:'全部'},{id:'1',text:'成功'},{id:'0',text:'处理中'},{id:'-1',text:'失败'}]">
                </div>
                <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <!--
                <label>来源子渠道:</label>
                <input id="sourceSubchannel" name="sourceSubchannel" style="width: 130px">-->
                <label>来源子渠道:</label>
                <input id="sourceSubchannel" name="sourceSubchannel" style="width: 155px" class="easyui-combobox" data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
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
                <c:forEach var="button" items="${button}">
                    <c:if test="${button.menu_button == 'edit'}">
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                            iconCls="icon-edit" plain="true" onclick="manualUpdate();">手动修改</a>
                    </c:if>
                </c:forEach>
            </div>
        </form>
    </div>

    <!-- 手动处理对话框 -->
    <div id="configdlg" class="easyui-dialog"
         style="width:300px;height:250px;padding:10px 20px" closed="true"
         buttons="#configdlg-buttons">
        <form id="configfm" method="post" novalidate>
            <table>
                <tr>
                    <td align="right">订单号:</td>
                    <td><input id="dlgPayOrderid" name="payOrderid" type="text" style="width: 120px" class="easyui-validatebox"></td>
                </tr>
                <tr id = "dealResult">
                    <td align="right">*处理结果:</td>
                    <td><input id="dlgSucFlag" name="sucFlag" class="easyui-combobox" style="width: 120px"
                               data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'1',text:'成功'},{id:'-1',text:'失败'}]" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*备注:</td>
                    <td><input id="dlgRemark3" name="remark3" type="text" class="easyui-validatebox"
                               required="true"></td>
                </tr>
            </table>
            <div id="points" style="padding:20px 33px">
                <label>成功或失败的订单只能修改备注!</label>
            </div>
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
