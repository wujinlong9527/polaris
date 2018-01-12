window.onload = function () {
    $("#datagrid").datagrid("options").url = getRootPath()+"/configchannelt/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
    $('#openRoleDiv').dialog({
        onClose: function () {
            $("#datagrid").datagrid("options").url = getRootPath()+"/configchannelt/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }
    });

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

//获取所有渠道，给渠道combobox赋值
function getDealSubchannel() {
    $('#dealSubChannel').combobox({
        editable: false, //编辑状态
        cache: false,
        valueField: 'channelId',
        textField: 'dealSubChannel'
    });
    $.ajax({
        type: "POST",
        url: getRootPath()+"/configchannelt/getDealSubChannel",
        cache: false,
        async: true,
        dataType: "json",
        success: function (data) {
            $("#dealSubChannel").combobox("loadData", data.rows);
        }
    })
}

var url;
var mesTitle;
function addCnfigChannelt() {
    //获取所有渠道，给渠道combobox赋值
    getDealSubchannel();
    $("#account").attr("readonly", false);
    $('#configdlg').dialog('open').dialog('setTitle', '新增测试通道配置');
    $('#configfm').form('clear');
    $('#id').val("0");
    url = getRootPath() + "/configchannelt/addCnfigChannelt";
    mesTitle = '新增测试通道配置成功';
}

function editCnfigChannelt() {
    //获取所有渠道，给渠道combobox赋值
    getDealSubchannel();
    var row = $('#datagrid').datagrid('getSelected');
    if (row) {
        var id = row.id;
        $("#account").attr("readonly", true);
        $('#configdlg').dialog('open').dialog('setTitle', '编辑测试通道配置');
        $('#configfm').form('load', row);//这句话有问题，第一次加载时正确的，第二次就出错了，还保持第一次的数据
        url = getRootPath() + "/configchannelt/editCnfigChannelt?id=" + id;
        mesTitle = '编辑测试通道配置成功';
    } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
    }
}

function saveCnfigChannelt() {
    $("#sourceChannel").combobox("setValue", $("#sourceChannel").combobox("getText"));
    if (null == $("#sourceSubChannel").combobox("getValue")) {
        $("#sourceSubChannel").combobox("setValue", $("#sourceSubChannel").combobox("getText"));
    }

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
                $("#datagrid").datagrid("options").url =getRootPath() +"/configchannelt/datagrid";
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

//格式换显示状态
function formatcardType(val, row) {
    if (val == 1) {
        return '<span >' + '借记卡' + '</span>';
    } else if (val == 2) {
        return '<span>' + '信用卡' + '</span>';
    } else if (val == 10) {
        return '<span>' + '借记卡和信用卡' + '</span>';
    } else {
        return '<span>' + '未知类型' + '</span>';
    }
}

function delCnfigChannelt() {
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        $.messager.confirm("删除", "是否删除", function (r) {
            if (r) {
                $.post(getRootPath()+'/configchannelt/delCnfigChannelt',
                    {id: record.id},
                    function (result) {
                        //var result = eval('(' + result + ')');
                        if (result.success) {
                            $.messager.alert('消息提示', "删除成功");
                            $("#datagrid").datagrid("options").url = getRootPath()+"/configchannelt/datagrid";
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