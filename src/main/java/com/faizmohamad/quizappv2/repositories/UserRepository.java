package com.faizmohamad.quizappv2.repositories;

import com.faizmohamad.quizappv2.entites.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByLogin(String login);
}
