window.onload = function () {
    searchOrder();
}

var url;
var mesTitle;
function addBankInfo() {
    $("#bankName").attr("readonly", false);
    $('#configdlg').dialog('open').dialog('setTitle', '新增');
    $('#configfm').form('clear');
    url = getRootPath() + "/bankinfostorm/addBankinfoStorm";
    mesTitle = '新增成功';
}

function editBankInfo() {
    $("#bankName").attr("readonly", true);
    var row = $('#datagrid').datagrid('getSelected');
    if (row) {
        var id = row.id;
        $('#configdlg').dialog('open').dialog('setTitle', '编辑信息');
        $('#configfm').form('load', row);
        url = getRootPath() + "/bankinfostorm/updateBankinfoStorm?id=" + id;
        mesTitle = '编辑成功';
    } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
    }
}

function copyConfig() {
    var row = $('#datagrid').datagrid('getSelected');
    if (row) {
        $('#configdlg').dialog('open').dialog('setTitle', '新增信息');
        $('#configfm').form('load', row);
        url = getRootPath() + "/bankinfostorm/addBankinfoStorm";
        mesTitle = '新增成功';
    } else {
        $.messager.alert('提示', '请选择要复制的记录！', 'error');
    }
}

function saveBankInfo() {
    $.ajax({
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
                $("#datagrid").datagrid("options").url = getRootPath()+ "/bankinfostorm/datagrid?" + $("#fmorder").serialize();
                $("#datagrid").datagrid("load");
            } else {
                mesTitle = '新增/修改失败';
            }
            $.messager.show({
                title: mesTitle,
                msg: result.msg
            });
        }
    });
}

function delBankInfo() {
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        $.messager.confirm("删除", "是否删除", function (r) {
            if (r) {
                $.post(getRootPath()+'/bankinfostorm/delBankinfoStorm',
                    {id: record.id},
                    function (result) {
                        //var result = eval('(' + result + ')');
                        if (result.success) {
                            $.messager.alert('消息提示', "删除成功");
                            $("#datagrid").datagrid("options").url = getRootPath()+ "/bankinfostorm/datagrid?" + $("#fmorder").serialize();
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

function formatIsdel(val, row) {
    if (val == 1) {
        return '<span>' + '是' + '</span>';
    } else if (val == 0) {
        return '<span>' + '否' + '</span>';
    }
}

function searchOrder() {
    $("#datagrid").datagrid("options").url = getRootPath()+ "/bankinfostorm/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

function onReset() {
    $("#bankNameSrc").textbox('setValue', "");
    $("#datagrid").datagrid("options").url =getRootPath()+ "/bankinfostorm/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}