var url;
var mesTitle;
formatterDate = function (date) {
    var day = date.getDate() > 9 ? date.getDate() : "0" + date.getDate();
    var month = (date.getMonth() + 1) > 9 ? (date.getMonth() + 1) : "0"
    + (date.getMonth() + 1);
    return date.getFullYear() + '-' + month + '-' + day;
};
window.onload = function () {
    $('#insertTime').datebox('setValue', formatterDate(new Date()));
    $('#inTime').datebox('setValue', formatterDate(new Date()));
    $("#datagrid").datagrid("options").url = getRootPath()+"/freedomhkquery/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");

}
//查询
function searchOrder(){
    $("#paramFileName").textbox('setValue', $("#paramFileName").textbox("getText"));
    $("#datagrid").datagrid("options").url = getRootPath()+"/freedomhkquery/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}
//重置
function onReset(){
    $('#insertTime').datebox('setValue', formatterDate(new Date()));
    $('#inTime').datebox('setValue', formatterDate(new Date()));
    $('#paramFileName').textbox('setValue',"");
    $("#datagrid").datagrid("options").url = getRootPath()+"/freedomhkquery/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

//修改调修改窗口
function doupdate(){
    var record = $("#datagrid").datagrid('getSelected');
    if(record){
        $("#updatefm").form('load',record);
        $("#updateDlg").dialog('open').dialog('setTitle','编辑信息');
    }else{
        $.messager.alert('提示',"请选择要修改的行");
    }
}

function update(){
    var record = $("#datagrid").datagrid('getSelected');
    $.ajax({
        cache: true,
        type: "POST",
        url:getRootPath()+ "/freedomhkquery/doupdate?id="+record.id,
        data:$('#updatefm').serialize(),
        async: false,
        error: function(request) {
            alert("Connection error");
        },
        success: function (result) {
            console.info(result);
            if (result.success) {
                mesTitle = '提示';
                $("#datagrid").datagrid("options").url = getRootPath() + "/freedomhkquery/datagrid?" + $("#fmorder").serialize();
                $("#datagrid").datagrid("load");
            } else {
                mesTitle = '提示';
            }
            $('#updateDlg').dialog('close');
            $.messager.show({
                title: mesTitle,
                msg: result.msg
            });
        }
    });
}