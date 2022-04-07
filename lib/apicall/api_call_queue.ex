defmodule Apicall.ApicallQueue do
  use GenServer
  @me ApicallQueue
  def start_link(root) do
    GenServer.start_link(__MODULE__, root, name: @me)
  end

  def next() do
    GenServer.call(@me, :next)
  end

  def init(calls) do
    {:ok, calls}
  end

  def handle_call(:next, _from, calls) do
    case calls do
      [] ->
        {:reply, nil, []}

      _ ->
        {:reply, hd(calls), tl(calls)}
    end
  end
end
