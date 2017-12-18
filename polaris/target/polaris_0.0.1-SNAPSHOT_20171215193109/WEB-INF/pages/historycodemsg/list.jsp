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
            $('#dlgdealSubChannel').combobox({
                editable: true, //编辑状态
                cache: false,
                panelHeight: 'auto',//自动高度适合
                valueField: 'dealSubChannel',
                textField: 'dealSubChannel'
            });

            $('#dealSubChannel').combobox({
                editable: true, //编辑状态
                cache: false,
                panelHeight: 'auto',//自动高度适合
                valueField: 'dealSubChannel',
                textField: 'dealSubChannel'
            });

            $.ajax({
                type: "POST",
                url: "${path}/historycodemsg/getDealSubChannel",
                cache: false,
                dataType: "json",
                success: function (data) {
                    $("#dealSubChannel").combobox("loadData", data.rows);
                    $("#dlgdealSubChannel").combobox("loadData", data.rows);
                }
            });

            $('#dlgcode').combobox({
                editable: true, //编辑状态
                cache: false,
                panelHeight: '100',//自动高度适合
                valueField: 'rowNum',
                textField: 'code',
                onSelect: function (record) {
                    $("#dlgmsg").combobox("setValue", $("#dlgcode").combobox("getValue"));
                }
            });

            $('#dlgmsg').combobox({
                editable: true, //编辑状态
                cache: false,
                panelHeight: '100',//自动高度适合
                valueField: 'rowNum',
                textField: 'msg',
                onSelect: function (record) {
                    $("#dlgcode").combobox("setValue", $("#dlgmsg").combobox("getValue"));
                }
            });

            $.ajax({
                type: "POST",
                url: "${path}/historycodemsg/getCodeList",
                cache: false,
                dataType: "json",
                success: function (data) {
                    $("#dlgcode").combobox("loadData", data.rows);
                    $("#dlgmsg").combobox("loadData", data.rows);
                }
            });

            $('#dlglocalCode').combobox({
                editable: true, //编辑状态
                cache: false,
                panelHeight: '100',//自动高度适合
                valueField: 'rowNum',
                textField: 'localCode',
                onSelect: function (record) {
                    $("#dlglocalMsg").combobox("setValue", $("#dlglocalCode").combobox("getValue"));
                }
            });

            $('#dlglocalMsg').combobox({
                editable: true, //编辑状态
                cache: false,
                panelHeight: '100',//自动高度适合
                valueField: 'rowNum',
                textField: 'localMsg',
                onSelect: function (record) {
                    $("#dlglocalCode").combobox("setValue", $("#dlglocalMsg").combobox("getValue"));
                }
            });

            $.ajax({
                type: "POST",
                url: "${path}/historycodemsg/getLocalCodeList",
                cache: false,
                dataType: "json",
                success: function (data) {
                    $("#dlglocalCode").combobox("loadData", data.rows);
                    $("#dlglocalMsg").combobox("loadData", data.rows);
                }
            });


        }

        //格式换显示状态
        function formatIsdel(val, row) {
            if (val == 1) {
                return '<span style="color:red;">' + '已删除' + '</span>';
            } else if (val == 0) {
                return '<span>' + '未删除' + '</span>';
            } else if (val == 2) {
                return '<span style="color:green;">' + '未审核' + '</span>';
            }
        }

        //查询列表
        function searchOrder() {
            $("#dealSubChannel").combobox("setValue", $("#dealSubChannel").combobox("getText"));
            $("#datagrid").datagrid("options").url = "${path}/historycodemsg/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        //重置
        function onReset() {
            $("#dealSubChannel").combobox('setValue', "");
            $("#code").textbox('setValue', "");
            $("#localMsg").textbox('setValue', "");
            $("#msg").textbox('setValue', "");
            $("#isdel").combobox("setValue", "");
            $("#datagrid").datagrid("options").url = "${path}/historycodemsg/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        //弹出新增界面
        function addConfig() {
            $('#configdlg').dialog('open').dialog('setTitle', '新增错误码');
            $('#configfm').form('clear');
            mesTitle = '新增成功';
        }

        //新增保存
        function saveConfig() {

            $("#dlgdealSubChannel").combobox("setValue", $("#dlgdealSubChannel").combobox("getText"));
            $("#dlgcode").combobox("setValue", $("#dlgcode").combobox("getText"));
            $("#dlgmsg").combobox("setValue", $("#dlgmsg").combobox("getText"));
            $("#dlglocalCode").combobox("setValue", $("#dlglocalCode").combobox("getText"));
            $("#dlglocalMsg").combobox("setValue", $("#dlglocalMsg").combobox("getText"));

            $('#configfm').form('submit', {
                url: path + "/historycodemsg/addCodeMsg",
                onSubmit: function () {
                    return $(this).form('validate');
                },
                success: function (result) {
                    var result = eval('(' + result + ')');
                    if (result.success) {
                        if ($("#gid").val() != '') {
                            $('#configdlg').dialog('close');
                        }
                        $('#datagrid').datagrid('reload');
                    } else {
                        mesTitle = '新增失败';
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

            var array = $('#datagrid').datagrid('getChecked');
            if (array.length > 1) {
                $.messager.alert('错误提示', "删除数据只能选择一条数据！");
                return;
            }

            var record = $("#datagrid").datagrid('getSelected');
            if (record) {

                if (record.isdel == 1) {
                    $.messager.alert('错误提示', "数据已经删除,不需要再次删除！");
                    return;
                }
                if (record.isdel == 2) {
                    $.messager.alert('错误提示', "未审核数据,不能删除！");
                    return;
                }
                $.messager.confirm("删除", "是否删除", function (r) {
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
            $.post('${path}/historycodemsg/upCodeMsgState',
                    {isdel: 1, delReason: $('#delReason').val(), gid: record.gid},
                    function (result) {
                        var result = eval('(' + result + ')');
                        if (result.success) {
                            $('#delreasondlg').dialog('close');
                            $.messager.alert('消息提示', "删除成功");
                            $("#datagrid").datagrid("options").url = "${path}/historycodemsg/datagrid";
                            $("#datagrid").datagrid("load");
                        } else {
                            $.messager.alert('错误提示', "删除失败");
                        }
                    });
        }

        function recoverConfig() {

            var array = $('#datagrid').datagrid('getChecked');
            if (array.length > 1) {
                $.messager.alert('错误提示', "恢复数据只能选择一条数据！");
                return;
            }

            var record = $("#datagrid").datagrid('getSelected');
            if (record) {
                if (record.isdel == 0) {
                    $.messager.alert('错误提示', "数据为未删除状态,不需要恢复！");
                    return;
                }
                if (record.isdel == 2) {
                    $.messager.alert('错误提示', "未审核数据,不能恢复！");
                    return;
                }
                $.messager.confirm("恢复", "是否恢复", function (r) {
                    if (r) {

                        $.post('${path}/historycodemsg/upCodeMsgState',
                                {isdel: 2, delReason: "", gid: record.gid},
                                function (result) {
                                    var result = eval('(' + result + ')');
                                    if (result.success) {
                                        $.messager.alert('消息提示', "恢复成功");
                                        $("#datagrid").datagrid("options").url = "${path}/historycodemsg/datagrid";
                                        $("#datagrid").datagrid("load");
                                    } else {
                                        $.messager.alert('错误提示', "恢复失败");
                                    }
                                });
                    }
                });

            } else {
                $.messager.alert('提示', '请先选中要恢复的行');
            }
        }


        function BatchAudit() {
            var array = $('#datagrid').datagrid('getChecked');
            var ids = "";
            for (var i = 0; i < array.length; i++) {//组成一个字符串，ID主键之间用逗号隔开
                if (array[i].isdel == 2) {
                    if (ids == "") {
                        ids = array[i].gid;
                    } else {
                        ids = ids + "," + array[i].gid;
                    }
                }
            }

            if (array.length > 0) {
                if (ids == "") {
                    $.messager.alert('消息提示', "没有需要审核的数据，请重新勾选！");
                    return;
                }
                $.messager.confirm("审核", "是否批量审核", function (r) {
                    if (r) {
                        $.post('${path}/historycodemsg/batchAudit',
                                {ids: ids},
                                function (result) {
                                    var result = eval('(' + result + ')');
                                    if (result.success) {
                                        $.messager.alert('消息提示', "批量审核成功");
                                        $("#datagrid").datagrid("options").url = "${path}/historycodemsg/datagrid?" + $("#fmorder").serialize();
                                        $("#datagrid").datagrid("load");
                                    } else {
                                        $.messager.alert('错误提示', "审核失败");
                                    }
                                });
                    }
                });
            } else {
                $.messager.alert('提示', "请选择要审核的信息，复选框选中！");
            }
        }

        function editConfig() {

            var array = $('#datagrid').datagrid('getChecked');
            if (array.length > 1) {
                $.messager.alert('错误提示', "编辑数据只能选择一条数据！");
                return;
            }

            var row = $('#datagrid').datagrid('getSelected');
            if (row) {
                $.post('${path}/historycodemsg/selectCodeMsg',
                        {gid: row.gid},
                        function (result) {
                            var result = eval('(' + result + ')');
                            if (result.success) {
                                $("#gid").val(result.obj.gid);
                                $("#dlgdealSubChannel").combobox("setValue", result.obj.dealSubChannel);
                                //$("#dlgorderAction").val(result.obj.orderAction);
                                $("#dlgcode").combobox("setValue", result.obj.code);
                                $("#dlgmsg").combobox("setValue", result.obj.msg);
                                $("#dlglocalCode").combobox("setValue", result.obj.localCode);
                                $("#dlglocalMsg").combobox("setValue", result.obj.localMsg);
                                $("#dlgsolution").val(result.obj.solution);
                                $('#configdlg').dialog('open').dialog('setTitle', '编辑');
                            } else {
                                $.messager.alert('错误提示', "编辑失败");
                            }
                        });

            } else {
                $.messager.alert('提示', '请选择要编辑的记录！', 'error');
            }
        }

    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 错误信息列表 -->
    <table id="datagrid" title="错误码管理" class="easyui-datagrid" fit="true"
           url="${path}/historycodemsg/datagrid" toolbar="#toolbar" pagination="true"
           fitColumns="false" singleSelect="false" rownumbers="true"
           border="false" nowrap="false" checkOnSelect="true" selectOnCheck="true">
        <thead>
        <tr>
            <th field="ck" checkbox="true"></th>
            <th field="gid" width="80" hidden="true">gid</th>
            <th field="dealSubChannel" width="100">处理渠道</th>
            <%--<th field="orderAction" width="80">业务类型</th>--%>
            <th field="code" width="60">渠道代码</th>
            <th field="msg" width="150">渠道信息</th>
            <th field="localCode" width="60">本地代码</th>
            <th field="localMsg" width="150">本地信息</th>
            <th field="solution" width="150">解决方案</th>
            <th field="isdel" width="60" formatter="formatIsdel">状态</th>
            <th field="delReason" width="120">删除原因</th>
            <th field="insertTime" width="100">创建时间</th>
            <th field="operateTime" width="100">操作时间</th>

        </tr>
        </thead>
    </table>

    <!-- 按钮 -->

    <div id="toolbar" class="easyui-layout"
         style="width:100%;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <form id="fmorder" name="fmorder" method="post">
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <label>处理渠道:</label> <input id="dealSubChannel" name="dealSubChannel"
                                            style="width: 120px">
                <label>渠道代码:</label> <input id="code" name="code" class="easyui-textbox" style="width: 100px">
                <label>渠道信息:</label> <input id="msg" name="msg" class="easyui-textbox" style="width: 150px">
                <label>本地信息:</label> <input id="localMsg" name="localMsg" class="easyui-textbox" style="width: 150px">
                <label>状态:</label> <input id="isdel" name="isdel" class="easyui-combobox" style="width: 80px"
                                          data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'',text:'不限'},{id:'0',text:'未删除'},{id:'1',text:'已删除'},{id:'2',text:'未审核'}]">

                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchOrder();">查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
            </div>
        </form>

        <c:if test="${button.size()>0}">
            <div id="toolbar1">
                <c:forEach var="button" items="${button}">
                    <c:if test="${button.menu_button == 'add'}">
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           iconCls="icon-add" plain="true" onclick="addConfig();">添加</a>
                    </c:if>
                    <c:if test="${button.menu_button == 'edit'}">
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           iconCls="icon-remove" plain="true" onclick="editConfig();">编辑</a>
                    </c:if>
                    <c:if test="${button.menu_button == 'batchaudit'}">
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           iconCls="icon-remove" plain="true" onclick="BatchAudit();">批量审核</a>
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
        </c:if>

    </div>

    <!-- 对话框 -->
    <div id="configdlg" class="easyui-dialog"
         style="width:400px;height:380px;padding:10px 20px" closed="true"
         buttons="#configdlg-buttons">
        <form id="configfm" method="post" novalidate>
            <table>
                <input id="gid" name="gid" type="hidden"></td>
                <tr>
                    <td align="right">*处理渠道:</td>
                    <td><input id="dlgdealSubChannel" name="dealSubChannel" style="width: 205px" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*渠道代码:</td>
                    <td><input id="dlgcode" name="code" style="width:205px" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*渠道信息:</td>
                    <td><input id="dlgmsg" name="msg" style="height:45px;width:205px;font-size:12px;resize:none"
                               required="true"></td>
                </tr>

                <tr>
                    <td align="right">*本地代码:</td>
                    <td><input id="dlglocalCode" name="localCode" style="width:205px" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*本地信息:</td>
                    <td><input id="dlglocalMsg" name="localMsg"
                               style="height:45px;width:205px;font-size:12px; resize:none" required="true"></td>
                </tr>
                <tr>
                    <td align="right">解决方案:</td>
                    <td><textarea id="dlgsolution" name="solution"
                                  style="height:45px;width:200px;font-size:12px;resize:none"
                                  class="easyui-validatebox"></textarea></td>
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
