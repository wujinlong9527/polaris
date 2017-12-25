package com.polaris.tool.easyui;

import java.util.List;

/**
 * 项目名称：SpringMvcDemo
 * 类名称：EasyuiDataGridJson
 * 类描述：后台向前台返回JSON，用于easyui的datagrid
 * 创建人：贾瑞宁
 * 创建时间：2015年11月7日 下午2:23:49
 * 修改人：贾瑞宁
 * 修改时间：2015年11月7日 下午2:23:49
 * 修改备注：
 */
public class EasyuiDataGridJson implements java.io.Serializable {

    /**
     *
     */
    private static final long serialVersionUID = 1L;

    /**
     * 总记录数
     */
    private Long total;

    /**
     * 每行记录
     */
    private List rows;

    /**
     *
     */
    private List footer;

    public Long getTotal() {
        return total;
    }

    public void setTotal(Long total) {
        this.total = total;
    }

    public List getRows() {
        return rows;
    }

    public void setRows(List rows) {
        this.rows = rows;
    }

    public List getFooter() {
        return footer;
    }

    public void setFooter(List footer) {
        this.footer = footer;
    }

}
