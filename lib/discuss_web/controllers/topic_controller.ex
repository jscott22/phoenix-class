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
    topics = Topics.list_topics()
    render(conn, "index.html", topics: topics)
  end

  def create(conn, %{"topic" => topic_params}) do
    case Topics.create_topic(topic_params) do
      {:ok, topic} -> 
        conn
        |> put_status(:created)
        |> put_resp_header("location", topic_path(conn, :show, topic))
        |> render("show.json", topic: topic)
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    topic = Topics.get_topic!(id)
    render(conn, "show.json", topic: topic)
  end

  def update(conn, %{"id" => id, "topic" => topic_params}) do
    topic = Topics.get_topic!(id)

    with {:ok, %Topic{} = topic} <- Topics.update_topic(topic, topic_params) do
      render(conn, "show.json", topic: topic)
    end
  end

  def delete(conn, %{"id" => id}) do
    topic = Topics.get_topic!(id)
    with {:ok, %Topic{}} <- Topics.delete_topic(topic) do
      send_resp(conn, :no_content, "")
    end
  end
end
