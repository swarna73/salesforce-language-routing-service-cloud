package com.springbasics.Spring_trial1;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class BinarySearchImpl {
	
	@Autowired
	private SortAlgorithm sortAlgorithm;
	
	/*Constructor
	 * public BinarySearchImpl(SortAlgorithm sortAlgorithm) { super();
	 * this.sortAlgorithm = sortAlgorithm; }
	 */
	

	//Sort
	
	
	public int binarySearch(int[] numbers, int numbertoSearch) {
	
		//Sort logic
		int[] sortedNumbers = sortAlgorithm.sort(numbers);
		System.out.println(sortAlgorithm);
		return 3;
		
	}



	
	
	//Search the array
	//Result returned

}
