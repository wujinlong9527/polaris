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
        var loading;
        window.onload = function () {
            $("#test").treegrid("options").url
                    = "${path}/sysrole/datagridformemu?id=" + $('#id').val();
            $("#test").treegrid("load");
        }

        function show(checkid) {
            var s = '#check_' + checkid;
            var nodes = $("#test").treegrid("getChildren", checkid);

            for (i = 0; i < nodes.length; i++) {
                $(('#check_' + nodes[i].id))[0].checked = $(s)[0].checked;

            }
            //选上级节点
            if (!$(s)[0].checked) {
               // alert(1);
                var parent = $("#test").treegrid("getParent", checkid);
                $(('#check_' + parent.id))[0].checked = true;
                while (parent) {
                    parent = $("#test").treegrid("getParent", parent.id);
                    $(('#check_' + parent.id))[0].checked = false;
                }
            } else {
                var parent = $("#test").treegrid("getParent", checkid);
                var flag = true;
                var sons = parent.sondata.split(',');
                for (j = 0; j < sons.length; j++) {
                    if (!$(('#check_' + sons[j]))[0].checked) {
                        flag = false;
                        break;
                    }
                }
                if (flag)
                    $(('#check_' + parent.id))[0].checked = true;
                while (flag) {
                    parent = $("#test").treegrid("getParent", parent.id);
                    if (parent) {
                        sons = parent.sondata.split(',');
                        for (j = 0; j < sons.length; j++) {
                            if (!$(('#check_' + sons[j]))[0].checked) {
                                flag = false;
                                break;
                            }
                        }
                    }
                    if (flag)
                        $(('#check_' + parent.id))[0].checked = true;
                }
            }
        }

        function formatcheckbox(val, row) {
            return "<input type='checkbox' onclick=show('" + row.id + "')  id = 'check_" + row.id + "'" + (row.isSelected ? 'checked' : '') + "/>" + row.id;
        }


        //获取选中的结点
        function getSelected() {
            var idList = "";
            $("input:checked").each(function () {
                var id = $(this).attr("id");

                if (id.indexOf('check_type') == -1 && id.indexOf("check_") > -1)
                    idList += id.replace("check_", '') + ',';
            })
        }

        //格式换显示状态
        function formatdata(val, row) {
            if (row.isParentId == 0) {
                return '<a class="editcls" onclick="editRow(\'' + row.id + '\')" href="javascript:void(0)">查看</a>';
            }
        }

        function editRow(id) {
            $('#iframe1')[0].src = '${path}/sysrole/buttonInfo?menu_id=' + id + "&role_id=" + $('#id').val();
            $('#openRoleDiv').dialog('open');
        }

        function save() {
            window.parent.linkDisable();
            var idList = "";
            $("input:checked").each(function () {
                var id = $(this).attr("id");
                if (id.indexOf('check_type') == -1 && id.indexOf("check_") > -1)
                    idList += id.replace("check_", '') + ',';
            })

            if (idList != "") {
                $.post('${path}/sysrole/saverole',
                        {ids: idList, roleid: $('#id').val()},
                        function (result) {
                            var result = eval('(' + result + ')');
                            if (result.success) {
                                parent.$.messager.alert('消息提示', "授权成功");
                                //$("#successful").val("successful");
                                //window.top.close();
                                parent.$('#openRoleDiv').window('close');

                            } else {
                                $.messager.alert('错误提示', "授权失败");
                            }
                            window.parent.linkShow();
                        });
            } else {
                window.parent.linkShow();
                $.messager.alert('提示', "请选择要添加的菜单，复选框选中！");
            }

        }

        function saveConfig() {
            window.frames["iframe1"].save();
        }

    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <input id="id" name="id" type="hidden" value="${sysrole.id}"></td>

    <body>
    <input id="successful" name="successful" type="hidden"></td>
    <table id="test" class="easyui-treegrid" style="width:400px;height:500px"
           fit="true" toolbar="#toolbar" fitColumns="false"
           singleSelect="false" rownumbers="true" border="false" nowrap="true"
           idField="id" treeField="text">
        <thead>
        <tr>
            <th field="id" width="120" formatter="formatcheckbox" resize="height:100">编号</th>
            <th field="text" width="150" align="left">菜单名称</th>
       <%--     <th data-options="field:'opt',width:120" formatter="formatdata">操作</th>--%>
        </tr>
        </thead>
    </table>
    </body>


    <div id="openRoleDiv" class="easyui-dialog" closed="true" modal="true" title="按钮信息"
         buttons="#configdlg-buttons" style="width:500px;height:300px;">
        <iframe scrolling="auto" id='iframe1' name='iframe1' frameborder="0"
                style="width:100%;height:100%;"></iframe>
    </div>

    <div id="configdlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="saveConfig()" style="width:60px">保存</a> <a
            href="javascript:void(0)" class="easyui-linkbutton"
            iconCls="icon-cancel" onclick="javascript:$('#openRoleDiv').dialog('close')"
            style="width:60px">取消</a>
    </div>


</div>

</body>
</html>
