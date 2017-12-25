package com.polaris.tool.easyui;

import java.util.List;

/**    
 *     
 * 项目名称：SpringMvcDemo    
 * 类名称：Tree    
 * 类描述：EasyUI tree模型    
 * 创建人：贾瑞宁    
 * 创建时间：2015年11月7日 下午2:27:11    
 * 修改人：贾瑞宁    
 * 修改时间：2015年11月7日 下午2:27:11    
 * 修改备注：    
 * @version     
 *     
 */
public class Tree {

    /**    
     * 节点的ID  
     */
    private int id;

    /**    
     *  节点显示的文字 
     */
    private String text;

    /**    
     *  默认open,当为‘closed’时说明此节点下有子节点，否则此节点为叶子节点 
     */
    private String state = "open";

    /**    
     * 指示节点是否被选中  
     */
    private boolean checked = false;

    /**    
     *  给一个节点追加的自定义属性 
     */
    private Object attributes;

    /**    
     * 定义了一些子节点的节点数组  
     */
    private List<Tree> children;

    /**    
     *  定义该节点的样式 
     */
    private String iconCls;

    /**    
     *  定义该节点的父节点 
     */
    private int pid;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public boolean isChecked() {
        return checked;
    }

    public void setChecked(boolean checked) {
        this.checked = checked;
    }

    public Object getAttributes() {
        return attributes;
    }

    public void setAttributes(Object attributes) {
        this.attributes = attributes;
    }

    public List<Tree> getChildren() {
        return children;
    }

    public void setChildren(List<Tree> children) {
        this.children = children;
    }

    public String getIconCls() {
        return iconCls;
    }

    public void setIconCls(String iconCls) {
        this.iconCls = iconCls;
    }

    public int getPid() {
        return pid;
    }

    public void setPid(int pid) {
        this.pid = pid;
    }

}
