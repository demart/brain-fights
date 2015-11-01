package kz.aphion.brainfights.exceptions;

/**
 * Базовое исключение генерируемое в приложении
 * 
 * @author artem.demidovich
 *
 */
public class PlatformException extends Exception {
	
	private String code;
	
	public PlatformException(String code, String message) {
		this(code, message, null);
	}
	
	public PlatformException(String code, String message, Throwable ex) {
		super(message, ex);
		this.code = code;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

}
