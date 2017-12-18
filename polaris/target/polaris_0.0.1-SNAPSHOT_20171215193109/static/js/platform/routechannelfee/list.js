/**
 * Created by Administrator on 2016/12/5.
 */
window.onload = function() {
    getDealChannel();
    searchOrder();
}

var url;
var mesTitle;
function addRouteChannelFee() {
    $("#account").attr("readonly", false);
    $('#configdlg').dialog('open').dialog('setTitle', '新增渠道费用');
    $('#configfm').form('clear');
    $('#id').val("0");
    url = getRootPath() + "/routechannelfee/addRouteChannelFee";
    mesTitle = '新增';
}

function editRouteChannelFee() {
    var row = $('#datagrid').datagrid('getSelected');
    if (row) {
        var id = row.id;
        $("#account").attr("readonly", true);
        $('#configdlg').dialog('open').dialog('setTitle', '编辑渠道费用');
        $('#configfm').form('load', row);
        url = getRootPath() + "/routechannelfee/editRouteChannelFee?id=" + id;
        mesTitle = '编辑';
    } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
    }
}

function saveRouteChannelFee() {
    if(null == $("#dealChannel").combobox("getValue")) {
        $("#dealChannel").combobox("setValue", $("#dealChannel").combobox("getText"));
    }
    $.ajax({
        type:"POST",
        data:$('#configfm').serialize(),
        url: url,
        error: function () {
          alert("Connection failed");
        },
        success: function (result) {
            if (result.success) {
                $('#configdlg').dialog('close');
                $("#datagrid").datagrid("options").url = getRootPath()+"/routechannelfee/datagrid?" + $("#fmorder").serialize();
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

function delRouteChannelFee() {
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        $.messager.confirm("删除", "是否删除", function (r) {
            if (r) {
                $.post(getRootPath()+'/routechannelfee/delRouteChannelFee',
                    {id: record.id},
                    function (result) {
                        if (result.success) {
                            $.messager.alert('消息提示', "删除成功");
                            $("#datagrid").datagrid("options").url = getRootPath()+"/routechannelfee/datagrid?" + $("#fmorder").serialize();
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
    if(null == $("#dealChannelSrc").combobox("getValue")) {
        $("#dealChannelSrc").combobox("setValue", $("#dealChannelSrc").combobox("getText"));
    }
    $("#datagrid").datagrid("options").url = getRootPath()+"/routechannelfee/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

function onReset() {
    $("#dealChannelSrc").combobox("setValue", "");
    $("#datagrid").datagrid("options").url = getRootPath()+"/routechannelfee/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

function getDealChannel() {
    $('#dealChannel').combobox({
        editable: true, //编辑状态
        cache: false,
        valueField: 'dealChannel',
        textField: 'dealChannel'
    });

    $('#dealChannelSrc').combobox({
        editable: true, //编辑状态
        cache: false,
        valueField: 'dealChannel',
        textField: 'dealChannel'
    });

    $.ajax({
        type: "POST",
        url: getRootPath()+"/routechannelfee/getDealChannel",
        cache: false,
        async: true,
        dataType: "json",
        success: function (data) {
            $("#dealChannel").combobox("loadData", data.rows);
            $("#dealChannelSrc").combobox("loadData", data.rows);
        }
    })
}