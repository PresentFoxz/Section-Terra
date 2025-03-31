import socketserver
import threading
import time
from http.server import HTTPServer, BaseHTTPRequestHandler


class CustomTCPHandler(socketserver.BaseRequestHandler):
    """Handles custom TCP messages."""

    def handle(self):
        data = self.request.recv(1024).decode("utf-8")
        print(f"TCP Connection from {self.client_address}, received: {data}")

        # Check if the message is "PING"
        if data.strip().upper() == "PING":
            response = "PONG"
        else:
            response = "Unknown command"

        self.request.sendall(response.encode("utf-8"))
        print(f"Sent TCP response: {response}")


class CustomHTTPHandler(BaseHTTPRequestHandler):
    """Handles HTTP requests with Keep-Alive support."""

    protocol_version = "HTTP/1.1"  # Upgrade to HTTP/1.1 for keep-alive support

    def do_GET(self):
        # Check the requested path
        if self.path == "/PING":
            # Add a slight delay to make the client example more meaningful
            time.sleep(0.2)

            # Respond with "PONG"
            response_body = "PONG"
            self.send_response(200)
            self.send_header("Content-Length", len(response_body))
            self.send_header("Content-Type", "text/plain")

            # Check if the client supports Keep-Alive
            if self.headers.get("Connection", "").lower() == "keep-alive":
                self.send_header("Connection", "keep-alive")
                self.send_header("Keep-Alive", "timeout=5, max=100")  # Adjust as needed
            else:
                self.send_header("Connection", "close")

            self.end_headers()
            self.wfile.write(response_body.encode("utf-8"))

            # Log the HTTP response
            print(f"HTTP GET /PING Response to {self.client_address}:")
            print("Status: 200 OK")
            print(
                f"Headers: Content-Length={len(response_body)}, Content-Type=text/plain"
            )
            print(f"Body: {response_body}")
        else:
            # Respond with 405 Method Not Allowed
            self.send_response(405)
            self.send_header("Content-Length", 0)
            self.send_header("Content-Type", "text/plain")
            self.send_header("Connection", "close")
            self.end_headers()

            # Log the HTTP response
            print(f"HTTP GET {self.path} Response to {self.client_address}:")
            print("Status: 405 Method Not Allowed")

    def do_POST(self):
        # Respond with 405 Method Not Allowed for POST and other methods
        self.send_response(405)
        self.send_header("Content-Length", 0)
        self.send_header("Content-Type", "text/plain")
        self.send_header("Connection", "close")
        self.end_headers()

        # Log the HTTP response
        print(f"HTTP POST {self.path} Response to {self.client_address}:")
        print("Status: 405 Method Not Allowed")


def start_tcp_server(host="127.0.0.1", port=65432):
    """Start the TCP server."""
    with socketserver.TCPServer((host, port), CustomTCPHandler) as server:
        print(f"TCP server is listening on {host}:{port}...")
        server.serve_forever()


def start_http_server(host="127.0.0.1", port=8080):
    """Start the HTTP server."""
    with HTTPServer((host, port), CustomHTTPHandler) as server:
        print(f"HTTP server is listening on {host}:{port}...")
        server.serve_forever()


if __name__ == "__main__":
    tcp_port = 65431
    http_port = 65433

    # Start the TCP server in a separate thread
    tcp_thread = threading.Thread(
        target=start_tcp_server, args=("0.0.0.0", tcp_port), daemon=True
    )
    tcp_thread.start()

    # Start the HTTP server in the main thread
    start_http_server("0.0.0.0", http_port)
