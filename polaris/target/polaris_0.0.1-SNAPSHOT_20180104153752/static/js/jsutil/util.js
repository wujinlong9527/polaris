/**
 * 获取路径
 *
 * @returns
 */
function getRootPath() {
    var curWwwPath = window.document.location.href;
    var pathName = window.document.location.pathname;
    var pos = curWwwPath.indexOf(pathName);
    var localhostPaht = curWwwPath.substring(0, pos);
    var projectName = pathName
        .substring(0, pathName.substr(1).indexOf('/') + 1);
    if(projectName.indexOf('whale')!=-1){
        return (localhostPaht + projectName);
    }else{
        return (localhostPaht);
    }
}

/**
 * 模拟点击事件
 *
 * @param page
 */
function autoclick(id) {
    var ie = navigator.appName == "Microsoft Internet Explorer" ? true : false;
    if (ie) {
        document.getElementById(id).click();
    }// IE的处理
    else {
        var a = document.createEvent("MouseEvents");// FF的处理
        a.initEvent("click", true, true);
        document.getElementById(id).dispatchEvent(a);
    }
}

/**
 * 回车事件监控
 *
 * @param obj
 * @param evt
 * @param callFunction 例如 "getId(array)"
 */
function enterEvent(obj, evt,callFunction) {
    evt = (evt) ? evt : ((window.event) ? window.event : "");
    keyCode = evt.keyCode ? evt.keyCode
        : (evt.which ? evt.which : evt.charCode);
    if (keyCode == 13) {
        eval(callFunction);
    }
}

/**
 * 获取对象数组中对象的某个属性值
 *
 * @param arr
 * @param colName
 * @returns {Array}
 */
function getListToCol(arr, colName) {
    var array = new Array();
    if (arr && arr.length > 0) {
        for (var i = 0, j = arr.length; i < j; i++) {
            array[i] = arr[i][colName];
        }
    }
    return array;
}

/**
 * 使用示例： new Date().Format("yyyy年MM月dd日") new Date().Format("MM/dd/yyyy") new
 * Date().Format("yyyyMMdd") new Date().Format("yyyy-MM-dd hh:mm:ss")
 *
 * @param format
 * @returns
 */
Date.prototype.Format = function(format) {
    var o = {
        "M+" : this.getMonth() + 1, // month
        "d+" : this.getDate(), // day
        "h+" : this.getHours(), // hour
        "m+" : this.getMinutes(), // minute
        "s+" : this.getSeconds(), // second
        "q+" : Math.floor((this.getMonth() + 3) / 3), // quarter
        "S" : this.getMilliseconds()
        // millisecond
    };
    if (/(y+)/.test(format)) {
        format = format.replace(RegExp.$1, (this.getFullYear() + "")
            .substr(4 - RegExp.$1.length));
    }
    for ( var k in o) {
        if (new RegExp("(" + k + ")").test(format)) {
            format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k]
                : ("00" + o[k]).substr(("" + o[k]).length));
        }
    }
    return format;
};