package com.qmcb.tool.easyui;

import java.util.List;

/**
 * 项目名称：SpringMvcDemo
 * 类名称：DataGrid
 * 类描述： 后台向前台返回JSON，用于easyui的datagrid
 * 创建人：武金龙
 * 创建时间：2015年11月7日 下午2:22:41
 * 修改人：武金龙
 * 修改时间：2015年11月7日 下午2:22:41
 * 修改备注：
 */
public class DataGrid implements java.io.Serializable {

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
    private List columns;

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

    public List getColumns() {
        return columns;
    }

    public void setColumns(List columns) {
        this.columns = columns;
    }
}
