defmodule MessagingServiceWeb.MessageControllerTest do
  use MessagingServiceWeb.ConnCase

  import MessagingService.MessagesFixtures

  alias MessagingService.Messages.Message

  @create_attrs %{
    timestamp: ~U[2025-10-22 20:11:00Z],
    type: "some type",
    body: "some body",
    to: "some to",
    from: "some from",
    attachments: ["option1", "option2"]
  }
  @update_attrs %{
    timestamp: ~U[2025-10-23 20:11:00Z],
    type: "some updated type",
    body: "some updated body",
    to: "some updated to",
    from: "some updated from",
    attachments: ["option1"]
  }
  @invalid_attrs %{timestamp: nil, type: nil, body: nil, to: nil, from: nil, attachments: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all messages", %{conn: conn} do
      conn = get(conn, ~p"/api/messages")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create message" do
    test "renders message when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/messages", message: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/messages/#{id}")

      assert %{
               "id" => ^id,
               "attachments" => ["option1", "option2"],
               "body" => "some body",
               "from" => "some from",
               "timestamp" => "2025-10-22T20:11:00Z",
               "to" => "some to",
               "type" => "some type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/messages", message: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update message" do
    setup [:create_message]

    test "renders message when data is valid", %{conn: conn, message: %Message{id: id} = message} do
      conn = put(conn, ~p"/api/messages/#{message}", message: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/messages/#{id}")

      assert %{
               "id" => ^id,
               "attachments" => ["option1"],
               "body" => "some updated body",
               "from" => "some updated from",
               "timestamp" => "2025-10-23T20:11:00Z",
               "to" => "some updated to",
               "type" => "some updated type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, message: message} do
      conn = put(conn, ~p"/api/messages/#{message}", message: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete message" do
    setup [:create_message]

    test "deletes chosen message", %{conn: conn, message: message} do
      conn = delete(conn, ~p"/api/messages/#{message}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/messages/#{message}")
      end
    end
  end

  defp create_message(_) do
    message = message_fixture()
    %{message: message}
  end
end
