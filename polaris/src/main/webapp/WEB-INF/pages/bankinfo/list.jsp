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
                url: "${path}/bankinfo/datagrid",
                columns: [[
                     {field: 'bankName', title: '银行名称', width: 80, align: 'left', rowspan: 2},
                    {
                        field: 'canGuarantee', title: '是否担保', width: 60, align: 'center',
                        rowspan: 2, formatter: function (value, rec) {
                        if (value == 1) {
                            return '<span>' + '是' + '</span>';
                        } else {
                            return '<span>' + '否' + '</span>';
                        }
                    }
                    },
                    {title: '借记卡', colspan: 5},
                    {title: '信用卡', colspan: 5},
                    {
                        field: 'apiState',
                        title: '同步状态',
                        width: 60,
                        align: 'center',
                        rowspan: 2,
                        formatter: function (value, rec) {
                            if (value == 1) {
                                return '<span>' + '同步' + '</span>';
                            } else {
                                return '<span>' + '未同步' + '</span>';
                            }
                        }
                    },
                    {
                        field: 'isdel', title: '状态', width: 60, align: 'center',
                        rowspan: 2, formatter: function (value, rec) {
                        if (value == 1) {
                            return '<span style="color:red;">' + '已删除' + '</span>';
                        } else if (value == 0) {
                            return '<span>' + '未删除' + '</span>';
                        }
                    }
                    },
                    {field: 'delReason', title: '删除原因', width: 80, align: 'center', rowspan: 2},
                    {field: 'description', title: '备注', width: 80, align: 'center', rowspan: 2},
                    {field: 'insertTime', title: '创建时间', width: 120, align: 'center', rowspan: 2},
                    {field: 'operateTime', title: '操作时间', width: 120, align: 'center', rowspan: 2}
                ],
                    [
                        {
                            field: 'debitCanloan', title: '提现', width: 60,
                            rowspan: 1, formatter: function (value, rec) {
                            if (value == 1) {
                                return '<span>' + '是' + '</span>';
                            } else {
                                return '<span>' + '否' + '</span>';
                            }
                        }
                        },
                        {
                            field: 'debitCanbind',
                            title: '绑定',
                            width: 60,
                            rowspan: 1,
                            formatter: function (value, rec) {
                                if (value == 1) {
                                    return '<span>' + '是' + '</span>';
                                } else {
                                    return '<span>' + '否' + '</span>';
                                }
                            }
                        },
                        {field: 'debitDailyMaxCount', title: '日交易限制笔数', width: 100, rowspan: 1},
                        {field: 'debitSingleQuota', title: '单笔最大金额', width: 80, rowspan: 1},
                        {field: 'debitDailyQuota', title: '日限额', width: 80, rowspan: 1},
                        {
                            field: 'creditCanloan',
                            title: '提现',
                            width: 60,
                            rowspan: 1,
                            formatter: function (value, rec) {
                                if (value == 1) {
                                    return '<span>' + '是' + '</span>';
                                } else {
                                    return '<span>' + '否' + '</span>';
                                }
                            }
                        },
                        {
                            field: 'creditCanbind',
                            title: '绑定',
                            width: 60,
                            rowspan: 1,
                            formatter: function (value, rec) {
                                if (value == 1) {
                                    return '<span>' + '是' + '</span>';
                                } else {
                                    return '<span>' + '否' + '</span>';
                                }
                            }
                        },
                        {field: 'creditDailyMaxCount', title: '日交易限制笔数', width: 100, rowspan: 1},
                        {field: 'creditSingleQuota', title: '单笔最大金额', width: 80, rowspan: 1},
                        {field: 'creditDailyQuota', title: '日限额', width: 80, rowspan: 1}
                    ]
                ]
            });

        }

        //查询列表
        function searchOrder() {
            $("#datagrid").datagrid("options").url = "${path}/bankinfo/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        //重置
        function onReset() {
            $("#bankName").textbox('setValue', "");
            $("#datagrid").datagrid("options").url = "${path}/bankinfo/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        //弹出新增界面
        function addConfig() {
            $("#dlgbankName").attr("readonly", false);
            $('#configdlg').dialog('open').dialog('setTitle', '新增银行信息');
            $('#configfm').form('clear');
            mesTitle = '新增成功';
        }

        //新增保存
        function saveConfig() {
            $('#configfm').form('submit', {
                url: path + "/bankinfo/addBankInfo",
                onSubmit: function () {
                    return $(this).form('validate');
                },
                success: function (result) {
                    var result = eval('(' + result + ')');
                    if (result.success) {
                        if ($("#gid").val() != '') {
                            $('#configdlg').dialog('close');
                        }
                        //
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
            $.post('${path}/bankinfo/upBankInfoState',
                    {isdel: 1, delReason: $('#delReason').val(), bankName: record.bankName},
                    function (result) {
                        var result = eval('(' + result + ')');
                        if (result.success) {
                            $('#delreasondlg').dialog('close');
                            $.messager.alert('消息提示', "删除成功");
                            $("#datagrid").datagrid("options").url = "${path}/bankinfo/datagrid";
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

                        $.post('${path}/bankinfo/upBankInfoState',
                                {isdel: 0, delReason: "", bankName: record.bankName},
                                function (result) {
                                    var result = eval('(' + result + ')');
                                    if (result.success) {
                                        $.messager.alert('消息提示', "恢复成功");
                                        $("#datagrid").datagrid("options").url = "${path}/bankinfo/datagrid";
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

        function copyConfig() {
            var row = $('#datagrid').datagrid('getSelected');
            if (row) {
                $.post('${path}/bankinfo/selectBankInfo',
                        {bankName: row.bankName},
                        function (result) {
                            var result = eval('(' + result + ')');
                            if (result.success) {
                                $("#dlgbankName").val(result.obj.bankName);
                                $("#dlgdebitCanloan").combobox("setValue", result.obj.debitCanloan);
                                $("#dlgdebitCanbind").combobox("setValue", result.obj.debitCanbind);
                                $("#dlgcreditCanloan").combobox("setValue", result.obj.creditCanloan);
                                $("#dlgcreditCanbind").combobox("setValue", result.obj.creditCanbind);
                                $("#dlgcanGuarantee").combobox("setValue", result.obj.canGuarantee);
                                $("#dlgdebitDailyMaxCount").val(result.obj.debitDailyMaxCount);
                                $("#dlgdebitSingleQuota").val(result.obj.debitSingleQuota);
                                $("#dlgdebitDailyQuota").val(result.obj.debitDailyQuota);
                                $("#dlgcreditDailyMaxCount").val(result.obj.creditDailyMaxCount);
                                $("#dlgcreditSingleQuota").val(result.obj.creditSingleQuota);
                                $("#dlgcreditDailyQuota").val(result.obj.creditDailyQuota);
                                $("#dlgdescription").val(result.obj.description);
                                $("#dlgapiState").combobox("setValue", result.obj.apiState);
                                $('#configdlg').dialog('open').dialog('setTitle', '添加银行');
                            } else {
                                $.messager.alert('错误提示', "添加银行失败");
                            }
                        });

            } else {
                $.messager.alert('提示', '请选择要复制的记录！', 'error');
            }
        }


        function editConfig() {
            var row = $('#datagrid').datagrid('getSelected');
            if (row) {
                if (row.isdel == 1) {
                    $.messager.alert('错误提示', "数据已经删除,不需要修改！");
                    return;
                }

                $.post('${path}/bankinfo/selectBankInfo',
                        {bankName: row.bankName},
                        function (result) {
                            var result = eval('(' + result + ')');
                            if (result.success) {
                                $("#dlgbankName").attr("readonly", true);
                                $("#gid").val("999");
                                $("#dlgbankName").val(result.obj.bankName);
                                $("#dlgdebitCanloan").combobox("setValue", result.obj.debitCanloan);
                                $("#dlgdebitCanbind").combobox("setValue", result.obj.debitCanbind);
                                $("#dlgcreditCanloan").combobox("setValue", result.obj.creditCanloan);
                                $("#dlgcreditCanbind").combobox("setValue", result.obj.creditCanbind);
                                $("#dlgcanGuarantee").combobox("setValue", result.obj.canGuarantee);
                                $("#dlgdebitDailyMaxCount").val(result.obj.debitDailyMaxCount);
                                $("#dlgdebitSingleQuota").val(result.obj.debitSingleQuota);
                                $("#dlgdebitDailyQuota").val(result.obj.debitDailyQuota);
                                $("#dlgcreditDailyMaxCount").val(result.obj.creditDailyMaxCount);
                                $("#dlgcreditSingleQuota").val(result.obj.creditSingleQuota);
                                $("#dlgcreditDailyQuota").val(result.obj.creditDailyQuota);
                                $("#dlgdescription").val(result.obj.description);
                                $("#dlgapiState").combobox("setValue", result.obj.apiState);
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
    <table id="datagrid" title="银行限制同步" class="easyui-datagrid" fit="true"
           toolbar="#toolbar" pagination="true"
           fitColumns="false" singleSelect="true" rownumbers="true"
           border="false" nowrap="true">
        <thead>
        <tr>
        </tr>
        </thead>
    </table>

    <!-- 按钮 -->

    <div id="toolbar" class="easyui-layout"
         style="width:100%;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <form id="fmorder" name="fmorder" method="post">
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <label>银行名称:</label> <input id="bankName" name="bankName" class="easyui-textbox"
                                            style="width: 150px">
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchOrder();">查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
            </div>
        </form>
        <c:if test="${button.size()>0}">
            <div id="toolbar">
                <c:forEach var="button" items="${button}">
                    <c:if test="${button.menu_button == 'add'}">
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           iconCls="icon-add" plain="true" onclick="addConfig();">添加</a>
                    </c:if>
                    <c:if test="${button.menu_button == 'copy'}">
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           iconCls="icon-add" plain="true" onclick="copyConfig();">复制添加</a>
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
                    <td align="right">*银行名称:</td>
                    <td><input id="dlgbankName" name="bankName" style="width: 150px" class="easyui-validatebox"
                               required="true"></td>
                </tr>
                <tr>
                    <td align="right">*借记卡是否能用做借款提现:</td>
                    <td><input id="dlgdebitCanloan" name="debitCanloan" style="width: 155px" class="easyui-combobox"
                               data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'1',text:'是'},{id:'0',text:'否'}]" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*借记卡能否支持绑定:</td>
                    <td><input id="dlgdebitCanbind" name="debitCanbind" style="width: 155px" class="easyui-combobox"
                               data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'1',text:'是'},{id:'0',text:'否'}]" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*信用卡是否能用做借款提现:</td>
                    <td><input id="dlgcreditCanloan" name="creditCanloan" style="width: 155px" class="easyui-combobox"
                               data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'1',text:'是'},{id:'0',text:'否'}]" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*信用卡能否支持绑定:</td>
                    <td><input id="dlgcreditCanbind" name="creditCanbind" style="width: 155px" class="easyui-combobox"
                               data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'1',text:'是'},{id:'0',text:'否'}]" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*是否能用做担保:</td>
                    <td><input id="dlgcanGuarantee" name="canGuarantee" style="width: 155px" class="easyui-combobox"
                               data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'1',text:'是'},{id:'0',text:'否'}]" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*借记卡日交易限制笔数:</td>
                    <td><input id="dlgdebitDailyMaxCount" name="debitDailyMaxCount" style="width: 150px"
                               class="easyui-validatebox" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*借记卡单笔最大金额:</td>
                    <td><input id="dlgdebitSingleQuota" name="debitSingleQuota" style="width: 150px"
                               class="easyui-validatebox" required="true">
                    </td>
                </tr>
                <tr>
                    <td align="right">*借记卡日限额:</td>
                    <td><input id="dlgdebitDailyQuota" name="debitDailyQuota" style="width: 150px"
                               class="easyui-validatebox" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*信用卡日交易限制笔数:</td>
                    <td><input id="dlgcreditDailyMaxCount" name="creditDailyMaxCount" style="width: 150px"
                               class="easyui-validatebox" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*信用卡单笔最大金额:</td>
                    <td><input id="dlgcreditSingleQuota" name="creditSingleQuota" style="width: 150px"
                               class="easyui-validatebox" required="true">
                    </td>
                </tr>
                <tr>
                    <td align="right">*信用卡日限额:</td>
                    <td><input id="dlgcreditDailyQuota" name="creditDailyQuota" style="width: 150px"
                               class="easyui-validatebox" required="true">
                    </td>
                </tr>
                <tr>
                    <td align="right">备注:</td>
                    <td><input id="dlgdescription" name="description" style="width: 150px">
                    </td>
                </tr>
                <tr>
                    <td align="right">*是否同步:</td>
                    <td><input id="dlgapiState" name="apiState" style="width: 155px" class="easyui-combobox"
                               data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'1',text:'是'},{id:'0',text:'否'}]" required="true"></td>
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
