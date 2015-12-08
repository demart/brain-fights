package kz.aphion.brainfights.admin.models;

import java.util.List;

public class DepartmentTreeRootModel {
	
	private Long id;
	
	private String name;
	
	private Integer count;
	
	private Integer score;
	
	private Boolean isParent;
	
	private List<DepartmentTreeModel> children;
	
	public void setCount (Integer count) {
		this.count = count;
	}
	
	public Integer getCount () {
		return count;
	}
	
	public void setScore (Integer score) {
		this.score = score;
	}
	
	public Integer getScore () {
		return score;
	}
	
	public List<DepartmentTreeModel> getChildren () {
		return children;
	}
	
	public void setChildren (List<DepartmentTreeModel> children) {
		this.children = children;
	}

}
