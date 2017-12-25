package com.polaris.controller;

import com.polaris.entity.Order;
import com.polaris.entity.SysGroup;
import com.polaris.entity.User;
import com.polaris.service.IOrderService;
import com.polaris.service.ISysGroupService;
import com.polaris.service.IUserService;
import com.polaris.tool.easyui.DataGrid;
import com.polaris.tool.easyui.Json;
import com.polaris.tool.util.StringUtil;
import net.sf.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 项目名称：polaris
 * 类名称：Aa01Controller
 * 类描述：订单管理
 * 创建人：武金龙
 * 创建时间：2015年11月7日 上午11:07:22
 * 修改人：武金龙
 * 修改时间：2015年11月7日 上午11:07:22
 * 修改备注：
 */
@Controller
public class OrderController {

    private final Logger log = LoggerFactory.getLogger(OrderController.class);

    @Resource
    private IOrderService orderService;

    @Resource
    private IUserService userService;

    @Resource
    private ISysGroupService sysGroupService;
    /**
     * 跳转到用户表格页面
     * @param model
     * @return String
     * @Exception
     */
    @RequestMapping(value = "/order/list", method = RequestMethod.GET)
    public String OrderList(Model model, String menu_button) {
        return "order/list";
    }

    @RequestMapping(value = "/order/addlist", method = RequestMethod.GET)
    public String OrderaddList(Model model, String menu_button) {
        return "order/addlist";
    }
    /**
     * 用户表格
     * @return DataGrid
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/order/datagrid", method = RequestMethod.POST)
    public DataGrid datagrid(Order order ,HttpServletRequest request) {
        String account= request.getSession().getAttribute("user").toString();
        List<User> list= userService.getgroupname(account);
        String groupid = "";
        for(User user:list){
            groupid = user.getGroupid();
        }
        if(groupid.equals("888888")){
            account="";
        }
        order.setAccount(account);
        DataGrid dg = new DataGrid();
        try {
            if ((order.getFinaltime() != null) && (order.getFinaltime() != "")
                    && (10 == order.getFinaltime().length())) {
                order.setFinaltime(order.getFinaltime() + " 23:59:59");
            }
            if("全部".equals(order.getDdzt())) {
                order.setDdzt("");
            }
            dg.setTotal(orderService.getOrderCount(order));
            List<Order> orderList = orderService.getOrderList(order);
            dg.setRows(orderList);
        }catch (Exception e){
            e.printStackTrace();
        }
        return dg;
    }


    @ResponseBody
    @RequestMapping(value = "/order/getgrouname", method = RequestMethod.POST)
    public JSONObject getgrouname(Order order ,HttpServletRequest request) {
        Map<String, Object> map = new HashMap<String, Object>();
        try {
            SysGroup sysGroup = null;
            List<SysGroup> list = sysGroupService.getGroupList(sysGroup);
            if(list.size()>0){
                Json j = new Json();
                map.put("rows", list);
                map.put("total", list.size());
                j.setObj(JSONObject.fromObject(map));
            }else{
                return null;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return JSONObject.fromObject(map);
    }


    /**
     * 新增订单
     * @return Json
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/order/addOrder", method = RequestMethod.POST)
    public Json addOrder(Order order,HttpServletRequest request) {
        Json j = new Json();
        try {
            String rq = StringUtil.getrq();
            order.setInserttime(rq);
            order.setOrderid(StringUtil.getId());
            String account = request.getSession().getAttribute("user").toString();
            order.setAccount(account);
            order.setDdzt("02");
            BigDecimal money = dealmoney(BigDecimal.valueOf(order.getPrice()),order.getCount());
            order.setAmount(String.valueOf(money));
            if (order.getId() == 0) {
                    int flag = orderService.addOrder(order);
                    if(flag==0){
                        j.setSuccess(true);
                        j.setMsg("新增订单成功！");
                    }else {
                        j.setSuccess(false);
                        j.setMsg("新增订单失败！");
                    }
            } else {
                    int flag=0;
                    if(flag==0){
                        j.setSuccess(true);
                        j.setMsg("修改订单成功！");
                    }else {
                        j.setSuccess(false);
                        j.setMsg("修改订单失败！");
                    }
            }
            j.setObj(order);
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }

    public static <T extends Number> BigDecimal dealmoney(T b1, T b2) {
        if (null == b1 || null == b2) {
            return BigDecimal.ZERO;
        }
        BigDecimal money=BigDecimal.valueOf(b1.doubleValue()).multiply(BigDecimal.valueOf(b2.doubleValue())).setScale(2, BigDecimal.ROUND_HALF_UP);
        return money;
    }
}