package kz.aphion.brainfights.persistents;

import java.util.Calendar;

import javax.persistence.Column;
import javax.persistence.MappedSuperclass;

import play.db.jpa.GenericModel;

@MappedSuperclass
public class PersistentObject extends GenericModel {

	public PersistentObject() {
		createdDate = Calendar.getInstance();
		modifiedDate = Calendar.getInstance();
		deleted = false;
	}
	
	
	@Column(name="created_date")
	private Calendar createdDate;
	
	@Column(name="modified_date")
	private Calendar modifiedDate;
	
	@Column(name="deleted", nullable=false, columnDefinition = "boolean default false")
	private Boolean deleted;

	
	public Calendar getCreatedDate() {
		return createdDate;
	}

	public void setCreatedDate(Calendar createdDate) {
		this.createdDate = createdDate;
	}

	public Calendar getModifiedDate() {
		return modifiedDate;
	}

	public void setModifiedDate(Calendar modifiedDate) {
		this.modifiedDate = modifiedDate;
	}

	public Boolean getDeleted() {
		return deleted;
	}

	public void setDeleted(Boolean deleted) {
		this.deleted = deleted;
	}
	
}
