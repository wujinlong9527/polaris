/**
 *
 */
package com.polaris.service;


import com.polaris.entity.Order;

import java.util.List;

/**
 * 项目名称：SpringMvcDemo
 * 类名称：OrderService
 * 类描述：  消费表
 * 创建人：武金龙
 * 创建时间：2015年11月7日 上午11:05:17
 * 修改人：武金龙
 * 修改时间：2015年11月7日 上午11:05:17
 * 修改备注：
 */
public interface IOrderService {

    public List<Order> getOrderList(Order order);

    public Long getOrderCount(Order order);

    public List<Order> getOrderListqr(Order order);

    public Long getOrderCountqr(Order order);

    public List<Order> getOrderListck(Order order);

    public Long getOrderCountck(Order order);

    public int addOrder(Order order);

    public int editOrder(Order order);

    public int makeorder(long id,String account);

    public int makeorderck(long id,String account);

    public List<Order> getOrderListwl(Order order);

    public Long getOrderCountwl(Order order);

    public int  makeorderwl(long id,String account);

    public List<Order> getOrderById(long id);

    public int updateOrderzt(String orderid,String goodsid);

    public List<Order> getOrderbackList(Order order);

    public Long getOrderbackCount(Order order);

    public int agreeorder(int id,String account);

    public int refuseorder(int id,String account);

    public int agreeExchangeOrder(int id,String account);

    public int refuseExchangeOrder(int id,String account);

    public List<Order> getOrderListrk(Order order);

    public Long getOrderCountrk(Order order);

    public int makeorderrk(int id,String account);
}
