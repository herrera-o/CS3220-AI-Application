@import dev.cs3220project1.cs3220aiapplication.models.Meal
@import java.time.ZoneId
@import java.time.format.DateTimeFormatter
@param Meal meal
@param String username

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${meal.name()}</title>
</head>
<body>
<h1>${meal.name()}</h1>

<p><strong>Owner:</strong> ${username}</p>
<p><strong>Type:</strong> ${meal.type()}</p>

!{
    DateTimeFormatter formatter =
        DateTimeFormatter.ofPattern("MMM dd, yyyy h:mm a")
                         .withZone(ZoneId.systemDefault());
}

<p><strong>Created at:</strong> ${formatter.format(meal.createdAt())}</p>
<p><strong>Calories per serving:</strong> ${meal.calories()}</p>

<h2>Ingredients</h2>
<ul>
    @for (var ingredient : meal.ingredients())>
        <li>${ingredient.quantity()} ${ingredient.unit()} ${ingredient.item()} - ${ingredient.notes()}</li>
    @endfor
</ul>

<h2>Instructions</h2>
<ol>
    @for (var step : meal.instructions())>
        <li>${step.text()}</li>
    @endfor>
</ol>

<h2>Nutrition</h2>
@if(meal.nutrition() != null)
    !{var n = meal.nutrition();}


    <div class="mt-2">
        <strong>Nutrition (per serving)</strong>
        <div class="small">
            @if(n.proteinGrams() != null) Protein ${n.proteinGrams()}g · @endif
            @if(n.carbsGrams()   != null) Carbs ${n.carbsGrams()}g ·   @endif
            @if(n.fatGrams()     != null) Fat ${n.fatGrams()}g ·       @endif
            @if(n.fiberGrams()   != null) Fiber ${n.fiberGrams()}g ·   @endif
            @if(n.sodiumMg()     != null) Sodium ${n.sodiumMg()}mg     @endif
        </div>
    </div>
@endif

<p>
    <a href="/meals">Back to my meals</a> |
    <a href="/assistant">Generate another</a> |
    <a href="/">Home</a>
</p>

</body>
</html>
