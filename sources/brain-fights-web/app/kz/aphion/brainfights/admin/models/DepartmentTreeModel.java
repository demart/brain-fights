package kz.aphion.brainfights.admin.models;

import java.util.List;

public class DepartmentTreeModel {
	
	private Long id;
	
	private String name;
	
	private Integer count;
	
	private Integer score;
	
	private Boolean isParent;
	
	private String iconCls;
	
	private Boolean leaf;
	
	private String type;
	
	private Long typeId;
	
	public DepartmentTreeModel (Long id, String name, String iconCls, Integer score, Integer count, String type, Long typeId, Boolean leaf) {
		this.id = id;
		this.name = name;
		this.iconCls = iconCls;
		this.count = count;
		this.score = score;
		this.leaf = leaf;
		this.type = type;
		this.typeId = typeId;
		//this.isParent= isParent;
	}
	
	public DepartmentTreeModel() {
		
	}
	
	private List<DepartmentTreeModel> children;
	

	
	public List<DepartmentTreeModel> getChildren () {
		return children;
	}
	
	public void setChildren (List<DepartmentTreeModel> children) {
		this.children = children;
	}

}
