package per.zpp.settings.Interceptor;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import per.zpp.commons.constants.SystemConstant;
import per.zpp.settings.domain.User;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginInterceptor extends HandlerInterceptorAdapter {
    @Override
    public boolean preHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o) throws Exception {
        HttpSession session = httpServletRequest.getSession();
        User user = (User) session.getAttribute(SystemConstant.SESSION_USER);
        System.out.println(user);
        if (user == null) {
            httpServletResponse.sendRedirect(httpServletRequest.getContextPath() );
            return false;
        }
        return true;
    }
}
