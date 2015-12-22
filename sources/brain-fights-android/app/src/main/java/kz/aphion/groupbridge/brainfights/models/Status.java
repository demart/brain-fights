package kz.aphion.groupbridge.brainfights.models;

/**
 * Created by alimjan on 04.11.2015.
 */
public class Status<T> {
    private ResponseStatus status;
    private T[] data;
    /**
     * Код ошибки
     */
    private String errorCode;

    /**
     * Описание ошибки
     */
    private String errorMessage;

    public ResponseStatus getStatus() {
        return status;
    }

    public void setStatus(ResponseStatus status) {
        this.status = status;
    }

    public T[] getData() {
        return data;
    }

    public void setData(T[] data) {
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
