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
      <img className={styles.backIcon} src={back} alt="back" />
      <div className={styles.backPanel} onClick={backToFeed} />
      <div className={styles.chatPost}>
        {SinglePostPage()}
        {ChatWindow()}
      </div>
    </div>
  );
};
