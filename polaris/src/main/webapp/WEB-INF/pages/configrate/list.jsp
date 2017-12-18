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

        }

        //格式换显示状态
        function formatIsdel(val, row) {
            if (val == 1) {
                return '<span style="color:red;">' + '已删除' + '</span>';
            } else if (val == 0) {
                return '<span>' + '未删除' + '</span>';
            }
        }

        //查询列表
        function searchOrder() {
            $("#datagrid").datagrid("options").url = "${path}/configrate/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        //重置
        function onReset() {
            $("#merName").textbox('setValue', "");
            $("#rateType").combobox('setValue', "");
            $("#isdel").combobox("setValue", "");
            $("#datagrid").datagrid("options").url = "${path}/configrate/datagrid";
            $("#datagrid").datagrid("load");
        }

        //弹出新增界面
        function addConfig() {
            $('#configdlg').dialog('open').dialog('setTitle', '新增商户');
            $('#configfm').form('clear');
            mesTitle = '新增成功';
        }

        //新增保存
        function saveConfig() {
            $('#configfm').form('submit', {
                url: path + "/configrate/addConfigRate",
                onSubmit: function () {
                    return $(this).form('validate');
                },
                success: function (result) {
                    var result = eval('(' + result + ')');
                    if (result.success) {
                        $('#configdlg').dialog('close');
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
            var record = $("#datagrid").datagrid('getSelected');
            if (record) {

                if (record.isdel == 1) {
                    $.messager.alert('错误提示', "数据已经删除,不需要再次删除！");
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
            $.post('${path}/configrate/upconfigRateState',
                    {isdel: 1, delReason: $('#delReason').val(), gid: record.gid},
                    function (result) {
                        var result = eval('(' + result + ')');
                        if (result.success) {
                            $('#delreasondlg').dialog('close');
                            $.messager.alert('消息提示', "删除成功");
                            $("#datagrid").datagrid("options").url = "${path}/configrate/datagrid";
                            $("#datagrid").datagrid("load");
                        } else {
                            $.messager.alert('错误提示', "删除失败");
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
                $.messager.confirm("恢复", "是否恢复", function (r) {
                    if (r) {

                        $.post('${path}/configrate/upconfigRateState',
                                {isdel: 0, gid: record.gid},
                                function (result) {
                                    var result = eval('(' + result + ')');
                                    if (result.success) {
                                        $.messager.alert('消息提示', "恢复成功");
                                        $("#datagrid").datagrid("options").url = "${path}/configrate/datagrid";
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

        function editConfig() {
            var row = $('#datagrid').datagrid('getSelected');
            if (row) {

                if (row.isdel == 1) {
                    $.messager.alert('错误提示', "数据为删除状态,不能编辑！");
                    return;
                }

                $.post('${path}/configrate/selectConfigRate',
                        {gid: row.gid},
                        function (result) {
                            var result = eval('(' + result + ')');
                            if (result.success) {
                                $("#gid").val(result.obj.gid);
                                $("#dlgmerId").val(result.obj.merId);
                                $("#dlgmerName").val(result.obj.merName);
                                $("#dlgrateType").combobox("setValue", result.obj.rateType);
                                $("#dlgrate").val(result.obj.rate);
                                $("#dlgminRate").val(result.obj.minRate);
                                $("#dlgmaxRate").val(result.obj.maxRate);
                                $("#dlglevel").val(result.obj.level);
                                $("#dlgminMoney").val(result.obj.minMoney);
                                $("#dlgmaxMoney").val(result.obj.maxMoney);
                                $("#dlgorderAction").val(result.obj.orderAction);
                                $('#configdlg').dialog('open').dialog('setTitle', '编辑');
                            } else {
                                $.messager.alert('错误提示', "编辑失败");
                            }
                        });

            } else {
                $.messager.alert('提示', '请选择要编辑的记录！', 'error');
            }
        }

        function addRedisConfig() {
            $('#addredis').linkbutton({disabled:true});
            $.post('${path}/configrate/addredis?'+ $("#fmorder").serialize(),
                function (result) {
                    var result = eval('(' + result + ')');
                    console.info(result);
                    if (result.success==true) {
                        $.messager.alert('提示', result.msg);
                    } else {
                        $.messager.alert('错误提示',result.msg);
                    }
                    $('#addredis').linkbutton({disabled:false});
                });
            }

    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 错误信息列表 -->
    <table id="datagrid" title="错误码管理" class="easyui-datagrid" fit="true"
           url="${path}/configrate/datagrid" toolbar="#toolbar" pagination="true"
           fitColumns="false" singleSelect="true" rownumbers="true"
           border="false" nowrap="true" checkOnSelect="false" selectOnCheck="false">
        <thead>
        <tr>
            <th field="gid" width="80" hidden="true">gid</th>
            <th field="merId" width="120">商户号</th>
            <th field="merName" width="120">商户名称</th>
            <th field="orderAction" width="80">交易类型</th>
            <th field="rateType" width="60">费率类型</th>
            <th field="rate" width="60" align="right">费率</th>
            <th field="minMoney" width="100" align="right">付款最小金额</th>
            <th field="maxMoney" width="100" align="right">付款最大金额</th>
            <th field="minRate" width="100" align="right">最低手续费</th>
            <th field="maxRate" width="100" align="right">封顶手续费</th>
            <th field="level" width="60">优先级</th>
            <th field="isdel" width="60" formatter="formatIsdel">删除标识</th>
            <th field="delReason" width="120">删除原因</th>
            <th field="insertTime" width="140">创建时间</th>
            <th field="operateTime" width="140">操作时间</th>
        </tr>
        </thead>
    </table>

    <!-- 按钮 -->

    <div id="toolbar" class="easyui-layout"
         style="width:100%;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <form id="fmorder" name="fmorder" method="post">
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <label>商户名称:</label> <input id="merName" name="merName" class="easyui-textbox" style="width: 150px">
                <label>费率类型:</label> <input id="rateType" name="rateType" class="easyui-combobox" style="width: 80px"
                                            data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'',text:'不限'},{id:'单笔',text:'单笔'},{id:'比例',text:'比例'}]">
                <label>删除标识:</label> <input id="isdel" name="isdel" class="easyui-combobox" style="width: 80px"
                                            data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'',text:'不限'},{id:'0',text:'未删除'},{id:'1',text:'已删除'}]">

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
                    <c:if test="${button.menu_button == 'delete'}">
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           iconCls="icon-remove" plain="true" onclick="removeConfig();">删除</a>
                    </c:if>
                    <c:if test="${button.menu_button == 'recover'}">
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           iconCls="icon-remove" plain="true" onclick="recoverConfig();">恢复</a>
                    </c:if>
                    <c:if test="${button.menu_button == 'addredis'}">
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           iconCls="icon-add" plain="true" onclick="addRedisConfig();">更新Redis</a>
                    </c:if>

                </c:forEach>
            </div>
        </c:if>

    </div>

    <!-- 对话框 -->
    <div id="configdlg" class="easyui-dialog"
         style="width:320px;height:400px;padding:10px 20px" closed="true"
         buttons="#configdlg-buttons">
        <form id="configfm" method="post" novalidate>
            <table>
                <input id="gid" name="gid" type="hidden"></td>
                <tr>
                    <td align="right">*商户号:</td>
                    <td><input id="dlgmerId" name="merId" type="text" style="width: 150px" class="easyui-validatebox"
                               required="true"></td>
                </tr>
                <tr>
                    <td align="right">*商户名称:</td>
                    <td><input id="dlgmerName" name="merName" type="text" style="width:150px" class="easyui-validatebox"
                               required="true"></td>
                </tr>
                <tr>
                    <td align="right">*费率类型:</td>
                    <td><input id="dlgrateType" name="rateType" class="easyui-combobox" style="width: 155px"
                               data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'单笔',text:'单笔'},{id:'比例',text:'比例'}]" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*费率:</td>
                    <td><input id="dlgrate" name="rate" style="width:150px" type="text" class="easyui-validatebox"
                               required="true"></td>
                </tr>
                <tr>
                    <td align="right">*最低手续费:</td>
                    <td><input id="dlgminRate" name="minRate" style="width:150px" type="text" class="easyui-validatebox"
                               required="true"></td>
                </tr>
                <tr>
                    <td align="right">*封顶手续费:</td>
                    <td><input id="dlgmaxRate" name="maxRate" style="width:150px" type="text" class="easyui-validatebox"
                               required="true"></td>
                </tr>
                <tr>
                    <td align="right">*付款最小金额:</td>
                    <td><input id="dlgminMoney" name="minMoney" style="width:150px" type="text"
                               class="easyui-validatebox" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*付款最大金额:</td>
                    <td><input id="dlgmaxMoney" name="maxMoney" style="width:150px" type="text"
                               class="easyui-validatebox" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*优先级:</td>
                    <td><input id="dlglevel" name="level" style="width:150px" type="text" class="easyui-validatebox"
                               required="true"></td>
                </tr>
                <tr>
                    <td align="right">*交易类型:</td>
                    <td><input id="dlgorderAction" name="orderAction" style="width:150px" type="text"
                               class="easyui-validatebox" required="true"></td>
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
