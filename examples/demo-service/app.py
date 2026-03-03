import json
import time
import uuid
from http.server import BaseHTTPRequestHandler, HTTPServer


class Handler(BaseHTTPRequestHandler):
    def _write(self, code, payload):
        body = json.dumps(payload).encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        started = time.time()
        trace_id = self.headers.get("x-trace-id", str(uuid.uuid4()))
        path = self.path

        if path == "/error":
            latency_ms = int((time.time() - started) * 1000)
            log = {
                "timestamp": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
                "service": "demo-service",
                "env": "local",
                "level": "error",
                "traceId": trace_id,
                "errorCode": "DEMO_ERROR",
                "path": path,
                "latencyMs": latency_ms,
                "message": "forced error"
            }
            print(json.dumps(log), flush=True)
            self._write(500, {"ok": False, "traceId": trace_id})
            return

        latency_ms = int((time.time() - started) * 1000)
        log = {
            "timestamp": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
            "service": "demo-service",
            "env": "local",
            "level": "info",
            "traceId": trace_id,
            "path": path,
            "latencyMs": latency_ms,
            "message": "request completed"
        }
        print(json.dumps(log), flush=True)
        self._write(200, {"ok": True, "traceId": trace_id})


def main():
    server = HTTPServer(("127.0.0.1", 9101), Handler)
    print("demo-service listening on 127.0.0.1:9101", flush=True)
    server.serve_forever()


if __name__ == "__main__":
    main()
