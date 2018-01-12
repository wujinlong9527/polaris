window.onload = function () {
    $('#openRoleDiv').dialog({
        onClose: function () {
            $("#datagrid").datagrid("options").url = getRootPath()+"/infoexception/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }
    });
    $("#datagrid").datagrid("options").url = getRootPath()+"/infoexception/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}
var url;
var mesTitle;
function addRestapiKey() {
    $("#account").attr("readonly", false);
    $('#configdlg').dialog('open').dialog('setTitle', '新增例外信息');
    $('#configfm').form('clear');
    url = getRootPath() + "/infoexception/addInfoException";
    mesTitle = '新增例外信息成功';
}

function editRestapiKey() {
    var row = $('#datagrid').datagrid('getSelected');
    if (row) {
        var id = row.id;
        $("#account").attr("readonly", true);
        $('#configdlg').dialog('open').dialog('setTitle', '编辑例外信息');
        $('#configfm').form('load', row);
        url = getRootPath() + "/infoexception/editInfoException?id=" + id;
        mesTitle = '编辑例外信息';
    } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
    }
}

function saveRestapiKey() {
    $.ajax({
        type: "POST",
        url:url,
        data:$('#configfm').serialize(),// 你的formid
        async: false,
        error: function(data) {
            alert("Connection error");
        },
        success: function(result) {
            //var result = eval('(' + result + ')');
            if (result.success) {
                $('#configdlg').dialog('close');
                $("#datagrid").datagrid("options").url = getRootPath()+"/infoexception/datagrid?" + $("#fmorder").serialize();
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
                $.post(getRootPath()+'/infoexception/delInfoException',
                    {id: record.id},
                    function (result) {
                        //var result = eval('(' + result + ')');
                        if (result.success) {
                            $.messager.alert('消息提示', "删除成功");
                            $("#datagrid").datagrid("options").url = getRootPath()+"/infoexception/datagrid?" + $("#fmorder").serialize();
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

function enableInfoException() {
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        var isdel = record.isdel;
        if(0 == isdel) {
            $.messager.alert('提示', '已启用，不需重新启用');
        } else {
            $.messager.confirm("启用", "是否启用", function (r) {
                if (r) {
                    $.post(getRootPath()+'/infoexception/enableInfoException',
                        {id: record.id},
                        function (result) {
                            //var result = eval('(' + result + ')');
                            if (result.success) {
                                $.messager.alert('消息提示', "启用成功");
                                $("#datagrid").datagrid("options").url = getRootPath()+"/infoexception/datagrid?" + $("#fmorder").serialize();
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

function disableInfoException() {
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        var isdel = record.isdel;
        if(1 == isdel) {
            $.messager.alert('提示', '已禁用，不需重新禁用');
        } else {
            $.messager.confirm("禁用", "是否禁用", function (r) {
                if (r) {
                    $.post(getRootPath()+'/infoexception/disableInfoException',
                        {id: record.id},
                        function (result) {
                            //var result = eval('(' + result + ')');
                            if (result.success) {
                                $.messager.alert('消息提示', "禁用成功");
                                $("#datagrid").datagrid("options").url = getRootPath()+"/infoexception/datagrid?" + $("#fmorder").serialize();
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

function formatIsdel(val, row) {
    if (val == 1) {
        return '<span style="color: red">' + '禁用' + '</span>';
    } else if (val == 0) {
        return '<span>' + '启用' + '</span>';
    }
}

function addRedisConfig() {
    $('#addredis').linkbutton({disabled:true});
    $.post(getRootPath()+'/infoexception/addRedis',
        function (result) {
            //var result = eval('(' + result + ')');
            console.info(result);
            if (result.success==true) {
                $.messager.alert('提示', result.msg);
            } else {
                $.messager.alert('错误提示',result.msg);
            }
            $('#addredis').linkbutton({disabled:false});
        });
}
