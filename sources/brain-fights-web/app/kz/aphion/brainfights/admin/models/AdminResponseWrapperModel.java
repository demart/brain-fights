package kz.aphion.brainfights.admin.models;

import kz.aphion.brainfights.models.ResponseWrapperModel;

public class AdminResponseWrapperModel extends ResponseWrapperModel {
	private Integer totalCount;
	
	public void setTotalCount (Integer totalCount) {
		this.totalCount = totalCount;
	}
	
	public Integer getTotalCount () {
		return totalCount;
	}
} 
