package com.polaris.controller;

import com.alibaba.fastjson.JSONArray;
import com.polaris.entity.Express;
import com.polaris.entity.Expuser;
import com.polaris.entity.User;
import com.polaris.service.IExpressService;
import com.polaris.service.IOrderService;
import com.polaris.service.IUserService;
import com.polaris.tool.easyui.DataGrid;
import com.polaris.tool.easyui.Json;
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
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 项目名称：polaris
 * 类名称：Aa01Controller
 * 类描述：物流管理
 * 创建人：武金龙
 * 创建时间：2015年11月7日 上午11:07:22
 * 修改人：武金龙
 * 修改时间：2015年11月7日 上午11:07:22
 * 修改备注：
 */
@Controller
public class ExpressController {

    private final Logger log = LoggerFactory.getLogger(ExpressController.class);

    @Resource
    private IUserService userService;

    @Resource
    private IExpressService expressService;

    @Resource
    private IOrderService orderService;

    /**
     * 跳转到用户表格页面
     * @param model
     * @return String
     * @Exception
     */
    @RequestMapping(value = "/express/list", method = RequestMethod.GET)
    public String list(Model model) {
        return "express/list";
    }

    @RequestMapping(value = "/express/confirmexp", method = RequestMethod.GET)
    public String confirmgoods(Model model) {
        return "express/confirmexp";
    }

    @RequestMapping(value = "/express/addpersonforexp", method = RequestMethod.GET)
    public String addpersonforexp(Model model) {
        return "express/addpersonforexp";
    }

    @RequestMapping(value = "/express/expgroup", method = RequestMethod.GET)
    public String expgroup(Model model) {
        return "express/expgroup";
    }

    @RequestMapping(value = "/express/fpexpgroup", method = RequestMethod.GET)
    public String fpexpgroup(Model model, Express express) {
        model.addAttribute("express", express);
        return "express/fpexpgroup";
    }
    /**
     * 用户表格
     * @return DataGrid
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/express/datagrid", method = RequestMethod.POST)
    public DataGrid datagrid(Express express ,HttpServletRequest request) {
        String account= request.getSession().getAttribute("user").toString();
        DataGrid dg = new DataGrid();
        try {
            List<User> list= userService.getgroupname(account);
            String groupid = "";
            for(User user:list){
                groupid = user.getGroupid();
            }
            if(groupid.equals("888888")){
                account="";
            }
            express.setAccount(account);
            express.setFinaltime(express.getFinaltime() + " 23:59:59");
            dg.setTotal(expressService.getExpCount(express));
            List<Express> expressList = expressService.getExpsList(express);
            dg.setRows(expressList);
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
    @RequestMapping(value = "/express/datagriduser", method = RequestMethod.POST)
    public DataGrid datagriduser(Expuser expuser ,HttpServletRequest request) {
        DataGrid dg = new DataGrid();
        try {
            expuser.setExpuserid(expuser.getUserid());
            expuser.setExpusername(expuser.getUsername());
            dg.setTotal(expressService.getExpuserCount(expuser));
            List<Expuser> expuserList = expressService.getExpuserList(expuser);
            dg.setRows(expuserList);
        }catch (Exception e){
            e.printStackTrace();
        }
        return dg;
    }

    /**
     * 物流组表格
     * @return DataGrid
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/express/datagridgroup", method = RequestMethod.POST)
    public DataGrid datagridgroup(Expuser expuser ,HttpServletRequest request) {
        DataGrid dg = new DataGrid();
        try {
            if(expuser.getTj() !=null && !expuser.getTj().equals("")){
                log.info("tj===="+expuser.getTj());
                expuser.setTeamid(Integer.parseInt((expuser.getTj())));
            }
            dg.setTotal(expressService.getExpgroupCount(expuser));
            List<Expuser> expgroupList = expressService.getExpgroupList(expuser);
            dg.setRows(expgroupList);
        }catch (Exception e){
            e.printStackTrace();
        }
        return dg;
    }

    /**
     * 新增物流组
     * @return Json
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/express/addExpGroup", method = RequestMethod.POST)
    public Json addExpGroup(Expuser expuser,HttpServletRequest request) {
        Json j = new Json();
        int ret = 0;
        SimpleDateFormat sm = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        expuser.setInserttime(sm.format(new Date()));
        try {
            if (expuser.getId() == 0) {
                ret = expressService.isExistGroup(expuser);
                if (ret > 0) {
                    j.setSuccess(false);
                    j.setMsg("此物流组已存在！");
                } else {
                    int flag = expressService.addExpGroup(expuser);
                    if(flag==0){
                        j.setSuccess(true);
                        j.setMsg("新增物流组成功！");
                    }else {
                        j.setSuccess(false);
                        j.setMsg("新增物流组失败！");
                    }
                }
            } else {
                ret = expressService.isExistTeamname(expuser);
                if (ret > 0) {
                    j.setSuccess(false);
                    j.setMsg("物流组名称已经存在，请重新输入！");
                }else{
                    int flag=expressService.editExpGroup(expuser);
                    if(flag==0){
                        j.setSuccess(true);
                        j.setMsg("修改物流组成功！");
                    }else {
                        j.setSuccess(false);
                        j.setMsg("修改物流组失败！");
                    }
                }
            }
            j.setObj(expuser);
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }

    /**
     * 删除物流组
     * @return Json
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/express/delTeam", method = RequestMethod.POST)
    public Json delTeam(Expuser expuser,HttpServletRequest request) {
        Json j = new Json();
        try {
            int flag = expressService.delExpGroup(expuser.getId());
            if(flag==0){
                j.setSuccess(true);
                j.setMsg("删除物流组成功！");
            }else {
                j.setSuccess(false);
                j.setMsg("删除物流组失败！");
            }
            j.setObj(expuser);
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }

    /**
     * 获取物流组
     * @return Json
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/express/getExpTeam", method = RequestMethod.POST)
    public JSONObject getExpTeam(Expuser expuser) {
        Map<String, Object> map = new HashMap<String, Object>();
        try {
            List<Expuser> list = expressService.getExpTeamList();
            if(list.size()>0){
                Json j = new Json();
                map.put("rows", list);
                map.put("total", list.size());
                j.setObj(JSONObject.fromObject(map));
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return JSONObject.fromObject(map);
    }

    /**
     * 新增派送员
     * @return Json
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/express/addExpUser", method = RequestMethod.POST)
    public Json addExpUser(Expuser expuser,HttpServletRequest request) {
        Json j = new Json();
        SimpleDateFormat sm = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        expuser.setInserttime(sm.format(new Date()));
        try {
            if (expuser.getId() == 0) {
                int flag = expressService.addExpUser(expuser);
                if(flag==0){
                    j.setSuccess(true);
                    j.setMsg("新增派送员成功！");
                }else {
                    j.setSuccess(false);
                    j.setMsg("新增派送员失败！");
                }
            } else {
                int flag=expressService.editExpUser(expuser);
                if(flag==0){
                    j.setSuccess(true);
                    j.setMsg("修改派送员成功！");
                }else {
                    j.setSuccess(false);
                    j.setMsg("修改派送员失败！");
                }
            }
            j.setObj(expuser);
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }

    //删除派送员
    @ResponseBody
    @RequestMapping(value = "/express/delExpuser", method = RequestMethod.POST)
    public Json delExpuser(Expuser expuser,HttpServletRequest request) {
        Json j = new Json();
        try {
            int flag = expressService.delExpuser(expuser.getId());
            if(flag==0){
                j.setSuccess(true);
                j.setMsg("删除派送员成功！");
            }else {
                j.setSuccess(false);
                j.setMsg("删除派送员失败！");
            }
            j.setObj(expuser);
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }

    //confirmFinalExp 确认完成配送
    @ResponseBody
    @RequestMapping(value = "/express/confirmFinalExp", method = RequestMethod.POST)
    public Json confirmFinalExp(Expuser expuser) {
        Json j = new Json();
        try {
            String [] arr = expuser.getTj().split(",");
            int id = Integer.parseInt(arr[0]);
            String orderid = arr[1].trim();
            String goodsid = arr[2].trim();
            int flag = expressService.confirmFinalExp(id);
            if(flag==0){
                orderService.updateOrderzt(orderid,goodsid);
                j.setSuccess(true);
                j.setMsg("订单配送完成确认成功！");
            }else {
                j.setSuccess(false);
                j.setMsg("订单配送完成确认失败！");
            }
            j.setObj(expuser);
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }

    /**
     * 查询分配快递员
     * @return DataGrid
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/express/selectexpuser", method = RequestMethod.POST)
    public JSONArray selectexpuser(Expuser expuser) {
        List<Expuser> expTeamList = expressService.getExpTeamList();
        List<Expuser> expuserList = expressService.getExpuserList(expuser);
        JSONArray arr = new JSONArray();
        if(expTeamList.size() > 0){
            for(Expuser exp:expTeamList){
                JSONObject json = new JSONObject();
                JSONArray array = new JSONArray();
                for(Expuser e:expuserList){
                    if(exp.getTeamid()==e.getTeamid()){
                        JSONObject json1 = new JSONObject();
                        json1.put("id",e.getExpuserid());
                        json1.put("name",e.getExpusername());
                        array.add(json1);
                    }
                }
                json.put("id",exp.getTeamid());
                json.put("name",exp.getTeamname());
                json.put("children",array);
                arr.add(json);
            }
        }
        return arr;
    }

    //confirmFinalExp 确认完成配送
    @ResponseBody
    @RequestMapping(value = "/express/dealfpexpuser", method = RequestMethod.POST)
    public Json dealfpexpuser(String ids, String id) {
        Json j = new Json();
        try {
            log.info(ids+"=========="+id);
           int flag = 0;
            if(flag==0){
                j.setSuccess(true);
                j.setMsg("快递员分配成功！");
            }else {
                j.setSuccess(false);
                j.setMsg("快递员分配失败！");
            }
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }
}
