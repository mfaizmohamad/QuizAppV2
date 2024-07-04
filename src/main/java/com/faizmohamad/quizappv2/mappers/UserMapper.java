package com.faizmohamad.quizappv2.mappers;

import com.faizmohamad.quizappv2.DTO.UserDto;
import com.faizmohamad.quizappv2.DTO.SignUpDto;
import com.faizmohamad.quizappv2.entites.User;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "Spring")
public interface UserMapper {
    UserDto toUserDto(User user);

    @Mapping(target = "password", ignore = true)
    User signUpToUser(SignUpDto signUpDto);
}
