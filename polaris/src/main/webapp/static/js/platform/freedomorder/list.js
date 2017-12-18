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
window.onload = function(){
    $('#insertTime').datebox('setValue', formatterDate(new Date()));
    $('#inTime').datebox('setValue', formatterDate(new Date()));
    $("#datagrid").datagrid("options").url = getRootPath()+"/freedomorder/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");

    $('#sourceSubChannel').combobox({
        editable: true, //编辑状态
        cache: false,
        valueField: 'id',
        textField: 'text'
    });
}

function formatIschannel(val, row) {
    if (val == 'deduct') {
        return '<span>' + '理财1.0(deduct)' + '</span>';
    } else if (val =='harbor') {
        return '<span>' + '借款2.0(harbor)' + '</span>';
    } else if (val =='harbor_sms') {
        return '<span>' + '借款2.0(harbor_sms)' + '</span>';
    }else if (val =='loan') {
        return '<span>' + '借款1.0(loan)' + '</span>';
    }
    else if (val =='loan_force') {
        return '<span>' + '借款强扣1.0(loan_force)' + '</span>';
    }
    else if (val =='storm') {
        return '<span>' + '理财2.0(storm)' + '</span>';
    }
    else if (val =='taurus') {
        return '<span>' + '闪电分期(taurus)' + '</span>';
    }else {
        return '<span>' + val + '</span>';
    }
}
//查询
function searchOrder(){
    $("#idcard").textbox('setValue', $("#idcard").textbox("getText"));
    $("#rpOrderId").textbox('setValue', $("#rpOrderId").textbox("getText"));
    $("#orderAction").textbox('setValue', $("#orderAction").textbox("getText"));
    $("#payOrderId").textbox('setValue', $("#payOrderId").textbox("getText"));
    if(null == $("#sourceSubChannel").combobox("getValue")) {
        $("#sourceSubChannel").combobox("setValue", $("#sourceSubChannel").combobox("getText"));
    }
    $("#datagrid").datagrid("options").url = getRootPath()+"/freedomorder/datagrid?" + $("#fmorder").serialize();

    $("#datagrid").datagrid("load");
}

//重置
function onReset(){
    $('#insertTime').datebox('setValue', formatterDate(new Date()));
    $('#inTime').datebox('setValue', formatterDate(new Date()));
    $("#idcard").textbox('setValue',"");
    $("#rpOrderId").textbox('setValue',"");
    $("#orderAction").textbox('setValue',"");
    $("#payOrderId").textbox('setValue',"");
    $("#sourceSubChannel").combobox("setValue","");
    $("#datagrid").datagrid("options").url = getRootPath()+"/freedomorder/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}
