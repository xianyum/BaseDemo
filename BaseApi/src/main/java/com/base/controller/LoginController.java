package com.base.controller;

import com.alibaba.fastjson.JSON;
import com.anji.captcha.model.common.ResponseModel;
import com.anji.captcha.model.vo.CaptchaVO;
import com.base.common.annotation.SysLog;
import com.base.common.async.AsyncManager;
import com.base.common.async.factory.AsyncLogFactory;
import com.base.common.exception.SoException;
import com.base.common.utils.*;
import com.base.common.validator.ValidatorUtils;
import com.base.entity.enums.UserStatusEnum;
import com.base.entity.po.LogEntity;
import com.base.entity.po.UserEntity;
import com.base.entity.request.UserRequest;
import com.base.service.iservice.CaptchaService;
import com.base.service.iservice.UserService;
import com.base.service.iservice.UserTokenService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.apache.commons.io.IOUtils;
import org.apache.shiro.crypto.hash.Sha256Hash;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Date;

/**
 * 登录相关
 * @author zhangwei
 * @date 2019/5/25 20:12
 * @email 80616059@qq.com
 */
@RestController
@Api(tags = "登录接口")
public class LoginController {

    @Autowired
    private CaptchaService captchaService;

    @Autowired
    private UserService userService;

    @Autowired
    private UserTokenService userTokenService;

    @Autowired
    private com.anji.captcha.service.CaptchaService captchaService1;

    /**
     * 验证码
     * 设置produces = MediaType.IMAGE_JPEG_VALUE（）import org.springframework.http.MediaType;
     * 可以在swagger打开，但是不输入uuid返回不了错误
     */
    @GetMapping(value = "captcha.jpg" ,produces = MediaType.IMAGE_JPEG_VALUE)
    @ApiOperation(value = "获取验证码", httpMethod = "GET", notes = "获取验证码")
    public void captcha(HttpServletResponse response, String uuid)throws ServletException, IOException {
        response.setHeader("Cache-Control", "no-store, no-cache");
        response.setContentType("image/jpeg");
        //获取图片验证码
        BufferedImage image = captchaService.getCaptcha(uuid);
        ServletOutputStream out = response.getOutputStream();
        ImageIO.write(image, "jpg", out);
        IOUtils.closeQuietly(out);
    }

    /**
     * 登录
     * @param userRequest
     * @return
     */
    @PostMapping("/login")
    @ApiOperation(value = "登录系统", httpMethod = "POST")
    public DataResult login(@RequestBody UserRequest userRequest) {
        long beginTime = System.currentTimeMillis();
        try {
            CaptchaVO captchaVO = new CaptchaVO();
            captchaVO.setCaptchaVerification(userRequest.getCaptchaVerification());
            ResponseModel response = captchaService1.verification(captchaVO);
            if(response.isSuccess() == false){
                long time = System.currentTimeMillis() - beginTime;
                saveLoginLog(userRequest,"验证码不正确",time);
                return DataResult.error("验证码不正确");
            }
//            boolean captcha = captchaService.validate(userRequest.getUuid(), userRequest.getCaptcha());
//            if(!captcha){
//                long time = System.currentTimeMillis() - beginTime;
//                saveLoginLog(userRequest,"验证码不正确",time);
//                return DataResult.error("验证码不正确");
//            }
            //用户信息
            UserEntity user = userService.queryByUserName(userRequest.getUsername());
            //账号不存在、密码错误
            if(user == null || !user.getPassword().equals(new Sha256Hash(userRequest.getPassword(), user.getSalt()).toHex())) {
                long time = System.currentTimeMillis() - beginTime;
                saveLoginLog(userRequest,"账号或密码不正确",time);
                return DataResult.error("账号或密码不正确");
            }
            //账号锁定
            if(user.getStatus() == UserStatusEnum.BAN.getStatus()){
                long time = System.currentTimeMillis() - beginTime;
                saveLoginLog(userRequest,"账号被锁定",time);
                return DataResult.error("账号已被锁定,请联系管理员");
            }

            //生成token，并保存到数据库
            DataResult result = userTokenService.createToken(user);
            long time = System.currentTimeMillis() - beginTime;
            saveLoginLog(userRequest,"登录成功",time);
            return result;
        }catch (SoException e){
            throw new SoException("系统异常");
        }
    }

    /**
     * 退出
     */
    @PostMapping("/logout")
    @SysLog(value = "注销")
    @ApiOperation(value = "注销用户", httpMethod = "POST")
    public DataResult logout() {
        userTokenService.logout();
        return DataResult.success();
    }

    /**
     * 获取手机验证码
     */
    @PostMapping("/getPhoneCode")
    @ApiOperation(value = "获取手机验证码", httpMethod = "POST")
    public DataResult getPhoneCode(@RequestBody UserRequest request) {
        //captchaService.getPhoneCaptcha(request);
        return DataResult.error("短信接口停用，无法发送短信！");
    }

    /**
     * 注册
     */
    @PostMapping("/register")
    @ApiOperation(value = "注册用户", httpMethod = "POST")
    public DataResult register(@RequestBody UserRequest request) {
        ValidatorUtils.validateEntity(request);
        long beginTime = System.currentTimeMillis();
        boolean captcha = captchaService.validate(request.getUuid(), request.getCaptcha());
        if(!captcha){
            return DataResult.error("验证码不正确");
        }
        Integer count = userService.save(request);
        if(count >0){
            long time = System.currentTimeMillis() - beginTime;
            saveLoginLog(request,"注册成功",time);
            return DataResult.success();
        }
        long time = System.currentTimeMillis() - beginTime;
        saveLoginLog(request,"注册失败",time);
        return DataResult.error("注册失败");
    }

    /**
     * 获取登录/注册信息
     */
    public void saveLoginLog(UserRequest userRequest,String desc,Long time){
        LogEntity log = new LogEntity();
        log.setId(UUIDUtils.UUIDReplace());
        HttpServletRequest httpServletRequest = HttpContextUtils.getHttpServletRequest();
        String ip = IPUtils.getIpAddr(httpServletRequest);
        log.setIp(ip);
        log.setIpInfo(IPUtils.getIpInfo(ip));
        log.setCreateTime(new Date());
        log.setMethod("login");
        userRequest.setPassword("");
        log.setParams(JSON.toJSONString(userRequest));
        log.setUsername(userRequest.getUsername());
        log.setOperation(desc);
        log.setTime(time);
        AsyncManager.async().execute(AsyncLogFactory.save(log));
    }
}
