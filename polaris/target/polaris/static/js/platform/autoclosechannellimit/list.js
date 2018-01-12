window.onload = function () {
    $("#datagrid").datagrid("options").url = getRootPath()+"/autoclosechannellimit/datagrid";
    $("#datagrid").datagrid("load");
}

function addTypeFormat() {
    $('#dlTypeId').combobox({
        onSelect: function (record) {
            if (record.id == 1) {
                $("#dlTypeName").textbox('setValue','');
                $("#dlTypeName").textbox('readonly', false);
                $("#dlTimeLimit").textbox({required: false});
                $("#dlDifferentBankNumber").textbox({required: false});
                $("#dlTimeLimit").textbox('disable');
                $("#dlDifferentBankNumber").textbox('disable');
                $("#typeOnePoints").show();
                $("#typeTwoPoints").hide();
                $("#typeThreePoints").hide();
                $("#typeFourPoints").hide();
                $("#typeFivePoints").hide();
            } else if (record.id == 2) {
                $("#dlTypeName").textbox('setValue','');
                $("#dlTypeName").textbox('readonly', false);
                $("#dlTimeLimit").textbox({required: true});
                $("#dlDifferentBankNumber").textbox({required: false});
                $("#dlTimeLimit").textbox('enable');
                $("#dlDifferentBankNumber").textbox('disable');
                $("#typeOnePoints").hide();
                $("#typeTwoPoints").show();
                $("#typeThreePoints").hide();
                $("#typeFourPoints").hide();
                $("#typeFivePoints").hide();
            } else if (record.id == 3) {
                $("#dlTypeName").textbox('setValue','');
                $("#dlTypeName").textbox('readonly', false);
                $("#dlTimeLimit").textbox({required: false});
                $("#dlDifferentBankNumber").textbox({required: true});
                $("#dlTimeLimit").textbox('disable');
                $("#dlDifferentBankNumber").textbox('enable');
                $("#typeOnePoints").hide();
                $("#typeTwoPoints").hide();
                $("#typeThreePoints").show();
                $("#typeFourPoints").hide();
                $("#typeFivePoints").hide();
            } else if (record.id == 4) {
                $("#dlTypeName").textbox('setValue','');
                $("#dlTypeName").textbox('readonly', false);
                $("#dlTimeLimit").textbox({required: true});
                $("#dlDifferentBankNumber").textbox({required: true});
                $("#dlTimeLimit").textbox('enable');
                $("#dlDifferentBankNumber").textbox('enable');
                $("#typeOnePoints").hide();
                $("#typeTwoPoints").hide();
                $("#typeThreePoints").hide();
                $("#typeFourPoints").show();
                $("#typeFivePoints").hide();
            } else if (record.id == 5) {
                $("#dlTypeName").textbox('setValue','钱袋快捷T0_消费');
                $("#dlTypeName").textbox('readonly', true);
                $("#dlTimeLimit").textbox({required: false});
                $("#dlDifferentBankNumber").textbox({required: false});
                $("#dlTimeLimit").textbox('disable');
                $("#dlDifferentBankNumber").textbox('disable');
                $("#typeOnePoints").hide();
                $("#typeTwoPoints").hide();
                $("#typeThreePoints").hide();
                $("#typeFourPoints").hide();
                $("#typeFivePoints").show();
            }
        }
    });
}

function editTypeFormat(row) {
    $('#dlTypeId').combobox('readonly', true);
    var typeId = row.typeId;
    if (typeId == 1) {
        $("#dlTypeName").textbox('setValue','');
        $("#dlTypeName").textbox('readonly', false);
        $("#dlTimeLimit").textbox({required: false});
        $("#dlDifferentBankNumber").textbox({required: false});
        $("#dlTimeLimit").textbox('disable');
        $("#dlDifferentBankNumber").textbox('disable');
        $("#typeOnePoints").show();
        $("#typeTwoPoints").hide();
        $("#typeThreePoints").hide();
        $("#typeFourPoints").hide();
        $("#typeFivePoints").hide();
    } else if (typeId == 2) {
        $("#dlTypeName").textbox('setValue','');
        $("#dlTypeName").textbox('readonly', false);
        $("#dlTimeLimit").textbox({required: true});
        $("#dlDifferentBankNumber").textbox({required: false});
        $("#dlTimeLimit").textbox('enable');
        $("#dlDifferentBankNumber").textbox('disable');
        $("#typeOnePoints").hide();
        $("#typeTwoPoints").show();
        $("#typeThreePoints").hide();
        $("#typeFourPoints").hide();
        $("#typeFivePoints").hide();
    } else if (typeId == 3) {
        $("#dlTypeName").textbox('setValue','');
        $("#dlTypeName").textbox('readonly', false);
        $("#dlTimeLimit").textbox({required: false});
        $("#dlDifferentBankNumber").textbox({required: true});
        $("#dlTimeLimit").textbox('disable');
        $("#dlDifferentBankNumber").textbox('enable');
        $("#typeOnePoints").hide();
        $("#typeTwoPoints").hide();
        $("#typeThreePoints").show();
        $("#typeFourPoints").hide();
        $("#typeFivePoints").hide();
    } else if (typeId == 4) {
        $("#dlTypeName").textbox('setValue','');
        $("#dlTypeName").textbox('readonly', false);
        $("#dlTimeLimit").textbox({required: true});
        $("#dlDifferentBankNumber").textbox({required: true});
        $("#dlTimeLimit").textbox('enable');
        $("#dlDifferentBankNumber").textbox('enable');
        $("#typeOnePoints").hide();
        $("#typeTwoPoints").hide();
        $("#typeThreePoints").hide();
        $("#typeFourPoints").show();
        $("#typeFivePoints").hide();
    } else if (typeId == 5) {
        $("#dlTypeName").textbox('setValue','钱袋快捷T0_消费');
        $("#dlTypeName").textbox('readonly', true);
        $("#dlTimeLimit").textbox({required: false});
        $("#dlDifferentBankNumber").textbox({required: false});
        $("#dlTimeLimit").textbox('disable');
        $("#dlDifferentBankNumber").textbox('disable');
        $("#typeOnePoints").hide();
        $("#typeTwoPoints").hide();
        $("#typeThreePoints").hide();
        $("#typeFourPoints").hide();
        $("#typeFivePoints").show();
    }
}

var url;
var mesTitle;
function addChannelLimit() {
    addTypeFormat();
    $('#dlTypeId').combobox('readonly', false);
    $('#configdlg').dialog('open').dialog('setTitle', '新增渠道限制');
    $('#configfm').form('clear');
    url = getRootPath() + "/autoclosechannellimit/addChannelLimit";
    mesTitle = '新增渠道限制成功';
}

function editChannelLimit() {
    var row = $('#datagrid').datagrid('getSelected');
    if (row) {
        editTypeFormat(row);
        var id = row.id;
        $('#configdlg').dialog('open').dialog('setTitle', '编辑渠道限制-不可修改类型');
        $('#configfm').form('load', row);
        url = getRootPath() + "/autoclosechannellimit/editChannelLimit?id=" + id;
        mesTitle = '编辑渠道限制';
    } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
    }
}

function saveChannelLimit() {
    $.ajax({
        cache: true,
        type: "POST",
        url:url,
        data:$('#configfm').serialize(),
        async: false,
        error: function(data) {
            alert("Connection error");
        },
        success: function(result) {
            //var result = eval('(' + result + ')');
            if (result.success) {
                $('#configdlg').dialog('close');
                $("#datagrid").datagrid("options").url = getRootPath()+"/autoclosechannellimit/datagrid";
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

function disableChannelLimit() {
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        if(1 == record.isDel) {
            $.messager.alert('提示', '已禁用不需再次禁用');
            return;
        }
        $.messager.confirm("禁用", "是否禁用", function (r) {
            if (r) {
                $.post(getRootPath()+'/autoclosechannellimit/updateIsDel',
                    {id: record.id, isDel: record.isDel},
                    function (result) {
                        //var result = eval('(' + result + ')');
                        if (result.success) {
                            $.messager.alert('消息提示', "禁用成功");
                            $("#datagrid").datagrid("options").url =getRootPath()+ "/autoclosechannellimit/datagrid";
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

function enableChannelLimit() {
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        if(0 == record.isDel) {
            $.messager.alert('提示', '已启用不需再次启用');
            return;
        }
        $.messager.confirm("启用", "是否启用", function (r) {
            if (r) {
                $.post(getRootPath()+'/autoclosechannellimit/updateIsDel',
                    {id: record.id, isDel: record.isDel},
                    function (result) {
                        //var result = eval('(' + result + ')');
                        if (result.success) {
                            $.messager.alert('消息提示', "启用成功");
                            $("#datagrid").datagrid("options").url = getRootPath()+"/autoclosechannellimit/datagrid";
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

function delChannelLimit() {
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        $.messager.confirm("删除", "是否删除", function (r) {
            if (r) {
                $.post(getRootPath()+'/autoclosechannellimit/delChannelLimit',
                    {id: record.id},
                    function (result) {
                        //var result = eval('(' + result + ')');
                        if (result.success) {
                            $.messager.alert('消息提示', "删除成功");
                            $("#datagrid").datagrid("options").url = getRootPath()+"/autoclosechannellimit/datagrid";
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

function isDelFormat(val, row) {
    if (val == 0) {
        return '<span>' + '启用' + '</span>';
    } else if (val == 1) {
        return '<span style="color:red;">' + '禁用' + '</span>';
    }
}

function dataFormat(val) {
    if (val == -1) {
        return '<span>' + '' + '</span>';
    } else {
        return '<span>' + val + '</span>';
    }
}