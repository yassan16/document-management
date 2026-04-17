package deepCopy.case1;

public class Item implements Cloneable{
	
	private String name;
	private int price;
	

	/**
	 * deepCopy
	 * オーバライドでclone()でも可能。
	 * 戻り値をItemクラスにすれば、呼び出しもとでキャストする必要がない。
	 */
	public Item createClone() {
		try {
			// 「super」はなくとも可能
			return (Item)super.clone();
		} catch (CloneNotSupportedException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/***** コンストラクタ *****/
	public Item(String name, int price) {
		super();
		this.name = name;
		this.price = price;
	}	
	
	/***** getter, setter *****/
	public String getName() {
		return name;
	}

	public int getPrice() {
		return price;
	}
	
	public void setName(String name) {
		this.name = name;
	}

	public void setPrice(int price) {
		this.price = price;
	}
}
