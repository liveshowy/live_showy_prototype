defmodule LiveShowy.Chat.BackstageTest do
  use ExUnit.Case, async: true
  alias LiveShowy.Users
  alias LiveShowy.Chat.Backstage
  alias LiveShowy.Chat.Message

  setup do
    user = Users.add()
    body = Faker.Lorem.paragraphs() |> Enum.join("\n\n")

    %{added_message: Backstage.add(%{user_id: user.id, body: body})}
  end

  test "a new message may be added", state do
    assert %Message{} = state.added_message
  end

  test "a new message is found in the list", state do
    assert state.added_message in Backstage.list()
  end

  test "a message may be retrieved", state do
    assert %Message{} = Backstage.get(state.added_message.id)
  end

  test "a message's status may be updated", state do
    new_status = :public

    assert %Message{status: ^new_status} =
             Backstage.update_status(state.added_message.id, new_status)
  end

  test "a message's body may be updated", state do
    new_body = Faker.Lorem.paragraphs() |> Enum.join("\n\n")
    assert %Message{body: ^new_body} = Backstage.update_body(state.added_message.id, new_body)
  end
end
