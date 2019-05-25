package com.base.common.utils;

import com.base.entity.po.UserEntity;
import org.apache.shiro.SecurityUtils;

/**
 * 获取登录用户信息
 * @author zhangwei
 * @date 2019/4/17 15:01
 */
public class AuthUserToken {

    public static UserEntity getUser(){
        return (UserEntity)SecurityUtils.getSubject().getPrincipal();
    }

}