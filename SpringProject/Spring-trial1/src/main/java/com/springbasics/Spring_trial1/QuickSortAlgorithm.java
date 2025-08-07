package com.springbasics.Spring_trial1;

import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Component;

@Component
@Primary
public class QuickSortAlgorithm implements SortAlgorithm{
	
	public int[] sort(int[] numbers) {
		//Logic of sort
		System.out.println("Quick");
		return numbers;
	}

}
