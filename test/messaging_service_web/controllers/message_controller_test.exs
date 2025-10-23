defmodule MessagingServiceWeb.MessageControllerTest do
  use MessagingServiceWeb.ConnCase

  import MessagingService.Factory

  @create_sms_attrs params_for(:sms_message)
  @create_email_attrs params_for(:email_message)

  @invalid_attrs %{timestamp: nil, type: nil, body: nil, to: nil, from: nil, attachments: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "send_sms" do
    test "returns 201 when sms data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/messages/sms", @create_sms_attrs)
      assert json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/messages/sms", message: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "send_email" do
    test "returns 201 when sms data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/messages/email", @create_email_attrs)
      assert json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/messages/email", message: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
