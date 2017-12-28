package com.polaris.tool.util;

import sun.misc.BASE64Encoder;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class StringUtil {  
	  
    public static boolean isEmpty(String str){  
        if("".equals(str)||str==null){  
            return true;  
        }else{  
            return false;  
        }  
    }  
      
    public static boolean isNotEmpty(String str){  
        if(!"".equals(str)&&str!=null){  
            return true;  
        }else{  
            return false;  
        }  
    }  
    
    public static String strByMd5(String str) throws NoSuchAlgorithmException, UnsupportedEncodingException{
    	MessageDigest md5=MessageDigest.getInstance("MD5");
    	BASE64Encoder base64en = new BASE64Encoder();
    	String newstr=base64en.encode(md5.digest(str.getBytes("utf-8")));
    	return newstr;
    }
 
    /**
     * 标准MD5加密
     */
    public static String getPwdByMD5(String inStr) {
        StringBuffer sb = new StringBuffer();
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(inStr.getBytes());
            byte b[] = md.digest();
            int i;
            for (int offset = 0; offset < b.length; offset++) {
                i = b[offset];
                if (i < 0)
                    i += 256;
                if (i < 16)
                    sb.append("0");
                sb.append(Integer.toHexString(i));
            }
        } catch (Exception e) {
            return null;
        }
        return sb.toString();
    }
 
    /**
 	 * 身份证校验
 	 * @param idcard
 	 * @return
 	 */
 	public static int Idcardcheck(String idcard) {  
 		String cityCode[] = { "11", "12", "13", "14", "15", "21",  
 	            "22", "23", "31", "32", "33", "34", "35", "36", "37", "41", "42",  
 	            "43", "44", "45", "46", "50", "51", "52", "53", "54", "61", "62",  
 	            "63", "64", "65", "71", "81", "82", "91" };  
        if (idcard == null || "".equals(idcard)) {  
            return 1;  
        }else {
        	 // 非18位为假  
            if (idcard.length() != 18) {  
                return 1;  
            }else {
            	 // 获取前17位  
                String idcard17 = idcard.substring(0, 17);  
          
                // 前17位全部为数字  
                if (!idcard17.matches("^[0-9]*$")) {  
                    return 1;  
                }
                
                String provinceid = idcard.substring(0, 2);  
                for (String id : cityCode) {  
                    if (id.equals(provinceid)) {  
                    	// 校验出生日期  
                        String birthday = idcard.substring(6, 14);  
                  
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");  
                  
                        try {  
                            Date birthDate = sdf.parse(birthday);  
                            String tmpDate = sdf.format(birthDate);  
                            if (!tmpDate.equals(birthday)) {// 出生年月日不正确  
                                return 1;  
                            }  
                            // 获取第18位  
                            String idcard18Code = idcard.substring(17, 18);  
                      
                            char c[] = idcard17.toCharArray();  
                      
                            int bit[] = converCharToInt(c);  
                      
                            int sum17 = 0;  
                      
                            sum17 = getPowerSum(bit);  
                      
                            // 将和值与11取模得到余数进行校验码判断  
                            String checkCode = getCheckCodeBySum(sum17);  
                            if (null == checkCode) {  
                                return 1;  
                            }  
                            // 将身份证的第18位与算出来的校码进行匹配，不相等就为假  
                            if (!idcard18Code.equalsIgnoreCase(checkCode)) {  
                                return 1;  
                            }  
                        } catch (ParseException e1) {  
                  
                            return 1;  
                        }  
                    }  
                }  
            }
        }
        
        return 0;  
    }  
 
    /** 
     * 将字符数组转为整型数组 
     *  
     * @param c 
     * @return 
     * @throws NumberFormatException 
     */  
    private static int[] converCharToInt(char[] c) throws NumberFormatException {  
        int[] a = new int[c.length];  
        int k = 0;  
        for (char temp : c) {  
            a[k++] = Integer.parseInt(String.valueOf(temp));  
        }  
        return a;  
    }  
    
    /** 
     * 每位加权因子 
     */  
    private static int power[] = { 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5,  
            8, 4, 2 };  
    /** 
     * 将身份证的每位和对应位的加权因子相乘之后，再得到和值 
     *  
     * @param bit 
     * @return 
     */  
    private static int getPowerSum(int[] bit) {  
  
        int sum = 0;  
  
        if (power.length != bit.length) {  
            return sum;  
        }  
  
        for (int i = 0; i < bit.length; i++) {  
            for (int j = 0; j < power.length; j++) {  
                if (i == j) {  
                    sum = sum + bit[i] * power[j];  
                }  
            }  
        }  
        return sum;  
    }  
    /** 
     * 将和值与11取模得到余数进行校验码判断 
     * @param sum17
     * @return 校验位 
     */  
    private static String getCheckCodeBySum(int sum17) {  
        String checkCode = null;  
        switch (sum17 % 11) {  
        case 10:  
            checkCode = "2";  
            break;  
        case 9:  
            checkCode = "3";  
            break;  
        case 8:  
            checkCode = "4";  
            break;  
        case 7:  
            checkCode = "5";  
            break;  
        case 6:  
            checkCode = "6";  
            break;  
        case 5:  
            checkCode = "7";  
            break;  
        case 4:  
            checkCode = "8";  
            break;  
        case 3:  
            checkCode = "9";  
            break;  
        case 2:  
            checkCode = "x";  
            break;  
        case 1:  
            checkCode = "0";  
            break;  
        case 0:  
            checkCode = "1";  
            break;  
        }  
        return checkCode;  
    }

    public static String getId(){
        String orderId =
                (System.currentTimeMillis() + "").substring(1) +
                        (System.nanoTime() + "").substring(7, 10);
        return orderId;
    }
    public static String getrq(){
       String rq = null;
        SimpleDateFormat sm = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        rq = sm.format(new Date());
        return rq;
    }

    public static <T extends Number> BigDecimal dealmoney(T b1, T b2) {
        if (null == b1 || null == b2) {
            return BigDecimal.ZERO;
        }
        BigDecimal money=BigDecimal.valueOf(b1.doubleValue()).multiply(BigDecimal.valueOf(b2.doubleValue())).setScale(2, BigDecimal.ROUND_HALF_UP);
        return money;
    }

    public static String getgoodsId(String type,String groupid){
        String goodsid =groupid+type+ (System.nanoTime() + "").substring(5, 10);
        return goodsid;
    }

}  
