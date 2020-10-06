package com.ksg.test.common.dto;

public class CommonDTO {
	private String TXT_ID;
	private String TXT_PW;
	private String TXT_PW_SHA;
	private String USER_TYPE;
	
	public String getTXT_ID() {
		return TXT_ID;
	}
	public void setTXT_ID(String tXT_ID) {
		TXT_ID = tXT_ID;
	}
	public String getTXT_PW() {
		return TXT_PW;
	}
	public void setTXT_PW(String tXT_PW) {
		TXT_PW = tXT_PW;
	}
	public String getTXT_PW_SHA() {
		return TXT_PW_SHA;
	}
	public void setTXT_PW_SHA(String tXT_PW_SHA) {
		TXT_PW_SHA = tXT_PW_SHA;
	}
	public String getUSER_TYPE() {
		return USER_TYPE;
	}
	public void setUSER_TYPE(String uSER_TYPE) {
		USER_TYPE = uSER_TYPE;
	}
	@Override
	public String toString() {
		return "CommonDTO [TXT_ID=" + TXT_ID + ", TXT_PW=" + TXT_PW + ", TXT_PW_SHA=" + TXT_PW_SHA + ", USER_TYPE="
				+ USER_TYPE + "]";
	}
	
	
	
}
