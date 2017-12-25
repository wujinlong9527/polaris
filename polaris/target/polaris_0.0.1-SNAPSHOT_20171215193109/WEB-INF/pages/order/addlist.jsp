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

            $('#groupid').combobox({
                editable: false, //编辑状态
                cache: false,
                panelHeight: 'auto',//自动高度适合
                valueField: 'groupid',
                textField: 'groupname'
            });

            $.ajax({
                type: "POST",
                url: "${path}/order/getgrouname",
                cache: false,
                dataType: "json",
                success: function (data) {
                    $("#groupid").combobox("loadData", data.rows);
                }
            });

            $('#inserttime').datebox('setValue', formatterDate(new Date()));
            $('#finaltime').datebox('setValue', formatterDate(new Date()));
            $("#datagrid").datagrid("options").url = "${path}/order/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");

        }

        function searchOrder() {
            var inserttime = $("#inserttime").datebox("getValue");
            var finaltime = $("#finaltime").datebox("getValue");
            if(inserttime > finaltime){
                $.messager.alert("提示","开始日期不能大于结束日期！","warning")
                return;
            }
            $("#datagrid").datagrid("options").url = "${path}/order/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");

        }

        function onReset() {
            $('#inserttime').datebox('setValue', formatterDate(new Date()));
            $('#finaltime').datebox('setValue', formatterDate(new Date()));
            $("#ddzt").combobox('setValue', "");
            $("#orderid").textbox('setValue', "");
            $("#datagrid").datagrid("options").url = "${path}/order/datagrid?" + $("#fmorder").serialize();
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

        function addorder() {
            $('#configfm').form('clear');
            $("#aab301hide").show();
            $('#configdlg').dialog('open').dialog('setTitle', '新增订单');
            $('#id').val("0");
            url = path + "/order/addOrder";
            mesTitle = '新增订单成功';
        }

        function saveOrder() {
            var groupid = $('#groupid').combobox('getValue');
            if(groupid==null||groupid==''){
                $.messager.alert("提示","供货商名称不能为空！","error");
                return;
            }
            var goods = $('#goods').val().trim();
            if(goods==null||goods==''){
                $.messager.alert("提示","商品名称不能为空！","error");
                return;
            }
            var price = $('#price').val().trim();
            if(price==null||price==''){
                $.messager.alert("提示","商品价格不能为空！","error");
                return;
            }else{
                var reg=/^([1-9]\d{0,9}|0)([.]?|(\.\d{1,2})?)$/;
                if(reg.test(price)==false){
                    $.messager.alert("提示","输入的金额不合法，请重新输入！","error");
                    return;
                }
            }
            var count = $('#count').val().trim();
            if(count==null||count==''){
                $.messager.alert("提示","商品数量不能为空！","error");
                return;
            }else{
                var reg=/^\+?[1-9][0-9]*$/;
                if(reg.test(count)==false){
                    $.messager.alert("提示","商品数量必须是正整数，请重新输入！","error");
                    return;
                }
            }
            var phone = $('#phone').val().trim();
            if(phone==null||phone==''){
                $.messager.alert("提示","手机号码不能为空！","error");
                return;
            }else {
                var reg=/^\+?[1-9][0-9]*$/;
                if(reg.test(phone)==false){
                    $.messager.alert("提示","手机号码必须数字，请重新输入！","error");
                    return;
                }
                if (phone.length != 11){
                    $.messager.alert("提示", "手机号码不是11位有效号码！", "error");
                    return;
                }
            }

            var tel = $('#tel').val().trim();
            if(tel!=null&&tel!=''){
                var reg=/\d{3}-\d{8}|\d{4}-\d{7}/;
                if(reg.test(tel)==false){
                    $.messager.alert("提示","电话必须是xxxx-xxxxxx格式，请重新输入！","error");
                    return;
                }
            }
            var username = $('#username').val().trim();
            if(username==null||username==''){
                $.messager.alert("提示","收货人姓名不能为空！","error");
                return;
            }
            var readdress = $('#readdress').val().trim();
            if(readdress==null||readdress==''){
                $.messager.alert("提示","收货地址不能为空！","error");
                return;
            }

            var jsfs = $('#jsfs').val().trim();
            if(jsfs==null||jsfs==''){
                $.messager.alert("提示","支付方式不能为空！（现金，微信，支付宝，银行转账，其他等）","error");
                return;
            }
            var jszt = $('#jszt').combobox('getValue');
            if(jszt==null||jszt==''){
                $.messager.alert("提示","支付状态不能为空！","error");
                return;
            }
            var aab301 = $('#aab301').combobox('getValue');
            if(aab301==null||aab301==''){
                $.messager.alert("提示","用户所在地不能为空！","error");
                return;
            }
            $('#configfm').form('submit', {
                url: url,
                success: function (result) {
                    var result = eval('(' + result + ')');
                    if (result.success) {
                        $('#configdlg').dialog('close');
                        $("#datagrid").datagrid("options").url = "${path}/order/datagrid?" + $("#fmorder").serialize();
                        $("#datagrid").datagrid("load");
                        $.messager.alert("提示",result.msg,"info")
                    } else {
                        $.messager.alert("提示",result.msg,"error")
                    }
                }
            });
        }
    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 信息列表 -->
    <table id="datagrid" title="订单新增" class="easyui-datagrid" fit="true" toolbar="#toolbar" pagination="true"
           fitColumns="false"  singleSelect="true" rownumbers="true" border="false" nowrap="true" width="100%">

        <thead>
        <tr>
            <th field="id" width="130" align="center" hidden="true">id</th>
            <th field="orderid" width="130" align="center">订单编号</th>
            <th field="groupid" width="130" align="center">经销商编号</th>
            <th field="account" width="130" align="center">下单用户名</th>
            <th field="username" width="130" align="center">客户姓名</th>
            <th field="goods" width="120" align="center">商品</th>
            <th field="price" width="80" align="center">单价（元）</th>
            <th field="count" width="80"  align="center">商品数量</th>
            <th field="amount" width="80"  align="center">订单总额</th>
            <th field="ddzt" width="80" formatter="formatIsSuc" align="center">订单状态</th>
            <th field="inserttime" width="130" align="center">下单时间</th>
            <th field="endtime" width="130" align="center">订单完成时间</th>
            <th field="phone" width="90" align="center">手机号码</th>
            <th field="tel" width="110" align="center">联系电话</th>
            <th field="jsfs" width="80" align="center">结算方式</th>
            <th field="jszt" width="80" align="center">结算状态</th>
            <th field="expressname" width="80" align="center">派送员</th>
            <th field="expressid" width="80" align="center" >派送员编号</th>
            <th field="readdress" width="400" align="center">收货地址</th>
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
                <label>订单状态:</label> <input id="ddzt" name="ddzt" class="easyui-combobox" style="width: 80px"
                   data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'',text:'全部'},{id:'01',text:'已完成'},{id:'02',text:'处理中'},{id:'03',text:'未处理'}]">
                &nbsp;
                <label>订单编号:</label> <input id="orderid" name="orderid" class="easyui-textbox" style="width: 160px">


            </div>
        </form>

        <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-left: 6px" align="left">

            <a href="javascript:void(0);" class="easyui-linkbutton"
               iconCls="icon-add" plain="true" onclick="addorder();">新增订单</a>
            <a href="javascript:void(0);" class="easyui-linkbutton"
               iconCls="icon-search" plain="true" onclick="searchOrder();" >查询</a>
            <a href="javascript:void(0);" class="easyui-linkbutton"
               iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
        </div>
    </div>


    <!-- 对话框 -->
    <div id="configdlg" class="easyui-dialog"
         style="width:360px;height:420px;padding:10px 20px" closed="true"
         buttons="#dlg-buttons">
        <form id="configfm" method="post" novalidate>

            <table>
                <input id="id" name="id" type="hidden"></td>
                <tr>
                    <td align="right">商户名称:</td>
                    <td>
                        <input id="groupid" name="groupid"  style="width: 180px" data-options="required:true"/>
                    </td>
                </tr>
                <tr>
                    <td align="right">商品名称:</td>
                    <td>
                        <input id="goods" name="goods"  style="width: 180px"  class="easyui-validatebox" required="true"/>
                    </td>
                </tr>
                <tr>
                    <td align="right">商品单价(元):</td>
                    <td>
                        <input id="price" name="price"  style="width: 180px"  class="easyui-validatebox" required="true"/>
                    </td>
                </tr>
                <tr>
                    <td align="right">订购数量:</td>
                    <td>
                        <input id="count" name="count"  style="width: 180px"  class="easyui-validatebox" required="true"/>
                    </td>
                </tr>
                <tr>
                    <td align="right">手机号码:</td>
                    <td>
                        <input id="phone" name="phone"  style="width: 180px"  class="easyui-validatebox" required="true"/>
                    </td>
                </tr>
                <tr>
                    <td align="right">联系电话:</td>
                    <td>
                        <input id="tel" name="tel"  style="width: 180px"  class="easyui-validatebox" />
                    </td>
                </tr>
                <tr>
                    <td align="right">用户姓名:</td>
                    <td>
                        <input id="username" name="username"  style="width: 180px"  class="easyui-validatebox" required="true"/>
                    </td>
                </tr>
                <tr>
                    <td align="right">收货地址:</td>
                    <td>
                        <input id="readdress" name="readdress"  style="width: 180px"  class="easyui-validatebox" required="true"/>
                    </td>
                </tr>
                <tr>
                    <td align="right">支付方式:</td>
                    <td>
                        <input id="jsfs" name="jsfs"  style="width: 180px"  class="easyui-validatebox" required="true"/>
                    </td>
                </tr>
                <tr>
                    <td align="right">支付状态:</td>
                    <td>
                        <input id="jszt" name="jszt"  style="width: 180px" class="easyui-combobox" data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'01',text:'已支付'},{id:'02',text:'待支付'},{id:'03',text:'月结'},{id:'04',text:'半月结'}]"  class="easyui-validatebox" required="true"/>
                    </td>
                </tr>
                <tr id="aab301hide">
                    <td align="right">用户所在地:</td>
                    <td><input id="aab301" name="aab301" style="width: 180px" class="easyui-combobox" data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'341621',text:'涡阳县'},{id:'341622',text:'蒙城县'},{id:'341623',text:'利辛县'}]"  class="easyui-validatebox" required="true"></td>
                </tr>
            </table>
        </form>
    </div>

    <div id="dlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="saveOrder()" style="width:90px">保存</a> <a
            href="javascript:void(0)" class="easyui-linkbutton"
            iconCls="icon-cancel" onclick="javascript:$('#configdlg').dialog('close')"
            style="width:90px">取消</a>
    </div>


</div>

</body>
</html>
