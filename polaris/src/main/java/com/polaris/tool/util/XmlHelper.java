package com.polaris.tool.util;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.QName;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;

import java.io.*;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public  class XmlHelper {
/*
     XmlHelper() {
    }*/

    public  static String GetBankXml(String bankreturnmsg, String merOrderid, String merSettleDate, String sendType) {
        String xml = "<Msg><bankReturnMsg>%s</bankReturnMsg><merOrderId>%s</merOrderId><merSettleDate>%s</merSettleDate><sendType>%s</sendType>" +
                "</Msg>";
        return String.format(xml, bankreturnmsg.replace("<?xml version=\"1.0\" encoding=\"GBK\"?>", ""), merOrderid, merSettleDate, sendType);
    }

    public static  String GetBankXml(String bankreturnmsg, String merOrderid, String merSettleDate) {
        String xml = "<Msg><bankReturnMsg>%s</bankReturnMsg><merOrderId1>%s</merOrderId1><merSettleDate>%s</merSettleDate></Msg>";
        return String.format(xml, bankreturnmsg.replace("<?xml version=\"1.0\" encoding=\"UTF-8\"?>", ""), merOrderid, merSettleDate);
    }

    public   String GetResponseXml(String responseCode, String message, String backdata, String tradeno, String settle_date, String issuccess) {
        String xml = "<Msg><responseCode>%s</responseCode><message>%s</message><backdata>%s</backdata><issuccess>%s</issuccess>" +
                "<授权码>%s</授权码><settle_date>%s</settle_date></Msg>";
        return String.format(xml, responseCode, message,backdata.replace("<?xml version=\"1.0\" encoding=\"GBK\"?>", ""), issuccess, tradeno, settle_date);
    }

    public   Map<String, String> convertPrototype(String messagePrototype)
            throws DocumentException {
        List<Element> fields = getFields(messagePrototype, "map");

        Map<String, String> paramMap = new LinkedHashMap<String, String>();
        for (Element field : fields) {
            String fieldName = field.attributeValue("name");
            String fieldValue = field.getText();
            paramMap.put(fieldName, fieldValue);
        }

        return paramMap;
    }

    public   Map<String, String> getParams(Element paramsElement) {
        LinkedHashMap<String, String> params = new LinkedHashMap<String, String>();
        List<Element> paramElements = children(paramsElement, "param");
        for (Element param : paramElements) {
            String text = param.getText();
            params.put(param.attributeValue("name"), text);
        }

        return params;
    }

    public   List<Element> getFields(String xml, String node)
            throws DocumentException {
        Element root = getField(xml);
        return children(root, node);
    }

    public   List<Element> getFields(String xml, String node,
                                          String subNode) throws DocumentException {
        Element root = getField(xml);
        Element nodeElement = child(root, node);
        return children(nodeElement, subNode);
    }

    public   Element getField(String xml) throws DocumentException {
        StringReader stringReader = null;

        try {
            stringReader = new StringReader(xml);
            SAXReader reader = new SAXReader();

            Document doc = reader.read(stringReader);
            return doc.getRootElement();
        } finally {
            //IOUtils.closeQuietly(stringReader);
        }
    }

    /**
     * Return the child element with the given name. The element must be in the
     * same name space as the parent element.
     *
     * @param element The parent element
     * @param name    The child element name
     * @return The child element
     */
    public   Element child(Element element, String name) {
        return element.element(new QName(name, element.getNamespace()));
    }

    /**
     * Return the descendant element with the given xPath. Remember to remove
     * the heading and tailing backslash ( / )
     *
     * @param element The parent element
     * @param xPath   e.g: "foo/bar"
     * @return The child element. Return null if any sub node name is not
     * matched
     */
    public   Element descendant(Element element, String xPath) {
        if (element == null || xPath == null || xPath.trim().isEmpty()) {
            return null;
        }

        String[] paths = xPath.split("/");

        Element tempElement = element;
        for (String nodeName : paths) {
            tempElement = child(tempElement, nodeName);
        }
        return tempElement;
    }

    /**
     * 取出一个指定长度大小的随机正整数.
     *
     * @param length int 设定所取出随机数的长度。length小于11
     * @return int 返回生成的随机数。
     */
    public   int buildRandom(int length) {
        int num = 1;
        double random = Math.random();
        if (random < 0.1) {
            random = random + 0.1;
        }
        for (int i = 0; i < length; i++) {
            num = num * 10;
        }
        return (int) ((random * num));
    }

    /**
     * Return the child elements with the given name. The elements must be in
     * the same name space as the parent element.
     * @param element The parent element
     * @param name    The child element name
     * @return The child elements
     */
    @SuppressWarnings("unchecked")
    public   List<Element> children(Element element, String name) {
        return element.elements(new QName(name, element.getNamespace()));
    }

    /**
     * Return the value of the child element with the given name. The element
     * must be in the same name space as the parent element.
     *
     * @param element The parent element
     * @param name    The child element name
     * @return The child element value
     */
    public   String elementAsString(Element element, String name) {
        return element.elementTextTrim(new QName(name, element.getNamespace()));
    }

    /**
     */
    public   int elementAsInteger(Element element, String name) {
        String text = elementAsString(element, name);
        if (text == null) {
            return 0;
        }

        return Integer.parseInt(text);
    }


    public   boolean elementAsBoolean(Element element, String name) {
        String text = elementAsString(element, name);
        if (text == null) {
            return false;
        }
        return Boolean.valueOf(text);
    }

    public static String formatXML(String inputXML) throws Exception {
        SAXReader reader = new SAXReader();
        StringReader s=new StringReader(inputXML);
        Document document = reader.read(s);
        String requestXML = null;
        XMLWriter writer = null;
        if (document != null) {
            try {
                StringWriter stringWriter = new StringWriter();
                OutputFormat format = OutputFormat.createPrettyPrint();
                format.setExpandEmptyElements(true);
                writer = new XMLWriter(stringWriter, format);
                writer.write(document);
                writer.flush();
                requestXML = stringWriter.getBuffer().toString();
            } finally {
                if (writer != null) {
                    try {
                        writer.close();
                    } catch (IOException e) {
                    }
                }
            }
        }
        return requestXML;
    }
    //认证方法xml
    public static  String getStarfishXml(String mer_id,String merOrderId, String timeStamp) {
        String xml1 ="<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><INFO><TRX_CODE>G60001</TRX_CODE><VERSION>01</VERSION><MERCHANT_ID>%s</MERCHANT_ID><REQ_SN>%s</REQ_SN><TIMESTAMP>%s</TIMESTAMP><SIGNED_MSG>";
        return String.format(xml1,mer_id, merOrderId, timeStamp);
    }
    //认证方法xml
    public static  String getStarfishXml2(String uuid,String bankName,String bankcode,String bType,String bankNo,
                    String name,String idType,String id, String phone){
        String xml="</SIGNED_MSG></INFO>" +
                "<BODY><BATCH><VALIDATE_MODE>V001</VALIDATE_MODE></BATCH><TRANS_DETAILS><DTL><SN>%s</SN><BANK_GENERAL_NAME>%s</BANK_GENERAL_NAME><BANK_NAME></BANK_NAME><BANK_CODE>%s</BANK_CODE><ACCOUNT_TYPE>%s</ACCOUNT_TYPE><ACCOUNT_NO>%s</ACCOUNT_NO><ACCOUNT_NAME>%s</ACCOUNT_NAME><ID_TYPE>%s</ID_TYPE><ID>%s</ID><TEL>%s</TEL></DTL></TRANS_DETAILS></BODY></MESSAGE>";
        return String.format(xml, uuid, bankName,bankcode,bType,bankNo,name,idType,id,phone);
    }
    //查询认证方法xml
    public static  String getQueryXml(String mer_id,String merId,String timeStamp) {
        String xml1 ="<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGE><INFO><TRX_CODE>G60002</TRX_CODE><VERSION>01</VERSION><MERCHANT_ID>%s</MERCHANT_ID><REQ_SN>%s</REQ_SN><TIMESTAMP>%s</TIMESTAMP><SIGNED_MSG>";
        return String.format(xml1,mer_id, merId, timeStamp);
    }
    //查询认证方法xml
    public static  String getQueryXml2(String merid){
        String xml="</SIGNED_MSG></INFO><BODY><QRY_REQ_SN>%s</QRY_REQ_SN></BODY></MESSAGE>";
        return String.format(xml, merid);
    }

    public static String getXmlNode (String xml,String node) throws Exception{
        SAXReader saxReader = new SAXReader();
        Document document = saxReader.read(new ByteArrayInputStream(xml.getBytes("UTF-8")));
        Element root = document.getRootElement();
        Element e = (Element) root.selectSingleNode(node);
        String value = e.getText();
        return value;
    }

}
