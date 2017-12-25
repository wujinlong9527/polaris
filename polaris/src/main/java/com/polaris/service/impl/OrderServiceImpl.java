
package com.polaris.service.impl;

import com.polaris.entity.Order;
import com.polaris.mapper.polaris.OrderMapper;
import com.polaris.service.IOrderService;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

/**
 * 项目名称：SpringMvcDemo
 * 类名称：OrderService
 * 创建人：武金龙
 * 创建时间：2015年11月7日 上午11:05:17
 * 修改人：武金龙
 * 修改时间：2015年11月7日 上午11:05:17
 * 修改备注：
 */
@Service
public class OrderServiceImpl implements IOrderService {

    @Resource
    private OrderMapper orderMapper;

    public List<Order> getOrderList(Order order) {
        List<Order> list = new ArrayList<Order>();
        try {
            list = orderMapper.getOrderList(order);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Long getOrderCount(Order order){
        return orderMapper.getOrderCount(order);
    }

    public int addOrder(Order order){
        int ret = 0;
        try {
            orderMapper.addOrder(order);
        }catch (Exception e){
            e.printStackTrace();
            ret=9;
        }
        return ret;
    }
}
