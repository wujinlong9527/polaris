package com.polaris.tool.easyui;

/**    
 * JSON模型   
 * 项目名称：SpringMvcDemo    
 * 类名称：Json    
 * 类描述：用户后台向前台返回的JSON对象    
 * 创建人：贾瑞宁    
 * 创建时间：2015年11月7日 下午2:25:00    
 * 修改人：贾瑞宁    
 * 修改时间：2015年11月7日 下午2:25:00    
 * 修改备注：    
 * @version     
 *     
 */
public class Json implements java.io.Serializable {

    /**
     * 
     */
    private static final long serialVersionUID = 1L;

    /**    
     *   
     */
    private boolean success = false;

    /**    
     *   
     */
    private String msg = "";

    /**    
     *   
     */
    private Object obj = null;

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Object getObj() {
        return obj;
    }

    public void setObj(Object obj) {
        this.obj = obj;
    }

}
