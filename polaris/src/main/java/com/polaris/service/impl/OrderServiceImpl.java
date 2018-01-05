
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

    public List<Order> getOrderListqr(Order order) {
        List<Order> list = new ArrayList<Order>();
        try {
            list = orderMapper.getOrderListqr(order);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Long getOrderCountqr(Order order){
        return orderMapper.getOrderCountqr(order);
    }

    public List<Order> getOrderListck(Order order) {
        List<Order> list = new ArrayList<Order>();
        try {
            list = orderMapper.getOrderListck(order);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Long getOrderCountck(Order order){
        return orderMapper.getOrderCountck(order);
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

    public int editOrder(Order order){
        int ret = 0;
        try {
            orderMapper.editOrder(order);
        }catch (Exception e){
            e.printStackTrace();
            ret=9;
        }
        return ret;
    }

    public int makeorder(long id,String account){
        int ret = 0;
        try {
            orderMapper.makeorder(id,account);
        }catch (Exception e){
            e.printStackTrace();
            ret=9;
        }
        return ret;
    }

    public int makeorderck(long id,String account){
        int ret = 0;
        try {
            orderMapper.makeorderck(id,account);
        }catch (Exception e){
            e.printStackTrace();
            ret=9;
        }
        return ret;
    }

    public List<Order> getOrderListwl(Order order) {
        List<Order> list = new ArrayList<Order>();
        try {
            list = orderMapper.getOrderListwl(order);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Long getOrderCountwl(Order order){
        return orderMapper.getOrderCountwl(order);
    }

    public int makeorderwl(long id,String account){
        int ret = 0;
        try {
            orderMapper.makeorderwl(id, account);
        }catch (Exception e){
            e.printStackTrace();
            ret=9;
        }
        return ret;
    }

    public List<Order> getOrderById(long id){
        List<Order> list = null;
        try {
            list = orderMapper.getOrderById(id);
        }catch (Exception e){
            e.printStackTrace();
        }
        return list;
    }
}
