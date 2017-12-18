/**
 * Created by Administrator on 2016/12/1.
 */
window.onload = function () {
    $("#datagrid").datagrid("options").url = getRootPath() + "/consumebankconfig/datagrid";
    $("#datagrid").datagrid("load");
}
var url;
var mesTitle;
function addBankConfig() {
    $('#configdlg').dialog('open').dialog('setTitle', '新增消费银行配置');
    $('#configfm').form('clear');
    url = getRootPath() + "/consumebankconfig/addbankConfig";
    mesTitle = '新增消费银行配置成功';
}

function saveCnfigChannelt() {
    $.ajax({
        type: "POST",
        url: url,
        data: $('#configfm').serialize(),
        error: function (request) {
            alert("Connection failed");
        },
        success: function (result) {
            if (result.success) {
                $("#datagrid").datagrid("options").url = getRootPath() + "/consumebankconfig/datagrid";
                $("#datagrid").datagrid("load");
            } else {
                mesTitle = '新增失败';
            }
            $('#configdlg').dialog('close');
            $.messager.show({
                title: mesTitle,
                msg: result.msg
            });
        }
    });
}

function enableBankConfig() {
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        var isDel = record.isDel;
        if (0 == isDel) {
            $.messager.alert('提示', '已启用，不需重新启用');
        } else {
            $.messager.confirm("启用", "是否启用", function (r) {
                if (r) {
                    $.post(getRootPath() + '/consumebankconfig/enableBankConfig',
                        {id: record.id},
                        function (result) {
                            if (result.success) {
                                $.messager.alert('消息提示', "启用成功");
                                $("#datagrid").datagrid("options").url = getRootPath() + "/consumebankconfig/datagrid";
                                $("#datagrid").datagrid("load");
                            } else {
                                $.messager.alert('错误提示', "启用失败");
                            }
                        });
                }
            });
        }
    } else {
        $.messager.alert('提示', '请先选中要启用的行');
    }
}

function disableBankConfig() {
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        if (1 == isDel) {
            $.messager.alert('提示', '已禁用，不需重新禁用');
        } else {
            $.messager.confirm("禁用", "是否禁用", function (r) {
                if (r) {
                    $.post(getRootPath() + '/consumebankconfig/disableBankConfig',
                        {id: record.id},
                        function (result) {
                            if (result.success) {
                                $.messager.alert('消息提示', "禁用成功");
                                $("#datagrid").datagrid("options").url = getRootPath() + "/consumebankconfig/datagrid";
                                $("#datagrid").datagrid("load");
                            } else {
                                $.messager.alert('错误提示', "禁用失败");
                            }
                        });
                }
            });
        }
    } else {
        $.messager.alert('提示', '请先选中要禁用的行');
    }
}

function delBankConfig() {
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        $.messager.confirm("删除", "是否删除", function (r) {
            if (r) {
                $.post(getRootPath() + '/consumebankconfig/delBankConfig',
                    {id: record.id},
                    function (result) {
                        if (result.success) {
                            $.messager.alert('消息提示', "删除成功");
                            $("#datagrid").datagrid("options").url = getRootPath() + "/consumebankconfig/datagrid";
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

function formatIsDel(val, row) {
    if (val == '1') {
        return '<span style="color:red;">' + '禁用' + '</span>';
    } else if (val == '0') {
        return '<span>' + '启用' + '</span>';
    }
}

function formatIschannel(val, row) {
    if (val == 'deduct') {
        return '<span>' + '理财1.0(deduct)' + '</span>';
    } else if (val == 'harbor') {
        return '<span>' + '借款2.0(harbor)' + '</span>';
    } else if (val == 'loan') {
        return '<span>' + '借款1.0(loan)' + '</span>';
    }
    else if (val == 'loan_force') {
        return '<span>' + '借款强扣1.0(loan_force)' + '</span>';
    }
    else if (val == 'storm') {
        return '<span>' + '理财2.0(storm)' + '</span>';
    }
    else if (val == 'taurus') {
        return '<span>' + '闪电分期(taurus)' + '</span>';
    }
    else {
        return '<span>' + val + '</span>';
    }
}


function addredis() {
    $('#addredis').linkbutton({disabled: true});
    $.post(getRootPath() + '/consumebankconfig/addredis',
        function (result) {
            if (result.success == true) {
                $.messager.alert('提示', result.msg);
            } else {
                $.messager.alert('错误提示', result.msg);
            }
            $('#addredis').linkbutton({disabled: false});
        });
}
