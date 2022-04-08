defmodule Apicall.Results do
  use GenServer
  @me __MODULE__
  # API
  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args, name: @me)
  end

  def add(result) do
    GenServer.cast(@me, {:add, result})
  end

  def result() do
    GenServer.call(@me, :result)
  end

  # Server
  def init(:no_args) do
    {:ok, %{}}
  end

  def handle_cast({:add, result}, results) do
    results = [result, results]

    IO.puts("Return from batch #{inspect(result)}")

    {:noreply, results}
  end

  def handle_call(:result, _from, results) do
    {
      :reply,
      results,
      results
    }
  end
end
