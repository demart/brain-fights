package kz.aphion.brainfights.admin.models;

import kz.aphion.brainfights.models.ResponseWrapperModel;

public class AdminResponseWrapperModel extends ResponseWrapperModel {
	private Integer totalCount;
	private Integer downloadQuestions;
	private Integer modelsQuestions;
	
	public void setDownloadQuestions (Integer downloadQuestions) {
		this.downloadQuestions = downloadQuestions;
	}
	
	public void setModelQuestions (Integer modelQuestions) {
		this.modelsQuestions = modelQuestions;
	}
	
	
	public void setTotalCount (Integer totalCount) {
		this.totalCount = totalCount;
	}
	
	public Integer getTotalCount () {
		return totalCount;
	}
} 
