/**
 *
 */
package com.polaris.service;


import com.polaris.entity.Express;

import java.util.List;

public interface IExpressService {

    public void addExpinfo(Express express);

    public Long getExpCount(Express express);

    public List<Express> getExpsList(Express express);
}
