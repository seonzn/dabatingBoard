package global03.groot.model;

import java.sql.Timestamp;

public class NanoomDTO {
	private Integer postNo;
	private Integer genre;
	private String id;
	private String bookName;
	private String subject;
	private String content;
	private String img;
	private Integer result;
	private Timestamp reg;
	
	public Integer getPostNo() {
		return postNo;
	}
	public void setPostNo(Integer postNo) {
		this.postNo = postNo;
	}
	public Integer getGenre() {
		return genre;
	}
	public void setGenre(Integer genre) {
		this.genre = genre;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getBookName() {
		return bookName;
	}
	public void setBookName(String bookName) {
		this.bookName = bookName;
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
	public String getImg() {
		return img;
	}
	public void setImg(String img) {
		this.img = img;
	}
	public Integer getResult() {
		return result;
	}
	public void setResult(Integer result) {
		this.result = result;
	}
	public Timestamp getReg() {
		return reg;
	}
	public void setReg(Timestamp reg) {
		this.reg = reg;
	}
}
