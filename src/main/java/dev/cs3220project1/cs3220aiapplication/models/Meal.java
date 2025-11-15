package dev.cs3220project1.cs3220aiapplication.models;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.*;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

public record Meal(
        @JsonProperty("id") UUID id,
        @JsonProperty("username") String username,
        @NotBlank String name,
        MealType type,
        @NotNull @Size(min = 1) List<Ingredient> ingredients,
        @NotNull @Size(min = 1) List<Step> instructions,
        @Positive Integer calories,
        Nutrition nutrition,
        Instant createdAt
) {

    public Meal {
        if (id == null) {

            id = UUID.randomUUID();
        }
        if (createdAt == null) {
            createdAt = Instant.now();
        }
        if (ingredients == null) {
            ingredients = List.<Ingredient>of();
        }
        if (instructions == null) {
            instructions = List.<Step>of();
        }
    }


    public Meal(UUID id,
                String name,
                String ingredientsText,
                String instructionsText,
                String username,
                int servings,
                int calories) {
        this(
                id,
                username,
                name,
                null, // type
                List.<Ingredient>of(),
                List.<Step>of(),
                Integer.valueOf(calories),
                null,
                Instant.now()
        );
    }
}
