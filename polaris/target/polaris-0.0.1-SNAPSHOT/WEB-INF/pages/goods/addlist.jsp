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

            $('#groupid').combobox({
                editable: false, //编辑状态
                cache: false,
             //   panelHeight: 'auto',//自动高度适合
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

            $('#gtype').combobox({
                editable: true, //编辑状态
                cache: false,
            //    panelHeight: 'auto',//自动高度适合，不自动出现滚动条
                valueField: 'gtype',
                textField: 'gtypename'
            });

            $.ajax({
                type: "POST",
                url: "${path}/goods/getgoodstype",
                cache: false,
                dataType: "json",
                success: function (data) {
                    $("#gtype").combobox("loadData", data.rows);
                }
            });

            $('#inserttime').datebox('setValue', formatterDate(new Date()));
            $('#finaltime').datebox('setValue', formatterDate(new Date()));
            $("#datagrid").datagrid("options").url = "${path}/goods/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");

        }

        function searchGoods() {
            var inserttime = $("#inserttime").datebox("getValue");
            var finaltime = $("#finaltime").datebox("getValue");
            if(inserttime > finaltime){
                $.messager.alert("提示","开始日期不能大于结束日期！","warning")
                return;
            }
            $("#datagrid").datagrid("options").url = "${path}/goods/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");

        }

        function onReset() {
            $('#inserttime').datebox('setValue', formatterDate(new Date()));
            $('#finaltime').datebox('setValue', formatterDate(new Date()));
            $("#goodsid").textbox('setValue', "");
            $("#datagrid").datagrid("options").url = "${path}/goods/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        function addgoods() {

            $('#configfm').form('clear');
            $('#groupid').combobox('enable');
            $('#configdlg').dialog('open').dialog('setTitle', '新增商品');
            $('#id').val("0");
            url = path + "/goods/addGoods";
            mesTitle = '新增商品成功';
        }

        function editgoods() {
            $('#groupid').combobox('disable');
            url = path + "/goods/addGoods";
            var row = $('#datagrid').datagrid('getSelected');
            if (row) {
                var id = row.id;
                $('#configdlg').dialog('open').dialog('setTitle', '商品修改');
                $('#configfm').form('load', row);//这句话有问题，第一次加载时正确的，第二次就出错了，还保持第一次的数据
                mesTitle = '修改商品成功';
            } else {
                $.messager.alert('提示', '请选择要编辑的记录！', 'error');
            }
        }

        function delgoods() {
            var record = $("#datagrid").datagrid('getSelected');
            if (record) {
                $.messager.confirm("删除", "确认删除？", function (r) {
                    if (r) {
                        $.post('${path}/goods/delgoods',
                        {id: record.id},
                        function (result) {
                            var result = eval('(' + result + ')');
                            if (result.success) {
                                $.messager.alert('消息提示', result.msg,"info");
                                $("#datagrid").datagrid("options").url = "${path}/goods/datagrid";
                                $("#datagrid").datagrid("load");
                            } else {
                                $.messager.alert('错误提示',  result.msg,"error");
                            }
                        });
                    }
                });
            } else {
                $.messager.alert('提示', '请先选中要删除的行','info');
            }
        }

        function saveGoods() {
            var groupid = $('#groupid').combobox('getValue');
            if(groupid==null||groupid==''){
                $.messager.alert("提示","经销商名称不能为空！","error");
                return;
            }
            var goodsname = $('#goodsname').val().trim();
            if(goodsname==null||goodsname==''){
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
            var gtype = $('#gtype').combobox('getValue');
            if(gtype==null||gtype==''){
                $.messager.alert("提示","商品类别不能为空！","error");
                return;
            }
            $('#configfm').form('submit', {
                url: url,
                success: function (result) {
                    var result = eval('(' + result + ')');
                    if (result.success) {
                        $('#configdlg').dialog('close');
                        $("#datagrid").datagrid("options").url = "${path}/goods/datagrid?" + $("#fmorder").serialize();
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
    <table id="datagrid" title="商品新增" class="easyui-datagrid" fit="true" toolbar="#toolbar" pagination="true"
           fitColumns="false"  singleSelect="true" rownumbers="true" border="false" nowrap="true" width="100%">

        <thead>
        <tr>
            <th field="id" width="130" align="center" hidden="true">id</th>
            <th field="goodsid" width="130" align="center">商品编号</th>
            <th field="groupid" width="10" align="center" hidden="true">groupid</th>
            <th field="groupname" width="260" align="center">所属经销商</th>
            <th field="goodsname" width="130"  align="center">商品名称</th>
            <th field="price" width="100" align="center">单价（元）</th>
            <th field="count" width="100"  align="center">商品数量</th>
            <th field="inserttime" width="140" align="center">新增日期</th>
            <th field="gtype" width="140" align="center" hidden="true">gtype</th>
            <th field="gtypename" width="140" align="center" >商品类别</th>
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
                &nbsp;
                <label>商品编号:</label> <input id="goodsid" name="goodsid" class="easyui-textbox" style="width: 160px">

                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchGoods();" >查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();" >重置</a>
            </div>
        </form>

        <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-left: 6px" align="left">

            <a href="javascript:void(0);" class="easyui-linkbutton"
               iconCls="icon-add" plain="true" onclick="addgoods();">新增商品</a>
            <a href="javascript:void(0);" class="easyui-linkbutton"
               iconCls="icon-edit" plain="true" onclick="editgoods();">编辑商品</a>

            <a href="javascript:void(0);" class="easyui-linkbutton"
               iconCls="icon-remove" plain="true" onclick="delgoods();">删除商品</a>
            <!-- 定义一个打印区域 -->
<%--            <input type ='button' value='打印' onclick='javascript:window.print()' />--%>
        </div>

    </div>


    <!-- 对话框 -->
    <div id="configdlg" class="easyui-dialog"
         style="width:360px;height:300px;padding:10px 20px" closed="true"
         buttons="#dlg-buttons">
        <form id="configfm" method="post" novalidate>

            <table>
                <input id="id" name="id" type="hidden"></td>
                <tr>
                    <td align="right">经销商名称:</td>
                    <td>
                        <input id="groupid" name="groupid"  style="width: 180px" data-options="required:true"/>
                    </td>
                </tr>
                <tr>
                    <td align="right">商品名称:</td>
                    <td>
                        <input id="goodsname" name="goodsname"  style="width: 180px"  class="easyui-validatebox" required="true"/>
                    </td>
                </tr>
                <tr>
                    <td align="right">商品单价(元):</td>
                    <td>
                        <input id="price" name="price"  style="width: 180px"  class="easyui-validatebox" required="true"/>
                    </td>
                </tr>
                <tr>
                    <td align="right">商品数量:</td>
                    <td>
                        <input id="count" name="count"  style="width: 180px"  class="easyui-validatebox" required="true"/>
                    </td>
                </tr>
                <tr>
                    <td align="right">商品类别:</td>
                    <td>
                        <input id="gtype" name="gtype"  style="width: 180px"  data-options="required:true"/>
                    </td>
                </tr>
            </table>
        </form>
    </div>

    <div id="dlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="saveGoods()" style="width:90px">保存</a> <a
            href="javascript:void(0)" class="easyui-linkbutton"
            iconCls="icon-cancel" onclick="javascript:$('#configdlg').dialog('close')"
            style="width:90px">取消</a>
    </div>


</div>

</body>
</html>
