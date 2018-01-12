var url;
var mesTitle;

window.onload = function () {
    $('#datagrid').datagrid({
        url: getRootPath() + "/bankinfo/datagrid",
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
    $("#datagrid").datagrid("options").url = getRootPath() + "/bankinfo/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

//重置
function onReset() {
    $("#bankName").textbox('setValue', "");
    $("#datagrid").datagrid("options").url = getRootPath() + "/bankinfo/datagrid?" + $("#fmorder").serialize();
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
    $.ajax({
        type: "POST",
        url: getRootPath() + "/bankinfo/addBankInfo",
        data: $('#configfm').serialize(),
        async: false,
        error: function (data) {
            alert("Connection error");
        },
        success: function (result) {
            //var result = eval('(' + result + ')');
            if (result.success) {
                $('#configdlg').dialog('close');
                $("#datagrid").datagrid("options").url = getRootPath() + "/bankinfo/datagrid?" + $("#fmorder").serialize();
                $("#datagrid").datagrid("load");
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
    $.post(getRootPath() + '/bankinfo/upBankInfoState',
        {isdel: 1, delReason: $('#delReason').val(), bankName: record.bankName},
        function (result) {
            //var result = eval('(' + result + ')');
            if (result.success) {
                $('#delreasondlg').dialog('close');
                $.messager.alert('消息提示', "删除成功");
                $("#datagrid").datagrid("options").url = getRootPath() + "/bankinfo/datagrid?" + $("#fmorder").serialize();
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

                $.post(getRootPath() + '/bankinfo/upBankInfoState',
                    {isdel: 0, delReason: "", bankName: record.bankName},
                    function (result) {
                        //var result = eval('(' + result + ')');
                        if (result.success) {
                            $.messager.alert('消息提示', "恢复成功");
                            $("#datagrid").datagrid("options").url = getRootPath() + "/bankinfo/datagrid?" + $("#fmorder").serialize();
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
        $.post(getRootPath() + '/bankinfo/selectBankInfo',
            {bankName: row.bankName},
            function (result) {
                //var result = eval('(' + result + ')');
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
       /* if (row.isdel == 1) {
            $.messager.alert('错误提示', "数据已经删除,不需要修改！");
            return;
        }*/

        $.post(getRootPath() + '/bankinfo/selectBankInfo',
            {bankName: row.bankName},
            function (result) {
                //var result = eval('(' + result + ')');
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