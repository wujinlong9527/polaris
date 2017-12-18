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

        window.onload = function () {
            $("#datagrid").datagrid("options").url
                    = "${path}/routestrategy/datagrid?bankId=" + $('#bankId').val();
            $("#datagrid").datagrid("load");

            $('#openRoleDiv').dialog({
                onClose: function () {
                    $("#datagrid").datagrid("options").url
                            = "${path}/routestrategy/datagrid?bankId=" + $('#bankId').val();
                    $("#datagrid").datagrid("load");
                }
            });
        }

        //格式换显示状态
        function formatIsdel(val, row) {
            if (val == 1) {
                return '<span style="color:red;">' + '禁用' + '</span>';
            } else if (val == 0) {
                return '<span>' + '启用' + '</span>';
            }
        }

        //查询列表
        function searchOrder() {
            $("#datagrid").datagrid("options").url = "${path}/routestrategy/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        //重置
        function onReset() {
            $("#strategy").textbox('setValue', "");
            $("#cardType").combobox('setValue', "");
            $("#isdel").combobox("setValue", "");
            $("#datagrid").datagrid("options").url = "${path}/routestrategy/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        //弹出新增界面
        function addConfig() {
            $('#iframe2')[0].src = '${path}/routestrategy/strategyinfo?bankId=' + $('#bankId').val();
            $('#openRoleDiv').dialog('open');
        }

        //删除
        function removeConfig() {
            var record = $("#datagrid").datagrid('getSelected');
            if (record) {
                if (record.isdel == 1) {
                    $.messager.alert('错误提示', "数据已经禁用,不需要再次禁用！");
                    return;
                }
                $.messager.confirm("禁用", "是否禁用", function (r) {
//                    if (r) {
//                        $('#delreasondlg').dialog('open').dialog('setTitle', '删除原因');
//                        $('#delReason').val("");
//                    }
                    if (r) {
                        $.post('${path}/routestrategy/upRoutestrategy',
                                {isdel: 1, id: record.id},
                                function (result) {
                                    var result = eval('(' + result + ')');
                                    if (result.success) {
//                                    $('#delreasondlg').dialog('close');
                                        $.messager.alert('消息提示', "禁用成功");
                                        $("#datagrid").datagrid("options").url = "${path}/routestrategy/datagrid?" + $("#fmorder").serialize();
                                        $("#datagrid").datagrid("load");
                                    } else {
                                        $.messager.alert('错误提示', "禁用失败");
                                    }
                                });
                    }
                });

            } else {
                $.messager.alert('提示', '请先选中要禁用的行');
            }
        }

        function recoverConfig() {
            var record = $("#datagrid").datagrid('getSelected');
            if (record) {
                if (record.isdel == 0) {
                    $.messager.alert('错误提示', "数据为启用状态,不需要启用！");
                    return;
                }
                $.messager.confirm("启用", "是否启用", function (r) {
                    if (r) {
                        $.post('${path}/routestrategy/upRoutestrategy',
                                {isdel: 0, id: record.id},
                                function (result) {
                                    var result = eval('(' + result + ')');
                                    if (result.success) {
                                        $.messager.alert('消息提示', "启用成功");
                                        $("#datagrid").datagrid("options").url = "${path}/routestrategy/datagrid?" + $("#fmorder").serialize();
                                        $("#datagrid").datagrid("load");
                                    } else {
                                        $.messager.alert('错误提示', "启用失败");
                                    }
                                });
                    }
                });

            } else {
                $.messager.alert('提示', '请先选中要启用的行');
            }
        }

        //格式换显示状态
        function formatdata(val, row) {
//            return '<a class="editcls" onclick="editRow(\'' + row.id + '\')" href="javascript:void(0)">编辑</a>'
//                    + '&nbsp;&nbsp;&nbsp;&nbsp;'
//                    + '<a class="editcls" onclick="editRow(\'' + row.id + '\')" href="javascript:void(0)">查看</a>';
            return '<a class="editcls" onclick="editRow(\'' + row.id + '\',\'' + row.isdel + '\')" href="javascript:void(0)">配置</a>';
        }

        function editRow(strategyId, isdel) {
//            if (isdel == 1) {
//                $.messager.alert('错误提示', "数据已经禁用,不需要配置！");
//                return;
//            }
            $('#iframe2')[0].src = '${path}/routestrategy/strategyinfo?bankId=' + $('#bankId').val()
                    + '&strategyId=' + strategyId + '&orderAction=' + $('#orderAction').val();
            $('#openRoleDiv').dialog('open');
        }

        function formatCardType(val, row) {
            if (val == 1) {
                return '<span>' + '借记卡' + '</span>';
            } else if (val == 2) {
                return '<span>' + '信用卡' + '</span>';
            }
            else if (val == 10) {
                return '<span>' + '全部' + '</span>';
            }
        }

    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 错误信息列表 -->
    <table id="datagrid" title=${orderAction}—配置 class="easyui-datagrid" fit="true"
    <%--url="${path}/routeclose/datagrid?bankId="+ --%>
           toolbar="#toolbar" pagination="true"
           fitColumns="false" singleSelect="true" rownumbers="true"
           border="false" nowrap="false">
        <thead>
        <tr>
            <th field="id" width="80" hidden="true">id</th>
            <th field="bankId" width="80" hidden="true">bankId</th>
            <th field="strategy" width="100">策略名称</th>
            <th field="isdel" width="60" formatter="formatIsdel">策略状态</th>
            <th field="cardType" width="50" formatter="formatCardType">卡别</th>
            <th field="minMoney" width="100">单笔最小金额(元)</th>
            <th field="maxMoney" width="100">单笔最大限额(元)</th>
            <th field="qUsSum" width="100">启用通道</th>
            <th field="qStopSum" width="100">禁用通道</th>
            <th field="level" width="100">优先级</th>
            <th data-options="field:'opt',width:80" formatter="formatdata">操作</th>
        </tr>
        </thead>
    </table>


    <!-- 按钮 -->

    <div id="toolbar" class="easyui-layout"
         style="width:100%;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <form id="fmorder" name="fmorder" method="post">

            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <label>策略:</label> <input id="strategy" name="strategy" class="easyui-textbox"
                                          style="width: 120px">
                <label>卡别:</label> <input id="cardType" name="cardType" class="easyui-combobox" style="width: 80px"
                                          data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
    data:[{id:'',text:'不限'},{id:'1',text:'借记卡'},{id:'2',text:'信用卡'},{id:'10',text:'全部'}]">
                <label>状态:</label> <input id="isdel" name="isdel" class="easyui-combobox" style="width: 80px"
                                          data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
    data:[{id:'',text:'不限'},{id:'0',text:'启用'},{id:'1',text:'禁用'}]">
                <a href=" javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchOrder();">查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
                <input id="bankId" name="bankId" type="hidden" value="${bankId}"></td>
                <input id="orderAction" name="orderAction" type="hidden" value="${orderAction}"></td>
            </div>
        </form>

        <div id=" toolbar ">
            <a href="javascript:void(0);" class="easyui-linkbutton"
               iconCls="icon-add" plain="true" onclick="addConfig();">添加</a>
            <a href="javascript:void(0);" class="easyui-linkbutton"
               iconCls="icon-remove" plain="true" onclick="removeConfig();">禁用</a>
            <a href="javascript:void(0);" class="easyui-linkbutton"
               iconCls="icon-remove" plain="true" onclick="recoverConfig();">启用</a>
        </div>
    </div>


    <div id="openRoleDiv" class="easyui-dialog" closed="true" modal="true" title="渠道配置"
         style="width:800px;height:400px;"
    <%--buttons="#configdlg-buttons"--%>
            >
        <iframe scrolling="auto" id='iframe2' frameborder="0"
        <%--     src="${path}/configdeal/dealinfo"  --%>
                style="width:100%;height:100%;"></iframe>
    </div>

</div>
</body>
</html>
