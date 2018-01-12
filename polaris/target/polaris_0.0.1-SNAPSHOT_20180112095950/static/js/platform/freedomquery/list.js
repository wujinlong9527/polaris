/**
 * Created by Administrator on 2016/12/1.
 */
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
    $("#datagrid").datagrid("options").url = getRootPath()+"/freedomquery/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");

    $('#datagrid').datagrid({
        view: detailview,
        detailFormatter: function (rowIndex, rowData) {
            tmp=rowData.length;
            return '<table>'
                + '<tr>'
                + '<td style="border:0;padding:3px"><b>返回bankMsg数据：</b></td>'
                + '</tr>'
                + '<tr>'
                + '<td style="border:0;padding:3px"><xmp>' + rowData.bankMsg + '</xmp></td>'
                + '</tr>'
                + '<tr>'
                + '<td style="border:0;padding:3px"><b>返回fileContent数据：</b></td>'
                + '</tr>'
                + '<tr>'
                + '<td style="border:0;padding:3px"><xmp>' + rowData.fileContent + '</xmp></td>'
                + '</tr>'
                + '</table>';
        }
    });

}

function searchOrder() {
    $("#datagrid").datagrid("options").url = getRootPath()+"/freedomquery/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

function onReset() {
    $('#insertTime').datebox('setValue', formatterDate(new Date()));
    $('#inTime').datebox('setValue', formatterDate(new Date()));
    $("#datagrid").datagrid("options").url = getRootPath()+"/freedomquery/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}


//修改
function doupdate(){
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        $('#updatefm').form('load', record);//这句话有问题，第一次加载时正确的，第二次就出错了，还保持第一次的数据
        $('#updateDlg').dialog('open').dialog('setTitle','编辑信息');
    }else {
        $.messager.alert('提示', '请先选中要修改的行');
    }
}

//      是否取走更新
function updateF() {
    var record = $("#datagrid").datagrid('getSelected');
    $.ajax({
        url:getRootPath()+"/freedomquery/update?id="+record.id,
        type:"POST",
        data:$("#updatefm").serialize(),
        error: function(request) {
            alert("Connection error");
        },
        success: function (result) {
            if (result.success) {
                mesTitle= '提示';
                result.msg = '修改成功';
                $("#datagrid").datagrid("options").url = getRootPath()+"/freedomquery/datagrid?" + $("#fmorder").serialize();
                $("#datagrid").datagrid("load");
            } else {
                mesTitle = '提示';
                result.msg = '修改失败'
            }
            $('#updateDlg').dialog('close');
            $.messager.show({
                title: mesTitle,
                msg: result.msg
            });
        }
    });
}

