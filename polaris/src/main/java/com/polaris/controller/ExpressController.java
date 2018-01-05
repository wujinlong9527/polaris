package com.polaris.controller;

import com.polaris.entity.Express;
import com.polaris.entity.User;
import com.polaris.service.IExpressService;
import com.polaris.service.IUserService;
import com.polaris.tool.easyui.DataGrid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;

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
}
