<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>订单管理</title>
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
            $("#datagrid").datagrid("options").url = "${path}/order/datagridback?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");

        }

        function searchOrder() {
            var inserttime = $("#inserttime").datebox("getValue");
            var finaltime = $("#finaltime").datebox("getValue");
            if(inserttime > finaltime){
                $.messager.alert("提示","开始日期不能大于结束日期！","warning")
                return;
            }
            $("#datagrid").datagrid("options").url = "${path}/order/datagridback?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        function onReset() {
            $('#inserttime').datebox('setValue', formatterDate(new Date()));
            $('#finaltime').datebox('setValue', formatterDate(new Date()));
            $("#orderid").textbox('setValue', "");
            $("#datagrid").datagrid("options").url = "${path}/order/datagridback?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        function formatIsSuc(val, row) {
            if (val == '01') {
                return '<span>' + '已完成' + '</span>';
            } else if (val == '02') {
                return '<span>' + '处理中' + '</span>';
            } else if (val == '03') {
                return '<span>' + '未处理' + '</span>';
            }
        }

        function formatjsfs(val, row) {
            if (val == '01') {
                return '<span>' + '支付宝' + '</span>';
            } else if (val == '02') {
                return '<span>' + '微信支付' + '</span>';
            } else if (val == '03') {
                return '<span>' + '手机银行支付' + '</span>';
            } else if (val == '04') {
                return '<span>' + '现金支付' + '</span>';
            } else if (val == '05') {
                return '<span>' + '银行转账' + '</span>';
            }else if (val == '06') {
                return '<span>' + '其他方式' + '</span>';
            }
        }

        function formatjszt(val, row) {
            if (val == '01') {
                return '<span>' + '已支付' + '</span>';
            } else if (val == '02') {
                return '<span>' + '待支付' + '</span>';
            } else if (val == '03') {
                return '<span>' + '月结' + '</span>';
            } else if (val == '04') {
                return '<span>' + '半月结' + '</span>';
            }
        }

        //确认订单
        function formatbackorder(val, row) {
            if (row.ddbz == '05') {
                return '<a class="editcls" href="javascript:void(0)" onclick="editRow(\'' + row.id + ',' + 1 + '\')" >同意退货</a> | ' +
                        '<a class="editcls" href="javascript:void(0)" onclick="editRow(\'' + row.id + ',' + 2 + '\')" >' +
                        '<span style="color:red">拒绝退货</span></a>';
            } else if (row.ddbz == '08') {
                return '<a class="editcls" href="javascript:void(0)" onclick="printth(\'' + row.id + '\')" >打印退货单</a>';
            } else if(row.ddbz == '10') {
                return '<a class="editcls" href="javascript:void(0)" onclick="editRow(\'' + row.id + ',' + 11 + '\')" >同意换货</a> | ' +
                        '<a class="editcls" href="javascript:void(0)" onclick="editRow(\'' + row.id + ',' + 12 + '\')" >' +
                        '<span style="color:red">拒绝换货</span></a>';
            } else if (row.ddbz == '11') {
                return '<a class="editcls" href="javascript:void(0)" onclick="printhh(\'' + row.id + '\')" >打印换货单</a>';
            }
        }

        function editRow(id) {
            var sid = id.split(",");
            var msg = "";
            id = sid[0];
            var type = sid[1];
            if(type==1){
                msg = '如果确认是货品问题，请同意退货？';
            }else if(type==2){
                msg = '如果确认是客户问题，请拒绝退货？';
            }else if(type==11){
                msg = '如果确认是货品问题，请同意换货？';
            }else if(type==12){
                msg = '如果确认是客户问题，请拒绝换货？';
            }
            $.messager.confirm("提示", msg, function (r) {
                if (r) {
                    $.post('${path}/order/confirmorderback',
                    {id: id,type:type},
                    function (result) {
                        var result = eval('(' + result + ')');
                        if (result.success) {
                            $.messager.alert('消息提示', result.msg,"info");
                            $("#datagrid").datagrid("options").url = "${path}/order/datagridback?" + $("#fmorder").serialize();
                            $("#datagrid").datagrid("load");
                        } else {
                            $.messager.alert('错误提示',  result.msg,"error");
                        }
                    });
                }
            });
        }

        function formatdd(val, row) {
            return  '<span style="color:red">'+row.ddbzmc+'</span>';
        }

        function printth(id) {
            $('#iframe1')[0].src = '${path}/order/printth?id=' + id;
            $('#openRoleDiv').dialog('open');
        }

        function printhh(id) {
            $('#iframe2')[0].src = '${path}/order/printhh?id=' + id;
            $('#openRoleDiv2').dialog('open');
        }

    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 信息列表 -->
    <table id="datagrid" title="退单查询" class="easyui-datagrid" fit="true" toolbar="#toolbar" pagination="true"
           fitColumns="false"  singleSelect="true" rownumbers="true" border="false" nowrap="true" width="100%">

        <thead>
        <tr>
            <th field="id" width="130" align="center" hidden="true">id</th>
            <th field="orderid" width="130" align="center">订单编号</th>
            <th field="groupname" width="220" align="center">经销商名称</th>
            <th field="username" width="90" align="center">客户姓名</th>
            <th field="goodsid" width="120" align="center" hidden="true">商品</th>
            <th field="goodsname" width="120" align="center">商品名称</th>
            <th field="price" width="80" align="center">单价（元）</th>
            <th field="count" width="80"  align="center">商品数量</th>
            <th field="amount" width="80"  align="center">订单总额</th>
            <th field="ddzt" width="80"  align="center">订单状态</th>
            <th field="inserttime" width="130" align="center">下单时间</th>
            <th field="endtime" width="130" align="center">订单完成时间</th>
            <th field="phone" width="90" align="center">手机号码</th>
            <th field="jsfs" width="80" formatter="formatjsfs" align="center">结算方式</th>
            <th field="jszt" width="80" formatter="formatjszt" align="center">结算状态</th>
            <th field="readdress" width="260" align="center">收货地址</th>
            <th field="ddbz" width="10" align="center" hidden="true">ddbz</th>
            <th field="ddbzmc" width="80" align="center" formatter="formatdd">订单标志</th>
            <th field="opt" width="135" align="center" formatter="formatbackorder">操作</th>
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
                <label>订单编号:</label> <input id="orderid" name="orderid" class="easyui-textbox" style="width: 160px">
            </div>

            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-left: 6px" align="left">
               <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchOrder();" >查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
            </div>
        </form>
    </div>

    <div id="openRoleDiv" class="easyui-dialog" closed="true" modal="true" title="打印退货单"
         style="width:1000px;height:450px;">
        <iframe scrolling="no" id='iframe1' frameborder="0" style="width:1000px;height:100%;"></iframe>
    </div>

    <div id="openRoleDiv2" class="easyui-dialog" closed="true" modal="true" title="打印换货单"
         style="width:1000px;height:450px;">
        <iframe scrolling="no" id='iframe2' frameborder="0" style="width:1000px;height:100%;"></iframe>
    </div>
</div>

</body>
</html>
