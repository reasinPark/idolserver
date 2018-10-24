package com.wingsinus.ep;

public class Module {
	public String itemNameCheck(int name) {
		String ret = "";
		
		if(name == 100001) {
			ret = "티켓";
		}
		else if(name == 100002) {
			ret = "젬";
		}
		else if(name == 0) {
			ret = "-";
		}
		else {
			ret = String.valueOf(name);
		}
		
		return ret;
	}
	
	public String attendReward(int day) {
		String ret = "";
		if(day == 1) {
			ret = "d1itemId_1, d1count_1, d1itemId_2, d1count_2, d1itemId_3, d1count_3, d1itemId_4, d1count_4";
		}
		else if(day == 2) {
			ret = "d2itemId_1, d2count_1, d2itemId_2, d2count_2, d2itemId_3, d2count_3, d2itemId_4, d2count_4";
		}
		else if(day == 3) {
			ret = "d3itemId_1, d3count_1, d3itemId_2, d3count_2, d3itemId_3, d3count_3, d3itemId_4, d3count_4";
		}
		else if(day == 4) {
			ret = "d4itemId_1, d4count_1, d4itemId_2, d4count_2, d4itemId_3, d4count_3, d4itemId_4, d4count_4";
		}
		else if(day == 5) {
			ret = "d5itemId_1, d5count_1, d5itemId_2, d5count_2, d5itemId_3, d5count_3, d5itemId_4, d5count_4";
		}
		else if(day == 6) {
			ret = "d6itemId_1, d6count_1, d6itemId_2, d6count_2, d6itemId_3, d6count_3, d6itemId_4, d6count_4";
		}
		else if(day == 7) {
			ret = "d7itemId_1, d7count_1, d7itemId_2, d7count_2, d7itemId_3, d7count_3, d7itemId_4, d7count_4";
		}
		
		return ret;
	}
}
