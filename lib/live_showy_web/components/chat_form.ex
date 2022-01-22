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
    <Form for={:message} submit={@submit} opts={autocomplete: "off"} class="flex gap-1">
      <TextInput name="body" value={@message.body} class="flex-grow px-2 py-1 transition focus:bg-white focus:text-black focus:outline-none bg-brand-700" opts={autofocus: true, required: true} />
      <Button type="submit" click={nil} label="SEND" rounded="rounded-none" />
    </Form>
    """
  end
end
