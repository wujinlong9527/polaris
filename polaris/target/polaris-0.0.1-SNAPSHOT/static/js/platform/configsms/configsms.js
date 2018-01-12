window.onload = function () {
    getDealSubChannel();
    searchOrder();
}

var url;
var mesTitle;
function addRestapiKey() {
    $("#account").attr("readonly", false);
    $('#configdlg').dialog('open').dialog('setTitle', '新增短信发送配置');
    $('#configfm').form('clear');
    $('#id').val("0");
    url = getRootPath() + "/configsms/addConfigSms";
    mesTitle = '新增短信发送配置成功';
}

function addRedisConfig() {
    $("#dealSubChannel").combobox("setValue", $("#dealSubChannel").combobox("getText"));
    $('#addredis').linkbutton({disabled: true});
    $.post(getRootPath() + '/configsms/updchannel?' + $("#fmorder").serialize(),
        function (result) {
            //var result = eval('(' + result + ')');
            console.info(result);
            if (result.success == true) {
                $.messager.alert('提示', result.msg);
            } else {
                $.messager.alert('错误提示', result.msg);
            }
            $('#addredis').linkbutton({disabled: false});
        });

}


function editRestapiKey() {
    var row = $('#datagrid').datagrid('getSelected');
    if (row) {
        var gid = row.gid;
        $("#account").attr("readonly", true);
        $('#configdlg').dialog('open').dialog('setTitle', '编辑短信发送配置');
        $('#configfm').form('load', row);
        url = getRootPath() + "/configsms/editConfigSms?gid=" + gid;
        mesTitle = '编辑短信发送配置成功';
    } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
    }
}

function saveRestapiKey() {
    if (null == $("#dealSubChannel").combobox("getValue")) {
        $("#dealSubChannel").combobox("setValue", $("#dealSubChannel").combobox("getText"));
    }

    $.ajax({
        type: "POST",
        url: url,
        data: $('#configfm').serialize(),
        async: false,
        error: function (data) {
            alert("Connection error");
        },
        success: function (result) {
            //var result = eval('(' + result + ')');
            if (result.success) {
                $('#configdlg').dialog('close');
                $("#datagrid").datagrid("options").url = getRootPath() + "/configsms/datagrid?" + $("#fmorder").serialize();
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
                $.post(getRootPath() + '/configsms/delConfigSms',
                    {gid: record.gid},
                    function (result) {
                        //var result = eval('(' + result + ')');
                        if (result.success) {
                            $.messager.alert('消息提示', "删除成功");
                            $("#datagrid").datagrid("options").url = getRootPath() + "/configsms/datagrid?" + $("#fmorder").serialize();
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
    if (null == $("#dealSubChannelSrc").combobox("getValue")) {
        $("#dealSubChannelSrc").combobox("setValue", $("#dealSubChannelSrc").combobox("getText"));
    }
    $("#datagrid").datagrid("options").url = getRootPath() + "/configsms/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

function onReset() {
    $("#dealSubChannelSrc").combobox("setValue", "");
    $("#datagrid").datagrid("options").url = getRootPath() + "/configsms/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

function getDealSubChannel() {
    $('#dealSubChannel').combobox({
        editable: true, //编辑状态
        cache: false,
        valueField: 'dealSubChannel',
        textField: 'dealSubChannel'
    });

    $('#dealSubChannelSrc').combobox({
        editable: true, //编辑状态
        cache: false,
        valueField: 'dealSubChannel',
        textField: 'dealSubChannel'
    });

    $.ajax({
        type: "POST",
        url: getRootPath() + "/configsms/getDealSubChannel",
        cache: false,
        async: true,
        dataType: "json",
        success: function (data) {
            $("#dealSubChannel").combobox("loadData", data.rows);
            $("#dealSubChannelSrc").combobox("loadData", data.rows);
        }
    })
}