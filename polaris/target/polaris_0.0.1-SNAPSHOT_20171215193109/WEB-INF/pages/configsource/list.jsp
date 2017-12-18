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

        //格式换显示状态
        function formatIsdel(val, row) {
            if (val == 1) {
                return '<span style="color:red;">' + '已删除' + '</span>';
            } else {
                return '<span>' + '未删除' + '</span>';
            }
        }

        //查询列表
        function searchOrder() {
            $("#datagrid").datagrid("options").url = "${path}/configsource/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        //重置
        function onReset() {
            $("#strategy").textbox('setValue', "");
            $("#orderAction").textbox('setValue', "");
            $("#isdel").combobox("setValue", "");
            $("#datagrid").datagrid("options").url = "${path}/configsource/datagrid";
            $("#datagrid").datagrid("load");
        }

        //弹出新增界面
        function addConfig() {
            $('#configdlg').dialog('open').dialog('setTitle', '新增策略');
            $('#configfm').form('clear');
            mesTitle = '新增策略成功';
        }

        //新增保存
        function saveConfig() {
            $('#configfm').form('submit', {
                url: path + "/configsource/addConfigSource",
                onSubmit: function () {
                    return $(this).form('validate');
                },
                success: function (result) {
                    var result = eval('(' + result + ')');
                    if (result.success) {
                        $('#configdlg').dialog('close');
                        $('#datagrid').datagrid('reload');
                    } else {
                        mesTitle = '新增策略失败';
                    }
                    $.messager.show({
                        title: mesTitle,
                        msg: result.msg
                    });
                }
            });
        }

        //删除
        function removeConfig() {
            var record = $("#datagrid").datagrid('getSelected');
            if (record) {
                if (record.isdel == 1) {
                    $.messager.alert('错误提示', "数据已经删除,不需要再次删除！");
                    return;
                }
                $.messager.confirm("删除", "是否删除策略", function (r) {
                    if (r) {
                        $('#delreasondlg').dialog('open').dialog('setTitle', '删除原因');
                        $('#delReason').val("");
                    }
                });

            } else {
                $.messager.alert('提示', '请先选中要删除的行');
            }
        }


        function save() {

            //去空格 replace(/(^\s*)|(\s*$)/, "")
            if ($('#delReason').val().replace(/(^\s*)|(\s*$)/, "") == "") {
                $.messager.alert('提示', '删除原因不能为空！');
                return;
            }

            var record = $("#datagrid").datagrid('getSelected');
            $.post('${path}/configsource/upConfigSourceState',
                    {isdel: 1, delReason: $('#delReason').val(), gid: record.gid},
                    function (result) {
                        var result = eval('(' + result + ')');
                        if (result.success) {
                            $('#delreasondlg').dialog('close');
                            $.messager.alert('消息提示', "删除策略成功");
                            $("#datagrid").datagrid("options").url = "${path}/configsource/datagrid";
                            $("#datagrid").datagrid("load");
                        } else {
                            $.messager.alert('错误提示', "删除策略失败");
                        }
                    });
        }

        function recoverConfig() {
            var record = $("#datagrid").datagrid('getSelected');
            if (record) {
                if (record.isdel == 0) {
                    $.messager.alert('错误提示', "数据为未删除状态,不需要恢复！");
                    return;
                }
                $.messager.confirm("恢复", "是否恢复策略", function (r) {
                    if (r) {

                        $.post('${path}/configsource/upConfigSourceState',
                                {isdel: 0, delReason: "", gid: record.gid},
                                function (result) {
                                    var result = eval('(' + result + ')');
                                    if (result.success) {
                                        $.messager.alert('消息提示', "恢复策略成功");
                                        $("#datagrid").datagrid("options").url = "${path}/configsource/datagrid";
                                        $("#datagrid").datagrid("load");
                                    } else {
                                        $.messager.alert('错误提示', "恢复策略失败");
                                    }
                                });
                    }
                });

            } else {
                $.messager.alert('提示', '请先选中要恢复的行');
            }
        }

    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 策略信息列表 -->
    <table id="datagrid" title="支付通道管理" class="easyui-datagrid" fit="true"
           url="${path}/configsource/datagrid" toolbar="#toolbar" pagination="true"
           fitColumns="false" singleSelect="true" rownumbers="true"
           border="false" nowrap="true">
        <thead>
        <tr>
            <th field="gid" width="80" hidden="true">gid</th>
            <th field="sourceChannel" width="80">来源渠道</th>
            <th field="sourceSubChannel" width="200">来源子渠道</th>
            <th field="strategy" width="150">策略名称</th>
            <th field="orderAction" width="150">业务类型</th>
            <th field="isdel" width="80" formatter="formatIsdel">删除标识</th>
            <th field="insertTime" width="140">创建时间</th>
            <th field="operateTime" width="140">操作时间</th>
            <th field="delReason" width="150">删除原因</th>
        </tr>
        </thead>
    </table>


    <c:if test="${button.size()>0}">
    <div id="toolbar" class="easyui-layout"
         style="width:100%;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <form id="fmorder" name="fmorder" method="post">
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <label>策略名称:</label> <input id="strategy" name="strategy" class="easyui-textbox" style="width: 100px">
                <label>业务类型:</label> <input id="orderAction" name="orderAction" class="easyui-combobox" style="width: 80px"
                                            data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'消费',text:'消费'},{id:'鉴权验证',text:'鉴权验证'},{id:'预授权',text:'预授权'}]">
                <%--<input id="orderAction" name="orderAction" class="easyui-textbox"
                                            style="width: 100px">--%>
                <label>删除标识:</label> <input id="isdel" name="isdel" class="easyui-combobox" style="width: 80px"
                                            data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'',text:'不限'},{id:'0',text:'未删除'},{id:'1',text:'已删除'}]">

                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchOrder();">查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
            </div>
        </form>
        <div id="toolbar">
            <c:forEach var="button" items="${button}">
                <c:if test="${button.menu_button == 'add'}">
                    <a href="javascript:void(0);" class="easyui-linkbutton"
                       iconCls="icon-add" plain="true" onclick="addConfig();">添加</a>
                </c:if>
                <c:if test="${button.menu_button == 'delete'}">
                    <a href="javascript:void(0);" class="easyui-linkbutton"
                       iconCls="icon-remove" plain="true" onclick="removeConfig();">删除</a>
                </c:if>
                <c:if test="${button.menu_button == 'recover'}">
                    <a href="javascript:void(0);" class="easyui-linkbutton"
                       iconCls="icon-remove" plain="true" onclick="recoverConfig();">恢复</a>
                </c:if>
            </c:forEach>
        </div>
    </div>
    </c:if>


    <c:if test="${button.size()==0}">
    <div id="toolbar" class="easyui-layout"
         style="width:100%;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <form id="fmorder" name="fmorder" method="post">
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <label>策略名称:</label> <input id="strategy" name="strategy" class="easyui-textbox"
                                            style="width: 100px">
                <label>业务类型:</label> <input id="orderAction" name="orderAction" class="easyui-combobox" style="width: 80px"
                                            data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'消费',text:'消费'},{id:'鉴权验证',text:'鉴权验证'},{id:'预授权',text:'预授权'}]">
                <%--<input id="orderAction" name="orderAction" class="easyui-textbox"
                                            style="width: 100px">--%>
                <label>删除标识:</label> <input id="isdel" name="isdel" class="easyui-combobox" style="width: 80px"
                                            data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'',text:'不限'},{id:'0',text:'未删除'},{id:'1',text:'已删除'}]">

                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchOrder();">查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
            </div>
        </form>
        </c:if>


        <!-- 对话框 -->
        <div id="configdlg" class="easyui-dialog"
             style="width:400px;height:280px;padding:10px 20px" closed="true"
             buttons="#configdlg-buttons">
            <form id="configfm" method="post" novalidate>

                <table>
                    <tr>
                        <td align="right">*来源渠道:</td>
                        <td><input id="sourceChannel" name="sourceChannel" type="text"
                                   class="easyui-validatebox"
                                   required="true"></td>
                    </tr>
                    <tr>
                        <td align="right">*来源子渠道:</td>
                        <td><input id="sourceSubChannel" name="sourceSubChannel" type="text"
                                   class="easyui-validatebox"
                                   required="true"></td>
                    </tr>
                    <tr>
                        <td align="right">*业务类型:</td>
                        <td><input id="orderAction" name="orderAction" type="text" class="easyui-validatebox"
                                   required="true"></td>
                    </tr>
                    <tr>
                        <td align="right">*策略名称:</td>
                        <td><input id="strategy" name="strategy" type="text" class="easyui-validatebox"
                                   required="true">
                        </td>
                    </tr>

                </table>
            </form>
        </div>

        <div id="delreasondlg" class="easyui-dialog"
             style="width:300px;height:120px;padding:10px 20px" closed="true"
             buttons="#delreason-buttons">
            <tr>
                <td>*删除原因:</td>
                <td><input id="delReason" name="delReason" type="text"></td>
            </tr>
        </div>

        <!-- 对话框按钮 -->
        <div id="configdlg-buttons">
            <a href="javascript:void(0)" class="easyui-linkbutton c6"
               iconCls="icon-ok" onclick="saveConfig()" style="width:60px">保存</a> <a
                href="javascript:void(0)" class="easyui-linkbutton"
                iconCls="icon-cancel" onclick="javascript:$('#configdlg').dialog('close')"
                style="width:60px">取消</a>
        </div>

        <!-- 对话框按钮 -->
        <div id="delreason-buttons">
            <a href="javascript:void(0)" class="easyui-linkbutton c6"
               iconCls="icon-ok" onclick="save()" style="width:60px">保存</a> <a
                href="javascript:void(0)" class="easyui-linkbutton"
                iconCls="icon-cancel" onclick="javascript:$('#delreasondlg').dialog('close')"
                style="width:60px">取消</a>
        </div>
    </div>


</body>
</html>
