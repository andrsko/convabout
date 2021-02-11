import { SinglePostPage } from "../features/posts/SinglePostPage";
import { ChatWindow } from "../features/chat/ChatWindow";

import back from "./back.svg";

import styles from "./ChatPost.module.css";

export const ChatPost = () => {
  const backToFeed = () => {
    window.history.back();
  };

  return (
    <div className={styles.chatPostWrapper}>
      <button className={styles.back} type="button" onClick={backToFeed}>
        <img src={back} alt="back" />
      </button>
      <div className={styles.backBackground} onClick={backToFeed} />
      <div className={styles.chatPost}>
        {SinglePostPage()}
        {ChatWindow()}
      </div>
    </div>
  );
};
