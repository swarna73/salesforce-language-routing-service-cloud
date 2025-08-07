package com.springbasics.Spring_trial1;

import org.springframework.stereotype.Component;

@Component
public class BubbleSortAlgorithm implements SortAlgorithm{
	
	public int[] sort(int[] numbers) {
		//Logic of sort
		System.out.println("Bubble");
		return numbers;
	}

}
