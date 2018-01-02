package com.polaris.controller;

import com.polaris.entity.Goods;
import com.polaris.entity.User;
import com.polaris.service.IGoodsService;
import com.polaris.service.IUserService;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 项目名称：polaris
 * 类名称：Aa01Controller
 * 类描述：库存管理
 * 创建人：武金龙
 * 创建时间：2015年11月7日 上午11:07:22
 * 修改人：武金龙
 * 修改时间：2015年11月7日 上午11:07:22
 * 修改备注：
 */
@Controller
public class GoodsController {

    private final Logger log = LoggerFactory.getLogger(GoodsController.class);

    @Resource
    private IGoodsService goodsService;

    @Resource
    private IUserService userService;

    /**
     * 跳转到用户表格页面
     * @param model
     * @return String
     * @Exception
     */
    @RequestMapping(value = "/goods/list", method = RequestMethod.GET)
    public String GoodsList(Model model, String menu_button) {
        return "goods/list";
    }

    @RequestMapping(value = "/goods/addlist", method = RequestMethod.GET)
    public String GoodsaddList(Model model, String menu_button) {
        return "goods/addlist";
    }

    @RequestMapping(value = "/goods/detaillist", method = RequestMethod.GET)
    public String GoodsdetailList(Model model, String menu_button) {
        return "goods/detaillist";
    }

    @RequestMapping(value = "/goods/confirmgoods", method = RequestMethod.GET)
    public String confirmgoods(Model model, String menu_button) {
        return "goods/confirmgoods";
    }

    /**
     * 用户表格
     * @return DataGrid
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/goods/datagrid", method = RequestMethod.POST)
    public DataGrid datagrid(Goods goods ,HttpServletRequest request) {
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
            goods.setAccount(account);
            if ((goods.getFinaltime() != null) && (goods.getFinaltime() != "")
                    && (10 == goods.getFinaltime().length())) {
                goods.setFinaltime(goods.getFinaltime() + " 23:59:59");
            }
            dg.setTotal(goodsService.getGoodsCount(goods));
            List<Goods> goodlist = goodsService.getGoodsList(goods);
            dg.setRows(goodlist);
        }catch (Exception e){
            e.printStackTrace();
        }
        return dg;
    }

    @ResponseBody
    @RequestMapping(value = "/goods/getgoodstype", method = RequestMethod.POST)
    public JSONObject getgoodstype(Goods goods,HttpServletRequest request) {
        Map<String, Object> map = new HashMap<String, Object>();
        try {
            String gtype = goods.getGtype();
            List<Goods> list = goodsService.getgoodstypeList(gtype);
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
     * 新增库存
     * @return Json
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/goods/addGoods", method = RequestMethod.POST)
    public Json addGoods(Goods goods,HttpServletRequest request) {
        Json j = new Json();
        try {
            String rq = StringUtil.getrq();
            if (goods.getId() == 0) {
                goods.setInserttime(rq);
                goods.setGoodsid(StringUtil.getgoodsId(goods.getGtype(),goods.getGroupid()));
                int flag = goodsService.addGoods(goods);
                if(flag==0){
                    j.setSuccess(true);
                    j.setMsg("新增库存成功！");
                }else {
                    j.setSuccess(false);
                    j.setMsg("新增库存失败！");
                }
            } else {
                log.info(goods.toString());
                int flag= goodsService.editGoods(goods);
                if(flag==0){
                    j.setSuccess(true);
                    j.setMsg("修改库存成功！");
                }else {
                    j.setSuccess(false);
                    j.setMsg("修改库存失败！");
                }
            }
            j.setObj(goods);
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }

    @ResponseBody
    @RequestMapping(value = "/goods/getgoodsname", method = RequestMethod.POST)
    public JSONObject getgoodsname(Goods goods,HttpServletRequest request) {
        Map<String, Object> map = new HashMap<String, Object>();
        try {
            List<Goods> list = goodsService.getgoodsname(goods);
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


    @ResponseBody
    @RequestMapping(value = "/goods/getgoodsnameByld", method = RequestMethod.POST)
    public JSONArray getgoodsnameByld(Goods goods,HttpServletRequest request,String groupid,String goodsid) {
        JSONArray array = new JSONArray();
        JSONObject json = new JSONObject();
        try {
            List<Goods> list = goodsService.getgoodsname(goods);
            if(list.size()>0){
                for(Goods g:list){
                    json.put("goodsid",g.getGoodsid());
                    json.put("goodsname",g.getGoodsname());
                    json.put("price",g.getPrice());
                    json.put("count",g.getCount());
                    array.add(json);
                }
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return array;
    }

    /**
     * 删除商品
     * @return Json
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/goods/delgoods", method = RequestMethod.POST)
    public Json delgoods(Goods goods,HttpServletRequest request) {
        Json j = new Json();
        try {
            long id = goods.getId();
            int flag= goodsService.delGoods(id);
            if(flag==0){
                j.setSuccess(true);
                j.setMsg("删除库存商品成功！");
            }else {
                j.setSuccess(false);
                j.setMsg("删除库存商品失败！");
            }
            j.setObj(goods);
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }

}
