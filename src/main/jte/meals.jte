@import dev.cs3220project1.cs3220aiapplication.models.Meal
@import java.time.ZoneId
@import java.time.format.DateTimeFormatter
@param java.util.List<Meal> meals
@param String username

!{
    DateTimeFormatter formatter =
        DateTimeFormatter.ofPattern("MMM dd, yyyy h:mm a")
                         .withZone(ZoneId.systemDefault());
}

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${username}'s Generated Meals</title>
</head>
<body>
<h1>Generated Meals for ${username}</h1>

<p><a href="/assistant">Generate a new meal</a></p>

@if (meals.isEmpty())
    <p>You have no generated meals yet.</p>
@endif

@if (!meals.isEmpty())
    <table border="1" cellpadding="6">
        <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Created At</th>
            <th>View</th>
        </tr>
        </thead>
        <tbody>
        @for (Meal meal : meals)
            <tr>
                <td>${meal.name()}</td>
                <td>${meal.type()}</td>
                <td>${formatter.format(meal.createdAt())}</td>
                <td><a href="/meals/${meal.id().toString()}">View</a></td>
            </tr>
        @endfor
        </tbody>
    </table>
@endif

<p><a href="/">Home</a></p>

</body>
</html>
