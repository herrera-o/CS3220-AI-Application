package dev.cs3220project1.cs3220aiapplication.controller;

import dev.cs3220project1.cs3220aiapplication.model.User;
import dev.cs3220project1.cs3220aiapplication.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@Controller
public class HomeController {

    private final UserRepository userRepository;

    public HomeController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping("/login")
    public String loginForm() {
        return "login";
    }

    @PostMapping("/login")
    public String loginSubmit(@RequestParam String email,
                              @RequestParam String password,
                              HttpSession session,
                              Model model) {
        Optional<User> userOpt = userRepository.findByEmail(email);

        if (userOpt.isPresent() && userOpt.get().getPassword().equals(password)) {
            session.setAttribute("userId", userOpt.get().getId());
            session.setAttribute("username", userOpt.get().getFirstName());
            return "redirect:/meals"; // works with your MealController
        } else {
            model.addAttribute("error", "Invalid email or password.");
            return "login";
        }
    }

    @GetMapping("/register")
    public String showRegister() {
        return "register";
    }

    @PostMapping("/register")
    public String handleRegister(@RequestParam String firstName,
                                 @RequestParam String lastName,
                                 @RequestParam String email,
                                 @RequestParam String password,
                                 @RequestParam String confirmPassword,
                                 HttpSession session,
                                 Model model) {
        if (!password.equals(confirmPassword)) {
            model.addAttribute("error", "Passwords do not match.");
            return "register";
        }

        if (userRepository.existsByEmail(email)) {
            model.addAttribute("error", "Email already registered.");
            return "register";
        }

        User user = new User(firstName.trim(), lastName.trim(), email.trim(), password);
        userRepository.save(user);

        session.setAttribute("userId", user.getId());
        session.setAttribute("username", user.getFirstName());

        return "redirect:/meals";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
