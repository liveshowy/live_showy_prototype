defmodule LiveShowy.Chat.BackstageTest do
  use ExUnit.Case, async: false
  alias LiveShowy.Chat.Backstage
  alias LiveShowy.Chat.Message

  test "a new message may be added" do
    message =
      Backstage.add(%{
        user_id: UUID.uuid4(),
        body: Faker.Lorem.paragraphs() |> Enum.join("\n\n")
      })

    assert %Message{} = message
  end

  test "a new message is found in the list" do
    message =
      Backstage.add(%{
        user_id: UUID.uuid4(),
        body: Faker.Lorem.paragraphs() |> Enum.join("\n\n")
      })

    assert message in Backstage.list()
  end

  test "a message may be retrieved" do
    message =
      Backstage.add(%{
        user_id: UUID.uuid4(),
        body: Faker.Lorem.paragraphs() |> Enum.join("\n\n")
      })

    assert %Message{} = Backstage.get(message.id)
  end

  test "a message's status may be updated" do
    message =
      Backstage.add(%{
        user_id: UUID.uuid4(),
        body: Faker.Lorem.paragraphs() |> Enum.join("\n\n")
      })

    new_status = :public

    assert %Message{status: ^new_status} = Backstage.update_status(message.id, new_status)
  end

  test "a message's body may be updated" do
    message =
      Backstage.add(%{
        user_id: UUID.uuid4(),
        body: Faker.Lorem.paragraphs() |> Enum.join("\n\n")
      })

    new_body = Faker.Lorem.paragraphs() |> Enum.join("\n\n")

    assert %Message{body: ^new_body} = Backstage.update_body(message.id, new_body)
  end
end
