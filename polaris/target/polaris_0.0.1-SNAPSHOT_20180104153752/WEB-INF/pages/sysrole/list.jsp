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
        function addRole() {
            $("#rolename").attr("readonly", false);
            $('#configdlg').dialog('open').dialog('setTitle', '新增角色');
            $('#configfm').form('clear');
            $('#id').val("0");
            url = path + "/sysrole/addSysRole";
            mesTitle = '新增角色成功';
        }

        function editRole() {
            $("#name").attr("readonly", true);
            url = path + "/sysrole/addSysRole";
            var row = $('#datagrid').datagrid('getSelected');
            if (row) {
                var id = row.id;
                $('#configdlg').dialog('open').dialog('setTitle', '编辑角色');
                $('#configfm').form('load', row);//这句话有问题，第一次加载时正确的，第二次就出错了，还保持第一次的数据
//		 	url = path+"/sysrole/editUser?id="+id;
                mesTitle = '编辑角色成功';
            } else {
                $.messager.alert('提示', '请选择要编辑的记录！', 'error');
            }
        }

        function saveRole() {
            $('#configfm').form('submit', {
                url: url,
                onSubmit: function () {
                    return $(this).form('validate');
                },
                success: function (result) {
                    /* console.info(result); */
                    var result = eval('(' + result + ')');
                    if (result.success) {
                        $('#configdlg').dialog('close');
                        $("#datagrid").datagrid("options").url = "${path}/sysrole/datagrid";
                        $("#datagrid").datagrid("load");
                    } else {
                        mesTitle = '新增角色失败';
                    }
                    $.messager.show({
                        title: mesTitle,
                        msg: result.msg
                    });
                }
            });
        }

        function deleteRole() {
            var record = $("#datagrid").datagrid('getSelected');
            if (record) {
                $.messager.confirm("删除", "是否删除", function (r) {
                    if (r) {

                        $.post('${path}/sysrole/deleteSysRole',
                                {id: record.id},
                                function (result) {
                                    var result = eval('(' + result + ')');
                                    if (result.success) {
                                        $.messager.alert('消息提示', "删除成功");
                                        $("#datagrid").datagrid("options").url = "${path}/sysrole/datagrid";
                                        $("#datagrid").datagrid("load");
                                    } else {
                                        $.messager.alert('错误提示', result.msg);
                                    }
                                });
                    }
                });

            } else {
                $.messager.alert('提示', '请先选中要删除的行');
            }
        }

        function DistributionRole() {
            var row = $("#datagrid").datagrid('getSelected');
            if (row) {
                var id = row.id;
                $('#iframe1')[0].src = '${path}/sysrole/distribution?id=' + id;
                $('#openRoleDiv').dialog('open');
            } else {
                $.messager.alert('提示', '请选择要分配权限的角色！', 'error');
            }
        }

        function saveConfig() {

            window.frames["iframe1"].save();
        }

        function linkDisable() {
            $("#btnok").linkbutton("disable");
        }
        function linkShow() {
            $("#btnok").linkbutton("enable");
        }
    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 用户信息列表 -->
    <table id="datagrid" title="角色管理" class="easyui-datagrid" fit="true"
           url="${path}/sysrole/datagrid" toolbar="#toolbar" pagination="false"
           fitColumns="false" singleSelect="true" rownumbers="true"
           border="false" nowrap="true">
        <thead>
        <tr>
            <th field="id" width="100" hidden="true">用户编号</th>
            <th field="rolename" width="100">角色名称</th>
            <th field="memo" width="200">备注</th>
        </tr>
        </thead>
    </table>

    <!-- 按钮 -->
    <div id="toolbar">
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-add" plain="true" onclick="addRole();">新增</a> <a
            href="javascript:void(0);" class="easyui-linkbutton"
            iconCls="icon-edit" plain="true" onclick="editRole();">编辑</a> <a
            href="javascript:void(0);" class="easyui-linkbutton"
            iconCls="icon-remove" plain="true" onclick="deleteRole();">删除</a><a
            href="javascript:void(0);" class="easyui-linkbutton"
            iconCls="icon-remove" plain="true" onclick="DistributionRole();">分配角色权限</a>

    </div>

    <!-- 对话框 -->
    <div id="configdlg" class="easyui-dialog"
         style="width:310px;height:300px;padding:10px 20px" closed="true"
         buttons="#dlg-buttons">
        <form id="configfm" method="post" novalidate>

            <table>
                <input id="id" name="id" type="hidden"></td>
                <tr>
                    <td align="right">*角色名称:</td>
                    <td><input id="rolename" name="rolename" style="width: 150px" class="easyui-validatebox" required="true">
                    </td>
                </tr>
                <tr>
                    <td align="right">备注:</td>
                    <td><input id="memo" name="memo" type="text" style="width: 150px" class="easyui-validatebox"></td>
                </tr>
            </table>
        </form>
    </div>

    <!-- 对话框按钮 -->
    <div id="dlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="saveRole()" style="width:90px">保存</a> <a
            href="javascript:void(0)" class="easyui-linkbutton"
            iconCls="icon-cancel" onclick="javascript:$('#configdlg').dialog('close')"
            style="width:90px">取消</a>
    </div>


    <div id="openRoleDiv" class="easyui-dialog" closed="true" modal="true" title="分配角色"
         style="width:800px;height:450px;" buttons="#configdlg-buttons">
        <iframe scrolling="auto" id='iframe1' name='iframe1' frameborder="0"
        &lt;%&ndash;     src="${path}/configdeal/dealinfo"  &ndash;%&gt;
                style="width:100%;height:100%;"></iframe>
    </div>

    <div id="configdlg-buttons">
        <a id="btnok"  href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="saveConfig()" style="width:60px">保存</a> <a
            href="javascript:void(0)" class="easyui-linkbutton"
            iconCls="icon-cancel" onclick="javascript:$('#openRoleDiv').dialog('close')"
            style="width:60px">取消</a>
    </div>

</div>
</body>
</html>
