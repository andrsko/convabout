import { useHistory } from "react-router-dom";
import { useDispatch } from "react-redux";

import { SinglePostPage } from "../features/posts/SinglePostPage";
import { ChatWindow } from "../features/chat/ChatWindow";

import { fetchPosts } from "../features/posts/postsSlice";

import back from "./back.svg";

import styles from "./ChatPost.module.css";

export const ChatPost = () => {
  const dispatch = useDispatch();
  const history = useHistory();

  const backToFeed = () => {
    const urlParams = new URLSearchParams(window.location.search);
    const isJustCreated = urlParams.get("ref") === "cr";
    if (!isJustCreated) window.history.back();
    else {
      dispatch(fetchPosts());
      history.push("/");
    }
  };

  return (
    <div className={styles.chatPostWrapper}>
      <img className={styles.backIcon} src={back} alt="back" />
      <div className={styles.backPanel} onClick={backToFeed} />
      <div className={styles.chatPost}>
        {SinglePostPage()}
        {ChatWindow()}
      </div>
    </div>
  );
};
