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
        var bz = 0;
        formatterDate = function (date) {
            var day = date.getDate() > 9 ? date.getDate() : "0" + date.getDate();
            var month = (date.getMonth() + 1) > 9 ? (date.getMonth() + 1) : "0"
            + (date.getMonth() + 1);
            return date.getFullYear() + '-' + month + '-' + day;
        };

        window.onload = function () {

          /*  $('#goodsid').combobox({
                editable: true, //编辑状态
                cache: false,
                //    panelHeight: 'auto',//自动高度适合，不自动出现滚动条
                valueField: 'goodsid',
                textField: 'goodsname'
            });

            $.ajax({
                 type: "POST",
                 url: "${path}/goods/getgoodsname",
                 cache: false,
                 dataType: "json",
                 success: function (data) {
                     $("#goodsid").combobox("loadData", data.rows);
                 }
             });*/

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
        function addorder() {
            $('#configfm').form('clear');
            $('#configdlg').dialog('open').dialog('setTitle', '新增订单');
            $('#id').val("0");
            url = path + "/order/addOrder";
            mesTitle = '新增订单成功';
        }

        function editorder() {
            url = path + "/order/addOrder";
            var row = $('#datagrid').datagrid('getSelected');
            if (row) {
                var ddzt = row.ddzt;
                if(ddzt=='01'){
                    $.messager.alert("提示","订单已完成不能修改！","warning");
                    return;
                }
                var id = row.id;
                $('#configdlg').dialog('open').dialog('setTitle', '订单修改');
                $('#configfm').form('load', row);//这句话有问题，第一次加载时正确的，第二次就出错了，还保持第一次的数据
                mesTitle = '修改订单成功';
            } else {
                $.messager.alert('提示', '请选择要编辑的记录！', 'error');
            }
        }

        function saveOrder() {
            var groupid = $('#groupid').combobox('getValue');
            if(groupid==null||groupid==''){
                $.messager.alert("提示","商户名称不能为空！","error");
                return;
            }
            var goodsid = $('#goodsid').combobox('getValue');
            if(goodsid==null||goodsid==''){
                $.messager.alert("提示","商品名称不能为空！","error");
                return;
            }
            var gcount = $('#gcount').combobox('getValue').trim();
            if(gcount==null||gcount==''){
                $.messager.alert("提示","库存数量不能为空！","error");
                return;
            }else if(gcount==0){
                $.messager.alert("提示","库存不足，不能下订单，请稍后再试！","error");
                return;
            }
            var price = $('#price').combobox('getValue').trim();
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
                $.messager.alert("提示","订购数量不能为空！","error");
                return;
            }else{
                var reg=/^\+?[1-9][0-9]*$/;
                if(reg.test(count)==false){
                    $.messager.alert("提示","订购数量必须是正整数，请重新输入！","error");
                    return;
                }
            }
            if(parseInt(count)>parseInt(gcount)){
                $.messager.alert("提示","订购数量不能超过库存数量，请重新输入！","error");
                return;
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

            var jsfs = $('#jsfs').combobox('getValue');
            if(jsfs==null||jsfs==''){
                $.messager.alert("提示","支付方式不能为空！（现金，微信，支付宝，银行转账，其他等）","error");
                return;
            }
            var jszt = $('#jszt').combobox('getValue');
            if(jszt==null||jszt==''){
                $.messager.alert("提示","支付状态不能为空！","error");
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
            bz=0;
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
            <th field="groupname" width="220" align="center">经销商名称</th>
            <th field="groupid" width="130" align="center" hidden="true">groupid</th>
            <th field="account" width="110" align="center" hidden="true">操作员</th>
            <th field="username" width="110" align="center">客户姓名</th>
            <th field="goodsid" width="120" align="center" hidden="true">商品</th>
            <th field="goodsname" width="120" align="center">商品名称</th>
            <th field="price" width="80" align="center">单价（元）</th>
            <th field="gcount" width="10" align="center" hidden="true">gcount</th>
            <th field="count" width="80"  align="center">商品数量</th>
            <th field="amount" width="80"  align="center">订单总额</th>
            <th field="ddzt" width="80" align="center">订单状态</th>
            <th field="inserttime" width="130" align="center">下单时间</th>
            <th field="endtime" width="130" align="center">订单完成时间</th>
            <th field="phone" width="90" align="center">手机号码</th>
            <th field="tel" width="110" align="center">联系电话</th>
            <th field="jsfs" width="80" formatter="formatjsfs" align="center">结算方式</th>
            <th field="jszt" width="80" formatter="formatjszt" align="center">结算状态</th>
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

                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchOrder();" >查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();" >重置</a>
            </div>
        </form>

        <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-left: 6px" align="left">

            <a href="javascript:void(0);" class="easyui-linkbutton"
               iconCls="icon-add" plain="true" onclick="addorder();">新增订单</a>
            <a href="javascript:void(0);" class="easyui-linkbutton"
               iconCls="icon-edit" plain="true" onclick="editorder();">编辑订单</a>
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
                        <input id="groupid" name="groupid"  class="easyui-combobox" style="width:180px"
                               data-options="{
                                url:'${path}/order/getgrounameByld',
                                editable: false,
                                cache: false,
                                valueField:'groupid',
                                textField:'groupname',
                                onSelect:function(json)
                                {
                                    $('#goodsid').combobox('clear');// 清除原有项目
                                    $('#price').combobox('clear');// 清除原有显示项目
                                    $('#gcount').combobox('clear');// 清除原有项目
                                    // 重新加载
                                    $('#goodsid').combobox('reload','${path}/goods/getgoodsnameByld?groupid='+json.groupid);
                                    $('#price').combobox('reload','${path}/goods/getgoodsnameByld'); //清理原有下拉项目
                                    $('#gcount').combobox('reload','${path}/goods/getgoodsnameByld'); //清理原有下拉项目
                                } }"/>
                    </td>
                </tr>
                <tr>
                    <td align="right">商品名称:</td>
                    <td>
                        <input id="goodsid" name="goodsid"  class="easyui-combobox" style="width:180px"
                               data-options="{
                                url:'${path}/goods/getgoodsnameByld',
                                editable: false,
                                cache: false,
                                valueField:'goodsid',
                                textField:'goodsname',
                                onSelect:function(json)
                                {
                                 $('#price').combobox('clear');// 清除原有项目
                                 $('#gcount').combobox('clear');// 清除原有项目
                                    // 重新加载
                                 $('#price').combobox('reload','${path}/goods/getgoodsnameByld?goodsid='+json.goodsid);
                                 $('#gcount').combobox('reload','${path}/goods/getgoodsnameByld?goodsid='+json.goodsid);
                                }   }"/>
                    </td>
                </tr>

                <tr id="gcnt">
                    <td align="right">库存数量:</td>
                    <td>
                        <input id="gcount" name="gcount"  class="easyui-combobox" style="width:180px"
                               data-options="{
                                url:'${path}/goods/getgoodsnameByld',
                                editable: false,
                                cache: false,
                                valueField:'count',
                                textField:'count' }"/>
                    </td>
                </tr>

                <tr>
                    <td align="right">商品单价(元):</td>
                    <td>
                        <input id="price" name="price" class="easyui-combobox" style="width:180px"
                               data-options="{
                                url:'${path}/goods/getgoodsnameByld',
                                editable: false,
                                cache: false,
                                valueField:'price',
                                textField:'price' }"/>
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
                        <input id="jsfs" name="jsfs"  style="width: 180px"  class="easyui-combobox" data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'01',text:'支付宝'},{id:'02',text:'微信支付'},{id:'03',text:'手机银行支付'},{id:'04',text:'现金支付'},{id:'05',text:'银行转账'},{id:'06',text:'其他方式'}]"  class="easyui-validatebox" required="true"/>
                    </td>
                </tr>
                <tr>
                    <td align="right">支付状态:</td>
                    <td>
                        <input id="jszt" name="jszt"  style="width: 180px" class="easyui-combobox" data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'01',text:'已支付'},{id:'02',text:'待支付'},{id:'03',text:'月结'},{id:'04',text:'半月结'}]"  class="easyui-validatebox" required="true"/>
                    </td>
                </tr>
 <%--               <tr id="aab301hide">
                    <td align="right">用户所在地:</td>
                    <td><input id="aab301" name="aab301" style="width: 180px" class="easyui-combobox" data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'341621',text:'涡阳县'},{id:'341622',text:'蒙城县'},{id:'341623',text:'利辛县'}]"  class="easyui-validatebox" required="true"></td>
                </tr>--%>
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
