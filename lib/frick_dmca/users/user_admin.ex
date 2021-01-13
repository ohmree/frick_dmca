defmodule FrickDmca.Users.UserAdmin do
  def widgets(schema, conn) do
    [
      %{
        type: "tidbit",
        title: "Current audience members",
        content: "TODO",
        icon: "user",
        order: 1,
        width: 6,
      },
      %{
        type: "tidbit",
        title: "Current streamers",
        content: "TODO",
        icon: "headset",
        order: 1,
        width: 6,
      },
    ]
  end
end
