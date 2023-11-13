import "./styles.css";
// ↑削除するとCSSが反映されなくなる

/***** 新規TODO追加機能 *****/
// 要素のidを指定して、クリックイベントを実行
document
  .getElementById("add-button")
  .addEventListener("click", () => onClickAdd());

/***** 新規追加機能 *****/
const onClickAdd = () => {
  // テキストボックスの値を取得し、元の値を初期化
  const inputText = document.getElementById("add-text").value;
  document.getElementById("add-text").value = "";
  // alert(inputText); //確認

  // 未完了リストに追加
  createIncompleteList(inputText);
};

/***** 未完了・完了リストへの追加機能 *****/
const createIncompleteList = (text) => {
  // div生成
  const div = document.createElement("div");
  div.className = "list-row";
  // console.log(div); //確認用

  // list生成
  const li = document.createElement("li");
  li.innerText = text;
  // console.log(li); //確認用

  // button(完了)生成
  const completeButton = document.createElement("button");
  completeButton.innerText = "完了";
  completeButton.addEventListener("click", () => {
    // 未完了リストから削除
    const deleteTarget = completeButton.parentNode;
    deleteFromTodoList(deleteTarget);

    // 完了リストに追加する要素
    const addTarget = completeButton.parentNode;
    console.log("addTarget↓↓");
    console.log(addTarget);

    // TODOの内容を取得
    const text = addTarget.firstElementChild.innerText;
    addTarget.textContent = null;
    console.log("TODOの内容: " + text);
    console.log("addTarget↓↓");
    console.log(addTarget);

    // list生成
    const li = document.createElement("li");
    li.innerText = text;

    // 戻すボタン生成
    const returnButton = document.createElement("button");
    returnButton.innerText = "戻す";
    returnButton.addEventListener("click", () => {
      // 完了TODOリストから削除
      const deleteTarget = returnButton.parentNode;
      document.getElementById("complete-list").removeChild(deleteTarget);

      // テキスト取得
      const text = returnButton.parentNode.firstElementChild.innerText;
      // 未完了リストに追加
      createIncompleteList(text);
    });

    // 要素をすべてまとめる
    addTarget.appendChild(li);
    addTarget.appendChild(returnButton);

    // 完了リストに追加
    document.getElementById("complete-list").appendChild(div);
  });

  // button(削除)生成
  const deleteButton = document.createElement("button");
  deleteButton.innerText = "削除";
  // イベントを仕込む
  deleteButton.addEventListener("click", () => {
    const deleteTarget = deleteButton.parentNode;
    deleteFromTodoList(deleteTarget);
  });

  // divタグの子要素に追加
  div.appendChild(li);
  div.appendChild(completeButton);
  div.appendChild(deleteButton);
  // console.log(div); //確認用

  // 未完了リストに追加
  document.getElementById("incomplete-list").appendChild(div);
};

/***** 削除機能 *****/
const deleteFromTodoList = (target) => {
  // 押されたボタンの親タグ(div)をTODOリストから削除
  //親タグ取得
  console.log("deleteTarget↓↓");
  console.log(target); //確認用
  document.getElementById("incomplete-list").removeChild(target);
};
