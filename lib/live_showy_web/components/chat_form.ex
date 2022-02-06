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
    <Form for={:message} submit={@submit} opts={autocomplete: "off"} class="flex p-1 pb-2 transition drop-shadow-md focus-within:drop-shadow-lg focus-within:-translate-y-0.5">
      <TextInput
        name="body"
        value={@message.body}
        class="flex-grow px-4 py-2 transition rounded-l bg-default-200 focus:bg-white dark:focus:bg-default-600 focus:outline-none dark:bg-default-700 dark:placeholder:text-default-300"
        opts={autofocus: true, required: true, placeholder: "Message Backstage"}
      />

      <Button type="submit" click={nil} label="SEND" rounded="rounded-r" />
    </Form>
    """
  end
end
