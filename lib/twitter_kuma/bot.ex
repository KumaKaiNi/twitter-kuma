defmodule TwitterKuma.Bot do
  use GenServer
  require Logger

  def start_link(opts \\ []) do
    Logger.info "Starting bot!"
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    send self, :update
    {:ok, []}
  end

  def handle_info(:update, state) do
    update = TwitterKuma.Markov.get_markov
    ExTwitter.update update
    Logger.info "Sent update: #{update}"

    :erlang.send_after(3_600_000, self, :update)
    {:noreply, state}
  end

  def handle_info(_object, state), do: {:noreply, state}
end
