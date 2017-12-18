package com.qmcb.tool.easyui;

/**    
 *     
 * 项目名称：SpringMvcDemo    
 * 类名称：PageHelper    
 * 类描述： easyui的datagrid向后台传递参数使用的model   
 * 创建人：贾瑞宁    
 * 创建时间：2015年11月7日 下午2:25:49    
 * 修改人：贾瑞宁    
 * 修改时间：2015年11月7日 下午2:25:49    
 * 修改备注：    
 * @version     
 *     
 */
public class PageHelper implements java.io.Serializable {

    /**
     * 
     */
    private static final long serialVersionUID = 1L;

    /**    
     *  当前页 
     */
    private int page;

    /**    
     *  每页显示记录数 
     */
    private int rows;

    /**    
     * 排序字段名  
     */
    private String sort = null;

    /**    
     * 按什么排序(asc,desc)  
     */
    private String order = "asc";

    /**    
     *  起始页 
     */
    private int start;

    /**    
     * 最终页  
     */
    private int end;

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public int getRows() {
        return rows;
    }

    public void setRows(int rows) {
        this.rows = rows;
    }

    public String getSort() {
        return sort;
    }

    public void setSort(String sort) {
        this.sort = sort;
    }

    public String getOrder() {
        return order;
    }

    public void setOrder(String order) {
        this.order = order;
    }

    public int getStart() {
        return start;
    }

    public void setStart(int start) {
        this.start = start;
    }

    public int getEnd() {
        return end;
    }

    public void setEnd(int end) {
        this.end = end;
    }

    @Override
    public String toString() {
        return "PageHelper{" +
                "page=" + page +
                ", rows=" + rows +
                ", sort='" + sort + '\'' +
                ", order='" + order + '\'' +
                ", start=" + start +
                ", end=" + end +
                '}';
    }
}
