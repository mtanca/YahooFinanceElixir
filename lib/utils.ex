defmodule Utils do
  @doc """
   Custom guard clause for strings.
   String args could be given as "hello world" or 'hello world'
  """
  defmacro is_string_like(item) do
    quote do
      is_binary(unquote(item)) or is_list(unquote(item))
    end
  end
end
