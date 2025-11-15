@param boolean isLoggedIn
@param String username
@param int year
@param String error

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="/css/styles1.css" />
    <link rel="stylesheet" href="/css/UserAccountCreation.css" />
    <title>MealPlanner — Log In</title>
</head>
<body class="d-flex flex-column min-vh-100">
<nav class="navbar navbar-expand-lg header-bg">
    <div class="container">
        <a class="navbar-brand text-white fw-bold" href="#">MealPlanner</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link text-white" href="/">Home</a></li>
                <li class="nav-item"><a class="nav-link text-white active" href="/login">Log In</a></li>
                <li class="nav-item"><a class="nav-link text-white" href="/register">Register</a></li>
            </ul>
        </div>
    </div>
</nav>

<main class="flex-fill d-flex align-items-center py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow-sm">
                    <div class="card-body p-4">
                        <h3 class="mb-3">Log In</h3>
                        @if(error != null)
                            <div class="alert alert-danger">${error}</div>
                        @endif
                        <form action="/login" method="post">
                            <div class="mb-3">
                                <label for="email" class="form-label">Email address</label>
                                <input name="email" type="email" class="form-control" id="email" required>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <input name="password" type="password" class="form-control" id="password" required>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <button type="submit" class="btn btn-purple">Log In</button>
                                <a href="/register" class="small">Create an account</a>
                            </div>
                        </form>
                    </div>
                </div>
                <p class="text-center mt-3 small text-muted">© ${year} MealPlanner</p>
            </div>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
