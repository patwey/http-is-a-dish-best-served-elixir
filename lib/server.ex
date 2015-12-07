defmodule Server do
  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port,
                                    [:binary,
                                     packet: :line,
                                     active: false,
                                     reuseaddr: true])
    accept_loop(socket)
  end

  def accept_loop(socket) do
    {:ok, client} = :gen_tcp.accept(socket)

    if {:ok, _} = :gen_tcp.recv(client, 0) do
      serve(client)
    end

    accept_loop(socket)
  end

  def serve(client) do
    response = 'HTTP/1.0 200 OK \r\n' ++
               'Content-Length: 11\r\n\r\n' ++
               'hello world'
    :gen_tcp.send(client, response)
  end
end
