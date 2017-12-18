package com.qmcb.dao.impl;


import com.qmcb.dao.RedisDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Repository;
import java.util.concurrent.TimeUnit;

/**
 * Created by Administrator on 2016/7/19.
 */

@Repository
public class RedisDaoImpl implements RedisDao {
    @Autowired
    StringRedisTemplate stringRedisTemplate;

    public boolean InHasKey(String key, String value) {
        key = String.format("polaris:%s", key);
        return stringRedisTemplate.opsForValue().setIfAbsent(key, value);
    }

    public void SetExpire(String key, long timeOut, TimeUnit timeUnit) {
        key = String.format("polaris:%s", key);
        stringRedisTemplate.expire(key, timeOut, timeUnit);
    }

    public String GetValue(String key) {
        key = String.format("polaris:%s", key);
        return stringRedisTemplate.opsForValue().get(key);
    }

    public boolean HasKey(String key) {
        key = String.format("polaris:%s", key);
        return stringRedisTemplate.hasKey(key);
    }

    public void DelKey(String key) {
        key = String.format("polaris:%s", key);
        stringRedisTemplate.delete(key);
    }

    public void SetValue(String key,String value){
        key = String.format("polaris:%s", key);
        stringRedisTemplate.opsForValue().set(key,value);
    }

}
