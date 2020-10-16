package com.ksg.test.common.domain;

public class CommonVO {
	
	String MEM_CD;
	String ID;
	String PW;
	String EMAIL;
	String ADDRESS;
	String ADDRESS_NO;
	String PHONE;

	public String getMEM_CD() {
		return MEM_CD;
	}
	public void setMEM_CD(String mEM_CD) {
		MEM_CD = mEM_CD;
	}
	public String getID() {
		return ID;
	}
	public void setID(String iD) {
		ID = iD;
	}
	public String getPW() {
		return PW;
	}
	public void setPW(String pW) {
		PW = pW;
	}
	public String getEMAIL() {
		return EMAIL;
	}
	public void setEMAIL(String eMAIL) {
		EMAIL = eMAIL;
	}
	public String getADDRESS() {
		return ADDRESS;
	}
	public void setADDRESS(String aDDRESS) {
		ADDRESS = aDDRESS;
	}
	public String getADDRESS_NO() {
		return ADDRESS_NO;
	}
	public void setADDRESS_NO(String aDDRESS_NO) {
		ADDRESS_NO = aDDRESS_NO;
	}
	public String getPHONE() {
		return PHONE;
	}
	public void setPHONE(String pHONE) {
		PHONE = pHONE;
	}
	
	
	@Override
	public String toString() {
		return "CommonVO [ID=" + ID + ", PW=" + PW + ", EMAIL=" + EMAIL + ", ADDRESS=" + ADDRESS + ", PHONE=" + PHONE
				+ "]";
	}
	
	
}
