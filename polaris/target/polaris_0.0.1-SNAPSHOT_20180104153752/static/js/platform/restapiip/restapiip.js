window.onload = function () {
    $('#toolbar').hide();
}

function validatPassword() {
    $.ajax({
        type: "POST",
        url: getRootPath()+"/restapiip/validatPassword",
        data:$('#validatForm').serialize(),
        cache: false,
        async: true,
        dataType: "json",
        success: function (result) {
            if (result.success) {
                $('#validatDiv').remove();
                $("#datagrid").datagrid("options").url = getRootPath()+"/restapiip/datagrid";
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
function addRestapiIp() {
    $("#account").attr("readonly", false);
    $('#configdlg').dialog('open').dialog('setTitle', '新增IP限制');
    $('#configfm').form('clear');
    $('#id').val("0");
    url = getRootPath() + "/restapiip/addRestapiIp";
    mesTitle = '新增IP限制成功';
}
function editRestapiIp() {
    var row = $('#datagrid').datagrid('getSelected');
    if (row) {
        var gid = row.gid;
        $("#account").attr("readonly", true);
        $('#configdlg').dialog('open').dialog('setTitle', '编辑IP限制');
        $('#configfm').form('load', row);//这句话有问题，第一次加载时正确的，第二次就出错了，还保持第一次的数据
        url = getRootPath() + "/restapiip/editRestapiIp?gid=" + gid;
        mesTitle = '编辑IP限制成功';
    } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
    }
}

function saveRestapiIp() {

    $.ajax({
        type: "POST",
        url:url,
        data:$('#configfm').serialize(),
        async: false,
        error: function(data) {
            alert("Connection error");
        },
        success: function(result) {
            if (result.success) {
                $('#configdlg').dialog('close');
                $("#datagrid").datagrid("options").url = getRootPath()+"/restapiip/datagrid";
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

function delRestapiIp() {
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        $.messager.confirm("删除", "是否删除", function (r) {
            if (r) {
                $.post(getRootPath()+'/restapiip/delRestapiIp',
                    {gid: record.gid},
                    function (result) {
                        //var result = eval('(' + result + ')');
                        if (result.success) {
                            $.messager.alert('消息提示', "删除成功");
                            $("#datagrid").datagrid("options").url = getRootPath()+"/restapiip/datagrid";
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

function addRedis() {
    $('#addredis').linkbutton({disabled:true});
    $.post(getRootPath()+'/restapiip/addredis',
        function (result) {
            //var result = eval('(' + result + ')');
            if (result.success==true) {
                $.messager.alert('提示', result.msg);
            } else {
                $.messager.alert('错误提示',result.msg);
            }
            $('#addredis').linkbutton({disabled:false});
        });
}