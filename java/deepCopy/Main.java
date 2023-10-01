package deepCopy.case1;

public class Main {

	public static void main(String[] args) {
		/** 
		 *  native修飾子であるcloneメソッドはObjectクラスに実装されている。
		 *  protect修飾子であるため、外部のクラスから呼び出す際は、コピーしたい参照クラスにて、
		 *  1) publicメソッド
		 *  2) super.clone()でObjectクラスのメソッドを呼ぶ必要がある。
		*/
		
		// deepCopy
		Item i = new Item("りんご", 100);
		Item i2 = i.createClone();
		i.setName("変更しました");
		System.out.println(i.getName());   // 変更しました
		System.out.println(i2.getName());  // りんご 
		System.out.println(i == i2);  // false
		
		// 参照のみ
		Item i3 = new Item("りんご", 100);
		Item i4 = i3;
		i3.setName("バナナ");
		System.out.println(i3.getName());  // バナナ
		System.out.println(i4.getName());  // バナナ
	}

}
