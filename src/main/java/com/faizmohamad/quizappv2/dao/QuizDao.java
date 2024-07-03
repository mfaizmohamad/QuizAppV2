package com.faizmohamad.quizappv2.dao;

import com.faizmohamad.quizappv2.model.Quiz;
import org.springframework.data.jpa.repository.JpaRepository;

public interface QuizDao extends JpaRepository<Quiz, Integer> {
}
