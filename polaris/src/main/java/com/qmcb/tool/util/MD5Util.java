package com.qmcb.tool.util;

import org.apache.commons.codec.digest.DigestUtils;

/**    
 *     
 * 项目名称：SpringMvcDemo    
 * 类名称：MD5Util    
 * 类描述：加密工具类    
 * 创建人：武金龙   
 * 创建时间：2015年11月7日 下午2:29:03    
 * 修改人：武金龙   
 * 修改时间：2015年11月7日 下午2:29:03    
 * 修改备注：    
 * @version     
 *     
 */
public class MD5Util {

    /**
     *    
     * @param  args 
     * @return void    
     * @Exception
    */
    public static void main(String[] args) {
        String s = "wujinlong1990";
        System.out.println(md5(s));
    }

    /**
     * md5加密   
     * @param  str
     * @return String    
     * @Exception
    */
    public static String md5(String str) {
        return DigestUtils.md5Hex(str);
    }

}
