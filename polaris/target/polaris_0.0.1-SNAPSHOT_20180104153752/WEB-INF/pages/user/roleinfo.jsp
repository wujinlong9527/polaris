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

            $('#datagrid').datagrid({
                onLoadSuccess: function (row) {//当表格成功加载时执行
                    var rowData = row.rows;
                    $.each(rowData, function (idx, val) {//遍历JSON
                        if (val.isSelected) {
                            $("#datagrid").datagrid("selectRow", idx);//如果数据行为已选中则选中改行
                        }
                    });
                }
            });

            $("#datagrid").datagrid("options").url
                    = "${path}/user/roledatagrid?userid=" + $('#userId').val();
            $("#datagrid").datagrid("load");

        }

        function save() {
            var array = $('#datagrid').datagrid('getChecked');
            var ids = "";

            for (var i = 0; i < array.length; i++) {//组成一个字符串，ID主键之间用逗号隔开
                if (ids == "") {
                    ids = array[i].id;
                } else {
                    ids = ids + "," + array[i].id;
                }
            }

            $.post('${path}/user/saveuserrole',
                    {ids: ids, userId: $('#userId').val()},
                    function (result) {
                        var result = eval('(' + result + ')');
                        if (result.success) {
//                            $.messager.alert('消息提示', "授权成功");
//                            $("#successful").val("successful");
                            parent.$.messager.alert('消息提示', "授权成功");
                            parent.$('#openRoleDiv').window('close');
                        } else {
                            $.messager.alert('错误提示', "授权失败");
                        }
                    });
        }


    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 策略信息列表 -->
    <input id="userId" name="userId" type="hidden" value="${users.id}"></td>
    <table id="datagrid" class="easyui-datagrid" fit="true"
                   url="" toolbar="#toolbar" pagination="fasle"
                   fitColumns="false" singleSelect="false" rownumbers="true"
                   border="false" nowrap="true">
    <thead>
    <tr>
        <th field="ck" checkbox="true" checked="true"></th>
        <th field="id" width="60" hidden="true">编号</th>
        <th field="rolename" width="80">角色</th>
        <th field="memo" width="120">备注</th>
    </tr>
    </thead>
</table>

    <!-- 按钮 -->

</div>

</body>
</html>
