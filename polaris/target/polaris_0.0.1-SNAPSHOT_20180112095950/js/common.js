window.onload = function () {
    $('#tt').tabs({
        border: false,
        //onContextMenu:function(e,title,index){
        //	alert("e : "+e+"t :"+title+"i : "+index)
        //	updateTab(title,'',"#tt");
        //},
        tools: [{
            iconCls: 'icon-reload',
            handler: function () {
                //alert($('.tabs-selected').text())
                updateTab($('.tabs-selected').text(), '', "#tt");
            }
        }]
    });
}
/**
 *首先加载jquery,
 *然后加载easyui
 *这些方法才能调用
 /

 /**
 **功能 ： 加载tab页面
 **参数title ：tab页面显示的头
 **参数url:加载的页面 eg：“http://www.baidu.com”、“./main.html”、“../book/search.do”（返回的必须是页面）
 **参数addeddiv：框架加载的区域 eg: "#div1"、 “.class2”
 */
function addTab(title, url, addeddiv) {
    if ($(addeddiv).tabs('exists', title)) {

        $(addeddiv).tabs('select', title);
    } else {
        var content = '<iframe scrolling="auto" frameborder="0"  src="' + url + '" style="width:100%;height:100%;"></iframe>';
        $(addeddiv).tabs('add', {
            title: title,
            content: content,
            closable: true

        });
    }
}


function updateTab(title, url, updateeddiv) {
    var tab = $(updateeddiv).tabs('getSelected');  // 获取选择的面板
    $(updateeddiv).tabs('update', {
        tab: tab,
        options: {
            title: title,
            href: url  // 新内容的URL
        }
    });
}

function getTabTitle() {
    var title = $('.tabs-selected').text();
    return title;
}


/*
 *弹出框

 1.把一个要弹出的div的属性设置为（class="easyui-window" title="xxx" modal="true"）
 2.直接调用函数window('open')(eg:$('#win').window('open')")
 */


formatterDate = function (date) {
    var day = date.getDate() > 9 ? date.getDate() : "0" + date.getDate();
    var month = (date.getMonth() + 1) > 9 ? (date.getMonth() + 1) : "0"
    + (date.getMonth() + 1);
    return date.getFullYear() + '-' + month + '-' + day;
};

//格式换显示状态
formatIsdel = function (val, row) {
    //alert("val=="+val)
    if (val == 1) {
        return '<span style="color:red;">' + '已禁用' + '</span>';
    } else {
        return '<span>' + '使用中' + '</span>';
    }
}

formatCardType = function (val, row) {
    switch (val) {
        case 10 :
            return '<span>' + '全部' + '</span>';
        case 0 :
            return '<span>' + '借记卡' + '</span>';
        case 1 :
            return '<span>' + '存折' + '</span>';
        case 2 :
            return '<span>' + '贷记卡' + '</span>';
        case 3 :
            return '<span>' + '公司账号' + '</span>';
    }
}

formatMoney = function (val, row) {
    if (val != null) {
        return val.toFixed(2);
    }
}