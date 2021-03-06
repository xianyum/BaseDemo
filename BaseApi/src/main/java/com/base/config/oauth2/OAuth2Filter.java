package com.base.config.oauth2;

import com.alibaba.fastjson.JSON;
import com.base.common.utils.DataResult;
import com.base.common.utils.HttpContextUtils;
import com.base.common.utils.StringUtil;
import org.apache.http.HttpStatus;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.web.filter.authc.AuthenticatingFilter;
import org.springframework.web.bind.annotation.RequestMethod;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * oauth2过滤器
 *
 */
public class OAuth2Filter extends AuthenticatingFilter {

    @Override
    protected AuthenticationToken createToken(ServletRequest request, ServletResponse response) throws Exception {
        //获取请求token
        String token = HttpContextUtils.getRequestToken((HttpServletRequest) request);
        if(StringUtil.isBlank(token)){
            return null;
        }

        return new OAuth2Token(token);
    }

    @Override
    protected boolean isAccessAllowed(ServletRequest request, ServletResponse response, Object mappedValue) {
        if(((HttpServletRequest) request).getMethod().equals(RequestMethod.OPTIONS.name())){
            return true;
        }
            return false;
        }

        @Override
        protected boolean onAccessDenied(ServletRequest request, ServletResponse response) throws Exception {
            //获取请求token，如果token不存在，直接返回401
            String token = HttpContextUtils.getRequestToken((HttpServletRequest) request);
            if(StringUtil.isBlank(token)){
                HttpServletResponse httpResponse = (HttpServletResponse) response;
                httpResponse.setHeader("Access-Control-Allow-Credentials", "true");
                httpResponse.setHeader("Access-Control-Allow-Origin", HttpContextUtils.getOrigin());
                String json = JSON.toJSONString(DataResult.error(HttpStatus.SC_UNAUTHORIZED, "token不存在"));
                httpResponse.setHeader("Content-type", "text/html;charset=UTF-8");//解决返回json中文乱码问题
                httpResponse.setCharacterEncoding("utf-8");
                httpResponse.getWriter().print(json);
                return false;
        }

        return executeLogin(request, response);
    }

    @Override
    protected boolean onLoginFailure(AuthenticationToken token, AuthenticationException e, ServletRequest request, ServletResponse response) {
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        httpResponse.setContentType("application/json;charset=utf-8");
        httpResponse.setHeader("Access-Control-Allow-Credentials", "true");
        httpResponse.setHeader("Access-Control-Allow-Origin", HttpContextUtils.getOrigin());
        try {
            //处理登录失败的异常
            Throwable throwable = e.getCause() == null ? e : e.getCause();
            DataResult result = DataResult.error(HttpStatus.SC_UNAUTHORIZED, throwable.getMessage());
            String json = JSON.toJSONString(result);
            httpResponse.setHeader("Content-type", "text/html;charset=UTF-8");//解决返回json中文乱码问题
            httpResponse.setCharacterEncoding("utf-8");
            httpResponse.getWriter().print(json);
        } catch (IOException e1) {

        }
        return false;
    }
}
