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
        var dealChannel;
        var editRow = undefined; //定义全局变量：当前编辑的行

        $(function () {
            var orderAction = $("#orderAction").val();
            $.ajax({
                type: "POST",
                url: "${path}/routechannel/getDealchannel",
                data:{orderAction:orderAction},
                cache: false,
                async: false,
                dataType: "json",
                success: function (data) {
                    dealChannel = eval(data.rows);
                }
            });

            var Address = [{"value": "1", "text": "启用"}, {"value": "2", "text": "禁用"}];

            function unitformatter(value, rowData, rowIndex) {
                if (value == 0) {
                    return;
                }

                for (var i = 0; i < Address.length; i++) {
                    if (Address[i].value == value) {
                        //return Address[i].text;
                        if (Address[i].value == 1) {
                            return '<span>' + Address[i].text + '</span>';
                        } else if (Address[i].value == 2) {
                            return '<span style="color:red;">' + Address[i].text + '</span>';
                        }
                    }
                }
            }

            function dealChannelformatter(value, rowData, rowIndex) {
                if (value == 0) {
                    return;
                }
                for (var i = 0; i < dealChannel.length; i++) {
                    if (dealChannel[i].id == value) {
                        return dealChannel[i].dealSubChannel;
                    }
                }
            }

            var datagrid; //定义全局变量datagrid
//            var editRow = undefined; //定义全局变量：当前编辑的行

            var strul = "${path}/routestrategy/channeldatagrid?strategyId=" + $('#strategyId').val();

            datagrid = $("#datagrid").datagrid({
                url: strul, //请求的数据源
                iconCls: "icon-save", //图标
                pagination: true, //显示分页
//                pageSize: 8, //页大小
//                pageList: [8, 15, 30, 45, 60], //页大小下拉选项此项各value是pageSize的倍数
                fit: true, //datagrid自适应宽度
                fitColumn: false, //列自适应宽度
                striped: true, //行背景交换
                nowap: true, //列内容多时自动折至第二行
                border: false,
                singleSelect: true,
                idField: "mId", //主键
                columns: [[//显示的列
//                    {checkbox: true},
                    {
                        field: "channelId", title: "渠道", width: 140, align: "center", sortable: true
                        ,
//                        editor: {type: "validatebox", options: {required: true}}
                        formatter: dealChannelformatter,
                        //align: 'center',
                        editor: {
                            type: 'combobox',
                            options: {data: dealChannel, valueField: "id", textField: "dealSubChannel"}
                        }
                    },
//                    {
//                        field: "runTime", title: "时长", align: "center", width: 100, sortable: true
//                        ,
//                        editor: {type: "validatebox", options: {required: true}}
//                    },
                    {
                        field: "level", title: "优先级", align: "center", width: 60, sortable: true
                        ,
                        editor: {type: "validatebox", options: {required: true}}
                    },
                    {
                        field: "channelDayMoney", title: "单日限额(元)", align: "center", width: 120, sortable: true
                        ,
                        editor: {type: "validatebox", options: {required: true}}
                    },
                    {
                        field: 'isdel',
                        title: '状态',
                        width: 100,
                        formatter: unitformatter,
                        align: 'center',
                        sortable: true,
                        editor: {
                            type: 'combobox',
                            options: {data: Address, valueField: "value", textField: "text"}
                        }
                    }
                ]],
                queryParams: {action: "query"}, //查询参数
                toolbar: [{
                    text: "添加", iconCls: "icon-add", handler: function () {//添加列表的操作按钮添加，修改，删除等
                        //添加时先判断是否有开启编辑的行，如果有则把开户编辑的那行结束编辑
                        if (editRow != undefined) {
                            datagrid.datagrid("endEdit", editRow);
                        }
                        //添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
                        if (editRow == undefined) {
                            datagrid.datagrid("insertRow", {
                                index: 0, // index start with 0
                                row: {}
                            });
                            //将新插入的那一行开户编辑状态
                            datagrid.datagrid("beginEdit", 0);
                            //给当前编辑的行赋值
                            editRow = 0;
                            var editors = $('#datagrid').datagrid('getEditors', editRow);
                            editors[3].target.combobox("setValue", "1");
                        }

                    }
                },
                    "-",
                    {
                        text: "删除", iconCls: "icon-remove", handler: function () {
                        //删除时先获取选择行
                        var NumIndex = datagrid.datagrid("getRowIndex", datagrid.datagrid("getSelections")[0]);
                        //alert(NumIndex);
                        var rows = datagrid.datagrid("getSelections");
                        //选择要删除的行
                        if (rows.length > 0) {
                            $.messager.confirm("提示", "你确定要删除吗?", function (r) {
                                if (r) {
                                    var ids = [];
                                    for (var i = 0; i < rows.length; i++) {
                                        ids.push(rows[i].mId);
                                        //   datagrid.datagrid('deleteRow', NumIndex[i]);
                                    }
                                    //datagrid.datagrid('deleteRow', datagrid.datagrid("getRowIndex", datagrid.datagrid("getSelections")[rows]));

//                                    for (var i = 0; i < rows.length; i++) {
//                                        //  ids.push(rows[i].mId);
//                                        datagrid.datagrid('deleteRow', datagrid.datagrid("getRowIndex", datagrid.datagrid("getSelections")[i]));
//                                        console.info(NumIndex[0] + ":" + NumIndex[1] + ":" + NumIndex[2]);
//                                        //    console.info(rows);
//
//                                    }
                                    datagrid.datagrid('deleteRow', NumIndex);
                                    ids.join(",");
                                    //alert(ids);
                                    console.info(ids);
                                    //将选择到的行存入数组并用,分隔转换成字符串，
                                    //本例只是前台操作没有与数据库进行交互所以此处只是弹出要传入后台的id
                                    //  alert(ids.join(","));
                                }
                            });
                        }
                        else {
                            $.messager.alert("提示", "请选择要删除的行", "hahhahah");
                        }

                    }
                    },
                    "-",
                    {
                        text: "修改", iconCls: "icon-edit", handler: function () {
                        //修改时要获取选择到的行
                        var rows = datagrid.datagrid("getSelections");
                        //如果只选择了一行则可以进行修改，否则不操作
                        if (rows.length == 1) {
                            //修改之前先关闭已经开启的编辑行，当调用endEdit该方法时会触发onAfterEdit事件
                            if (editRow != undefined) {
                                datagrid.datagrid("endEdit", editRow);
                            }
                            //当无编辑行时
                            if (editRow == undefined) {
                                //获取到当前选择行的下标
                                var index = datagrid.datagrid("getRowIndex", rows[0]);
                                //开启编辑
                                datagrid.datagrid("beginEdit", index);
                                //把当前开启编辑的行赋值给全局变量editRow
                                editRow = index;
                                //当开启了当前选择行的编辑状态之后，
                                //应该取消当前列表的所有选择行，要不然双击之后无法再选择其他行进行编辑
                                datagrid.datagrid("unselectAll");
                            }
                        }
                    }
                    }, "-",
                    {
                        text: "保存", iconCls: "icon-save", handler: function () {

                        var editors = $('#datagrid').datagrid('getEditors', editRow);
                        var data = datagrid.datagrid('getData');
                        for (var i = 0; i < data.rows.length; i++) {
                            var row = $('#datagrid').datagrid('getData').rows[i];
                            //alert(i + "   :  " + row.channelId);
                            if ((row.channelId == editors[0].target.combobox("getValue")) && (i != editRow)) {
                                $.messager.alert('提示', '此渠道已添加，请重新选择！');
                                return;
                            }
                        }

                        //保存时结束当前编辑的行，自动触发onAfterEdit事件如果要与后台交互可将数据通过Ajax提交后台
                        datagrid.datagrid("endEdit", editRow);
                    }
                    },
                    "-",
                    {
                        text: "取消编辑", iconCls: "icon-redo", handler: function () {

                        //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                        editRow = undefined;
                        datagrid.datagrid("rejectChanges");
                        datagrid.datagrid("unselectAll");
                    }
                    },
                    "-"],
                onAfterEdit: function (rowIndex, rowData, changes) {
                    //endEdit该方法触发此事件
                    console.info(rowData);
                    editRow = undefined;
                },
                onDblClickRow: function (rowIndex, rowData) {
                    //双击开启编辑行
                    if (editRow != undefined) {
                        datagrid.datagrid("endEdit", editRow);
                    }
                    if (editRow == undefined) {
                        datagrid.datagrid("beginEdit", rowIndex);
                        editRow = rowIndex;
                    }
                }
            });
        });

        function save() {
            if (editRow != undefined) {
                $.messager.alert('提示', '请先保存再提交！');
                return;
            }
            var str = JSON.stringify($("#datagrid").datagrid('getData'));
            if (($("#strategy").val() == "") || ($("#cardType").combobox("getValue") == "")
                    || ($("#MinMoney").val() == "") || ($("#MaxMoney").val() == "") || ($("#slevel").val() == "")) {
                $.messager.alert('提示', '策略信息不能为空！');
                return;
            }

            $.post('${path}/routestrategy/addrouteStrategy',
                    {
                        id: $('#strategyId').val(),
                        bankId: $('#bankId').val(),
                        strategy: $('#strategy').val(),
                        oldstrategy: $('#oldstrategy').val(),
                        cardType: $("#cardType").combobox("getValue"),
                        minMoney: $("#MinMoney").val(),
                        maxMoney: $("#MaxMoney").val(),
                        slevel: $("#slevel").val(),
                        data: str
                    },
                    function (result) {
                        var result = eval('(' + result + ')');

                        if (result.success) {
//                            parent.$.messager.alert('消息提示', "授权成功");
//                            parent.$('#openRoleDiv').window('close');

                        } else {
                            mesTitle = "保存失败";
                        }
                        $.messager.show({
                            title: mesTitle,
                            msg: result.msg
                        });
                    });

        }

    </script>

</head>
<body class="easyui-layout" fit="true">

<div id="cc" class="easyui-layout" style="width:100%;height:100%;">
    <div id="toolbar" region="north" title="策略信息" style="height:60px;">
        <form id="fmorder" name="fmorder" method="post">
            <table>
                <div style="padding-top:3px;padding-bottom: 3px;padding-left: 6px;padding-right: 6px">
                    <label>*策略:</label> <input id="strategy" name="strategy" class="easyui-validatebox" required="true"
                                               style="width: 120px" value="${routebank.strategy}">
                    <label>*卡别:</label> <input id="cardType" name="cardType" class="easyui-combobox" style="width: 80px"
                                               data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
data:[{id:'1',text:'借记卡'},{id:'2',text:'信用卡'},{id:'10',text:'全部'}]" required="true" value="${routebank.cardType}">
                    <label>*单笔金额:</label>
                    <input id="MinMoney" name="minMoney" class="easyui-validatebox" required="true"
                           onkeyup="if(this.value==this.value2)return;if(this.value.search(/^\d*(?:\.\d{0,2})?$/)==-1)this.value=(this.value2)?this.value2:'';else this.value2=this.value;"
                           style="width: 80px" value="${routebank.minMoney}">&nbsp;&nbsp;-&nbsp;&nbsp;
                    <input id="MaxMoney" name="maxMoney" class="easyui-validatebox" required="true"
                           onkeyup="if(this.value==this.value2)return;if(this.value.search(/^\d*(?:\.\d{0,2})?$/)==-1)this.value=(this.value2)?this.value2:'';else this.value2=this.value;"
                           style="width: 80px" value="${routebank.maxMoney}"><label>(元)&nbsp&nbsp</label>
                    <label>*优先级:</label> <input id="slevel" name="slevel" class="easyui-validatebox" required="true"
                                                onkeyup="this.value=this.value.replace(/[^\d]/g,'')"
                                                style="width: 60px" value="${routebank.level}">
                    <input id="bankId" name="bankId" type="hidden" value="${routebank.bankId}"></td>
                    <input id="strategyId" name="strategyId" type="hidden" value="${routebank.id}"></td>
                    <input id="oldstrategy" name="oldstrategy" type="hidden" value="${routebank.strategy}"></td>
                    <input id="orderAction" name="orderAction" type="hidden" value="${routebank.orderAction}"></td>
                </div>
            </table>
        </form>
    </div>

    <div region="center" title="渠道信息" style="padding:5px;background:#eee;">
        <table id="datagrid">
        </table>
    </div>
    <div region="south" style="height:40px;padding-top:5px;padding-bottom: 5px" align="center">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="save()" style="width:60px">提交</a>
    </div>
</div>

</body>
</html>
