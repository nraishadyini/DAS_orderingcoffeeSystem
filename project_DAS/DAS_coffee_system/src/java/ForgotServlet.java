import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class ForgotServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");

        // Dummy response
        System.out.println("Password recovery for: " + username + "in email!");

        response.getWriter().println("Password reset link sent!");
    }
}