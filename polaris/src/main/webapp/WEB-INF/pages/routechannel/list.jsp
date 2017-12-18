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
        }

        //格式换显示状态
        function formatIsdel(val, row) {
            if (val == 1) {
                return '<span style="color:red;">' + '禁用' + '</span>';
            } else if (val == 0) {
                return '<span>' + '启用' + '</span>';
            }
        }

        function formatIsSms(val, row) {
            if (val == 1) {
                return '<span>' + '是' + '</span>';
            } else if (val == 0) {
                return '<span>' + '否' + '</span>';
            }
        }

        //查询列表
        function searchOrder() {
            $("#datagrid").datagrid("options").url = "${path}/routechannel/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        //重置
        function onReset() {
            $("#dealChannel").textbox('setValue', "");
            $("#dealSubChannel").textbox('setValue', "");
            $("#orderAction").combobox('setValue', "");
            $("#isdel").combobox("setValue", "");

            $("#datagrid").datagrid("options").url = "${path}/routechannel/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        //弹出新增界面
        function addConfig() {
            $('#configdlg').dialog('open').dialog('setTitle', '新增渠道');
            $('#configfm').form('clear');
            mesTitle = '新增成功';
        }

        //新增保存
        function saveConfig() {
            $('#configfm').form('submit', {
                url: path + "/routechannel/addrouteChannel",
                onSubmit: function () {
                    return $(this).form('validate');
                },
                success: function (result) {
                    var result = eval('(' + result + ')');
                    if (result.success) {
                        if ($("#id").val() != '') {
                            $('#configdlg').dialog('close');
                        }
                        //
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
                        $.post('${path}/routechannel/upRouteChannelState',
                                {isdel: 1, id: record.id},
                                function (result) {
                                    var result = eval('(' + result + ')');
                                    if (result.success) {
//                                    $('#delreasondlg').dialog('close');
                                        $.messager.alert('消息提示', "禁用成功");
                                        $("#datagrid").datagrid("options").url = "${path}/routechannel/datagrid?" + $("#fmorder").serialize();
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


        function save() {
            //去空格 replace(/(^\s*)|(\s*$)/, "")
            if ($('#delReason').val().replace(/(^\s*)|(\s*$)/, "") == "") {
                $.messager.alert('提示', '禁用原因不能为空！');
                return;
            }

            var record = $("#datagrid").datagrid('getSelected');
            $.post('${path}/routechannel/upRouteChannelState',
                    {isdel: 1, delReason: $('#delReason').val(), id: record.id},
                    function (result) {
                        var result = eval('(' + result + ')');
                        if (result.success) {
                            $('#delreasondlg').dialog('close');
                            $.messager.alert('消息提示', "禁用成功");
                            $("#datagrid").datagrid("options").url = "${path}/routechannel/datagrid?" + $("#fmorder").serialize();
                            $("#datagrid").datagrid("load");
                        } else {
                            $.messager.alert('错误提示', "禁用失败");
                        }
                    });
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
                        $.post('${path}/routechannel/upRouteChannelState',
                                {isdel: 0, id: record.id},
                                function (result) {
                                    var result = eval('(' + result + ')');
                                    if (result.success) {
                                        $.messager.alert('消息提示', "启用成功");
                                        $("#datagrid").datagrid("options").url = "${path}/routechannel/datagrid?" + $("#fmorder").serialize();
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

        function editConfig() {
            var row = $('#datagrid').datagrid('getSelected');
            if (row) {
                if (row.isdel == 1) {
                    $.messager.alert('错误提示', "数据已经禁用,不需要编辑！");
                    return;
                }
                $.post('${path}/routechannel/selectRouteChannel',
                        {id: row.id},
                        function (result) {
                            var result = eval('(' + result + ')');
                            if (result.success) {
                                $("#olddealSubChannel").val(result.obj.dealSubChannel);
                                $("#olddealChannel").val(result.obj.dealChannel);
                                $("#id").val(result.obj.id);
                                $("#dlgdealChannel").val(result.obj.dealChannel);
                                $("#dlgdealSubChannel").val(result.obj.dealSubChannel);
                                $("#dlgfrontChannel").val(result.obj.frontChannel);
                                $("#dlgmerId").val(result.obj.merId);
                                $("#dlgsignMark").val(result.obj.signMark);
                                $("#dlgorderAction").combobox("setValue", result.obj.orderAction);
                                $("#dlgisSms").combobox("setValue", result.obj.isSms);
                                $('#configdlg').dialog('open').dialog('setTitle', '编辑');
                            } else {
                                $.messager.alert('错误提示', "编辑失败");
                            }
                        });

            } else {
                $.messager.alert('提示', '请选择要编辑的记录！', 'error');
            }
        }

        function addRedisConfig() {
            $('#addredis').linkbutton({disabled:true});
            $.post('${path}/routechannel/updredis?'+ $("#fmorder").serialize(),
                    function (result) {
                        var result = eval('(' + result + ')');
                        console.info(result);
                        if (result.success==true) {
                            $.messager.alert('提示', result.msg);
                        } else {
                            $.messager.alert('错误提示',result.msg);
                        }
                        $('#addredis').linkbutton({disabled:false});
                    });
        }


    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 错误信息列表 -->
    <table id="datagrid" title="渠道管理" class="easyui-datagrid" fit="true"
           url="${path}/routechannel/datagrid" toolbar="#toolbar" pagination="true"
           fitColumns="false" singleSelect="true" rownumbers="true"
           border="false" nowrap="false">
        <thead>
        <tr>
            <%--<th field="ck" checkbox="true"></th>--%>
            <th field="id" width="80" hidden="true">id</th>
            <th field="dealChannel" width="100">处理渠道</th>
            <th field="dealSubChannel" width="100">处理子渠道</th>
            <th field="frontChannel" width="100">前置渠道</th>
            <th field="merId" width="100">商户号</th>
            <th field="signMark" width="100">签约公司</th>
            <th field="orderAction" width="100">业务类型</th>
            <th field="isdel" width="60" formatter="formatIsdel">状态</th>
            <th field="isSms" width="100" formatter="formatIsSms">是否发短信</th>
            <%--<th field="delReason" width="120">删除原因</th>--%>
        </tr>
        </thead>
    </table>

    <!-- 按钮 -->

    <div id="toolbar" class="easyui-layout"
         style="width:100%;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <form id="fmorder" name="fmorder" method="post">
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <label>处理渠道:</label> <input id="dealChannel" name="dealChannel" class="easyui-textbox"
                                            style="width: 120px">
                <label>处理子渠道:</label> <input id="dealSubChannel" name="dealSubChannel"
                                             class="easyui-textbox" style="width: 120px">

                <tr>
                    <td align="right">交易类别:</td>
                    <td><input id="orderAction" name="orderAction" style="width: 100px" class="easyui-combobox"
                               data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'消费',text:'消费'},{id:'预授权',text:'预授权'},{id:'鉴权验证',text:'鉴权验证'}]"></td>
                </tr>
                <label>状态:</label> <input id="isdel" name="isdel" class="easyui-combobox" style="width: 80px"
                                          data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'',text:'不限'},{id:'0',text:'启用'},{id:'1',text:'禁用'}]">

                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchOrder();">查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
            </div>
        </form>
        <c:if test="${button.size()>0}">
            <div id="toolbar">
                <c:forEach var="button" items="${button}">
                    <c:if test="${button.menu_button == 'add'}">
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           iconCls="icon-add" plain="true" onclick="addConfig();">添加</a>
                    </c:if>
                    <c:if test="${button.menu_button == 'edit'}">
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           iconCls="icon-remove" plain="true" onclick="editConfig();">编辑</a>
                    </c:if>
                    <c:if test="${button.menu_button == 'delete'}">
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           iconCls="icon-remove" plain="true" onclick="removeConfig();">禁用</a>
                    </c:if>
                    <c:if test="${button.menu_button == 'recover'}">
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           iconCls="icon-remove" plain="true" onclick="recoverConfig();">启用</a>
                    </c:if>
                    <c:if test="${button.menu_button == 'addRedis'}">
                        <a href="javascript:void(0);" class="easyui-linkbutton" id="addredis"
                           iconCls="icon-add" plain="true" onclick="addRedisConfig();">更新Redis</a>
                    </c:if>
                </c:forEach>
            </div>
        </c:if>
    </div>


    <!-- 对话框 -->
    <div id="configdlg" class="easyui-dialog"
         style="width:300px;height:300px;padding:10px 20px" closed="true"
         buttons="#configdlg-buttons">
        <form id="configfm" method="post" novalidate>
            <table>
                <input id="id" name="id" type="hidden"></td>
                <input id="olddealChannel" name="olddealChannel" type="hidden"></td>
                <input id="olddealSubChannel" name="olddealSubChannel" type="hidden"></td>
                <tr>
                    <td align="right">*处理渠道:</td>
                    <td><input id="dlgdealChannel" name="dealChannel" type="text" class="easyui-validatebox"
                               required="true"></td>
                </tr>
                <tr>
                    <td align="right">*处理子渠道:</td>
                    <td><input id="dlgdealSubChannel" name="dealSubChannel" type="text" class="easyui-validatebox"
                               required="true"></td>
                </tr>
                <tr>
                    <td align="right">*前置渠道:</td>
                    <td><input id="dlgfrontChannel" name="frontChannel" type="text"
                               required="true"></td>
                </tr>
                <tr>
                    <td align="right">*商户号:</td>
                    <td><input id="dlgmerId" name="merId" type="text" class="easyui-validatebox"
                               required="true"></td>
                </tr>
                <tr>
                    <td align="right">*签约公司:</td>
                    <td><input id="dlgsignMark" name="signMark" type="text" class="easyui-validatebox"
                               required="true"></td>
                </tr>
                <tr>
                    <td align="right">*类别:</td>
                    <td><input id="dlgorderAction" name="orderAction" style="width: 150px" class="easyui-combobox"
                               data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'消费',text:'消费'},{id:'预授权',text:'预授权'},{id:'鉴权验证',text:'鉴权验证'}]" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*发短信:</td>
                    <td><input id="dlgisSms" name="isSms" style="width: 150px" class="easyui-combobox"
                               data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'1',text:'是'},{id:'0',text:'否'}]" required="true"></td>
                </tr>
            </table>
        </form>
    </div>

    <div id="delreasondlg" class="easyui-dialog"
         style="width:300px;height:120px;padding:10px 20px" closed="true"
         buttons="#delreason-buttons">
        <tr>
            <td>*删除原因:</td>
            <td><input id="delReason" name="delReason" type="text"></td>
        </tr>
    </div>

    <!-- 对话框按钮 -->
    <div id="configdlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="saveConfig()" style="width:60px">保存</a> <a
            href="javascript:void(0)" class="easyui-linkbutton"
            iconCls="icon-cancel" onclick="javascript:$('#configdlg').dialog('close')"
            style="width:60px">取消</a>
    </div>

    <!-- 对话框按钮 -->
    <div id="delreason-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="save()" style="width:60px">保存</a> <a
            href="javascript:void(0)" class="easyui-linkbutton"
            iconCls="icon-cancel" onclick="javascript:$('#delreasondlg').dialog('close')"
            style="width:60px">取消</a>
    </div>
</div>

</body>
</html>
