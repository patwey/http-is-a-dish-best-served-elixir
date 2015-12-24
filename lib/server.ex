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
      request
      |> parse_request
      |> build_response
      |> serve(client)
    end

    accept_loop(socket)
  end

  def parse_request(request) do
    [request|body] = String.split(request, "\r\n\r\n")
    request_lines = String.split(request, "\r\n")

    request_lines
    |> parse_first_line
    |> parse_headers
  end

  def parse_first_line(list, request \\ Map.new)
  def parse_first_line([first_line|headers], request) do
    [verb, path, protocol] = String.split(first_line, " ")
    request = Map.put(request, :verb, verb)
    request = Map.put(request, :path, path)
    request = Map.put(request, :protocol, protocol)
    [headers, request]
  end

  # Handle requests with no headers
  def parse_headers([[""], request]), do: request

  def parse_headers([[header|tail], request]) do
    [k, v] = String.split(header, ": ")
    request = Map.put(request, k, v)
    parse_headers([tail, request])
  end

  def parse_headers([[], request]), do: request

  def build_response(request) do
    request
    |> get_body
    |> respond_with
  end

  @root_path Path.expand("~/code/server/files")
  def get_body(request) do
    file_path = Path.join(@root_path, request[:path])
    case File.read file_path do
      {:ok, body}      -> body
      {:error, reason} -> "Something went wrong: #{reason}"
    end
  end

  def respond_with(body) do
    "HTTP/1.0 200 OK \r\n" <>
    "Content-Length: #{String.length(body)}\r\n\r\n" <>
    body
  end

  def serve(response, client) do
    :gen_tcp.send(client, response)
  end
end
