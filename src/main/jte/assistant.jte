@import java.util.*
@import dev.cs3220project1.cs3220aiapplication.models.*
@import dev.cs3220project1.cs3220aiapplication.util.JsonHelper

@param Meal meal
@param String status

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>AI Meal Assistant</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="css/styles1.css" />
    <link rel="stylesheet" href="css/styles2.css" />
    <style>
        .section-card { background:#fff;border:1px solid rgba(16,24,40,.08);border-radius:16px;box-shadow:0 8px 16px rgba(16,24,40,.06); }
        .breathe{ padding:1rem 1.25rem; }
        .recipe-meta{ color:#6b7280; }
        .badge-chip{ background:rgba(124,58,237,.12);border:1px solid rgba(124,58,237,.28);color:#4a246f; }
        .mono{ font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono","Courier New", monospace; }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">
<nav class="navbar navbar-expand-lg navbar-dark header-bg">
    <div class="container">
        <a class="navbar-brand fw-bold text-white" href="/index.html">MealPlanner</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navAI">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div id="navAI" class="collapse navbar-collapse justify-content-end">
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link text-white active" href="/ai">AI Assistant</a></li>
                <li class="nav-item"><a class="nav-link text-white" href="/meal-list.html">My Meals</a></li>
                <li class="nav-item"><a class="nav-link text-white" href="/about-us.html">About Us</a></li>
            </ul>
        </div>
    </div>
</nav>

<main class="flex-fill py-4">
    <div class="container">
        <div class="row g-4">
            <div class="col-lg-8">
                <h2 class="mb-3">AI Meal Assistant</h2>

                <!-- Form card -->
                <div class="section-card breathe mb-3">
                    <form method="post" action="/ai" class="row g-3">
                        <div class="col-md-6">
                            <label class="fw-semibold">Meal Type</label>
                            <select class="form-select" name="mealType">
                                <option value="">Let AI choose</option>
                                <option>BREAKFAST</option>
                                <option>LUNCH</option>
                                <option>DINNER</option>
                                <option>SNACK</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="fw-semibold">Servings</label>
                            <input type="number" class="form-control" name="servings" min="1" placeholder="e.g., 2">
                        </div>

                        <div class="col-md-6">
                            <label class="fw-semibold">Dietary Preferences</label>
                            <div class="d-flex flex-wrap gap-3">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="pref" value="vegan" id="prefVegan">
                                    <label class="form-check-label" for="prefVegan">Vegan</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="pref" value="vegetarian" id="prefVegetarian">
                                    <label class="form-check-label" for="prefVegetarian">Vegetarian</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="pref" value="gluten-free" id="prefGlutenFree">
                                    <label class="form-check-label" for="prefGlutenFree">Gluten-free</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="pref" value="keto" id="prefKeto">
                                    <label class="form-check-label" for="prefKeto">Keto</label>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label class="fw-semibold">Calories (target max)</label>
                            <input type="number" class="form-control" name="calories" min="50" step="10" placeholder="e.g., 500">
                        </div>

                        <div class="col-12">
                            <label class="fw-semibold">Optional Note</label>
                            <textarea class="form-control" name="note" rows="2" placeholder="Any constraints or flavor notes…"></textarea>
                        </div>

                        <div class="col-12 d-flex align-items-center gap-2">
                            <button class="btn btn-purple" type="submit">Generate Recipe</button>
                            <a class="btn btn-light-purple" href="/ai">Clear</a>
                            @if(status != null && !status.isBlank())
                                <span class="ms-2 small text-muted">${status}</span>
                            @endif
                        </div>
                    </form>
                </div>

                <!-- Result card -->
                @if(meal != null)
                    <div class="recipe-card">
                        <div class="d-flex align-items-center justify-content-between">
                            <h5 class="fw-semibold mb-1">
                                ${meal.name()}
                            </h5>
                            @if(meal.type() != null)
                                <span class="badge badge-chip">${meal.type()}</span>
                            @endif
                        </div>

                        <div class="small recipe-meta mb-2">
                            @if(meal.calories() != null)
                                ~ ${meal.calories()} kcal per serving
                            @endif
                        </div>

                        <div class="mb-2">
                            <strong>Ingredients</strong>
                            <ul class="mb-0">
                                @if(meal.ingredients() != null)
                                    @for(Ingredient it : meal.ingredients())
                                        <li>
                                            @if(it != null)
                                                ${it.toString()}
                                            @else
                                                !{
                                                var item = it.item();
                                                var qty  = it.quantity();
                                                var unit = it.unit();
                                                var notes= it.notes();
                                                }
                                                ${item} ${qty}${unit != null ? " " + unit : ""}${notes != null && !notes.isBlank() ? " (" + notes + ")" : ""}
                                            @endif
                                        </li>
                                    @endfor
                                @else
                                    !{
                                    var raw = Objects.toString(meal.ingredients(), "");
                                    var parts = raw.split("\\s*,\\s*");
                                    }
                                    @for(String p : parts)
                                        @if(!p.isBlank())
                                            <li>${p}</li>
                                        @endif
                                    @endfor
                                @endif
                            </ul>
                        </div>

                        <div class="mt-3">
                            <strong>Instructions</strong>
                            <ol class="mb-2">
                                @if(meal.instructions() != null)
                                    @for(Step st : meal.instructions())
                                        <li>
                                            @if(st.text() != null)
                                                ${st.text()}
<%--                                            @else--%>
<%--                                                ${Objects.toString(((java.util.Map) st).get("text"), "")}--%>
                                            @endif
                                        </li>
                                    @endfor
                                @else
                                    !{
                                    var raw = Objects.toString(meal.instructions(), "");
                                    var numbered = raw.split("\\s*\\d+\\.\\s*");
                                    }
                                    @if(numbered.length > 1)
                                        @for(String s : numbered)
                                            @if(!s.isBlank())
                                                <li>${s}</li>
                                            @endif
                                        @endfor
                                    @else
                                        !{
                                        var parts2 = raw.split("\\s*,\\s*");
                                        }
                                        @for(String s : parts2)
                                            @if(!s.isBlank())
                                                <li>${s}</li>
                                            @endif
                                        @endfor
                                    @endif
                                @endif
                            </ol>
                        </div>

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

                        <details class="mt-2">
                            <summary class="small">Raw JSON</summary>
                            <pre class="mono small mb-0">${JsonHelper.toJson(meal)}</pre>
                        </details>
                    </div>
                @endif
            </div>

            <!-- Right column: examples -->
            <div class="col-lg-4">
                <div class="light-purple-bg rounded-4 p-4 h-100">
                    <h5 class="fw-semibold mb-3">Example Inputs</h5>
                    <ul class="mb-0">
                        <li>Breakfast, 2 servings, vegetarian, ≤ 500 kcal</li>
                        <li>Dinner, gluten-free, ≤ 650 kcal, note: spicy</li>
                        <li>Snack, vegan, ≤ 300 kcal</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</main>

<footer class="footer">
    <p class="mb-0">© 2025 MealPlanner · <a href="#">Privacy</a> · <a href="#">Terms</a></p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
