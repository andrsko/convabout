import React, { useEffect } from "react";
import { useSelector, useDispatch } from "react-redux";
import { Link } from "react-router-dom";

import timeAgo from "../../utils/timeAgo";
import { fetchPosts, activateTag } from "./postsSlice";
import { Tag } from "./Tag";
import { TrendingTags } from "./TrendingTags";
import { ActiveTag } from "./ActiveTag";
import { Loader } from "../../shared/Loader";

import styles from "./PostList.module.css";

import messageCount from "./messageCount.svg";

const PostExcerpt = ({ post }) => {
  return (
    <Link to={`/chat?p=${post.id}`}>
      <article className={styles.postExcerpt} key={post.id}>
        <p className={styles.postTitle}>{post.title}</p>
        {post.tags.map((tag) => (
          <Tag key={tag.id} tag={tag} />
        ))}

        <div className={styles.postInfo}>
          <p className={styles.postAuthorAndTimestamp}>{`by ${
            post.username
          } ${timeAgo(post.inserted_at)}`}</p>
          <div className={styles.messageCount}>
            <div className={styles.messageCountInterlayer}>
              <img
                className={styles.messageCountIcon}
                src={messageCount}
                alt="message-count"
              />
              <p className={styles.messageCountValue}>{post.message_count}</p>
            </div>
          </div>
        </div>
      </article>
    </Link>
  );
};

export const PostList = (props) => {
  const dispatch = useDispatch();
  const posts = useSelector((state) => state.posts.posts);

  const postsStatus = useSelector((state) => state.posts.postsStatus);
  const error = useSelector((state) => state.posts.postsError);

  useEffect(() => {
    if (postsStatus === "idle") {
      const tagName = props.match.params.tag;
      if (tagName) {
        const tag = { id: 0, name: tagName };
        dispatch(activateTag(tag));
        dispatch(fetchPosts(tag));
      } else dispatch(fetchPosts());
    }
  }, [postsStatus, dispatch, props.match.params.tag]);

  let postExcerpts;

  if (postsStatus === "loading") {
    postExcerpts = <Loader size="large" />;
  } else if (postsStatus === "succeeded") {
    // Sort posts in reverse chronological order by datetime string
    const orderedPosts = posts
      .slice()
      .sort((a, b) => b.inserted_at.localeCompare(a.inserted_at));

    postExcerpts = orderedPosts.map((post) => (
      <PostExcerpt key={post.id} post={post} />
    ));
  } else if (postsStatus === "error") {
    postExcerpts = <div className="error">{error}</div>;
  }

  return (
    <section className={styles.postList}>
      <TrendingTags />
      <ActiveTag />
      {postExcerpts}
    </section>
  );
};
