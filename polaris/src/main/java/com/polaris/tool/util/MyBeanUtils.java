package com.polaris.tool.util;

import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

/**
 * Created with IDEA
 * 类名称：
 * 类描述：
 * 创建人：姬新平
 * 创建日期：2016/7/14
 * 创建时间：13:37
 */
public class MyBeanUtils implements ApplicationContextAware {

    private static ApplicationContext applicationContext;

    public void setApplicationContext(ApplicationContext applicationContext){
        this.applicationContext = applicationContext;
    }

    public static Object getBean(String beanName){
        return applicationContext.getBean(beanName);
    }
}

