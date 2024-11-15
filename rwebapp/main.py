import http.server
import socketserver
import random
import time
import threading

PORT = 80

class random_number_webapp(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            delay = random.uniform(1, 3)
            time.sleep(delay)
            random_number = random.randint(1, 100)
            
            html_content = f"""
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <title>Random Number</title>
            </head>
            <body>
                <h1>Your random number is: {random_number}</h1>
            </body>
            </html>
            """
            
            try:
                self.send_response(200)
                self.send_header("Content-type", "text/html")
                self.end_headers()
                self.wfile.write(html_content.encode('utf-8'))
            except BrokenPipeError:
                print("Client disconnected before completing the response.")
        else:
            self.send_error(404, "Page Not Found")

class ThreadingTCPServer(socketserver.ThreadingMixIn, socketserver.TCPServer):
    pass

with ThreadingTCPServer(("", PORT), random_number_webapp) as httpd:
    print(f"Serving on port {PORT}")
    httpd.serve_forever()
