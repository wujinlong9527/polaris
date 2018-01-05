/**
 * Created by Administrator on 2016/12/1.
 */

window.onload = function () {
    $("#datagrid").datagrid("options").url = getRootPath()+"/consumeerrorcodeconfig/datagrid";
    $("#datagrid").datagrid("load");
}
var url;
var mesTitle;
function addErrorcodeConfig() {
    $('#configdlg').dialog('open').dialog('setTitle', '新增消费错误码配置');
    $('#configfm').form('clear');
    url = getRootPath()+"/consumeerrorcodeconfig/addErrorcodeConfig";
    mesTitle = '新增消费错误码配置成功';
}

function saveErrorcodeConfig() {
    $.ajax({
        type:"POST",
        data:$("#configfm").serialize(),
        url: url,
        error:function(){
            alert("Connection failed");
        },
        success: function (result) {
            if (result.success) {
                mesTitle="提示";
                $("#datagrid").datagrid("options").url = getRootPath()+"/consumeerrorcodeconfig/datagrid";
                $("#datagrid").datagrid("load");
            } else {
                mesTitle = '提示';
            }

            $.messager.show({
                title: mesTitle,
                msg: result.msg
            });
            $('#configdlg').dialog('close');
        }
    });
}

function enableErrorcodeConfig() {
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        var isDel = record.isDel;
        if(0 == isDel) {
            $.messager.alert('提示', '已启用，不需重新启用');
        } else {
            $.messager.confirm("启用", "是否启用", function (r) {
                if (r) {
                    $.post(getRootPath()+'/consumeerrorcodeconfig/enableErrorcodeConfig',
                        {id: record.id},
                        function (result) {
                            if (result.success) {
                                $.messager.alert('消息提示', "启用成功");
                                $("#datagrid").datagrid("options").url = getRootPath()+"/consumeerrorcodeconfig/datagrid";
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

function disableErrorcodeConfig() {
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        var isDel = record.isDel;
        if(1 == isDel) {
            $.messager.alert('提示', '已禁用，不需重新禁用');
        } else {
            $.messager.confirm("禁用", "是否禁用", function (r) {
                if (r) {
                    $.post(getRootPath()+'/consumeerrorcodeconfig/disableErrorcodeConfig',
                        {id: record.id},
                        function (result) {
                            if (result.success) {
                                $.messager.alert('消息提示', "禁用成功");
                                $("#datagrid").datagrid("options").url = getRootPath()+"/consumeerrorcodeconfig/datagrid";
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

function delErrorcodeConfig() {
    var record = $("#datagrid").datagrid('getSelected');
    console.info(record.id);
    if (record) {
        $.messager.confirm("删除", "是否删除", function (r) {
            if (r) {
                $.post(getRootPath()+'/consumeerrorcodeconfig/delErrorcodeConfig',
                    {id: record.id},
                    function (result) {
                        if (result.success) {
                            $.messager.alert('消息提示', "删除成功");
                            $("#datagrid").datagrid("options").url = getRootPath()+"/consumeerrorcodeconfig/datagrid";
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
    } else if (val =='0') {
        return '<span>' + '启用' + '</span>';
    }
}

function addredis() {
    $('#addredis').linkbutton({disabled:true});
    $.post(getRootPath()+'/consumeerrorcodeconfig/addredis',
        function (result) {
            if (result.success==true) {
                $.messager.alert('提示', result.msg);
            } else {
                $.messager.alert('错误提示',result.msg);
            }
            $('#addredis').linkbutton({disabled:false});
        });
}
