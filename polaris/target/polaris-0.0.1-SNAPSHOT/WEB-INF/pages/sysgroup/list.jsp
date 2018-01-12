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
            $("#datagrid").datagrid("options").url = "${path}/sysgroup/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");

        }

        function searchOrder() {
            $("#datagrid").datagrid("options").url = "${path}/sysgroup/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        function onReset() {
            $("#tj").textbox('setValue', "");
            $("#datagrid").datagrid("options").url = "${path}/sysgroup/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        function formataab302(val, row) {
            if (val == '341621') {
                return '<span >' + '涡阳县' + '</span>';
            } else if (val == '341622') {
                return '<span>' + '蒙城县' + '</span>';
            } else if (val == '341623') {
                return '<span>' + '利辛县' + '</span>';
            }
        }

        function addGroup() {
            $('#configfm').form('clear');
            $("#aab301hide").show();
            $("#groupid").textbox('textbox').attr('readonly',false);
            $('#configdlg').dialog('open').dialog('setTitle', '新增商户');
            $('#id').val("0");
            url = path + "/sysgroup/addSysGroup";
            mesTitle = '新增商户成功';
        }

        function editGroup() {
            $("#aab301hide").hide();
            $("#groupid").textbox('textbox').attr('readonly',true);
            url = path + "/sysgroup/addSysGroup";
            var row = $('#datagrid').datagrid('getSelected');
            if (row) {
                var id = row.id;
                $('#configdlg').dialog('open').dialog('setTitle', '编辑商户');
                $('#configfm').form('load', row);//这句话有问题，第一次加载时正确的，第二次就出错了，还保持第一次的数据
                mesTitle = '编辑商户成功';
            } else {
                $.messager.alert('提示', '请选择要编辑的记录！', 'error');
            }
        }

        function saveGroup() {
            var id = $("#groupid").textbox("getValue").trim();
            var name = $("#groupname").textbox("getValue").trim();
            if(id==null ||id==''){
                $.messager.alert("提示","商户编码不能为空","warning");
                return;
            }
            if(name==null ||name==''){
                $.messager.alert("提示","商户名称不能为空","warning");
                return;
            }

            $('#configfm').form('submit', {
                url: url,
                onSubmit: function () {
                    return $(this).form('validate');
                },
                success: function (result) {
                    var result = eval('(' + result + ')');
                    if (result.success) {
                        $('#configdlg').dialog('close');
                        $("#datagrid").datagrid("options").url = "${path}/sysgroup/datagrid";
                        $("#datagrid").datagrid("load");
                        $.messager.alert("提示",result.msg,"info");
                    } else {
                        $.messager.alert("提示",result.msg,"error");
                    }
                }
            });
        }

    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 用户信息列表 -->
    <table id="datagrid" title="商户管理" class="easyui-datagrid" fit="true" toolbar="#toolbar"
           pagination="true" fitColumns="false" singleSelect="true" rownumbers="true" border="false" nowrap="true">
        <thead>
        <tr>
            <th field="id" width="120" align="center" hidden="true">id</th>
            <th field="groupid" width="120" align="center">商户编号</th>
            <th field="groupname" width="260" align="center">商户名称</th>
            <th field="aab301" width="140" align="center" formatter="formataab302">商户所在地</th>
            <th field="inserttime" width="160" align="center">创建时间</th>
            <th field="account" width="120" align="center">操作员</th>
        </tr>
        </thead>
    </table>

    <!-- 按钮 -->
    <div id="toolbar" class="easyui-layout"
         style="width:100%;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <form id="fmorder" name="fmorder" method="post">
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-left: 6px" align="left">

                <label>商户编号:</label> <input id="tj" name="tj" class="easyui-textbox" style="width: 160px">

                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchOrder();" >查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
            </div>
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <a href="javascript:void(0);" class="easyui-linkbutton"
               iconCls="icon-add" plain="true" onclick="addGroup();">新增</a>

                <a href="javascript:void(0);" class="easyui-linkbutton"
                iconCls="icon-edit" plain="true" onclick="editGroup();">编辑</a>

            </div>
        </form>
    </div>

    <!-- 对话框 -->
    <div id="configdlg" class="easyui-dialog"
         style="width:310px;height:200px;padding:10px 20px" closed="true"
         buttons="#dlg-buttons">
        <form id="configfm" method="post" novalidate>
            <table>
                <input id="id" name="id" type="hidden"></td>
                <tr>
                    <td align="right">*商户编号:</td>
                         <td><input id="groupid" name="groupid" style="width: 150px" class="easyui-textbox">
                    </td>
                </tr>
                <tr>
                    <td align="right">*商户名称:</td>
                         <td><input id="groupname" name="groupname" style="width: 150px" class="easyui-textbox">
                    </td>
                </tr>
                <tr id="aab301hide">
                    <td align="right">*商户所在地:</td>
                    <td><input id="aab301" name="aab301" style="width: 150px" class="easyui-combobox" data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'341621',text:'涡阳县'},{id:'341622',text:'蒙城县'},{id:'341623',text:'利辛县'}]"  class="easyui-validatebox" required="true"></td>
                </tr>
            </table>
        </form>
    </div>

    <!-- 对话框按钮 -->
    <div id="dlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="saveGroup()" style="width:90px">保存</a> <a
            href="javascript:void(0)" class="easyui-linkbutton"
            iconCls="icon-cancel" onclick="javascript:$('#configdlg').dialog('close')"
            style="width:90px">取消</a>
    </div>

</div>
</body>
</html>
