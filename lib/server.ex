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

    if {:ok, request} = :gen_tcp.recv(client, 0) do
      parse_request(request)
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
    [request|body] = String.split(request, "\r\n\r\n")
    request = String.split(request, "\r\n")
    |> parse_first_line(Map.new)
    |> parse_headers
    |> IO.inspect
  end

  def parse_first_line([first_line|headers], request) do
    [verb, path, protocol] = String.split(first_line, " ")
    request = Map.put(request, :verb, verb)
    request = Map.put(request, :path, path)
    request = Map.put(request, :protocol, protocol)
    [headers, request]
  end

  # Handles requests with no headers
  def parse_headers([[""], request]) do
    request
  end

  def parse_headers([[header|headers], request]) do
    [k, v] = String.split(header, ": ")
    request = Map.put(request, k, v)
    parse_headers([headers, request])
  end

  def parse_headers([[], request]) do
    request
  end
end
