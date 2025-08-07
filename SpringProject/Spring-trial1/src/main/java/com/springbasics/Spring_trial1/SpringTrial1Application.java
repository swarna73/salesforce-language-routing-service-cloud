package com.springbasics.Spring_trial1;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;

@SpringBootApplication
public class SpringTrial1Application {

	public static void main(String[] args) {
		
		//BinarySearchImpl binarySearch = new BinarySearchImpl(new QuickSortAlgorithm());
		ConfigurableApplicationContext applicationcontext = SpringApplication.run(SpringTrial1Application.class, args);
		BinarySearchImpl binarySearch = applicationcontext.getBean(BinarySearchImpl.class);
		int result = binarySearch.binarySearch(new int[] {12, 4, 6}, 3);
		System.out.println(result);
		
		
		
	}

}
