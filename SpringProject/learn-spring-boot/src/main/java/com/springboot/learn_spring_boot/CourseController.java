package com.springboot.learn_spring_boot;

import java.util.Arrays;
import java.util.List;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
public class CourseController {

@RequestMapping("/courses")	
public List<Course> retrieveAllCourses() {
		return Arrays.asList(
				new Course(1, "Learn AWS", "Auth1"),
				new Course(2, "Learn Google Cloud", "Auth2"),
				new Course(3, "Learn Azure", "Auth3")					

		);
		
	}

}
