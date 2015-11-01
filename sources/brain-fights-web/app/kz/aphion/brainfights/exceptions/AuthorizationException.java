package kz.aphion.brainfights.exceptions;


public class AuthorizationException extends PlatformException {

	public AuthorizationException(String code, String message) {
		super(code, message);
	}
	
	public AuthorizationException(String code, String message, Throwable ex) {
		super(code, message, ex);
	
	}

}
