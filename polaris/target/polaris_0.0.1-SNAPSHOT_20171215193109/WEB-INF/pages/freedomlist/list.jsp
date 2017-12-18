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
            $('#operateTime').datebox('setValue', formatterDate(new Date()));
            $("#datagrid").datagrid("options").url = "${path}/freedomlist/datagrid?" + $("#fmorder").serialize();
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
        }

        function searchOrder() {
            $("#idNo").textbox('setValue', $("#idNo").textbox("getText"));
            $("#datagrid").datagrid("options").url = "${path}/freedomlist/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        function onReset() {
            $('#insertTime').datebox('setValue', formatterDate(new Date()));
            $('#operateTime').datebox('setValue', formatterDate(new Date()));
            $("#idNo").textbox('setValue', "");
            $("#datagrid").datagrid("options").url = "${path}/freedomlist/datagrid?" + $("#fmorder").serialize();
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
                            $.post('${path}/freedomlist/enableFreedomConfig?select='+val,
                            {accountId: record.accountId},
                            function (result) {
                                var result = eval('(' + result + ')');
                                if (result.success) {
                                    $.messager.alert('消息提示', "启用成功");
                                    $("#datagrid").datagrid("options").url = "${path}/freedomlist/datagrid?"+ $("#fmorder").serialize();
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
                            $.post('${path}/freedomlist/disableFreedomConfig?select='+val,
                            {accountId: record.accountId},
                            function (result) {
                                var result = eval('(' + result + ')');
                                if (result.success) {
                                    $.messager.alert('消息提示', "禁用成功");
                                    $("#datagrid").datagrid("options").url = "${path}/freedomlist/datagrid?"+ $("#fmorder").serialize();
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
            $.post('${path}/freedomlist/addredis?'+ $("#fmorder").serialize(),
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

    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 任务信息列表 -->
    <table id="datagrid" title="恒丰查询" class="easyui-datagrid" fit="true"
           toolbar="#toolbar" pagination="true"
           fitColumns="false" singleSelect="true" rownumbers="true"
           border="false" nowrap="true">
        <thead frozen="true">
        <tr>
            <th field="pName" width="80">姓名</th>
        </tr>
        </thead>
        <thead>
        <tr>
            <th field="eAccNo" width="140">虚账号</th>
            <th field="idNo" width="140">身份证号</th>
            <th field="soleId" width="100" hidden="hidden">soleId</th>
            <th field="dealChannel" width="90">处理渠道</th>
            <th field="amount" width="90">金额</th>
            <th field="finAmount" width="90">理财金额</th>
            <th field="loanAmount" width="90">借款金额</th>
            <th field="proAmount" width="90">收益</th>
            <th field="insertTime" width="140">创建时间</th>
            <th field="operateTime" width="140">操作时间</th>
            <th field="gGcustomerId" width="90">客户编号</th>
            <th field="stormDel" width="90" formatter="formatstormDel">可投资还款</th>
            <th field="isDel" width="90" formatter="formatIsDel">可借款提现</th>
            <th field="accountId" width="90" hidden="hidden">accountId</th>
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
                <label>结束日期:</label> <input id="operateTime" name="operateTime" class="easyui-datetimebox" style="width: 100px">
                <label>身份证号:</label> <input id="idNo" name="idNo" class="easyui-textbox" style="width: 150px">

                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchOrder();">查询</a>

                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
            </div>
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-remove" plain="true" onclick="enableFreedomConfig(1);">借款提现启用</a>

                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-remove" plain="true" onclick="disableFreedomConfig(1);">借款提现禁用</a>

                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-remove" plain="true" onclick="enableFreedomConfig(2);">投资还款启用</a>

                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-remove" plain="true" onclick="disableFreedomConfig(2);">投资还款禁用</a>
<%--                <a href="javascript:void(0);" class="easyui-linkbutton" id="addredis"
                   iconCls="icon-add" plain="true" onclick="addRedisConfig();">更新到Redis</a>--%>
            </div>
        </form>
    </div>

</div>

</body>
</html>
