package com.polaris.controller;


import com.polaris.entity.Express;
import com.polaris.entity.Order;
import com.polaris.entity.SysGroup;
import com.polaris.entity.User;
import com.polaris.service.*;
import com.polaris.tool.easyui.DataGrid;
import com.polaris.tool.easyui.Json;
import com.polaris.tool.util.StringUtil;
import net.sf.json.JSONArray;
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
    private IGoodsService goodsService;

    @Resource
    private ISysGroupService sysGroupService;

    @Resource
    private IExpressService expressService;
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

    @RequestMapping(value = "/order/confirmorder", method = RequestMethod.GET)
    public String confirmorder(Model model, String menu_button) {
        return "order/confirmorder";
    }

    @RequestMapping(value = "/order/printck", method = RequestMethod.GET)
    public String printck(Model model, String id) {
        model.addAttribute("id",id);
        return "order/printck";
    }

    @RequestMapping(value = "/order/printwl", method = RequestMethod.GET)
    public String printwl(Model model, String id) {
        model.addAttribute("id",id);
        return "order/printwl";
    }

    @RequestMapping(value = "/order/rollbacklist", method = RequestMethod.GET)
    public String rollbacklist(Model model) {
        return "order/rollbacklist";
    }

    @RequestMapping(value = "/order/printth", method = RequestMethod.GET)
    public String printth(Model model, int id) {
        model.addAttribute("id",id);
        return "order/printth";
    }

    @RequestMapping(value = "/order/printhh", method = RequestMethod.GET)
    public String printhh(Model model, int id) {
        model.addAttribute("id",id);
        return "order/printhh";
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
            if("全部".equals(order.getSfqr())) {
                order.setSfqr("");
            }
            dg.setTotal(orderService.getOrderCount(order));
            List<Order> orderList = orderService.getOrderList(order);
            dg.setRows(orderList);
        }catch (Exception e){
            e.printStackTrace();
        }
        return dg;
    }

    /**
     * 用户表格
     * @return DataGrid
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/order/datagridqr", method = RequestMethod.POST)
    public DataGrid datagridqr(Order order ,HttpServletRequest request) {
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
            if("全部".equals(order.getSfqr())) {
                order.setSfqr("");
            }
            dg.setTotal(orderService.getOrderCountqr(order));
            List<Order> orderList = orderService.getOrderListqr(order);
            dg.setRows(orderList);
        }catch (Exception e){
            e.printStackTrace();
        }
        return dg;
    }


    /**
     * 出库确认用户表格
     * @return DataGrid
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/order/datagridck", method = RequestMethod.POST)
    public DataGrid datagridck(Order order ,HttpServletRequest request) {
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
            if("全部".equals(order.getSfqr())) {
                order.setSfqr("");
            }
            if("全部".equals(order.getCkqr())) {
                order.setCkqr("");
            }
            dg.setTotal(orderService.getOrderCountck(order));
            List<Order> orderList = orderService.getOrderListck(order);
            dg.setRows(orderList);
        }catch (Exception e){
            e.printStackTrace();
        }
        return dg;
    }


    /**
     * 物流确认用户表格
     * @return DataGrid
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/order/datagridwl", method = RequestMethod.POST)
    public DataGrid datagridwl(Order order ,HttpServletRequest request) {
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
            if("全部".equals(order.getWlqr())) {
                order.setWlqr("");
            }
            dg.setTotal(orderService.getOrderCountwl(order));
            List<Order> orderList = orderService.getOrderListwl(order);
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
            List<SysGroup> list = sysGroupService.getGroupListByid(sysGroup);
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



    @ResponseBody
    @RequestMapping(value = "/order/getgrounameByld", method = RequestMethod.POST)
    public JSONArray getgrounameByld(Order order ,HttpServletRequest request) {
        JSONObject json = new JSONObject();
        JSONArray array = new JSONArray();
        try {
            SysGroup sysGroup = null;
            List<SysGroup> list = sysGroupService.getGroupListByid(sysGroup);
            if(list.size()>0){
              for(SysGroup s:list){
                  json.put("groupid",s.getGroupid());
                  json.put("groupname",s.getGroupname());
                  array.add(json);
              }
            }else{
                return null;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return array;
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
            String account = request.getSession().getAttribute("user").toString();
            order.setAccount(account);
            BigDecimal money = dealmoney(BigDecimal.valueOf(order.getPrice()),order.getCount());
            String rq = StringUtil.getrq();
            int  count= order.getGcount()-order.getCount();
            if (order.getId() == 0) {
                order.setInserttime(rq);
                order.setOrderid(StringUtil.getId());
                order.setDdzt("02");
                order.setAmount(String.valueOf(money));
                int flag = orderService.addOrder(order);
                if(flag==0){
                    goodsService.updateGoodsCount(count,order.getGoodsid());
                    j.setSuccess(true);
                    j.setMsg("新增订单成功！");
                }else {
                    j.setSuccess(false);
                    j.setMsg("新增订单失败！");
                }
            } else {
                order.setAmount(String.valueOf(money));
                int flag=orderService.editOrder(order);
                if(flag==0){
                    goodsService.updateGoodsCount(count,order.getGoodsid());
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


    /**
     * 确认订单
     * @return Json
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/order/confirmorder", method = RequestMethod.POST)
    public Json confirmorder(Order order,HttpServletRequest request) {
        Json j = new Json();
        String account = request.getSession().getAttribute("user").toString();
        try {
            int flag = orderService.makeorder(order.getId(),account);
            if(flag==0){
                j.setSuccess(true);
                j.setMsg("确认订单成功！");
            }else {
                j.setSuccess(false);
                j.setMsg("确认订单失败！");
            }
            j.setObj(order);
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }

    /**
     * 确认库存
     * @return Json
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/order/confirmgoods", method = RequestMethod.POST)
    public Json confirmgoods(Order order,HttpServletRequest request) {
        Json j = new Json();
        String account = request.getSession().getAttribute("user").toString();
        try {
            int flag = orderService.makeorderck(order.getId(),account);
            if(flag==0){
                j.setSuccess(true);
                j.setMsg("出库确认成功！");
            }else {
                j.setSuccess(false);
                j.setMsg("出库确认失败！");
            }
            j.setObj(order);
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }

    /**
     * 确认物流
     * @return Json
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/order/confirmexp", method = RequestMethod.POST)
    public Json confirmexp(Order order,HttpServletRequest request) {
        Json j = new Json();
        String account = request.getSession().getAttribute("user").toString();
        try {
            int flag = orderService.makeorderwl(order.getId(), account);
            if(flag==0){
                //确认物流成功后，同时新增物流信息
                List<Order> list = orderService.getOrderById(order.getId());
                Express express = dealdata(list);
                expressService.addExpinfo(express);
                j.setSuccess(true);
                j.setMsg("物流确认成功！");
            }else {
                j.setSuccess(false);
                j.setMsg("物流确认失败！");
            }
            j.setObj(order);
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }

    public Express dealdata(List<Order> list){
        Express exp = new Express();
        String expressid = StringUtil.getExpressid();
        String rq = StringUtil.getrq();
        for(Order order :list){
            exp.setOrderid(order.getOrderid());
            exp.setGoodsid(order.getGoodsid());
            exp.setGroupid(order.getGroupid());
            exp.setExpaddress(order.getReaddress());
        }
        exp.setExpressid(expressid);
        exp.setExptime(rq);
        return exp;
    }




    /**
     * 退货订单查询
     * @return DataGrid
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/order/datagridback", method = RequestMethod.POST)
    public DataGrid datagridback(Order order ,HttpServletRequest request) {
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
            dg.setTotal(orderService.getOrderbackCount(order));
            List<Order> orderList = orderService.getOrderbackList(order);
            dg.setRows(orderList);
        }catch (Exception e){
            e.printStackTrace();
        }
        return dg;
    }

    /**
     * 是否同意退货
     * @return Json
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/order/confirmorderback", method = RequestMethod.POST)
    public Json confirmorderback(HttpServletRequest request,int id,int type) {
        Json j = new Json();
        String account = request.getSession().getAttribute("user").toString();
        try {
            int flag = 0;
            if(type==1){
                flag = orderService.agreeorder(id,account);
                if(flag==0){
                    j.setSuccess(true);
                    j.setMsg("操作同意退单成功！");
                }else {
                    j.setSuccess(false);
                    j.setMsg("操作同意退单失败！");
                }
            }else if(type==2){
                flag = orderService.refuseorder(id, account);
                if(flag==0){
                    j.setSuccess(true);
                    j.setMsg("操作拒绝退单成功！");
                }else {
                    j.setSuccess(false);
                    j.setMsg("操作拒绝退单失败！");
                }
            }else if(type==11){
                flag = orderService.agreeExchangeOrder(id, account);
                if(flag==0){
                    j.setSuccess(true);
                    j.setMsg("同意换货操作成功！");
                }else {
                    j.setSuccess(false);
                    j.setMsg("同意换货操作失败！");
                }
            }else if(type==12){
                flag = orderService.refuseExchangeOrder(id, account);
                if(flag==0){
                    j.setSuccess(true);
                    j.setMsg("拒绝换货操作成功！");
                }else {
                    j.setSuccess(false);
                    j.setMsg("拒绝换货操作失败！");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }

    /**
     * 入库确认用户表格
     * @return DataGrid
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/order/datagridrk", method = RequestMethod.POST)
    public DataGrid datagridrk(Order order ,HttpServletRequest request) {
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
            order.setFinaltime(order.getFinaltime() + " 23:59:59");
            if("全部".equals(order.getDdzt())) {
                order.setDdzt("");
            }
            if("全部".equals(order.getRkqr())) {
                order.setRkqr("");
            }
            dg.setTotal(orderService.getOrderCountrk(order));
            List<Order> orderList = orderService.getOrderListrk(order);
            dg.setRows(orderList);
        }catch (Exception e){
            e.printStackTrace();
        }
        return dg;
    }

    /**
     * 确认库存
     * @return Json
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/order/confirmgoodsrk", method = RequestMethod.POST)
    public Json confirmgoodsrk(HttpServletRequest request,int id,int gcount,String goodsid) {
        Json j = new Json();
        String account = request.getSession().getAttribute("user").toString();
        try {
            int flag = orderService.makeorderrk(id, account);
            if(flag==0){
                expressService.updateckcount(goodsid,gcount);
                j.setSuccess(true);
                j.setMsg("入库确认成功！");
            }else {
                j.setSuccess(false);
                j.setMsg("入库确认失败！");
            }
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }
}
