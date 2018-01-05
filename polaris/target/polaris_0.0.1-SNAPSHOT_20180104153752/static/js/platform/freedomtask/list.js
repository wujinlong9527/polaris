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
    $('#nextSendTime').datebox('setValue', formatterDate(new Date()));
    $('#inTime').datebox('setValue', formatterDate(new Date()));
    $('#nextTime').datebox('setValue', formatterDate(new Date()));
    $("#datagrid").datagrid("options").url = getRootPath()+"/freedomtask/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");

    $('#sourceSubChannel').combobox({
        editable: true, //编辑状态
        cache: false,
        valueField: 'id',
        textField: 'text'
    });
}

function searchOrder() {
    $("#idcard").textbox('setValue', $("#idcard").textbox("getText"));
    $("#rpOrderId").textbox('setValue', $("#rpOrderId").textbox("getText"));
    $("#orderAction").textbox('setValue', $("#orderAction").textbox("getText"));
    $("#payOrderId").textbox('setValue', $("#payOrderId").textbox("getText"));
    if(null == $("#sourceSubChannel").combobox("getValue")) {
        $("#sourceSubChannel").combobox("setValue", $("#sourceSubChannel").combobox("getText"));
    }
    $("#datagrid").datagrid("options").url = getRootPath()+"/freedomtask/datagrid?" + $("#fmorder").serialize();

    $("#datagrid").datagrid("load");
}

function onReset() {
    $('#insertTime').datebox('setValue', formatterDate(new Date()));
    $('#nextSendTime').datebox('setValue', formatterDate(new Date()));
    $('#inTime').datebox('setValue', formatterDate(new Date()));
    $('#nextTime').datebox('setValue', formatterDate(new Date()));
    $("#idcard").textbox('setValue',"");
    $("#rpOrderId").textbox('setValue',"");
    $("#orderAction").textbox('setValue',"");
    $("#payOrderId").textbox('setValue',"");
    $("#sourceSubChannel").combobox("setValue","");
    $("#datagrid").datagrid("options").url =  getRootPath()+"/freedomtask/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
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

function formatType(val, row) {
    if (val == 1) {
        return '<span>' + '是' + '</span>';
    } else if (val == 0) {
        return '<span>' + '否' + '</span>';
    }
}

//确认修改提示框
function Confirm(msg, control) {
    $('#configdlg').dialog('open').dialog('setTitle', '修改');
    $('#configfm').form('clear');
    mesTitle = '修改成功';
}

//删除信息
function deleteInfo(){
    var insertTime = $("#insertTime").textbox("getText");//创建时间
    var inTime = $("#inTime").textbox("getText");//创建结束日期
    var nextSendTime = $("#nextSendTime").textbox("getText");//下次查询开始日期
    var nextTime = $("#nextTime").textbox("getText");//下次查询结束日期
    var payOrderId = $("#payOrderId").textbox("getText");//银联流水号
    var idcard = $("#idcard").textbox("getText");//身份证号
    var rpOrderId = $("#rpOrderId").textbox("getText");//rpOrderId
    var orderAction = $("#orderAction").textbox("getText");//orderAction
    var val = $("#sourceSubChannel").combobox("getText");
    var sourceSubChannel = dealChannel(val);//来源子渠道

    var _condition="已选择查询条件：";
    if(insertTime!=null && insertTime!=''){
        _condition+='</br>创建时间：'+insertTime;
    }
    if(inTime!=null && inTime!=''){
        _condition+='</br>创建结束日期：'+inTime;
    }
    if(nextSendTime!=null && nextSendTime!=''){
        _condition+="</br>下次查询开始日期："+nextSendTime;
    }
    if(nextTime!=null && nextTime!=''){
        _condition+="</br>下次查询结束日期："+nextTime;
    }
    if(payOrderId!=null && payOrderId!=''){
        _condition+="</br>银联流水号："+payOrderId;
    }
    if(idcard!=null && idcard!=''){
        _condition+="</br>身份证号："+idcard;
    }
    if(rpOrderId!=null && rpOrderId!=''){
        _condition+="</br>rpOrderId："+rpOrderId;
    }
    if(orderAction!=null && orderAction!=''){
        _condition+="</br>orderAction："+orderAction;
    }
    if(sourceSubChannel!=null && sourceSubChannel!=''){
        _condition+="</br>来源子渠道："+sourceSubChannel;
    }
    $.post( getRootPath()+'/freedomtask/doeditTotalNumber?'+"idcard="+idcard+"&rpOrderId="+rpOrderId+"&orderAction="+orderAction
        +"&sourceSubChannel="+sourceSubChannel+"&insertTime="+insertTime+"&inTime="+inTime+"&nextSendTime="+nextSendTime
        +"&nextTime="+nextTime+"&joiner="+joiner+"&payOrderId="+payOrderId,
        function (result) {
            var ifDeleteMsg=",是否删除?";
            console.info(result);
            if (result.success) {
                ifDeleteMsg="总共"+result.msg+"条"+ifDeleteMsg;
                $("#_ifDeleteMsg").html(ifDeleteMsg);
                $("#deleteMsg").html(_condition);
                $('#delDlg').dialog('open').dialog('setTitle', '删除');
                $('#del').form('clear');
            } else {
                mesTitle = '提示';
                result.msg= '查询删除条数失败';
                $.messager.show({
                    title: mesTitle,
                    msg: result.msg
                });
            }
        });
}
//修改remark
function doupdate(){
    $('#updateDlg').dialog('open').dialog('setTitle','修改');
    $('#updateR').form('clear');
}
//修改银联流水号
function doedit(){
    $('#editdlg').dialog('open').dialog('setTitle','修改');
    $('#editB').form('clear');
}
//修改下次发送时间
function doeditTime(){
    $('#editTimedlg').dialog('open').dialog('setTitle','修改');
    $('#editTime').form('clear');
}
function dealChannel(val){
    if (val == '理财1.0(deduct)') {
        return 'deduct';
    } else if (val =='借款2.0(harbor)') {
        return 'harbor';
    } else if (val =='借款2.0(harbor_sms)') {
        return 'harbor_sms';
    }else if (val =='借款1.0(loan)') {
        return 'loan';
    }else if (val =='借款强扣1.0(loan_force)') {
        return 'loan_force';
    }else if (val =='理财2.0(storm)') {
        return 'storm';
    }else if (val =='闪电分期(taurus)') {
        return 'taurus';
    }else if (val =='全部') {
        return '';
    }else {
        return val;
    }
}

//      是否取走更新
function update() {
    var insertTime = $("#insertTime").textbox("getText");
    var nextSendTime = $("#nextSendTime").textbox("getText");
    var inTime = $("#inTime").textbox("getText");
    var nextTime = $("#nextTime").textbox("getText");
    var idcard = $("#idcard").textbox("getText");
    var rpOrderId = $("#rpOrderId").textbox("getText");
    var orderAction = $("#orderAction").textbox("getText");
    var payOrderId = $("#payOrderId").textbox("getText");
    var val = $("#sourceSubChannel").combobox("getText");
    var sourceSubChannel = dealChannel(val);
    $('#configfm').form('submit', {
        url:  getRootPath()+"/freedomtask/update?idcard="+idcard+"&rpOrderId="+rpOrderId+"&orderAction="+orderAction
        +"&sourceSubChannel="+sourceSubChannel+"&insertTime="+insertTime+"&inTime="+inTime+"&nextSendTime="+nextSendTime
        +"&nextTime="+nextTime+"&payOrderId="+payOrderId,
        onSubmit: function () {
            return $(this).form('validate');
        },
        success: function (result) {
            var result = eval('(' + result + ')');
            if (result.success) {
                mesTitle= '提示';
                result.msg = '修改成功';
                $("#datagrid").datagrid("options").url =  getRootPath()+"/freedomtask/datagrid?" + $("#fmorder").serialize();
                $("#datagrid").datagrid("load");
            } else {
                mesTitle= '提示';
                result.msg = '修改失败';
            }
            $('#configdlg').dialog('close');
            $.messager.show({
                title: mesTitle,
                msg: result.msg
            });
        }
    });
}
//      根据条件批量修改流水号
function edit(){
    var insertTime = $("#insertTime").textbox("getText");
    var nextSendTime = $("#nextSendTime").textbox("getText");
    var inTime = $("#inTime").textbox("getText");
    var nextTime = $("#nextTime").textbox("getText");
    var idcard = $("#idcard").textbox("getText");
    var rpOrderId = $("#rpOrderId").textbox("getText");
    var orderAction = $("#orderAction").textbox("getText");
    var payOrderId = $("#payOrderId").textbox("getText");
    var val = $("#sourceSubChannel").combobox("getText");
    var sourceSubChannel = dealChannel(val);
    var joiner = $("#joiner").val();
    $.post(getRootPath()+'/freedomtask/doedit?'+"idcard="+idcard+"&rpOrderId="+rpOrderId+"&orderAction="+orderAction
        +"&sourceSubChannel="+sourceSubChannel+"&insertTime="+insertTime+"&inTime="+inTime+"&nextSendTime="+nextSendTime
        +"&nextTime="+nextTime+"&joiner="+joiner+"&payOrderId="+payOrderId,
        function (result) {
            console.info(result);
            if (result.success) {
                mesTitle= '提示';
                result.msg = '修改成功';
                $("#datagrid").datagrid("options").url = getRootPath()+"/freedomtask/datagrid?" + $("#fmorder").serialize();
                $("#datagrid").datagrid("load");
            } else {
                mesTitle = '提示';
                result.msg= '修改失败';
            }
            $('#editdlg').dialog('close');
            $.messager.show({
                title: mesTitle,
                msg: result.msg
            });
        });
}
//修改下次发送时间
function updateSendTime(){
    var insertTime = $("#insertTime").textbox("getText");
    var nextSendTime = $("#nextSendTime").textbox("getText");
    var inTime = $("#inTime").textbox("getText");
    var nextTime = $("#nextTime").textbox("getText");
    var idcard = $("#idcard").textbox("getText");
    var rpOrderId = $("#rpOrderId").textbox("getText");
    var orderAction = $("#orderAction").textbox("getText");
    var payOrderId = $("#payOrderId").textbox("getText");
    var val = $("#sourceSubChannel").combobox("getText");
    var sourceSubChannel = dealChannel(val);
    var updateNextTime = $("#updateNextTime").val();

    if(updateNextTime==null || updateNextTime==''){
        $.messager.show({
            title: '提示',
            msg: '请正确填写要更新的时间！'
        });
        return false;
    }
    $.post( getRootPath()+'/freedomtask/updateNextSendTime?'+"idcard="+idcard+"&rpOrderId="+rpOrderId+"&orderAction="+orderAction
        +"&sourceSubChannel="+sourceSubChannel+"&insertTime="+insertTime+"&inTime="+inTime+"&nextSendTime="+nextSendTime
        +"&nextTime="+nextTime+"&joiner="+updateNextTime+"&payOrderId="+payOrderId,
        function (result) {
            console.info(result);
            if (result.success) {
                mesTitle= '提示';
                result.msg = '修改成功,修改数据： '+result.msg+" 条";
                $("#datagrid").datagrid("options").url =  getRootPath()+"/freedomtask/datagrid?" + $("#fmorder").serialize();
                $("#datagrid").datagrid("load");
            } else {
                mesTitle = '提示';
                result.msg= '修改失败';
            }
            $('#editTimedlg').dialog('close');
            $.messager.show({
                title: mesTitle,
                msg: result.msg
            });
        }
    );
}
/*删除根据已知条件查出的信息*/
function  deleteIn(){
    var insertTime = $("#insertTime").textbox("getText");
    var nextSendTime = $("#nextSendTime").textbox("getText");
    var inTime = $("#inTime").textbox("getText");
    var nextTime = $("#nextTime").textbox("getText");
    var idcard = $("#idcard").textbox("getText");
    var rpOrderId = $("#rpOrderId").textbox("getText");
    var orderAction = $("#orderAction").textbox("getText");
    var payOrderId = $("#payOrderId").textbox("getText");
    var val = $("#sourceSubChannel").combobox("getText");
    var sourceSubChannel = dealChannel(val);
    $.post(getRootPath()+'/freedomtask/delete?'+"idcard="+idcard+"&rpOrderId="+rpOrderId+"&orderAction="+orderAction
        +"&sourceSubChannel="+sourceSubChannel+"&insertTime="+insertTime+"&inTime="+inTime+"&nextSendTime="+nextSendTime
        +"&nextTime="+nextTime+"&payOrderId="+payOrderId,
        function (result) {
            console.info(result);
            if (result.success) {
                mesTitle= '提示';
                result.msg = '删除成功,共删除数据 '+result.msg+" 条";
                $("#datagrid").datagrid("options").url = getRootPath()+"/freedomtask/datagrid?" + $("#fmorder").serialize();
                $("#datagrid").datagrid("load");
            } else {
                mesTitle = '提示';
                result.msg= '删除失败';
            }
            $('#delDlg').dialog('close');
            $.messager.show({
                title: mesTitle,
                msg: result.msg
            });
        });
}
//更新remark状态
function updateRemark(){
    var insertTime = $("#insertTime").textbox("getText");
    var nextSendTime = $("#nextSendTime").textbox("getText");
    var inTime = $("#inTime").textbox("getText");
    var nextTime = $("#nextTime").textbox("getText");
    var idcard = $("#idcard").textbox("getText");
    var rpOrderId = $("#rpOrderId").textbox("getText");
    var orderAction = $("#orderAction").textbox("getText");
    var payOrderId = $("#payOrderId").textbox("getText");
    var val = $("#sourceSubChannel").combobox("getText");
    var sourceSubChannel = dealChannel(val);
    $.ajax({
        cache: true,
        type: "POST",
        url:getRootPath()+"/freedomtask/doupdate?idcard="+idcard+"&rpOrderId="+rpOrderId+"&orderAction="+orderAction
        +"&sourceSubChannel="+sourceSubChannel+"&insertTime="+insertTime+"&inTime="+inTime+"&nextSendTime="+nextSendTime
        +"&nextTime="+nextTime+"&payOrderId="+payOrderId,
        data:$('#updateR').serialize(),
        async: false,
        error: function(request) {
            alert("Connection error");
        },
        success: function (result) {
            if (result.success) {
                mesTitle= '提示';
                result.msg = '修改成功';
                searchOrder();
            } else {
                mesTitle = '提示';
                result.msg= '修改失败';
            }
            $('#updateDlg').dialog('close');
            $.messager.show({
                title: mesTitle,
                msg: result.msg
            });
        }
    });

}