defmodule Server do
  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port,
                                    [:binary,
                                     packet: :line,
                                     active: false,
                                     reuseaddr: true])
    {:ok, client} = :gen_tcp.accept(socket)
    loop_acceptor(socket)
  end

  def loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    :gen_tcp.send(socket, "hello world")
    loop_acceptor(socket)
  end
end
