<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>物流管理</title>
    <%@include file="/WEB-INF/pages/include/easyui.jsp" %>
    <!-- 对话框的样式 -->
    <link href="${path}/css/userList.css" rel="stylesheet" type="text/css"/>

    <script type="text/javascript">
        var url;
        var mesTitle;

        window.onload = function () {
            $('#teamid').combobox({
                editable: false, //编辑状态
                cache: false,
             //   panelHeight: 'auto',//自动高度适合
                valueField: 'teamid',
                textField: 'teamname'
            });

            $.ajax({
                type: "POST",
                url: "${path}/express/getExpTeam",
                cache: false,
                dataType: "json",
                success: function (data) {
                    $("#teamid").combobox("loadData", data.rows);
                }
            });

            $("#datagrid").datagrid("options").url = "${path}/express/datagriduser?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");

        }

        function searchperson() {
            $("#datagrid").datagrid("options").url = "${path}/express/datagriduser?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        function onReset() {
            $("#userid").textbox('setValue', "");
            $("#username").textbox('setValue', "");
            $("#datagrid").datagrid("options").url = "${path}/express/datagriduser?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        function addperson() {
            $('#configfm').form('clear');
            $('#expuserid').combobox('enable');
            $('#configdlg').dialog('open').dialog('setTitle', '新增派送员');
            $('#id').val("0");
            url = path + "/express/addExpUser";
        }

        function editperson() {
            $('#expuserid').combobox('disable');
            url = path + "/express/addExpUser";
            var row = $('#datagrid').datagrid('getSelected');
            if (row) {
                var id = row.id;
                $('#configdlg').dialog('open').dialog('setTitle', '派送员修改');
                $('#configfm').form('load', row);//这句话有问题，第一次加载时正确的，第二次就出错了，还保持第一次的数据
            } else {
                $.messager.alert('提示', '请选择要编辑的记录！', 'error');
            }
        }

        function delperson() {
            var record = $("#datagrid").datagrid('getSelected');
            if (record) {
                $.messager.confirm("删除", "确认删除派送员？", function (r) {
                    if (r) {
                        $.post('${path}/express/delExpuser',
                        {id: record.id},
                        function (result) {
                            var result = eval('(' + result + ')');
                            if (result.success) {
                                $.messager.alert('消息提示', result.msg,"info");
                                $("#datagrid").datagrid("options").url = "${path}/express/datagriduser";
                                $("#datagrid").datagrid("load");
                            } else {
                                $.messager.alert('错误提示',  result.msg,"error");
                            }
                        });
                    }
                });
            } else {
                $.messager.alert('提示', '请先选中要删除的行','info');
            }
        }

        function saveexpUser() {
            var expusername = $('#expusername').val().trim();
            if(expusername==null||expusername==''){
                $.messager.alert("提示","派送员姓名不能为空！","error");
                return;
            }
            var sex = $('#sex').combobox('getValue');
            if(sex==null||sex==''){
                $.messager.alert("提示","性别不能为空！","error");
                return;
            }
            var exphone = $('#exphone').val().trim();
            if(exphone==null||exphone==''){
                $.messager.alert("提示","手机号码不能为空！","error");
                return;
            }else{
                var reg=/^\+?[1-9][0-9]*$/;
                if(reg.test(exphone)==false){
                    $.messager.alert("提示","手机号码必须是正整数，请重新输入！","error");
                    return;
                }
                if(exphone.length !=11){
                    $.messager.alert("提示","手机号码必须是11位有效号码，请重新输入！","error");
                    return;
                }
            }
            var teamid = $('#teamid').combobox('getValue');
            if(teamid==null||teamid==''){
                $.messager.alert("提示","所属货运组不能为空！","error");
                return;
            }

            $('#configfm').form('submit', {
                url: url,
                success: function (result) {
                    var result = eval('(' + result + ')');
                    if (result.success) {
                        $('#configdlg').dialog('close');
                        $("#datagrid").datagrid("options").url = "${path}/express/datagriduser?" + $("#fmorder").serialize();
                        $("#datagrid").datagrid("load");
                        $.messager.alert("提示",result.msg,"info")
                    } else {
                        $.messager.alert("提示",result.msg,"error")
                    }
                }
            });
        }

        //格式换显示状态
        function formatsex(val, row) {
            if (val == 1) {
                return '<span >' + '男' + '</span>';
            } else if (val == 2) {
                return '<span>' + '女' + '</span>';
            }
        }
    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 信息列表 -->
    <table id="datagrid" title="新增派送员" class="easyui-datagrid" fit="true" toolbar="#toolbar" pagination="true"
           fitColumns="false"  singleSelect="true" rownumbers="true" border="false" nowrap="true" width="100%">

        <thead>
        <tr>
            <th field="id" width="130" align="center" hidden="true">id</th>
            <th field="expuserid" width="130" align="center">派送员编号</th>
            <th field="expusername" width="130" align="center">派送员姓名</th>
            <th field="sex" width="80" align="center" formatter="formatsex">性别</th>
            <th field="exphone" width="130"  align="center">手机号码</th>
            <th field="teamid" width="100" align="center" hidden="true">teamid</th>
            <th field="teamname" width="130"  align="center">所属组</th>
        </tr>
        </thead>
    </table>

    <!-- 按钮 -->

    <div id="toolbar" class="easyui-layout"
         style="width:100%;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <form id="fmorder" name="fmorder" method="post">
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <label>派送员编号:</label> <input id="userid" name="userid" class="easyui-textbox" style="width: 160px">
                &nbsp;
                &nbsp;
                <label>派送员姓名:</label> <input id="username" name="username" class="easyui-textbox" style="width: 160px">

                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchperson();" >查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();" >重置</a>
            </div>
        </form>

        <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-left: 6px" align="left">

            <a href="javascript:void(0);" class="easyui-linkbutton"
               iconCls="icon-add" plain="true" onclick="addperson();">新增派送员</a>

            <a href="javascript:void(0);" class="easyui-linkbutton"
               iconCls="icon-edit" plain="true" onclick="editperson();">编辑派送员</a>

            <a href="javascript:void(0);" class="easyui-linkbutton"
               iconCls="icon-remove" plain="true" onclick="delperson();">删除派送员</a>
        </div>

    </div>


    <!-- 对话框 -->
    <div id="configdlg" class="easyui-dialog"
         style="width:330px;height:260px;padding:10px 20px" closed="true"
         buttons="#dlg-buttons">
        <form id="configfm" method="post" novalidate>

            <table>
                <input id="id" name="id" type="hidden"></td>
                <tr>
                    <td align="right">派送员姓名:</td>
                    <td>
                        <input id="expusername" name="expusername"  style="width: 160px"  class="easyui-validatebox" required="true"/>
                    </td>
                </tr>
                <tr id="sehide">
                    <td align="right">性别:</td>
                    <td><input id="sex" name="sex" style="width: 160px" class="easyui-combobox" data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'1',text:'男'},{id:'2',text:'女'}]"  class="easyui-validatebox" required="true"></td>
                </tr>
                <tr>
                    <td align="right">手机号码:</td>
                    <td>
                        <input id="exphone" name="exphone"  style="width: 160px"  class="easyui-validatebox" required="true"/>
                    </td>
                </tr>
                <tr>
                    <td align="right">所属组:</td>
                    <td>
                        <input id="teamid" name="teamid"  style="width: 160px" data-options="required:true"/>
                    </td>
                </tr>

            </table>
        </form>
    </div>

    <div id="dlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="saveexpUser()" style="width:90px">保存</a> <a
            href="javascript:void(0)" class="easyui-linkbutton"
            iconCls="icon-cancel" onclick="javascript:$('#configdlg').dialog('close')"
            style="width:90px">取消</a>
    </div>


</div>

</body>
</html>
