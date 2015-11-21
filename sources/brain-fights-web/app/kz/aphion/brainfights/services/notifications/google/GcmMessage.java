package kz.aphion.brainfights.services.notifications.google;

public class GcmMessage {

	public String deviceToken;
	
	public Message message;
	
	public GcmMessage(String deviceToken, Message message){
		this.deviceToken = deviceToken;
		this.message = message;
	}

	public String getDeviceToken() {
		return deviceToken;
	}

	public void setDeviceToken(String deviceToken) {
		this.deviceToken = deviceToken;
	}

	public Message getMessage() {
		return message;
	}

	public void setMessage(Message message) {
		this.message = message;
	}

	
	
	
}
