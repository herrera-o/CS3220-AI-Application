package dev.cs3220project1.cs3220aiapplication.repository;

import dev.cs3220project1.cs3220aiapplication.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
    boolean existsByEmail(String email);
}
