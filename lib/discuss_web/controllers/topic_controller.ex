defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topics
  alias Discuss.Topics.Topic

  action_fallback DiscussWeb.FallbackController

  def new(conn, _parmas) do
    changeset = Topic.changeset(%Topic{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def index(conn, _params) do
    IO.inspect(conn.assigns)
    topics = Topics.list_topics()
    render(conn, "index.html", topics: topics)
  end

  def create(conn, %{"topic" => topic_params}) do
    case Topics.create_topic(topic_params) do
      {:ok, _topic} -> 
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Topics.get_topic!(topic_id)
    changeset = Topic.changeset(topic)

    render(conn, "edit.html", changeset: changeset, topic: topic)
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    old_topic = Topics.get_topic!(topic_id)

    case Topics.update_topic(old_topic, topic) do
      
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset, topic: old_topic)
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    old_topic = Topics.get_topic!(topic_id)

    case Topics.delete_topic(old_topic) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Deleted")
        |> redirect(to: topic_path(conn, :index))
      {:error, _changeset} ->
        render(conn, "index.html")
    end
    
  end

end
