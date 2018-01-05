
package com.polaris.service.impl;

import com.polaris.entity.Express;
import com.polaris.mapper.polaris.ExpressMapper;
import com.polaris.service.IExpressService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * 项目名称：SpringMvcDemo
 * 类名称：GoodsService
 * 创建人：武金龙
 * 创建时间：2015年11月7日 上午11:05:17
 * 修改人：武金龙
 * 修改时间：2015年11月7日 上午11:05:17
 * 修改备注：
 */
@Service
public class ExpressServiceImpl implements IExpressService {

    @Resource
    private ExpressMapper expressMapper;

    public void addExpinfo(Express express){
        try {
            expressMapper.addExpinfo(express);
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    public Long getExpCount(Express express){
        return expressMapper.getExpCount(express);
    }

    public List<Express> getExpsList(Express express){
        List<Express> list = null;
        try {
            list = expressMapper.getExpsList(express);
        }catch (Exception e){
            e.printStackTrace();
        }
        return list;
    }
}
