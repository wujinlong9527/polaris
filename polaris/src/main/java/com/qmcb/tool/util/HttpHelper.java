package com.qmcb.tool.util;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.methods.RequestEntity;
import org.apache.commons.httpclient.methods.StringRequestEntity;
import org.apache.commons.httpclient.params.HttpConnectionManagerParams;
import org.apache.commons.httpclient.params.HttpMethodParams;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;

import javax.servlet.http.HttpServletRequest;

public class HttpHelper {
    private static final Logger logger = LoggerFactory.getLogger(HttpHelper.class);

    public static String get(String posturl) {
        //发送url并得到返回结果
        HttpClient httpClient = new HttpClient();
        HttpConnectionManagerParams managerParams = httpClient.getHttpConnectionManager().getParams();
        // 设置连接超时时间(单位毫秒)
        managerParams.setConnectionTimeout(60000);
        // 设置读数据超时时间(单位毫秒)
        managerParams.setSoTimeout(180000);
        HttpMethod getmethod = new GetMethod(posturl);
        int statusCode = 0;
        try {
            statusCode = httpClient.executeMethod(getmethod);
            if (statusCode != 200) {
                logger.error("请求异常,参数：" + posturl + " statusCode：" + statusCode);
                return "";
            } else {
                byte[] responseBody = getmethod.getResponseBody();
                String html = new String(responseBody, "UTF-8");
                return html;
            }
        } catch (Exception e) {
            logger.error("请求异常,参数：" + posturl + " 错误信息：" + e.getMessage());
            return "";
        }
    }

	public static String sendGet(String addr) {
		String person = null;
		try {
			// 创建连接
			URL url = new URL(addr);
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			connection.setRequestProperty("appcode", "130000810");
			if(connection.getResponseCode()==connection.HTTP_OK){
				//得到输入流
                InputStream is =connection.getInputStream();
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                byte[] buffer = new byte[1024];
                int len = 0;
                while(-1 != (len = is.read(buffer))){
                    baos.write(buffer,0,len);
                    baos.flush();
                }
                person = baos.toString("utf-8");
	        }

		}  catch (IOException e) {
            e.printStackTrace();
        }
		return person;
	}
    
	
	
	
	
	
	  public static String httpRequest1(String sac02,String ywcode) throws Exception {
	        PostMethod postMethod = null;
	        try {
	        	String url = "http://10.32.33.5/hebsicp/api/v0/sac02";
	            HttpClient client = new HttpClient();
	            client.getParams().setParameter(HttpMethodParams.HTTP_CONTENT_CHARSET, "utf-8");
	            client.getParams().setSoTimeout(60000);
	            postMethod = new PostMethod(url);
	            RequestEntity requestEntity = new StringRequestEntity(sac02, "application/json", "UTF-8");
	            postMethod.setRequestEntity(requestEntity);
	            postMethod.setRequestHeader("appcode", "130000170");
	            postMethod.setRequestHeader("ywcode", ywcode);
	            postMethod.setRequestHeader("mbz", "1");
	            int statusCode = client.executeMethod(postMethod);
	            if (statusCode != HttpStatus.SC_OK) {
	                String msg = "访问失败！！HTTP_STATUS=" + statusCode;
	                throw new HttpException(msg);
	            }
	            String context = postMethod.getResponseBodyAsString();
	            return context;
	        } finally {
	            if (postMethod != null)
	                postMethod.releaseConnection();
	        }
	    }	

	
	
	
    public static String httpRequest(String tab,String body) throws Exception {
        PostMethod postMethod = null;
        try {
        	String url = "http://10.32.33.5/hebsicp/api/v0/"+tab;
            HttpClient client = new HttpClient();
            client.getParams().setParameter(HttpMethodParams.HTTP_CONTENT_CHARSET, "utf-8");
            client.getParams().setSoTimeout(60000);
            postMethod = new PostMethod(url);
            RequestEntity requestEntity = new StringRequestEntity(body, "application/json", "UTF-8");
            postMethod.setRequestEntity(requestEntity);
            postMethod.setRequestHeader("appcode", "130000170");
            postMethod.setRequestHeader("ywcode", "21014");
            if(tab.equals("sac02")){
            	postMethod.setRequestHeader("mbz", "0");
            }else{
            	postMethod.setRequestHeader("mbz", "1");
            }
            int statusCode = client.executeMethod(postMethod);
            if (statusCode != HttpStatus.SC_OK) {
                String msg = "访问失败！！HTTP_STATUS=" + statusCode;
                throw new HttpException(msg);
            }
            String context = postMethod.getResponseBodyAsString();
            return context;
        } finally {
            if (postMethod != null)
                postMethod.releaseConnection();
        }
    }
    
    public static String sendPost(String url,String json)
    {
        PrintWriter out = null;
        BufferedReader in = null;
        String result = "";
        InputStream inputStream = null;
        try{
            URL realUrl = new URL(url);
            // 打开和URL之间的连接
            URLConnection conn = realUrl.openConnection();
            HttpURLConnection httpURLConnection = (HttpURLConnection)conn;
            httpURLConnection.setRequestProperty("Content-Type","application/json;charset=utf-8");
        //  	httpURLConnection.setRequestProperty("X-WeshareAuth-Token",token);
            httpURLConnection.setRequestMethod("POST");
            httpURLConnection.setRequestProperty("appcode", "130000170");
            httpURLConnection.setRequestProperty("ywcode", "21008");
            httpURLConnection.setDoOutput(true);
            httpURLConnection.setDoInput(true);
            out = new PrintWriter(new OutputStreamWriter(httpURLConnection.getOutputStream(),"utf-8"));
            // 发送请求参数
            out.print(json);
            // flush输出流的缓冲
            out.flush();
            int code = httpURLConnection.getResponseCode();
            if(code==200){
                inputStream = httpURLConnection.getInputStream();
                in = new BufferedReader(new InputStreamReader(inputStream,"utf-8"));
                String line;
                while ((line = in.readLine()) != null) {
                    result += line;
                }
            }else{
            	logger.info("返回状态code:{}",code);
            }
        } catch (Exception e){
            e.printStackTrace();
            logger.info(String.format("url:%s post请求异常%s",url,json),e);
        }
        //使用finally块来关闭输出流、输入流
        finally {
            try {
                if (out != null) {
                    out.close();
                }
                if (in != null) {
                    in.close();
                }
                if (inputStream != null) {
                    inputStream.close();
                }
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
        return result;
    }
    
    
    public static String sendPostNoRes(String url,String json)
    {
        PrintWriter out = null;
        String result = "";
        try{
            URL realUrl = new URL(url);
            // 打开和URL之间的连接
            URLConnection conn = realUrl.openConnection();
            HttpURLConnection httpURLConnection = (HttpURLConnection)conn;
            httpURLConnection.setRequestProperty("Content-Type","application/json;charset=utf-8");
        //    httpURLConnection.setRequestProperty("X-WeshareAuth-Token",token);
            httpURLConnection.setRequestMethod("POST");
            httpURLConnection.setRequestProperty("appcode", "130000170");
            httpURLConnection.setRequestProperty("ywcode", "21008");
            httpURLConnection.setRequestProperty("mbz", "1");
            httpURLConnection.setDoOutput(true);
            httpURLConnection.setDoInput(true);
            out = new PrintWriter(new OutputStreamWriter(httpURLConnection.getOutputStream(),"utf-8"));
            // 发送请求参数
            out.print(json);
            // flush输出流的缓冲
            out.flush();
        } catch (Exception e){
            e.printStackTrace();
            logger.info(String.format("url:%s post请求异常%s",url,json),e);
        }
        //使用finally块来关闭输出流、输入流
        finally {
            if (out != null) {
			    out.close();
			}
        }
        return result;
    }
    
    /**
	 * 获取客户端IP地址.<br>
	 * 支持多级反向代理
	 * @param request
	 *            HttpServletRequest
	 * @return 客户端真实IP地址
	 */
	public static String getIpAddr(final HttpServletRequest request) {
		try{
			String remoteAddr = request.getHeader("X-Forwarded-For");
			// 如果通过多级反向代理，X-Forwarded-For的值不止一个，而是一串用逗号分隔的IP值，此时取X-Forwarded-For中第一个非unknown的有效IP字符串
			if (isEffective(remoteAddr) && (remoteAddr.indexOf(",") > -1)) {
				String[] array = remoteAddr.split(",");
				for (String element : array) {
					if (isEffective(element)) {
						remoteAddr = element;
						break;
					}
				}
			}
			if (!isEffective(remoteAddr)) {
				remoteAddr = request.getHeader("X-Real-IP");
			}
			if (!isEffective(remoteAddr)) {
				remoteAddr = request.getRemoteAddr();
			}
			return remoteAddr;
		}catch(Exception e){
			logger.error("get romote ip error,error message:"+e.getMessage());
			return "";
		}
	}
	
	
	/**
	 * 获取客户端源端口
	 * @param request
	 * @return
	 */
	public static Long getRemotePort(final HttpServletRequest request){
		try{
			String port = request.getHeader("remote-port");
			if( StringUtil.isNotEmpty(port)) {
				try{
					return Long.parseLong(port);
				}catch(NumberFormatException ex){
					logger.error("convert port to long error , port:	"+port);
					return 0l;
				}
			}else{
				return 0l;
			}		
		}catch(Exception e){
			logger.error("get romote port error,error message:"+e.getMessage());
			return 0l;
		}
	}

	/**
	 * 远程地址是否有效.
	 * 
	 * @param remoteAddr
	 *            远程地址
	 * @return true代表远程地址有效，false代表远程地址无效
	 */
	private static boolean isEffective(final String remoteAddr) {
		boolean isEffective = false;
		if ((null != remoteAddr) && (!"".equals(remoteAddr.trim()))
				&& (!"unknown".equalsIgnoreCase(remoteAddr.trim()))) {
			isEffective = true;
		}
		return isEffective;
	}
}
