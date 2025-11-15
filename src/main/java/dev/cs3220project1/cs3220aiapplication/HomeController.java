package dev.cs3220project1.cs3220aiapplication;

import dev.cs3220project1.cs3220aiapplication.User;
import dev.cs3220project1.cs3220aiapplication.UserRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import jakarta.servlet.http.HttpSession;

import java.time.Year;
import java.util.Optional;
import java.util.UUID;

@Controller
public class HomeController {

    private final UserRepository userRepository;

    public HomeController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    private void populateCommon(Model model, HttpSession session) {
        boolean isLoggedIn = session != null && session.getAttribute("username") != null;
        model.addAttribute("isLoggedIn", isLoggedIn);
        model.addAttribute("username", isLoggedIn ? session.getAttribute("username") : "");
        model.addAttribute("year", Year.now().getValue());
    }

    @GetMapping("/")
    public String index(Model model, HttpSession session) {
        populateCommon(model, session);
        return "index";
    }


    @GetMapping("/login")
    public String loginForm(Model model, HttpSession session) {
        populateCommon(model, session);
        if (!model.containsAttribute("error")) {
            model.addAttribute("error", "");
        }
        return "login";
    }

    @PostMapping("/login")
    public String loginSubmit(@RequestParam String email,
                              @RequestParam String password,
                              Model model,
                              HttpSession session) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isPresent() && userOpt.get().getPassword().equals(password)) {
            User user = userOpt.get();
            session.setAttribute("username", user.getFirstName() != null ? user.getFirstName() : user.getEmail());
            populateCommon(model, session);
            return "redirect:/";
        } else {
            populateCommon(model, session);
            model.addAttribute("error", "Invalid email or password.");
            return "login";
        }
    }

    // --- Register ---
    @GetMapping("/register")
    public String showRegister(Model model, HttpSession session) {
        populateCommon(model, session);
        if (!model.containsAttribute("error")) {
            model.addAttribute("error", "");
        }
        if (!model.containsAttribute("success")) {
            model.addAttribute("success", "");
        }
        return "register";
    }

    @PostMapping("/register")
    public String handleRegister(
            @RequestParam String firstName,
            @RequestParam String lastName,
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam String confirmPassword,
            Model model,
            RedirectAttributes redirectAttributes,
            HttpSession session
    ) {
        populateCommon(model, session);

        if (firstName == null || firstName.isBlank()
                || lastName == null || lastName.isBlank()
                || email == null || email.isBlank()
                || password == null || password.isBlank()) {
            model.addAttribute("error", "All fields are required.");
            return "register";
        }

        if (!password.equals(confirmPassword)) {
            model.addAttribute("error", "Passwords do not match.");
            return "register";
        }

        if (userRepository.existsByEmail(email)) {
            model.addAttribute("error", "Email already registered.");
            return "register";
        }

        User user = new User(UUID.randomUUID().toString(), firstName.trim(), lastName.trim(), email.trim(), password);
        userRepository.save(user);

        redirectAttributes.addFlashAttribute("success", "Account created successfully. You can log in now.");
        return "redirect:/";
    }


    @GetMapping("/logout")
    public String logout(HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
        return "redirect:/";
    }

    @GetMapping("/assistant/form")
    public String assistantForm(Model model, HttpSession session) {
        populateCommon(model, session);
        return "assistant";
    }

    // java
    @GetMapping("/assistant")
    public String assistantRedirect() {

        return "redirect:/assistant/form";
    }



}
