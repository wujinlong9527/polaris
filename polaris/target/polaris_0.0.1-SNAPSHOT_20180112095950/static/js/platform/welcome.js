/**
 *首先加载jquery,
 *然后加载easyui
 *这些方法才能调用
 */
var path;
var onlyOpenTitle="欢迎使用";
window.onload = function () {
    path = $("p[name='path']").html();
    if(path!=null && path!=''){
        if(path.charAt(path.length - 1)=='/'){
            path=path.substr(0,path.length - 1);
        }
    }
    tabClose();
    tabCloseEven();
}

/**
 **功能 ： 加载tab页面
 **参数title ：tab页面显示的头
 **参数url:加载的页面 eg：“http://www.baidu.com”、“./main.html”、“../book/search.do”（返回的必须是页面）
 **参数addeddiv：框架加载的区域 eg: "#div1"、 “.class2”
 */
function addTab1(url,title,addeddiv,buttons) {
    if(addeddiv == null || addeddiv==''){
        addeddiv='#mainTabs';
    }
    if ($(addeddiv).tabs('exists', title)) {
        $(addeddiv).tabs('select', title);
    } else {
        _url=path+url;
        $(addeddiv).tabs('add', {
            title: title,
            content: createFrame(_url),
            closable: true
        });
    }
    tabClose();
}

function addTab(bankName, bankId, isdel, orderAction) {
    var src = path + '/routestrategy/list?bankId=' + bankId + '&orderAction=' + orderAction+'&isdel='+isdel;
    var tabs = $('#mainTabs');
    var opts = {
        title: bankName,
        closable: true,
        content: createFrame(src)/*String.prototype.StringFormat('<iframe src="{0}" allowTransparency="true" style="border:0;width:100%;height:99%;" frameBorder="0"></iframe>', src)*/,
        border: false,
        fit: true
    };
    if (tabs.tabs('exists', opts.title)) {
        tabs.tabs('select', opts.title);
    } else {
        tabs.tabs('add', opts);
    }
}

function createFrame(_url)
{
    var content = '<iframe name="child" scrolling="auto" frameborder="0"  src="' + _url + '" style="width:100%;height:99%;"></iframe>';
    var s = content;
    return s;
}

function tabClose()
{
    /*双击关闭TAB选项卡*/
    $(".tabs-inner").dblclick(function(){
        var subtitle = $(this).children(".tabs-closable").text();
        $('#mainTabs').tabs('close',subtitle);
    })
    /*为选项卡绑定右键*/
    $(".tabs-inner").bind('contextmenu',function(e){
        $('#mm').menu('show', {
            left: e.pageX,
            top: e.pageY
        });

        var subtitle =$(this).children(".tabs-closable").text();

        $('#mm').data("currtab",subtitle);
        $('#mainTabs').tabs('select',subtitle);
        return false;
    });
}
//绑定右键菜单事件
function tabCloseEven() {

    $('#mm').menu({
        onClick: function (item) {
            closeTab(item.id);
        }
    });

    return false;
}

function closeTab(action)
{
    var alltabs = $('#mainTabs').tabs('tabs');
    var currentTab =$('#mainTabs').tabs('getSelected');
    var allTabtitle = [];
    $.each(alltabs,function(i,n){
        allTabtitle.push($(n).panel('options').title);
    })
    switch (action) {
        case "refresh":
            var iframe = $(currentTab.panel('options').content);
            var src = iframe.attr('src');
            $('#mainTabs').tabs('update', {
                tab: currentTab,
                options: {
                    content: createFrame(src)
                }
            })
            break;
        case "close":
            var currtab_title = currentTab.panel('options').title;
            $('#mainTabs').tabs('close', currtab_title);
            break;
        case "closeall":
            $.each(allTabtitle, function (i, n) {
                if (n != onlyOpenTitle){
                    $('#mainTabs').tabs('close', n);
                }
            });
            break;
        case "closeother":
            var currtab_title = currentTab.panel('options').title;
            $.each(allTabtitle, function (i, n) {
                if (n != currtab_title && n != onlyOpenTitle)
                {
                    $('#mainTabs').tabs('close', n);
                }
            });
            break;
        case "closeright":
            var tabIndex = $('#mainTabs').tabs('getTabIndex', currentTab);

            if (tabIndex == alltabs.length - 1){
                alert('亲，后边没有啦 ^@^!!');
                return false;
            }
            $.each(allTabtitle, function (i, n) {
                if (i > tabIndex) {
                    if (n != onlyOpenTitle){
                        $('#mainTabs').tabs('close', n);
                    }
                }
            });

            break;
        case "closeleft":
            var tabIndex = $('#mainTabs').tabs('getTabIndex', currentTab);
            if (tabIndex == 1) {
                alert('亲，前边那个上头有人，咱惹不起哦。 ^@^!!');
                return false;
            }
            $.each(allTabtitle, function (i, n) {
                if (i < tabIndex) {
                    if (n != onlyOpenTitle){
                        $('#mainTabs').tabs('close', n);
                    }
                }
            });

            break;
        case "exit":
            $('#closeMenu').menu('hide');
            break;
    }
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

/**
 * 交易金额格式化
 * @param val
 * @param row
 * @returns {string}
 */
formatMoney = function (val, row) {
    if (val != null) {
       // return (val / 100).toFixed(2);
        return fmoney(val / 100, 2);
    }
    return '';
}


function fmoney(s, n) {
    n = n > 0 && n <= 20 ? n : 2;
    s = parseFloat((s + "").replace(/[^\d\.-]/g, "")).toFixed(n) + "";
    var l = s.split(".")[0].split("").reverse(), r = s.split(".")[1];
    t = "";
    for (i = 0; i < l.length; i++) {
        t += l[i] + ((i + 1) % 3 == 0 && (i + 1) != l.length ? "," : "");
    }
    return t.split("").reverse().join("") + "." + r;
}