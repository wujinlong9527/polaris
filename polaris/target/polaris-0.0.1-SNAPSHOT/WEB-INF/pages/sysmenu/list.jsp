<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>菜单管理</title>
    <%@include file="/WEB-INF/pages/include/easyui.jsp" %>
    <!-- 对话框的样式 -->
    <link href="${path}/css/userList.css" rel="stylesheet" type="text/css"/>

    <script type="text/javascript">
        var url;
        var mesTitle;
        window.onload = function () {

            $('#parentId').combobox({
                editable: false, //编辑状态
                cache: false,
                panelHeight: 'auto',//自动高度适合
                valueField: 'id',
                textField: 'text'
            });

            $.ajax({
                type: "POST",
                url: "${path}/sysmenu/getParentName",
                cache: false,
                dataType: "json",
                success: function (data) {

                    $("#parentId").combobox("loadData", data.rows);
                }
            });

            $('#isParentId').combobox({
                onSelect: function (record) {
                    if (record.id == 0) {
                        $("#parentId").combobox({required: true});
                        $("#parentId").combobox('enable');
                    }
                    else if (record.id == 1) {
                        $("#parentId").combobox({required: false});
                        $("#parentId").combobox('disable');
                    }
                }
            });

        }


        //查询列表
        function searchOrder() {
            $("#datagrid").treegrid("options").url = "${path}/sysmenu/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").treegrid("load");
        }

        //重置
        function onReset() {
            $("#text").textbox('setValue', "");
            $("#datagrid").treegrid("options").url = "${path}/sysmenu/datagrid";
            $("#datagrid").treegrid("load");
        }

        //弹出新增界面
        function addMemu() {
            $('#configdlg').dialog('open').dialog('setTitle', '新增菜单');
            $('#configfm').form('clear');
            $('#id').val("0");
            $('#parentId').combobox("setValue", "0");
            $('#parentId').combobox("setText", "");
            mesTitle = '新增菜单成功';
        }

        //新增保存
        function saveConfig() {
            $('#configfm').form('submit', {
                url: path + "/sysmenu/addSysMemu",
                onSubmit: function () {
                    return $(this).form('validate');
                },
                success: function (result) {
                    var result = eval('(' + result + ')');
                    if (result.success) {
                        $('#configdlg').dialog('close');
                        $('#datagrid').treegrid('reload');
                    } else {
                        mesTitle = '新增菜单失败';
                    }
                    $.messager.show({
                        title: mesTitle,
                        msg: result.msg
                    });
                }
            });
        }

        function editMemu() {
            var row = $('#datagrid').treegrid('getSelected');
            if (row) {
                var id = row.id;
                $('#configdlg').dialog('open').dialog('setTitle', '编辑菜单');
                $('#configfm').form('load', row);

                if (row.parentId == 0) {
                    $("#parentId").combobox({required: false});
                    $("#parentId").combobox('disable');
                }
                else {
                    $("#parentId").combobox({required: true});
                    $("#parentId").combobox('enable');
                    $("#parentId").combobox("setText", row.parentId);
                    $("#parentId").combobox("setValue", row.parentId);
                }
            } else {
                $.messager.alert('提示', '请选择要编辑的记录！', 'error');
            }
        }

        function deleteMemu() {
            var record = $("#datagrid").treegrid('getSelected');
            if (record) {
                if (record.children) {
                    $.messager.alert('错误提示', "根节点下有子节点，不能删除！");
                    return;
                }

                $.messager.confirm("删除", "是否删除", function (r) {
                    if (r) {

                        $.post('${path}/sysmenu/deleteSysMenu',
                                {id: record.id},
                                function (result) {
                                    var result = eval('(' + result + ')');
                                    if (result.success) {
                                        $.messager.alert('消息提示', "删除成功");
                                        $("#datagrid").treegrid("options").url = "${path}/sysmenu/datagrid";
                                        $("#datagrid").treegrid("load");
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

        function formatIsdel(val, row) {
            if (val == 0) {
                return '<span>' + '启用' + '</span>';
            } else {
                return '<span style="color:red;">' + '禁用' + '</span>';
            }
        }

        //格式换显示状态
        function formatdata(val, row) {
            if (row.isParentId == 0 && row.isdel == 0) {
                return '<a class="editcls" onclick="editRow(\'' + row.id + '\')" href="javascript:void(0)">查看</a>';
            }
        }

        function editRow(id) {
            $('#iframe1')[0].src = '${path}/sysmenu/buttonInfo?menuId=' + id;
            $('#openRoleDiv').dialog('open');
        }

        function disableMenu() {
            var record = $("#datagrid").treegrid('getSelected');

            if (record) {
                if (1 == record.isdel) {
                    $.messager.alert('错误提示', "菜单已禁用，不需再次禁用！");
                    return;
                }

                if (record.children) {
                    $.messager.alert('错误提示', "根节点下有子节点，不能禁用！");
                    return;
                }

                $.messager.confirm("禁用", "是否禁用", function (r) {
                    if (r) {

                        $.post('${path}/sysmenu/disableMenu',
                                {id: record.id},
                                function (result) {
                                    var result = eval('(' + result + ')');
                                    if (result.success) {
                                        $.messager.alert('消息提示', "禁用成功");
                                        $("#datagrid").treegrid("options").url = "${path}/sysmenu/datagrid";
                                        $("#datagrid").treegrid("load");
                                    } else {
                                        $.messager.alert('错误提示', "禁用失败");
                                    }
                                });
                    }
                });

            } else {
                $.messager.alert('提示', '请先选中要禁用的行');
            }
        }

        function enableMenu() {
            var record = $("#datagrid").treegrid('getSelected');

            if (record) {
                if (0 == record.isdel) {
                    $.messager.alert('错误提示', "菜单已启用，不需再次启用！");
                    return;
                }

                $.messager.confirm("启用", "是否启用", function (r) {
                    if (r) {
                        $.post('${path}/sysmenu/enableMenu',
                                {id: record.id},
                                function (result) {
                                    var result = eval('(' + result + ')');
                                    if (result.success) {
                                        $.messager.alert('消息提示', "启用成功");
                                        $("#datagrid").treegrid("options").url = "${path}/sysmenu/datagrid";
                                        $("#datagrid").treegrid("load");
                                    } else {
                                        $.messager.alert('错误提示', "启用失败");
                                    }
                                });
                    }
                });

            } else {
                $.messager.alert('提示', '请先选中要启用的行');
            }
        }
    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">

    <table id="datagrid" class="easyui-treegrid"
           data-options="url:'${path}/sysmenu/datagrid',idField:'id',treeField:'text'"
           title="菜单查询" fit="true" toolbar="#toolbar" fitColumns="false"
           singleSelect="true" rownumbers="true" border="false" nowrap="true">
        <thead>
        <tr>
            <th data-options="field:'id',width:40">编号</th>
            <th data-options="field:'text',width:150">资源名称</th>
            <th data-options="field:'url',width:200">资源路径</th>
            <th data-options="field:'sequence',width:50">排序</th>
            <th data-options="field:'iconCls',width:80">图标</th>
            <th data-options="field:'parentId',width:80">上级资源ID</th>
            <th data-options="field:'isdel',width:50" formatter="formatIsdel">状态</th>
          <%--  <th data-options="field:'opt',width:120" formatter="formatdata" >操作</th>--%>
        </tr>
        </thead>
    </table>

    <!-- 按钮 -->

    <div id="toolbar" class="easyui-layout"
         style="width:100%;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <form id="fmorder" name="fmorder" method="post">
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <label>名称:</label> <input id="text" name="text" class="easyui-textbox" style="width: 160px">


                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchOrder();">查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
            </div>
        </form>

        <div id="toolbar1">
            <a href="javascript:void(0);" class="easyui-linkbutton"
               iconCls="icon-add" plain="true" onclick="addMemu();">新增</a>
            <a href="javascript:void(0);" class="easyui-linkbutton"
                iconCls="icon-edit" plain="true" onclick="editMemu();">编辑</a>
            <a href="javascript:void(0);" class="easyui-linkbutton"
               iconCls="icon-remove" plain="true" onclick="disableMenu();">禁用</a>
            <a href="javascript:void(0);" class="easyui-linkbutton"
               iconCls="icon-remove" plain="true" onclick="enableMenu();">启用</a>
            <a href="javascript:void(0);" class="easyui-linkbutton"
                iconCls="icon-remove" plain="true" onclick="deleteMemu();">删除</a>
        </div>

    </div>

    <!-- 对话框 -->
    <div id="configdlg" class="easyui-dialog"
         style="width:400px;height:280px;padding:10px 20px" closed="true"
         buttons="#configdlg-buttons">
        <form id="configfm" method="post" novalidate>

            <table>
                <input id="id" name="id" type="hidden"></td>
                <tr>
                    <td align="right">*根节点:</td>
                    <td><input id="isParentId" name="isParentId" class="easyui-combobox" style="width: 150px"
                               data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'0',text:'否'},{id:'1',text:'是'}]" required="true"></td>
                    </td>
                </tr>
                <tr>
                    <td align="right">*根节点名称:</td>
                    <td>
                        <input id="parentId" name="parentId" style="width: 150px"></td>
                    </td>
                </tr>

                <tr>
                    <td align="right">*菜单名称:</td>
                    <td><input id="dlgtext" name="text" type="text" style="width: 145px" class="easyui-validatebox"
                               required="true"></td>
                </tr>
                <tr>
                    <td align="right">*菜单顺序:</td>
                    <td><input id="sequence" name="sequence" type="text" style="width: 145px" required="true"
                               class="easyui-validatebox">
                    </td>
                </tr>
                <tr>
                    <td align="right">菜单图标样式:</td>
                    <td><input id="iconCls" name="iconCls" type="text" style="width: 145px" class="easyui-validatebox">
                    </td>
                </tr>
                <tr>
                    <td align="right">菜单链接地址:</td>
                    <td><input id="url" name="url" type="text" style="width: 145px" class="easyui-validatebox"></td>
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

    <div id="openRoleDiv" class="easyui-dialog" closed="true" modal="true" title="按钮信息"
         style="width:500px;height:400px;">
        <iframe scrolling="auto" id='iframe1' frameborder="0"
                style="width:100%;height:100%;"></iframe>
    </div>

</div>

</body>
</html>
