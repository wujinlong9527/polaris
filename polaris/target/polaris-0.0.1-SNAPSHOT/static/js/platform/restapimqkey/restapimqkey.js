window.onload = function () {
    getDealSubChannel();
    searchOrder();
}
var url;
var mesTitle;
function addRestapiMqKey() {
    $("#account").attr("readonly", false);
    $('#configdlg').dialog('open').dialog('setTitle', '新增api MqKey配置');
    $('#configfm').form('clear');
    $('#id').val("0");
    url = getRootPath() + "/restapimqkey/addRestapiMqKey";
    mesTitle = '新增MqKey成功';
}

function editRestapiMqKey() {
    var row = $('#datagrid').datagrid('getSelected');
    if (row) {
        var gid = row.gid;
        $("#account").attr("readonly", true);
        $('#configdlg').dialog('open').dialog('setTitle', '编辑MqKey配置');
        $('#configfm').form('load', row);
        url = getRootPath() + "/restapimqkey/editRestapiMqKey?gid=" + gid;
        mesTitle = '编辑MqKey成功';
    } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
    }
}

function saveRestapiMqKey() {
    if (null == $("#dealSubChannel").combobox("getValue")) {
        $("#dealSubChannel").combobox("setValue", $("#dealSubChannel").combobox("getText"));
    }

    $.ajax({
        cache: true,
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
                $("#datagrid").datagrid("options").url =getRootPath() +  "/restapimqkey/datagrid?" + $("#fmorder").serialize();
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
function delRestapiMqKey() {
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        $.messager.confirm("删除", "是否删除", function (r) {
            if (r) {
                $.post(getRootPath()+'/restapimqkey/delRestapiMqKey',
                    {gid: record.gid},
                    function (result) {
                        //console.log(result);
                        //var result = eval('(' + result + ')');
                        if (result.success) {
                            $.messager.alert('消息提示', "删除成功");
                            $("#datagrid").datagrid("options").url =getRootPath()+ "/restapimqkey/datagrid?" + $("#fmorder").serialize();
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
    $("#datagrid").datagrid("options").url = getRootPath()+"/restapimqkey/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

function addRedisConfig() {
    $('#addredis').linkbutton({disabled: true});
    $.post(getRootPath()+'/restapimqkey/addRedis',
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

function onReset() {
    $("#dealSubChannelSrc").combobox("setValue", "");
    $("#datagrid").datagrid("options").url = getRootPath()+"/restapimqkey/datagrid?" + $("#fmorder").serialize();
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
        url: getRootPath()+"/restapimqkey/getDealSubChannel",
        cache: false,
        async: true,
        dataType: "json",
        success: function (data) {
            $("#dealSubChannel").combobox("loadData", data.rows);
            $("#dealSubChannelSrc").combobox("loadData", data.rows);
        }
    })
}