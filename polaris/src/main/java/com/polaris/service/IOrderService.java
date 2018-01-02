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

    public List<Order> getOrderListck(Order order);

    public Long getOrderCountck(Order order);

    public int addOrder(Order order);

    public int editOrder(Order order);

    public int makeorder(long id,String account);

    public int makeorderck(long id,String account);
}
