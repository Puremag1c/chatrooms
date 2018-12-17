defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller
  import Ecto

  plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_owner when action in [:edit, :update, :delete]
  def new(conn, _params) do
    changeset = Discuss.Topic.changeset(%Discuss.Topic{}, %{})

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    changeset = conn.assigns.user
    |> build_assoc(:topics)
    |> Discuss.Topic.changeset(topic)

    case Discuss.Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
      render conn, "new.html", changeset: changeset
    end
  end

  def index(conn, _params) do
    IO.inspect(conn.assigns)
    topics = Discuss.Repo.all(Discuss.Topic)
    render conn, "index.html", topics: topics
  end

  def edit(conn, %{"id" => topic_id}) do
     topic = Discuss.Repo.get(Discuss.Topic, topic_id)
     changeset = Discuss.Topic.changeset(topic)

     render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{"topic" => topic, "id" => topic_id}) do
    old = Discuss.Repo.get(Discuss.Topic, topic_id)
    changeset = Discuss.Topic.changeset(old, topic)

    case Discuss.Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
      render conn, "edit.html", changeset: changeset, topic: old
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    Discuss.Repo.get!(Discuss.Topic, topic_id) |> Discuss.Repo.delete!

    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: Routes.topic_path(conn, :index))
  end

  def check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn
    if Discuss.Repo.get(Discuss.Topic, topic_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "Not Available")
      |> redirect(to: Routes.topic_path(conn, :index))
      |> halt()
    end
  end

  def show(conn, %{"id" => topic_id}) do
    topic = Discuss.Repo.get!(Discuss.Topic, topic_id)
    render conn, "comments.html", topic: topic
  end
end
