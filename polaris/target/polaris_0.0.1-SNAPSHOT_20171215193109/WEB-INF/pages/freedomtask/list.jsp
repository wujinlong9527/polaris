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
            $('#nextSendTime').datebox('setValue', formatterDate(new Date()));
            $('#inTime').datebox('setValue', formatterDate(new Date()));
            $('#nextTime').datebox('setValue', formatterDate(new Date()));
            $("#datagrid").datagrid("options").url = "${path}/freedomtask/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");

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
            $('#sourceSubChannel').combobox({
                editable: true, //编辑状态
                cache: false,
                valueField: 'id',
                textField: 'text'
            });
        }

        function searchOrder() {
            $("#idcard").textbox('setValue', $("#idcard").textbox("getText"));
            $("#rpOrderId").textbox('setValue', $("#rpOrderId").textbox("getText"));
            $("#orderAction").textbox('setValue', $("#orderAction").textbox("getText"));
            if(null == $("#sourceSubChannel").combobox("getValue")) {
                $("#sourceSubChannel").combobox("setValue", $("#sourceSubChannel").combobox("getText"));
            }
            $("#datagrid").datagrid("options").url = "${path}/freedomtask/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        function onReset() {
            $('#insertTime').datebox('setValue', formatterDate(new Date()));
            $('#nextSendTime').datebox('setValue', formatterDate(new Date()));
            $('#inTime').datebox('setValue', formatterDate(new Date()));
            $('#nextTime').datebox('setValue', formatterDate(new Date()));
            $("#idcard").textbox('setValue',"");
            $("#rpOrderId").textbox('setValue',"");
            $("#orderAction").textbox('setValue',"");
            $("#sourceSubChannel").combobox("setValue","");
            $("#datagrid").datagrid("options").url = "${path}/freedomtask/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
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
            }else {
                return '<span>' + val + '</span>';
            }
        }

        function formatType(val, row) {
            if (val == 1) {
                return '<span>' + '是' + '</span>';
            } else if (val == 0) {
                return '<span>' + '否' + '</span>';
            }
        }

        //确认修改提示框
        function Confirm(msg, control) {
                $('#configdlg').dialog('open').dialog('setTitle', '修改');
                $('#configfm').form('clear');
                mesTitle = '修改成功';
        }

        function dealChannel(val){
            if (val == '理财1.0(deduct)') {
                return 'deduct';
            } else if (val =='借款2.0(harbor)') {
                return 'harbor';
            } else if (val =='借款2.0(harbor_sms)') {
                return 'harbor_sms';
            }else if (val =='借款1.0(loan)') {
                return 'loan';
            }else if (val =='借款强扣1.0(loan_force)') {
                return 'loan_force';
            }else if (val =='理财2.0(storm)') {
                return 'storm';
            }else if (val =='闪电分期(taurus)') {
                return 'taurus';
            }else if (val =='全部') {
                return '';
            }else {
                return val;
            }
        }

        function update() {
            var insertTime = $("#insertTime").textbox("getText");
            var nextSendTime = $("#nextSendTime").textbox("getText");
            var inTime = $("#inTime").textbox("getText");
            var nextTime = $("#nextTime").textbox("getText");
            var idcard = $("#idcard").textbox("getText");
            var rpOrderId = $("#rpOrderId").textbox("getText");
            var orderAction = $("#orderAction").textbox("getText");
            var val = $("#sourceSubChannel").combobox("getText");
            var sourceSubChannel = dealChannel(val);
            $('#configfm').form('submit', {
                url: path + "/freedomtask/update?idcard="+idcard+"&rpOrderId="+rpOrderId+"&orderAction="+orderAction
                +"&sourceSubChannel="+sourceSubChannel+"&insertTime="+insertTime+"&inTime="+inTime+"&nextSendTime="+nextSendTime
                +"&nextTime="+nextTime,
                onSubmit: function () {
                    return $(this).form('validate');
                },
                success: function (result) {
                    var result = eval('(' + result + ')');
                    if (result.success) {
                        mesTitle= '修改成功';
                        $("#datagrid").datagrid("options").url = "${path}/freedomtask/datagrid?" + $("#fmorder").serialize();
                        $("#datagrid").datagrid("load");
                    } else {
                        mesTitle = '修改失败';
                    }
                    $('#configdlg').dialog('close');
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
    <!-- 任务信息列表 -->
    <table id="datagrid" title="恒丰任务查询" class="easyui-datagrid" fit="true"
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
            <th field="insertTime" width="140">创建时间</th>
            <th field="nextSendTime" width="140">下次发送时间</th>
            <th field="inTime" width="140" hidden="true"></th>
            <th field="nextTime" width="140" hidden="true"></th>
            <th field="idcard" width="150">身份证号</th>
            <th field="rpOrderId" width="240">rpOrderId</th>
            <th field="orderAction" width="80">orderAction</th>
            <th field="sourceSubChannel" width="80" formatter="formatIschannel">来源子渠道</th>
            <th field="cardNo" width="140">银行卡号</th>
            <th field="cardBankName" width="160">银行</th>
            <th field="dealChannel" width="80">处理渠道</th>
            <th field="dealSubChannel" width="100">处理子渠道</th>
            <th field="payOrderId" width="140">银联流水号</th>
            <th field="fullName" width="80">姓名</th>
            <th field="phone" width="110">手机号</th>
            <th field="payMoney" width="80" align="right">金额(元)</th>
            <th field="isget" width="70" formatter="formatType">是否取走</th>
        </tr>
        </thead>
    </table>

    <!-- 按钮 -->

    <div id="toolbar" class="easyui-layout"
         style="width:100%;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <form id="fmorder" name="fmorder" method="post">
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <label>创建开始日期:</label> <input id="insertTime" name="insertTime" class="easyui-datetimebox"
                                            style="width: 110px">
                <label>创建结束日期:</label> <input id="inTime" name="inTime" class="easyui-datetimebox" style="width: 110px">
                <label>下次查询开始日期:</label> <input id="nextSendTime" name="nextSendTime" class="easyui-datetimebox"
                                              style="width: 110px">
                <label>下次查询结束日期:</label> <input id="nextTime" name="nextTime" class="easyui-datetimebox" style="width: 110px">
            </div>
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <label>身份证号:</label> <input id="idcard" name="idcard" class="easyui-textbox" style="width: 150px">
                <label>rpOrderId:</label> <input id="rpOrderId" name="rpOrderId" class="easyui-textbox" style="width: 240px">
                <label>orderAction:</label> <input id="orderAction" name="orderAction" class="easyui-textbox" style="width: 100px">
                <label>来源子渠道:</label>
                <input id="sourceSubChannel" name="sourceSubChannel" style="width: 155px" class="easyui-combobox" data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'',text:'全部'},{id:'harbor',text:'借款2.0(harbor)'},{id:'harbor_sms',text:'借款2.0(harbor_sms)'},{id:'loan',text:'借款1.0(loan)'},
					{id:'loan_force',text:'借款1.0强扣(loan_force)'},{id:'storm',text:'理财2.0(storm)'},{id:'deduct',text:'理财1.0(deduct)'},{id:'taurus',text:'闪电分期(taurus)'}]">
            </div>
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchOrder();">查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="Confirm();">任务修改</a>
            </div>
        </form>
    </div>

    <div id="configdlg" class="easyui-dialog"
         style="width:250px;height:150px;padding:10px 20px" closed="true"
         buttons="#configdlg-buttons">
        <form id="configfm" method="post" novalidate>
            <table>
                <tr>
                    <td align="left">是否取走修改为:</td>
                    <td><input id="isget" name="isget" style="width: 50px" class="easyui-combobox"
                               data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'0',text:'否'},{id:'1',text:'是'}]" required="true"></td>
                </tr>
            </table>
        </form>
    </div>
    <!-- 对话框按钮 -->
    <div id="configdlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="update()" style="width:80px">确认修改</a> <a
            href="javascript:void(0)" class="easyui-linkbutton"
            iconCls="icon-cancel" onclick="javascript:$('#configdlg').dialog('close')"
            style="width:60px">取消</a>
    </div>
</div>

</body>
</html>
