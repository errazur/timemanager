defmodule Timemachine.Utils do
  def parse_boolean(boolean) do
    case boolean do
      "true" -> true
      "false" -> false
      _ -> nil
    end
  end
end
