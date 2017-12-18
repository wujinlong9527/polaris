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

        window.onload = function () {
            $('#openRoleDiv').dialog({
                onClose: function () {
                    $("#datagrid").datagrid("options").url = "${path}/user/datagrid?" + $("#fmorder").serialize();
                    $("#datagrid").datagrid("load");
                }
            });
        }



        var url;
        var mesTitle;

        //查询列表
        function searchOrder() {
            $("#datagrid").datagrid("options").url = "${path}/user/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        //重置
        function onReset() {
            $("#userId").textbox('setValue', "");
            $("#datagrid").datagrid("options").url = "${path}/user/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }



        function addUser() {
            $("#account").attr("readonly", false);
            $("#groupid").attr("readonly", false);
            $("#groupname").attr("readonly", false);
            $("#sehide").show();
            $("#aab301hide").show();
            $('#configdlg').dialog('open').dialog('setTitle', '新增用户');
            $('#configfm').form('clear');
            $('#id').val("0");
            url = path + "/user/addUser";
            mesTitle = '新增用户成功';
        }

        function editUser() {
            var row = $('#datagrid').datagrid('getSelected');
            if (row) {
                var id = row.id;
                $("#account").attr("readonly", true);
                $("#groupid").attr("readonly", true);
                $("#groupname").attr("readonly", true);
                $("#sehide").hide();
                $("#aab301hide").hide();
                $('#configdlg').dialog('open').dialog('setTitle', '编辑用户');
                $('#configfm').form('load', row);//这句话有问题，第一次加载时正确的，第二次就出错了，还保持第一次的数据
                url = path + "/user/editUser?id=" + id;
                mesTitle = '编辑用户成功';
            } else {
                $.messager.alert('提示', '请选择要编辑的记录！', 'info');
            }
        }

        function saveUser() {
            if ($('#password').val().replace(/(^\s*)|(\s*$)/, "") == "") {
                $.messager.alert('提示', '密码不能为空！');
                return;
            }

            if($('#password').val().length < 6){
                $.messager.alert('提示', '密码长度必须大于6位！');
                return;
            }

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
                        $("#datagrid").datagrid("options").url = "${path}/user/datagrid";
                        $("#datagrid").datagrid("load");
                        $.messager.alert('提示', result.msg);
                    } else {
                        mesTitle = '新增用户失败';
                        $.messager.alert('提示', mesTitle);
                    }
                }
            });
        }

        //格式换显示状态
        function formatsex(val, row) {
            if (val == 1) {
                return '<span >' + '男' + '</span>';
            } else if (val == 2) {
                return '<span>' + '女' + '</span>';
            }
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

        function deleteUser() {
            var record = $("#datagrid").datagrid('getSelected');
            if (record) {
                $.messager.confirm("删除", "是否删除", function (r) {
                    if (r) {

                        $.post('${path}/user/deleteUser',
                                {id: record.id},
                                function (result) {
                                    var result = eval('(' + result + ')');
                                    if (result.success) {
                                        $.messager.alert('消息提示', "删除成功");
                                        $("#datagrid").datagrid("options").url = "${path}/user/datagrid";
                                        $("#datagrid").datagrid("load");
                                    } else {
                                        $.messager.alert('错误提示', "删除失败");
                                    }
                                });
                    }
                });

            } else {
                $.messager.alert('提示', '请先选中要删除的行','info');
            }
        }

        function setRole() {
            var record = $("#datagrid").datagrid('getSelected');
            if (record) {
                $('#iframe1')[0].src = '${path}/user/roleinfo?id=' + record.id;
                $('#openRoleDiv').dialog('open');
            } else {
                $.messager.alert('提示', '请先选中用户','info');
            }
        }

        function saveConfig() {
            window.frames["iframe1"].save();
        }

    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 用户信息列表 -->
    <table id="datagrid" title="用户管理" class="easyui-datagrid" fit="true"
           url="${path}/user/datagrid" toolbar="#toolbar" pagination="true"
           fitColumns="true" singleSelect="true" rownumbers="true"
           border="false" nowrap="true">
        <thead>
        <tr>
            <th field="id" width="100" hidden="true">用户编号</th>
            <th field="account" width="100">账号</th>
            <th field="username" width="100">用户姓名</th>
            <th field="roleName" width="100">角色</th>
            <th field="groupname" width="100">商户名称</th>
            <th field="groupid" width="100">商户号</th>
            <th field="sex" width="40" formatter="formatsex">性别</th>
            <th field="telphone" width="100">电话</th>
            <th field="aab301" width="100" formatter="formataab302">用户所在地</th>
        </tr>
        </thead>
    </table>

    <!-- 按钮 -->
    <div id="toolbar" class="easyui-layout"
         style="width:100%;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">

        <form id="fmorder" name="fmorder" method="post">
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
              <label>根据账号:</label> <input id="userId" name="userId" class="easyui-textbox" style="width: 160px">

                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchOrder();">查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
            </div>
        </form>


        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-add" plain="true" onclick="addUser();">新增用户</a> <a
            href="javascript:void(0);" class="easyui-linkbutton"
            iconCls="icon-edit" plain="true" onclick="editUser();">编辑用户</a> <a
            href="javascript:void(0);" class="easyui-linkbutton"
            iconCls="icon-remove" plain="true" onclick="deleteUser();">删除用户</a>
        <a href="javascript:void(0);" class="easyui-linkbutton"
                iconCls="icon-edit" plain="true" onclick="setRole()">设置角色</a>
    </div>

    <!-- 对话框 -->
    <div id="configdlg" class="easyui-dialog"
         style="width:310px;height:300px;padding:10px 20px" closed="true"
         buttons="#dlg-buttons">
        <form id="configfm" method="post" novalidate>

            <table>
                <input id="id" name="id" type="hidden"></td>
                <tr>
                    <td align="right">*账号:</td>
                    <td><input id="account" name="account" style="width: 150px" class="easyui-validatebox"
                               required="true"></td>
                </tr>
                <tr>
                    <td align="right">*姓名:</td>
                    <td><input id="username" name="username" style="width: 150px" class="easyui-validatebox"
                               required="true"></td>
                </tr>
                <tr>
                    <td align="right">*密码:</td>
                    <td><input id="password" name="password" type="text" style="width: 150px" class="easyui-validatebox"
                               required="true"></td>
                </tr>
                <tr id="sehide">
                    <td align="right">性别:</td>
                    <td><input id="sex" name="sex" style="width: 155px" class="easyui-combobox" data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'1',text:'男'},{id:'2',text:'女'}]"  class="easyui-validatebox" required="true"></td>
                </tr>
                <tr>
                    <td align="right">商户名称:</td>
                    <td><input id="groupname" name="groupname" style="width: 150px" class="easyui-validatebox" required="true"></td>
                </tr>
                <tr>
                    <td align="right">商户号:</td>
                    <td><input id="groupid" name="groupid" style="width: 150px" class="easyui-validatebox" required="true"></td>
                </tr>
                <tr id="aab301hide">
                    <td align="right">用户所在地:</td>
                    <td><input id="aab301" name="aab301" style="width: 150px" class="easyui-combobox" data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'341621',text:'涡阳县'},{id:'341622',text:'蒙城县'},{id:'341623',text:'利辛县'}]"  class="easyui-validatebox" required="true"></td>
                </tr>
                <tr>
                    <td align="right">电话:</td>
                    <td><input id="telphone" name="telphone" style="width: 150px"></td>
                </tr>
            </table>
        </form>
    </div>

    <div id="dlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="saveUser()" style="width:90px">保存</a> <a
            href="javascript:void(0)" class="easyui-linkbutton"
            iconCls="icon-cancel" onclick="javascript:$('#configdlg').dialog('close')"
            style="width:90px">取消</a>
    </div>


    <div id="openRoleDiv" class="easyui-dialog" closed="true" modal="true" title="角色信息"
         buttons="#configdlg-buttons" style="width:500px;height:300px;">
        <iframe scrolling="auto" id='iframe1' name='iframe1' frameborder="0"
                style="width:100%;height:100%;"></iframe>
    </div>

    <div id="configdlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="saveConfig()" style="width:60px">保存</a> <a
            href="javascript:void(0)" class="easyui-linkbutton"
            iconCls="icon-cancel" onclick="javascript:$('#openRoleDiv').dialog('close')"
            style="width:60px">取消</a>
    </div>

</div>
</body>
</html>
