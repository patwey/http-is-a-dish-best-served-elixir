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

  def parse_request(request) do
    # parse first line
    [ first_line | headers ] = String.split(request, "\r\n")
    [ verb | path_and_protocol ] = String.split(first_line, " ")
    [ path | protocol ] = path_and_protocol
    [ protocol_version | _ ] = protocol
    [ verb: verb, path: path, protocol_version: protocol_version ]
  end
end
