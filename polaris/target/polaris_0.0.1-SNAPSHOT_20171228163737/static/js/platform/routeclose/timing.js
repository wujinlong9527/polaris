/**
 * Created by Administrator on 2016/12/5.
 */
window.onload = function () {
    //onReset();
    reload();
}

function reload() {
    var openTime = $("#openTimeInput").val();
    var closeTime = $("#closeTimeInput").val();
    var repeatDate = $("#repeatDateInput").val();
    var v_repeatDate='';
    $("#openTime").val(openTime);
    $("#closeTime").val(closeTime);
    if(repeatDate.length<=3){
        var singleChar = repeatDate;
        if('MON' == singleChar) {
            $("#monday").attr("checked", true);
        }
        if('TUE' == singleChar) {
            $("#tuesday").attr("checked", true);
        }
        if('WED' == singleChar) {
            $("#wednesday").attr("checked", true);
        }
        if('THU' == singleChar) {
            $("#thursday").attr("checked", true);
        }
        if('FRI' == singleChar) {
            $("#friday").attr("checked", true);
        }
        if('SAT' == singleChar) {
            $("#saturday").attr("checked", true);
        }
        if('SUN' == singleChar) {
            $("#sunday").attr("checked", true);
        }
    }else{
        v_repeatDate = repeatDate.split(",");
        for(var i = 0;i <= v_repeatDate.length;i++) {
            repeatDate = v_repeatDate[i];
            if(repeatDate !=null && repeatDate !='') {
                var singleChar = repeatDate;
                if ('MON' == singleChar) {
                    $("#monday").attr("checked", true);
                }
                if ('TUE' == singleChar) {
                    $("#tuesday").attr("checked", true);
                }
                if ('WED' == singleChar) {
                    $("#wednesday").attr("checked", true);
                }
                if ('THU' == singleChar) {
                    $("#thursday").attr("checked", true);
                }
                if ('FRI' == singleChar) {
                    $("#friday").attr("checked", true);
                }
                if ('SAT' == singleChar) {
                    $("#saturday").attr("checked", true);
                }
                if ('SUN' == singleChar) {
                    $("#sunday").attr("checked", true);
                }
            }
        }
    }
}

function save() {
    var flag = prasData();
    if(flag) {
        $.ajax({
            type:"POST",
            url: getRootPath() + "/routeclose/saveTiming",
            data:$('#configfm').serialize(),
            error:function(){
              alert("Connection failed");
            },
            success: function (result) {
                if (result.success) {
                    window.parent.closeRoleDiv();
                } else {
                    $.messager.show({
                        title: "提示",
                        msg: result.msg
                    });
                }
            }
        });
    }
}

function prasData() {
    var openTime = $("#openTime").val();
    var closeTime = $("#closeTime").val();
    var repeatDate = '';
    if($("#monday").is(':checked')) {
        repeatDate = 'MON,';
    }
    if($("#tuesday").is(':checked')) {
        repeatDate += 'TUE,';
    }
    if($("#wednesday").is(':checked')) {
        repeatDate += 'WED,';
    }
    if($("#thursday").is(':checked')) {
        repeatDate += 'THU,';
    }
    if($("#friday").is(':checked')) {
        repeatDate += 'FRI,';
    }
    if($("#saturday").is(':checked')) {
        repeatDate += 'SAT,';
    }
    if($("#sunday").is(':checked')) {
        repeatDate += 'SUN,';
    }

    if((openTime != '' &&  closeTime != '' && repeatDate != '')
        || (openTime == '' &&  closeTime == '' && repeatDate == '')) {
        if(openTime != '' && openTime == closeTime) {
            $.messager.show({
                title: "保存失败",
                msg: "开启时间和关闭时间不能相同！"
            });
            return false;
        }
        $("#openTimeInput").val(openTime);
        $("#closeTimeInput").val(closeTime);
        $("#repeatDateInput").val(repeatDate);
        return true;
    } else {
        $.messager.show({
            title: "保存失败",
            msg: "时间和重复日期请保持同时有或无！"
        });
        return false;
    }
}

function onReset() {
    $("#openTime").val("");
    $("#closeTime").val("");
    $("#opposite").attr("checked", false);
    $("#monday").attr("checked", false);
    $("#tuesday").attr("checked", false);
    $("#wednesday").attr("checked", false);
    $("#thursday").attr("checked", false);
    $("#friday").attr("checked", false);
    $("#saturday").attr("checked", false);
    $("#sunday").attr("checked", false);
}

function onChange() {
    if($("#monday").is(':checked')) {
        $("#monday").attr("checked", false);
    } else {
        $("#monday").attr("checked", true);
    }
    if($("#tuesday").is(':checked')) {
        $("#tuesday").attr("checked", false);
    } else {
        $("#tuesday").attr("checked", true);
    }
    if($("#wednesday").is(':checked')) {
        $("#wednesday").attr("checked", false);
    } else {
        $("#wednesday").attr("checked", true);
    }
    if($("#thursday").is(':checked')) {
        $("#thursday").attr("checked", false);
    } else {
        $("#thursday").attr("checked", true);
    }
    if($("#friday").is(':checked')) {
        $("#friday").attr("checked", false);
    } else {
        $("#friday").attr("checked", true);
    }
    if($("#saturday").is(':checked')) {
        $("#saturday").attr("checked", false);
    } else {
        $("#saturday").attr("checked", true);
    }
    if($("#sunday").is(':checked')) {
        $("#sunday").attr("checked", false);
    } else {
        $("#sunday").attr("checked", true);
    }
}