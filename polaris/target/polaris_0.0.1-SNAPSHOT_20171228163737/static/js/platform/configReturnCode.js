var url;
var mesTitle;
window.onload = function () {
    searchOrder();
}
function addRestapiKey() {
    $("#account").attr("readonly", false);
    $('#configdlg').dialog('open').dialog('setTitle', '新增请求码配置');
    $('#configfm').form('clear');
    $('#id').val("0");
    url = getRootPath() + "/ncmpiReturnCode/addConfigReturnCode";
    mesTitle = '新增请求码配置成功';
}

function editRestapiKey() {
    var row = $('#datagrid').datagrid('getSelected');
    if (row) {
        var id = row.id;
        $("#account").attr("readonly", true);
        $('#configdlg').dialog('open').dialog('setTitle', '编辑请求码配置');
        $('#configfm').form('load', row);
        url = getRootPath() + "/ncmpiReturnCode/editConfigReturnCode?id="+id;
        mesTitle = '编辑请求码配置成功';
    } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
    }
}

function saveRestapiKey() {
    if(null == $("#returnCode").val()) {
        $("#returnCode").val( $("#returnCode").val());
    }
    if(null == $("#transReturnCode").val()) {
        $("#transReturnCode").val( $("#transReturnCode").val());
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
            //console.log(result);
            //var result = eval('(' + result + ')');
            if (result.success) {
                $('#configdlg').dialog('close');
                $("#datagrid").datagrid("options").url = getRootPath()+"/ncmpiReturnCode/datagrid?" + $("#fmorder").serialize();
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
                $.post(getRootPath()+'/ncmpiReturnCode/delReturnCode',
                    {id: record.id},
                    function (result) {
                        //var result = eval('(' + result + ')');
                        if (result.success) {
                            $.messager.alert('消息提示', "删除成功");
                            $("#datagrid").datagrid("options").url = getRootPath()+"/ncmpiReturnCode/datagrid?" + $("#fmorder").serialize();
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

    if(null == $("#returnCode").val()) {
        $("#returnCode").val( $("#returnCode").val());
    }
    if(null == $("#transReturnCode").val()) {
        $("#transReturnCode").val( $("#transReturnCode").val());
    }
    $("#datagrid").datagrid("options").url = getRootPath()+"/ncmpiReturnCode/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

function onReset() {
    $("#returnCode").val("");
    $("#transReturnCode").val("");
    $("#datagrid").datagrid("options").url = getRootPath()+"/ncmpiReturnCode/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}