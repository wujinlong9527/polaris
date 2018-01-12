<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>用户管理</title>
    <%@include file="/WEB-INF/pages/include/easyui.jsp" %>
    <!-- 对话框的样式 -->
    <link href="${path}/css/userList.css" rel="stylesheet" type="text/css"/>

    <script type="text/javascript">
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
            $('#finalTime').datebox('setValue', formatterDate(new Date()));

            $("#datagrid").datagrid("options").url = "${path}/userinfo/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");

            $('#datagrid').datagrid({
                view: detailview,
                detailFormatter: function (rowIndex, rowData) {
                    return '<table>'
                            + '<tr>'
                            + '<td style="border:0;padding:3px"><b>返回数据：</b></td>'
                            + '</tr>'
                            + '<tr>'
                            + '<td style="border:0;padding:3px"><xmp>' + rowData.bankReturnMsg + '</xmp></td>'
                            + '</tr>'
                            + '</table>';
                }
            });
            //页面加载时即加载所有渠道，用于查询条件中渠道下拉
            getDealchannel();
        }

        function searchOrder() {
            $("#dealSubChannel").combobox("setValue", $("#dealSubChannel").combobox("getText"));
            $("#datagrid").datagrid("options").url = "${path}/userinfo/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        function onReset() {
            $('#insertTime').datebox('setValue', formatterDate(new Date()));
            $('#finalTime').datebox('setValue', formatterDate(new Date()));
            $("#fullName").textbox('setValue', "");
            $("#cardNo").textbox('setValue', "");
            $("#idCard").textbox('setValue', "");
            $("#phone").textbox('setValue', "");
            $("#dealSubChannel").combobox('setValue', "");
            $("#datagrid").datagrid("options").url = "${path}/userinfo/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        //
        function formatCardType(val, row) {
            if (val == 1) {
                return '<span>' + '借记卡' + '</span>';
            } else if (val == 2) {
                return '<span>' + '信用卡' + '</span>';
            }
        }

        function formatIsSuc(val, row) {
            if (val == 0) {
                return '<span>' + '处理中' + '</span>';
            } else if (val == 1) {
                return '<span>' + '成功' + '</span>';
            } else if (val == -1) {
                return '<span>' + '失败' + '</span>';
            }
        }
        function formatIschannel(val, row) {
            if (val == 'deduct') {
                return '<span>' + '理财1.0(deduct)' + '</span>';
            } else if (val =='harbor') {
                return '<span>' + '借款2.0(harbor)' + '</span>';
            } else if (val =='loan') {
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
            }
            else {
                return '<span>' + val + '</span>';
            }
        }

        //获取所有渠道，给渠道combobox赋值
        function getDealchannel() {
            $('#dealSubChannel').combobox({
                editable: true, //编辑状态
                cache: false,
                valueField: 'dealSubChannel',
                textField: 'dealSubChannel',
               // value: "全部"//默认显示全部选项
            });
            $.ajax({
                type: "POST",
                url: "${path}/userinfo/getDealChannel",
                cache: false,
                async: true,
                dataType: "json",
                success: function (data) {
                   // data.rows.unshift({"dealSubChannel":"全部"});//第一列加上全部选项
                    $("#dealSubChannel").combobox("loadData", data.rows).val();
                }
            })
        }

        //弹出新增界面
        function addConfig() {
            var orderAction = "鉴权验证";
            //ajax加载鉴权验证类型的渠道
            $.ajax({
                type: "POST",
                url: "${path}/routechannel/getDealchannel",
                data:{orderAction:orderAction},
                cache: false,
                async: true,
                dataType: "json",
                success: function (data) {
                    $("#dealSubChannelAdd").combobox("loadData", data.rows);
                }
            })
            $('#configdlg').dialog('open').dialog('setTitle', '扣款查询');
            $('#configfm').form('clear');
            mesTitle = '新增成功';
        }

        function addRedisConfig() {
            $("#dealSubChannel").combobox("setValue", $("#dealSubChannel").combobox("getText"));
            $('#addredis').linkbutton({disabled:true});
            $.post('${path}/userinfo/updchannel?'+ $("#fmorder").serialize(),
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

        function addAllRedisConfig() {
            $('#addredis').linkbutton({disabled:true});
            $.post('${path}/userinfo/updallchannel?'+ $("#fmorder").serialize(),
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

        //新增保存
        function saveConfig() {
            $('#configfm').form('submit', {
                url: path + "/userinfo/adduserinfo",
                onSubmit: function () {
                    return $(this).form('validate');
                },
                success: function (result) {
                    var result = eval('(' + result + ')');

                    if (result.success) {
                        $('#configdlg').dialog('close');
                        $('#datagrid').datagrid('reload');
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
    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 任务信息列表 -->
    <table id="datagrid" title="用户信息列表" class="easyui-datagrid" fit="true"
    <%--url="${path}/userinfo/datagrid" --%>
           toolbar="#toolbar" pagination="true"
           fitColumns="false" singleSelect="true" rownumbers="true"
           border="false" nowrap="true">
        <thead frozen="true">
        <tr>
            <th field="fullName" width="80">姓名</th>
        </tr>
        </thead>
        <thead>
        <tr>
            <th field="cardNo" width="140">银行卡号</th>
            <th field="idCard" width="140">身份证号</th>
            <th field="phone" width="100">手机号</th>
            <th field="insertTime" width="140">创建时间</th>
            <th field="dealSubChannel" width="90">处理子渠道</th>
            <th field="customerId" width="90">客户编号</th>
        </tr>
        </thead>
    </table>

    <!-- 按钮 -->

    <div id="toolbar" class="easyui-layout"
         style="width:100%;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <form id="fmorder" name="fmorder" method="post">
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <label>开始日期:</label> <input id="insertTime" name="insertTime" class="easyui-datetimebox"
                                            style="width: 100px">
                <label>结束日期:</label> <input id="finalTime" name="finalTime" class="easyui-datetimebox" style="width: 100px">
                <label>姓名:</label> <input id="fullName" name="fullName" class="easyui-textbox" style="width: 100px">
                <label>手机号:</label> <input id="phone" name="phone" class="easyui-textbox" style="width: 100px">
                <label>身份证号:</label> <input id="idCard" name="idCard" class="easyui-textbox" style="width: 150px">
                <label>银行卡号:</label> <input id="cardNo" name="cardNo" class="easyui-textbox" style="width: 150px">
            </div>
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <label>处理子渠道:</label> <input id="dealSubChannel" name="dealSubChannel" class="easyui-textbox" style="width: 120px">
            </div>
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">

                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchOrder();">查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
                <a href="javascript:void(0);" class="easyui-linkbutton" id="addredis"
                   iconCls="icon-add" plain="true" onclick="addRedisConfig();">更新到Redis</a>
                <a href="javascript:void(0);" class="easyui-linkbutton" id="addallredis"
                   iconCls="icon-add" plain="true" onclick="addAllRedisConfig();">全部更新到Redis</a>
            </div>
        </form>

    </div>

    <!-- 新增对话框 -->
    <div id="configdlg" class="easyui-dialog"
         style="width:300px;height:250px;padding:10px 20px" closed="true"
         buttons="#configdlg-buttons">
        <form id="configfm" method="post" novalidate>
            <table>
                <input id="id" name="id" type="hidden"></td>
                <input id="olddealChannel" name="olddealChannel" type="hidden"></td>
                <input id="olddealSubChannel" name="olddealSubChannel" type="hidden"></td>
                <tr>
                    <td align="right">*姓名:</td>
                    <td><input id="fullNameAdd" name="fullName" type="text" class="easyui-validatebox"
                               required="true"></td>
                </tr>
                <tr>
                    <td align="right">*身份证号:</td>
                    <td><input id="idCardAdd" name="idCard" type="text" class="easyui-validatebox"
                               required="true"></td>
                </tr>
                <tr>
                    <td align="right">*手机号:</td>
                    <td><input id="phoneAdd" name="phone" type="text" class="easyui-validatebox"
                               required="true"></td>
                </tr>
                <tr>
                    <td align="right">*银行卡号:</td>
                    <td><input id="cardNoAdd" name="cardNo" type="text" class="easyui-validatebox"
                               required="true"></td>
                </tr>
                <tr>
                    <td align="right">*渠道:</td>
                    <td>
                        <input id="dealSubChannelAdd" name="dealSubChannel" style="width: 150px" class="easyui-combobox"
                               data-options="editable:false,valueField:'id',textField:'dealSubChannel',data:[]" required="true">
                    </td>
                </tr>

            </table>
        </form>
    </div>

    <!-- 对话框按钮 -->
    <div id="configdlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="saveConfig()" style="width:60px">保存</a> <a
            href="javascript:void(0)" class="easyui-linkbutton"
            iconCls="icon-cancel" onclick="javascript:$('#configdlg').dialog('close')"
            style="width:60px">取消</a>
    </div>
</div>

</body>
</html>
