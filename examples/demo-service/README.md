# Demo Service (M3-02)

This folder provides a minimal local example for log + trace correlation.

## Goal
1. Generate logs with `traceId`.
2. Emit simple timing metrics.
3. Provide a deterministic error endpoint for drill.

## Files
- `app.py`: minimal HTTP server example with trace-aware logging.

## Notes
- This example is intentionally dependency-light.
- Replace with your real service when entering M4.
