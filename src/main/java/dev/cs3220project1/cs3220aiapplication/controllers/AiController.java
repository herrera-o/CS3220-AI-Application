package dev.cs3220project1.cs3220aiapplication.controllers;

import dev.cs3220project1.cs3220aiapplication.DataStore;
import dev.cs3220project1.cs3220aiapplication.models.Ingredient;
import dev.cs3220project1.cs3220aiapplication.models.Meal;
import dev.cs3220project1.cs3220aiapplication.models.Step;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

@Controller
public class AiController {

    private final DataStore dataStore;

    public AiController(DataStore dataStore) {
        this.dataStore = dataStore;
    }

    @PostMapping("/ai")
    public String generateRecipe(
            @RequestParam(required = false) String mealType,
            @RequestParam(required = false) Integer servings,
            @RequestParam(required = false, name = "pref") String[] prefs,
            @RequestParam(required = false) Integer calories,
            @RequestParam(required = false) String note,
            HttpSession session,
            RedirectAttributes redirectAttributes,
            Model model
    ) {
        Object userAttr = session != null ? session.getAttribute("user") : null;
        if (userAttr == null && session != null) {
            userAttr = session.getAttribute("username");
        }
        if (userAttr == null) {
            redirectAttributes.addFlashAttribute("message", "Please log in to generate a recipe.");
            return "redirect:/login";
        }
        String username = userAttr.toString();

        String title = (mealType == null || mealType.isBlank()) ? "AI Generated Meal" : mealType + " (AI)";
        int finalServings = Objects.requireNonNullElse(servings, 1);
        int finalCalories = Objects.requireNonNullElse(calories, 0);
        String prefsText = (prefs == null) ? "" : String.join(", ", prefs);

        String ingredientsText = prefsText.isEmpty() ? "salt\npepper\nolive oil\nprotein of choice" : prefsText;
        if (note != null && !note.isBlank()) {
            ingredientsText += "\nNote: " + note;
        }
        String instructionsText = "1. Combine ingredients.\n2. Cook until done.\n3. Serve.";


        List<Ingredient> ingredientsList = Arrays.stream(ingredientsText.split("[\\r\\n,;]+"))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .map(item -> new Ingredient(
                        item,
                        BigDecimal.ONE,
                        null,
                        "AI-generated"
                ))
                .collect(Collectors.toList());

        AtomicInteger stepCounter = new AtomicInteger(1);
        List<Step> stepsList = Arrays.stream(instructionsText.split("[\\r\\n]+"))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .map(s -> new Step(stepCounter.getAndIncrement(), s)) // supply the second argument expected by Step
                .collect(Collectors.toList());

        Meal generated = new Meal(
                UUID.randomUUID(),               // id
                username,                        // username (owner)
                title,                           // name/title
                null,                            // MealType (unknown)
                ingredientsList,                 // structured ingredients
                stepsList,                       // structured instructions
                Integer.valueOf(finalCalories),  // calories
                null,                            // Nutrition (none)
                Instant.now()                    // createdAt
        );


        try {
            dataStore.getClass().getMethod("addMeal", Meal.class).invoke(dataStore, generated);
        } catch (ReflectiveOperationException e) {
            dataStore.getMeals().add(generated);
        }

        session.setAttribute("user", username);
        session.setAttribute("username", username);
        session.setAttribute("lastAiRequest", title);

        return "redirect:/meals/" + generated.id();
    }
}
