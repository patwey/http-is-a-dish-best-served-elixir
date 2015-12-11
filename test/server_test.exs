defmodule ServerTest do
  use ExUnit.Case
  test "parse_first_line stores first line" do
    request = ["GET / HTTP/1.1", "SOME HEADERS"]
    [_, parsed_first_line] = Server.parse_first_line(request, Map.new)
    expected = %{verb: "GET",
                 path: "/",
                 protocol: "HTTP/1.1"}
    assert expected == parsed_first_line
  end

  test "parse_headers and stores headers" do
    headers = ["User-Agent: curl/7.37.1", "Host: example.com", "Accept: /"]
    expected = %{"User-Agent" => "curl/7.37.1",
                 "Host" => "example.com",
                 "Accept" => "/"}
    assert expected == Server.parse_headers([headers, %{}])
  end

  test "parse_request stores full request" do
    request = "GET / HTTP/1.1\r\nUser-Agent: curl/7.37.1\r\nHost: example.com\r\nAccept: /\r\n\r\n"
    expected = %{:verb        => "GET",
                 :path        => "/",
                 :protocol    => "HTTP/1.1",
                 "User-Agent" => "curl/7.37.1",
                 "Host"       => "example.com",
                 "Accept"     => "/"}
    assert expected == Server.parse_request(request)
  end
end
