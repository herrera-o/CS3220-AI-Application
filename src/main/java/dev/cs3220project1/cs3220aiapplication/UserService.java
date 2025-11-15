package dev.cs3220project1.cs3220aiapplication;


import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class UserService {
    private final Map<String, User> users = new ConcurrentHashMap<>();

    public void register(User user) {
        if (user != null && user.getEmail() != null) {
            users.put(user.getEmail().toLowerCase(), user);
        }
    }

    public Optional<User> findByEmail(String email) {
        if (email == null) return Optional.empty();
        return Optional.ofNullable(users.get(email.toLowerCase()));
    }

    public Optional<User> authenticate(String email, String password) {
        return findByEmail(email).filter(u -> u.getPassword() != null && u.getPassword().equals(password));
    }
}
