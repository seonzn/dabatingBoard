package global03.groot.model;

import java.sql.Timestamp;

public class GrootUserDTO {
	private Integer no;
	private String id;
	private String pw;
	private String name;
	private String email;
	private String tel;
	private String addr;
	private Integer favorite1;
	private Integer favorite2;
	private Integer favorite3;
	private Timestamp reg;
	
	public Integer getNo() {
		return no;
	}
	public void setNo(Integer no) {
		this.no = no;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPw() {
		return pw;
	}
	public void setPw(String pw) {
		this.pw = pw;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public String getAddr() {
		return addr;
	}
	public void setAddr(String addr) {
		this.addr = addr;
	}
	public Integer getFavorite1() {
		return favorite1;
	}
	public void setFavorite1(Integer favorite1) {
		this.favorite1 = favorite1;
	}
	public Integer getFavorite2() {
		return favorite2;
	}
	public void setFavorite2(Integer favorite2) {
		this.favorite2 = favorite2;
	}
	public Integer getFavorite3() {
		return favorite3;
	}
	public void setFavorite3(Integer favorite3) {
		this.favorite3 = favorite3;
	}
	public Timestamp getReg() {
		return reg;
	}
	public void setReg(Timestamp reg) {
		this.reg = reg;
	}
	
	
}
