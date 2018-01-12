
var url;
var mesTitle;
function addredisconfig() {
    $("#account").attr("readonly", false);
    $('#configdlg').dialog('open').dialog('setTitle', '新增redis配置');
    $('#configfm').form('clear');
    $('#id').val("0");
    url = getRootPath() + "/redisconfig/addredisconfig";
    mesTitle = '新增redis成功';
}

function editredisconfig() {
    var row = $('#datagrid').datagrid('getSelected');
    if (row) {
        var redisKey = row.redisKey;
        console.info(redisKey);
        $("#account").attr("readonly", true);
        $('#configdlg').dialog('open').dialog('setTitle', '编辑redis配置');
        $('#configfm').form('load', row);
        url = getRootPath() + "/redisconfig/editredisconfig?redisKey=" + redisKey;
        mesTitle = '编辑redis成功';
    } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
    }
}

function saveRedis() {
    $('#configfm').form('submit', {
        url: url,
        success: function (result) {
            var result = eval('(' + result + ')');
            if (result.success) {
                $('#configdlg').dialog('close');
                $("#datagrid").datagrid("options").url = getRootPath() + "/redisconfig/datagrid";
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
function delredisconfig() {
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        $.messager.confirm("删除", "是否删除", function (r) {
            if (r) {
                $.post(getRootPath() + '/redisconfig/delredisconfig',
                    {redisKey: record.redisKey},
                    function (result) {
                        //var result = eval('(' + result + ')');
                        if (result.success) {
                            $.messager.alert('消息提示', "删除成功");
                            $("#datagrid").datagrid("options").url = getRootPath() + "/redisconfig/datagrid";
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

function searchOrder() {
    $("#redisKey").textbox('setValue', $("#redisKey").textbox("getText"));
    $("#datagrid").datagrid("options").url =getRootPath()+  "/redisconfig/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

function onReset() {
    $("#redisKey").textbox('setValue', '');
    $("#datagrid").datagrid("options").url = getRootPath() +  "/redisconfig/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}