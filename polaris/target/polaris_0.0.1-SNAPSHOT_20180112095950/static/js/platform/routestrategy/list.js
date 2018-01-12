var url;
var mesTitle;

window.onload = function () {
    $("#datagrid").datagrid("options").url
        = getRootPath()+"/routestrategy/datagrid?bankId=" + $('#bankId').val();
    $("#datagrid").datagrid("load");

    $('#openRoleDiv').dialog({
        onClose: function () {
            $("#datagrid").datagrid("options").url
                = getRootPath()+"/routestrategy/datagrid?bankId=" + $('#bankId').val();
            $("#datagrid").datagrid("load");
        }
    });
}

//格式换显示状态
function formatIsdel(val, row) {
    if (val == 1) {
        return '<span style="color:red;">' + '禁用' + '</span>';
    } else if (val == 0) {
        return '<span>' + '启用' + '</span>';
    }
}

//查询列表
function searchOrder() {
    $("#datagrid").datagrid("options").url = getRootPath()+"/routestrategy/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

//重置
function onReset() {
    $("#strategy").textbox('setValue', "");
    $("#cardType").combobox('setValue', "");
    $("#isdel").combobox("setValue", "");
    $("#datagrid").datagrid("options").url = getRootPath()+"/routestrategy/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

//弹出新增界面
function addConfig() {
    $('#iframe2')[0].src = getRootPath()+'/routestrategy/strategyinfo?bankId=' + $('#bankId').val();
    $('#openRoleDiv').dialog('open');
}

//删除
function removeConfig() {
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        if (record.isdel == 1) {
            $.messager.alert('错误提示', "数据已经禁用,不需要再次禁用！");
            return;
        }
        $.messager.confirm("禁用", "是否禁用", function (r) {
            if (r) {
                $.post(getRootPath()+'/routestrategy/upRoutestrategy',
                    {isdel: 1, id: record.id},
                    function (result) {
                        //var result = eval('(' + result + ')');
                        if (result.success) {
//                                    $('#delreasondlg').dialog('close');
                            $.messager.alert('消息提示', "禁用成功");
                            $("#datagrid").datagrid("options").url = getRootPath()+"/routestrategy/datagrid?" + $("#fmorder").serialize();
                            $("#datagrid").datagrid("load");
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

function recoverConfig() {
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        if (record.isdel == 0) {
            $.messager.alert('错误提示', "数据为启用状态,不需要启用！");
            return;
        }
        $.messager.confirm("启用", "是否启用", function (r) {
            if (r) {
                $.post(getRootPath()+'/routestrategy/upRoutestrategy',
                    {isdel: 0, id: record.id},
                    function (result) {
                        //var result = eval('(' + result + ')');
                        if (result.success) {
                            $.messager.alert('消息提示', "启用成功");
                            $("#datagrid").datagrid("options").url = getRootPath()+"/routestrategy/datagrid?" + $("#fmorder").serialize();
                            $("#datagrid").datagrid("load");
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

//格式换显示状态
function formatdata(val, row) {
    return '<a class="editcls" onclick="editRow(\'' + row.id + '\',\'' + row.isdel + '\')" href="javascript:void(0)">配置</a>';
}

function editRow(strategyId, isdel) {
    $('#iframe2')[0].src = getRootPath()+'/routestrategy/strategyinfo?bankId=' + $('#bankId').val()
        + '&strategyId=' + strategyId + '&orderAction=' + $('#orderAction').val();
    $('#openRoleDiv').dialog('open');
}

function formatCardType(val, row) {
    if (val == 1) {
        return '<span>' + '借记卡' + '</span>';
    } else if (val == 2) {
        return '<span>' + '信用卡' + '</span>';
    }
    else if (val == 10) {
        return '<span>' + '全部' + '</span>';
    }
}
