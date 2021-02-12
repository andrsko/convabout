import React, { useEffect } from "react";
import { useSelector } from "react-redux";
import Linkify from "react-linkify";

import toTimeAmPm from "../../utils/toTimeAmPm";

import styles from "./MessageList.module.css";

const MessageExcerpt = ({ message }) => {
  return (
    <div className={styles.messageExcerpt}>
      <p className={styles.author}>{message.username}</p>
      <Linkify>
        <p className={styles.body}>{message.body}</p>
      </Linkify>
      <p className={styles.timestamp}>{toTimeAmPm(message.inserted_at)}</p>
    </div>
  );
};

export const MessageList = () => {
  const messages = useSelector((state) => state.chat.log);

  useEffect(() => {
    //scroll on new message automatically only if scroll position is near bottom
    if (
      window.scrollY &&
      window.innerHeight + window.scrollY >= document.body.scrollHeight - 250
    )
      window.scrollTo(0, document.body.scrollHeight);
  }, [messages]);

  const content = messages.map((message) => (
    <MessageExcerpt key={message.id} message={message} />
  ));

  return <div id="message-list">{content}</div>;
};
