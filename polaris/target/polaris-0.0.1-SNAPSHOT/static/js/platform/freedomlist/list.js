/**
 * Created by Administrator on 2016/11/30.
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
    $('#operateTime').datebox('setValue', formatterDate(new Date()));
    $("#datagrid").datagrid("options").url = getRootPath()+"/freedomlist/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

function searchOrder() {
    $("#idNo").textbox('setValue', $("#idNo").textbox("getText"));
    $("#datagrid").datagrid("options").url = getRootPath()+"/freedomlist/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

function onReset() {
    $('#insertTime').datebox('setValue', formatterDate(new Date()));
    $('#operateTime').datebox('setValue', formatterDate(new Date()));
    $("#idNo").textbox('setValue', "");
    $("#datagrid").datagrid("options").url = getRootPath()+"/freedomlist/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}
//启用
function enableFreedomConfig(val) {
    var record = $("#datagrid").datagrid('getSelected');
    var del = 0;
    if (record) {
        if(val==1){
            del = record.isDel;
        }else if(val==2){
            del = record.stormDel;
        }
        if(0 == del) {
            $.messager.alert('提示', '已启用，不需重新启用');
        } else {
            $.messager.confirm("启用", "是否启用", function (r) {
                if (r) {
                    $.post(getRootPath()+'/freedomlist/enableFreedomConfig?select='+val,
                        {accountId: record.accountId},
                        function (result) {
                            if (result.success) {
                                $.messager.alert('消息提示', "启用成功");
                                $("#datagrid").datagrid("options").url = getRootPath()+"/freedomlist/datagrid?"+ $("#fmorder").serialize();
                                $("#datagrid").datagrid("load");
                            } else {
                                $.messager.alert('错误提示', "启用失败");
                            }
                        });
                }
            });
        }
    } else {
        $.messager.alert('提示', '请先选中要启用的行');
    }
}
//禁用
function disableFreedomConfig(val) {
    var record = $("#datagrid").datagrid('getSelected');
    var del = 0;
    if (record) {
        if(val==1){
            del = record.isDel;
        }else if(val==2){
            del = record.stormDel;
        }
        console.info(record.accountId);
        if(1 == del) {
            $.messager.alert('提示', '已禁用，不需重新禁用');
        } else {
            $.messager.confirm("禁用", "是否禁用", function (r) {
                if (r) {
                    $.post(getRootPath()+'/freedomlist/disableFreedomConfig?select='+val,
                        {accountId: record.accountId},
                        function (result) {
                            if (result.success) {
                                $.messager.alert('消息提示', "禁用成功");
                                $("#datagrid").datagrid("options").url = getRootPath()+"/freedomlist/datagrid?"+ $("#fmorder").serialize();
                                $("#datagrid").datagrid("load");
                            } else {
                                $.messager.alert('错误提示', "禁用失败");
                            }
                        });
                }
            });
        }
    } else {
        $.messager.alert('提示', '请先选中要禁用的行');
    }
}

function formatstormDel(val, row) {
    if (val == '1') {
        return '<span style="color:red;">' + '禁用' + '</span>';
    } else if (val =='0') {
        return '<span>' + '启用' + '</span>';
    }
}

function formatIsDel(val, row) {
    if (val == '1') {
        return '<span style="color:red;">' + '禁用' + '</span>';
    } else if (val =='0') {
        return '<span>' + '启用' + '</span>';
    }
}

//添加Redis
function addRedisConfig() {
    $('#addredis').linkbutton({disabled:true});
    $.post(getRootPath()+'/freedomlist/addredis?'+ $("#fmorder").serialize(),
        function (result) {
            var result = eval('(' + result + ')');
            if (result.success==true &&  result.msg>0) {
                $.messager.alert('提示', "更新"+result.msg+"条数据");
            } else if(result.success==true) {
                $.messager.alert('提示', "没有可更新的数据");
            }else{
                $.messager.alert('提示', "更新失败");
            }
            $('#addredis').linkbutton({disabled:false});
        });
}
