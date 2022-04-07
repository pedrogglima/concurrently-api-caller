defmodule Apicall.Worker do
  use GenServer, restart: :transient

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args)
  end

  def init(:no_args) do
    Process.send_after(self(), :do_one_apicall, 0)
    {:ok, nil}
  end

  def handle_info(:do_one_apicall, _) do
    Apicall.ApicallQueue.next()
    |> add_result()
  end

  defp add_result(nil) do
    IO.puts("work done")
    Apicall.Gatherer.done()

    {:stop, :normal, nil}
  end

  defp add_result(url) do
    call_api(url)
    |> Apicall.Gatherer.result()

    send(self(), :do_one_apicall)
    {:noreply, nil}
  end

  defp call_api(url) do
    IO.puts("calling #{url}")
    {:ok, url}
  end
end
