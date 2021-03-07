package global03.groot.model;

import java.sql.Timestamp;

public class DebateReplyDTO {
	private Integer replyNo;
	private Integer type;
	private String id;
	private String content;
	private Integer postNo;
	private Integer ref;
	private Integer re_level;
	private Integer liked;
	private Timestamp reg;
	
	public Integer getReplyNo() {
		return replyNo;
	}
	public void setReplyNo(Integer replyNo) {
		this.replyNo = replyNo;
	}
	public Integer getType() {
		return type;
	}
	public void setType(Integer type) {
		this.type = type;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public Integer getPostNo() {
		return postNo;
	}
	public void setPostNo(Integer postNo) {
		this.postNo = postNo;
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
	public Integer getLiked() {
		return liked;
	}
	public void setLiked(Integer liked) {
		this.liked = liked;
	}
	public Timestamp getReg() {
		return reg;
	}
	public void setReg(Timestamp reg) {
		this.reg = reg;
	}
}
