package kz.aphion.brainfights.models;

import kz.aphion.brainfights.exceptions.PlatformException;

/**
 * Контейнер ответов на запросы с мобильных (и не только) приложений
 * 
 * @author artem.demidovich
 *
 */
public class ResponseWrapperModel {

	private ResponseStatus status;
	private Object data;
	
	/**
	 * Код ошибки
	 */
	private String errorCode;
	
	/**
	 * Описание ошибки 
	 */
	private String errorMessage;
	
	public ResponseWrapperModel() {}
	
	public ResponseWrapperModel(ResponseStatus status, Object data) {
		this(status, data, null);	
	}
	
	public ResponseWrapperModel(ResponseStatus status, Object data, PlatformException sEx) {
		this.status = status;
		this.data = data;
		
		if (sEx != null) {
			errorCode = sEx.getCode();
			errorMessage = sEx.getMessage();
		}
			
	}
	
	public static ResponseWrapperModel getAuthorizationError(Object data) {
		return new ResponseWrapperModel(ResponseStatus.AUTHORIZATION_ERROR, data);
	}
	
	public static ResponseWrapperModel getAuthorizationError(String errorCode, Throwable ex) {
		return new ResponseWrapperModel(ResponseStatus.AUTHORIZATION_ERROR, null, new PlatformException(errorCode, ex.getMessage(), ex));
	}
	
	
	public static ResponseWrapperModel getSuccess(Object data) {
		return new ResponseWrapperModel(ResponseStatus.SUCCESS, data);
	}
	
	public static ResponseWrapperModel getNoContent() {
		return new ResponseWrapperModel(ResponseStatus.NO_CONTENT, null);
	}

	public static ResponseWrapperModel getBadRequest(PlatformException sEx) {
		return new ResponseWrapperModel(ResponseStatus.BAD_REQUEST, null, sEx);
	}
	
	public static ResponseWrapperModel getServerError(PlatformException sEx) {
		return new ResponseWrapperModel(ResponseStatus.SERVER_ERROR, null, sEx);
	}
	
	public static ResponseWrapperModel getServerError(String errorCode, Throwable ex) {
		return new ResponseWrapperModel(ResponseStatus.SERVER_ERROR, null, new PlatformException(errorCode, ex.getMessage(), ex));
	}	
	
	
	public ResponseStatus getStatus() {
		return status;
	}
	public void setStatus(ResponseStatus status) {
		this.status = status;
	}
	public Object getData() {
		return data;
	}
	public void setData(Object data) {
		this.data = data;
	}
	
	public String getErrorCode() {
		return errorCode;
	}

	public void setErrorCode(String errorCode) {
		this.errorCode = errorCode;
	}

	public String getErrorMessage() {
		return errorMessage;
	}

	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}

}
