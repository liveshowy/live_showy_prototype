defmodule LiveShowyWeb.Components.ChatForm do
  @moduledoc false
  use Surface.Component
  alias Surface.Components.Form
  alias Surface.Components.Form.TextInput
  alias LiveShowy.Chat.Message
  alias LiveShowyWeb.Components.Button

  prop submit, :event, required: true
  prop message, :struct, default: Message.new()

  def render(assigns) do
    ~F"""
    <Form for={:message} submit={@submit} opts={autocomplete: "off"} class="flex p-1">

      <TextInput
        name="body"
        value={@message.body}
        class="flex-grow px-2 py-1 transition border-2 border-transparent rounded-l focus:border-white focus:bg-default-600 focus:outline-none bg-default-700 placeholder:text-default-500"
        opts={autofocus: true, required: true, placeholder: "Message Backstage"}
      />

      <Button type="submit" click={nil} label="SEND" rounded="rounded-r" />

    </Form>
    """
  end
end
