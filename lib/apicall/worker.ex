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
    Apicall.Gatherer.done()

    {:stop, :normal, nil}
  end

  defp add_result(urls) do
    call_api(urls)
    |> Apicall.Gatherer.result()

    send(self(), :do_one_apicall)
    {:noreply, nil}
  end

  import :timer, only: [sleep: 1]

  defp call_api(urls) do
    IO.puts("Batch: #{urls}")

    {:ok, pid} = Task.Supervisor.start_link()

    results =
      Enum.map(urls, fn url ->
        try do
          task =
            Task.Supervisor.async(
              pid,
              fn ->
                IO.puts("calling #{url}")

                ## fakes possibility of request timeout
                Enum.random(0..4000)
                |> sleep

                {:ok, url}
              end
            )

          Task.await(task, 2000)
        catch
          :exit, _ -> {:error, url}
        end
      end)

    {:ok, results}
  end
end
