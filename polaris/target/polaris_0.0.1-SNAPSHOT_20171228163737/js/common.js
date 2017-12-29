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
 *���ȼ���jquery,
 *Ȼ�����easyui
 *��Щ�������ܵ���
 /

 /**
 **���� �� ����tabҳ��
 **����title ��tabҳ����ʾ��ͷ
 **����url:���ص�ҳ�� eg����http://www.baidu.com������./main.html������../book/search.do�������صı�����ҳ�棩
 **����addeddiv����ܼ��ص����� eg: "#div1"�� ��.class2��
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
    var tab = $(updateeddiv).tabs('getSelected');  // ��ȡѡ������
    $(updateeddiv).tabs('update', {
        tab: tab,
        options: {
            title: title,
            href: url  // �����ݵ�URL
        }
    });
}

function getTabTitle() {
    var title = $('.tabs-selected').text();
    return title;
}


/*
 *������

 1.��һ��Ҫ������div����������Ϊ��class="easyui-window" title="xxx" modal="true"��
 2.ֱ�ӵ��ú���window('open')(eg:$('#win').window('open')")
 */


formatterDate = function (date) {
    var day = date.getDate() > 9 ? date.getDate() : "0" + date.getDate();
    var month = (date.getMonth() + 1) > 9 ? (date.getMonth() + 1) : "0"
    + (date.getMonth() + 1);
    return date.getFullYear() + '-' + month + '-' + day;
};

//��ʽ����ʾ״̬
formatIsdel = function (val, row) {
    //alert("val=="+val)
    if (val == 1) {
        return '<span style="color:red;">' + '�ѽ���' + '</span>';
    } else {
        return '<span>' + 'ʹ����' + '</span>';
    }
}

formatCardType = function (val, row) {
    switch (val) {
        case 10 :
            return '<span>' + 'ȫ��' + '</span>';
        case 0 :
            return '<span>' + '��ǿ�' + '</span>';
        case 1 :
            return '<span>' + '����' + '</span>';
        case 2 :
            return '<span>' + '���ǿ�' + '</span>';
        case 3 :
            return '<span>' + '��˾�˺�' + '</span>';
    }
}

formatMoney = function (val, row) {
    if (val != null) {
        return val.toFixed(2);
    }
}