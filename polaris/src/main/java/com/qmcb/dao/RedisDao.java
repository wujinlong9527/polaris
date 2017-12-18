package com.qmcb.dao;

import java.util.concurrent.TimeUnit;

/**
 * 武金龙
 */

public interface RedisDao {
	
    public boolean InHasKey(String key, String value);

    public void SetExpire(String key, long timeOut, TimeUnit timeUnit);

    public String GetValue(String key);

    public boolean HasKey(String key);

    public void DelKey(String key);

    public void SetValue(String key, String value);
}