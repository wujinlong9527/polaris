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
            $("#datagrid").datagrid("options").url
                    = "${path}/sysmenu/selectButton?menuId=" + $('#menuId').val();
            $("#datagrid").datagrid("load");
        }

        //弹出新增界面
        function addConfig() {
            $('#configdlg').dialog('open').dialog('setTitle', '添加按钮');
            $('#configfm').form('clear');
            $('#id').val("0");
            $('#dlgmenuId').val($('#menuId').val());
            mesTitle = '保存成功';
        }

        //新增保存
        function saveConfig() {
            $('#configfm').form('submit', {
                url: path + "/sysmenu/addMemuButton",
                onSubmit: function () {
                    return $(this).form('validate');
                },
                success: function (result) {
                    var result = eval('(' + result + ')');
                    if (result.success) {
                        $('#configdlg').dialog('close');
                        $("#datagrid").datagrid("options").url
                                = "${path}/sysmenu/selectButton?menuId=" + $('#menuId').val();
                        $('#datagrid').datagrid('reload');
                    } else {
                        mesTitle = '新增按钮失败';
                    }
                    $.messager.show({
                        title: mesTitle,
                        msg: result.msg
                    });
                }
            });
        }

        function deleteButton() {
            var record = $("#datagrid").datagrid('getSelected');
            if (record) {
                $.messager.confirm("删除", "是否删除", function (r) {
                    if (r) {

                        $.post('${path}/sysmenu/deleteMenuButton',
                                {id: record.id},
                                function (result) {
                                    var result = eval('(' + result + ')');
                                    if (result.success) {
                                        $.messager.alert('消息提示', "删除成功");
                                        $("#datagrid").datagrid("options").url = "${path}/sysmenu/selectButton?menuId=" + $('#menuId').val();
                                        $("#datagrid").datagrid("load");
                                    } else {
                                        $.messager.alert('错误提示', "删除失败");
                                    }
                                });
                    }
                });

            } else {
                $.messager.alert('提示', '请先选中要删除的行');
            }
        }

        function editButton() {
            var row = $('#datagrid').datagrid('getSelected');
            if (row) {
                var id = row.id;
                $('#configdlg').dialog('open').dialog('setTitle', '编辑按钮');
                $('#configfm').form('load', row);//这句话有问题，第一次加载时正确的，第二次就出错了，还保持第一次的数据
//                url = path + "/user/editUser?id=" + id;
                mesTitle = '编辑按钮成功';
            } else {
                $.messager.alert('提示', '请选择要编辑的记录！', 'error');
            }
        }

    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 策略信息列表 -->
    <table id="datagrid" class="easyui-datagrid" fit="true"
           url="" toolbar="#toolbar" pagination="fasle"
           fitColumns="false" singleSelect="true" rownumbers="true"
           border="false" nowrap="true">
        <thead>
        <tr>
            <th field="cName" width="80">按钮类型</th>
            <th field="eName" width="120">按钮名称</th>
        </tr>
        </thead>
    </table>

    <!-- 按钮 -->


    <div id="toolbar">
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-add" plain="true" onclick="addConfig();">添加</a><a
            href="javascript:void(0);" class="easyui-linkbutton"
            iconCls="icon-edit" plain="true" onclick="editButton();">编辑</a><a
            href="javascript:void(0);" class="easyui-linkbutton"
            iconCls="icon-remove" plain="true" onclick="deleteButton();">删除</a>
        <input id="menuId" name="menuId" type="hidden" value="${sysmenu.menuId}"></td>
    </div>

<%--
<c:if test="${button.size()>0}">
    <div id="toolbar1">
    <c:forEach var="button" items="${button}">
        <c:if test="${button.menu_button == 'add'}">
            < a href=" " class="easyui-linkbutton"
            iconCls="icon-add" plain="true" onclick="addConfig();">添加</ a>
        </c:if>
        <c:if test="${button.menu_button == 'edit'}">
            < a href="javascript:void(0);" class="easyui-linkbutton"
            iconCls="icon-remove" plain="true" onclick="editConfig();">编辑</ a>
        </c:if>
        <c:if test="${button.menu_button == 'delete'}">
            < a href="javascript:void(0);" class="easyui-linkbutton"
            iconCls="icon-remove" plain="true" onclick="removeConfig();">删除</ a>
        </c:if>
        <c:if test="${button.menu_button == 'recover'}">
            < a href="javascript:void(0);" class="easyui-linkbutton"
            iconCls="icon-remove" plain="true" onclick="recoverConfig();">恢复</ a>
        </c:if>
    </c:forEach>
    </div>
</c:if>--%>




    <!-- 对话框 -->
    <div id="configdlg" class="easyui-dialog"
         style="width:400px;height:300px;padding:10px 20px" closed="true"
         buttons="#configdlg-buttons">
        <form id="configfm" method="post" novalidate>

            <table>
                <input id="id" name="id" type="hidden"></td>
                <input id="dlgmenuId" name="menuId" type="hidden"></td>

                <tr>
                    <td align="right">*按钮类型:</td>
                    <td><input id="cName" name="cName" type="text" style="width: 145px" class="easyui-validatebox"
                               required="true"></td>
                </tr>
                <tr>
                    <td align="right">*按钮名称:</td>
                    <td><input id="eName" name="eName" type="text" style="width: 145px" class="easyui-validatebox"
                               required="true"></td>
                </tr>
            </table>
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
