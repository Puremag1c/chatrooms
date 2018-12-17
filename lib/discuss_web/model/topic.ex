defmodule Discuss.Topic do
use DiscussWeb, :model

  schema "topics" do
    field :title, :string
    belongs_to :user, Discuss.User
    has_many :comments, Discuss.Comment
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params,  [:title], [:id])
    |> validate_required([:title])
  end


end