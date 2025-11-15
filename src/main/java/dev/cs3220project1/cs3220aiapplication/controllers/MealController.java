package dev.cs3220project1.cs3220aiapplication.controllers;

import dev.cs3220project1.cs3220aiapplication.DataStore;
import dev.cs3220project1.cs3220aiapplication.models.Meal;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;

@Controller
public class MealController {

    private final DataStore dataStore;

    public MealController(DataStore dataStore) {
        this.dataStore = dataStore;
    }

    @GetMapping("/meals")
    public String listMeals(HttpSession session, Model model) {
        Object userAttr = session != null ? session.getAttribute("user") : null;
        if (userAttr == null && session != null) {
            userAttr = session.getAttribute("username");
        }
        if (userAttr == null) {
            return "redirect:/login";
        }
        String username = userAttr.toString();

        List<Meal> myMeals = dataStore.getMeals().stream()
                .filter(m -> Objects.equals(m.username(), username))
                .toList();

        model.addAttribute("meals", myMeals);
        model.addAttribute("username", username);

        return "meals";
    }

    @GetMapping("/meals/{id}")
    public String viewMeal(
            @PathVariable("id") UUID id,
            HttpSession session,
            Model model
    ) {
        Object userAttr = session != null ? session.getAttribute("user") : null;
        if (userAttr == null && session != null) {
            userAttr = session.getAttribute("username");
        }
        if (userAttr == null) {
            return "redirect:/login";
        }
        String username = userAttr.toString();

        Optional<Meal> mealOpt = dataStore.getMeals().stream()
                .filter(m -> m.id().equals(id) && Objects.equals(m.username(), username))
                .findFirst();

        if (mealOpt.isEmpty()) {
            model.addAttribute("message", "Meal not found or you do not have access.");
            return "error";
        }

        model.addAttribute("meal", mealOpt.get());
        model.addAttribute("username", username);

        return "meal";
    }

    @GetMapping("/meal")
    public String mealRedirect() {
        return "redirect:/meals";
    }

    @GetMapping("/meal-list")
    public String mealListRedirect() {
        return "redirect:/meals";
    }

    @GetMapping("/ai/meals")
    public String aiMealsRedirect() {
        return "redirect:/meals";
    }
}
