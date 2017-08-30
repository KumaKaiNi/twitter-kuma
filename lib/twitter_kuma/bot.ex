defmodule TwitterKuma.Bot do
  use GenServer

  def start_link(opts \\ []) do
    require Logger

    Logger.debug "Starting bot!"
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    send self, :update
    {:ok, []}
  end

  def handle_info(:update, state) do
    ExTwitter.update(TwitterKuma.Markov.get_markov)

    :erlang.send_after(3_600_000, self, :update)
    {:noreply, state}
  end

  def handle_info(_object, state), do: {:noreply, state}
end
