window.onload = function () {
    $('#toolbar').hide();

    $('#sourceChannel').combobox({
        editable: true, //编辑状态
        cache: false,
        valueField: 'id',
        textField: 'text'
    });
    $('#sourceSubChannel').combobox({
        editable: true, //编辑状态
        cache: false,
        valueField: 'id',
        textField: 'text'
    });
}

function validatPassword() {
    $.ajax({
        type: "POST",
        url: getRootPath() + "/restapikey/validatPassword",
        data: $('#validatForm').serialize(),
        cache: false,
        async: true,
        dataType: "json",
        success: function (result) {
            if (result.success) {
                $('#validatDiv').remove();
                $("#datagrid").datagrid("options").url = getRootPath() + "/restapikey/datagrid";
                $("#datagrid").datagrid("load");
                $('#toolbar').show();
            } else {
                validatReset();
                mesTitle = '验证不通过';
            }
            $.messager.show({
                title: mesTitle,
                msg: result.msg
            });
        }
    })
}

function validatReset() {
    $("#password").textbox('setValue', "");
}

var url;
var mesTitle;
function addRestapiKey() {
    $("#account").attr("readonly", false);
    $('#configdlg').dialog('open').dialog('setTitle', '新增api Key配置');
    $('#configfm').form('clear');
    url = getRootPath() + "/restapikey/addRestapiKey";
    mesTitle = '新增IP限制成功';
}

function editRestapiKey() {
    var row = $('#datagrid').datagrid('getSelected');
    if (row) {
        var gid = row.gid;
        $("#account").attr("readonly", true);
        $('#configdlg').dialog('open').dialog('setTitle', '编辑IP限制');
        $('#configfm').form('load', row);
        url = getRootPath() + "/restapikey/editRestapiKey?gid=" + gid;
        mesTitle = '编辑IP限制成功';
    } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
    }
}

function saveRestapiKey() {
    $("#sourceChannel").combobox("setValue", $("#sourceChannel").combobox("getText"));
    $("#sourceSubChannel").combobox("setValue", $("#sourceSubChannel").combobox("getText"));

    $.ajax({
        type: "POST",
        url: url,
        data: $('#configfm').serialize(),// 你的formid
        async: false,
        error: function (data) {
            alert("Connection error");
        },
        success: function (result) {
            //var result = eval('(' + result + ')');
            if (result.success) {
                $('#configdlg').dialog('close');
                $("#datagrid").datagrid("options").url = getRootPath() + "/restapikey/datagrid";
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

function delRestapiKey() {
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        $.messager.confirm("删除", "是否删除", function (r) {
            if (r) {
                $.post(getRootPath() + '/restapikey/delRestapiKey',
                    {gid: record.gid},
                    function (result) {
                        //var result = eval('(' + result + ')');
                        if (result.success) {
                            $.messager.alert('消息提示', "删除成功");
                            $("#datagrid").datagrid("options").url = getRootPath() + "/restapikey/datagrid";
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