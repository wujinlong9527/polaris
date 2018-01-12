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
            $("#datagrid").datagrid("options").url = "${path}/express/datagridgroup?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");

        }

        function searchOrder() {
            $("#datagrid").datagrid("options").url = "${path}/express/datagridgroup?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        function onReset() {
            $("#tj").textbox('setValue', '');
            $("#datagrid").datagrid("options").url = "${path}/express/datagridgroup?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        function addGroup() {
            $('#configfm').form('clear');
            $("#teamid").textbox('textbox').attr('readonly',false);
            $('#configdlg').dialog('open').dialog('setTitle', '新增物流组');
            $('#id').val("0");
            url = path + "/express/addExpGroup";
        }

        function editGroup() {
            $("#teamid").textbox('textbox').attr('readonly',true);
            url = path + "/express/addExpGroup";
            var row = $('#datagrid').datagrid('getSelected');
            if (row) {
                var id = row.id;
                $('#configdlg').dialog('open').dialog('setTitle', '编辑物流组');
                $('#configfm').form('load', row);//这句话有问题，第一次加载时正确的，第二次就出错了，还保持第一次的数据
            } else {
                $.messager.alert('提示', '请选择要编辑的记录！', 'error');
            }
        }

        function delGroup() {
            var record = $("#datagrid").datagrid('getSelected');
            if (record) {
                $.messager.confirm("删除", "确定删除物流组？", function (r) {
                    if (r) {
                        $.post('${path}/express/delTeam',
                        {id: record.id},
                        function (result) {
                            var result = eval('(' + result + ')');
                            if (result.success) {
                                $.messager.alert("提示",result.msg,"info");
                                $("#datagrid").datagrid("options").url = "${path}/express/datagridgroup";
                                $("#datagrid").datagrid("load");
                            } else {
                                $.messager.alert("提示",result.msg,"error");
                            }
                        });
                    }
                });
            } else {
                $.messager.alert('提示', '请先选中要删除的行','info');
            }
        }

        function saveExpGroup() {
            var id = $("#teamid").textbox("getValue").trim();
            var name = $("#teamname").textbox("getValue").trim();
            if(id==null ||id==''){
                $.messager.alert("提示","物流组编码不能为空","warning");
                return;
            }
            if(name==null ||name==''){
                $.messager.alert("提示","物流组名称不能为空","warning");
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
                        $("#datagrid").datagrid("options").url = "${path}/express/datagridgroup";
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
    <table id="datagrid" title="物流组管理" class="easyui-datagrid" fit="true" toolbar="#toolbar"
           pagination="true" fitColumns="false" singleSelect="true" rownumbers="true" border="false" nowrap="true">
        <thead>
        <tr>
            <th field="id" width="120" align="center" hidden="true">id</th>
            <th field="teamid" width="120" align="center">物流组编号</th>
            <th field="teamname" width="260" align="center">物流组名称</th>
            <th field="inserttime" width="160" align="center">创建时间</th>
        </tr>
        </thead>
    </table>

    <!-- 按钮 -->
    <div id="toolbar" class="easyui-layout"
         style="width:100%;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <form id="fmorder" name="fmorder" method="post">
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-left: 6px" align="left">

                <label>物流组编号:</label> <input id="tj" name="tj" class="easyui-textbox" style="width: 160px">

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

                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-remove" plain="true" onclick="delGroup();">删除</a>
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
                    <td align="right">*物流组编号:</td>
                         <td><input id="teamid" name="teamid" style="width: 150px" class="easyui-textbox">
                    </td>
                </tr>
                <tr>
                    <td align="right">*物流组名称:</td>
                         <td><input id="teamname" name="teamname" style="width: 150px" class="easyui-textbox">
                    </td>
                </tr>
            </table>
        </form>
    </div>

    <!-- 对话框按钮 -->
    <div id="dlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="saveExpGroup()" style="width:90px">保存</a> <a
            href="javascript:void(0)" class="easyui-linkbutton"
            iconCls="icon-cancel" onclick="javascript:$('#configdlg').dialog('close')"
            style="width:90px">取消</a>
    </div>

</div>
</body>
</html>
