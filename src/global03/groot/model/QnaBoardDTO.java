package global03.groot.model;

import java.sql.Timestamp;

public class QnaBoardDTO {
	private Integer postNo;
	private String id;
	private String type;
	private String subject;
	private String content;
	private Integer ref;
	private Integer re_level;
	private Integer secret;
	private Integer status;
	private Integer readCnt;
	private Timestamp reg;
	
	public Integer getPostNo() {
		return postNo;
	}
	public void setPostNo(Integer postNo) {
		this.postNo = postNo;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public Integer getRef() {
		return ref;
	}
	public void setRef(Integer ref) {
		this.ref = ref;
	}
	public Integer getRe_level() {
		return re_level;
	}
	public void setRe_level(Integer re_level) {
		this.re_level = re_level;
	}
	public Integer getSecret() {
		return secret;
	}
	public void setSecret(Integer secret) {
		this.secret = secret;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	public Integer getReadCnt() {
		return readCnt;
	}
	public void setReadCnt(Integer readCnt) {
		this.readCnt = readCnt;
	}
	public Timestamp getReg() {
		return reg;
	}
	public void setReg(Timestamp reg) {
		this.reg = reg;
	}
}