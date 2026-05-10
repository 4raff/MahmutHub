# MahmutHub

Project template for Luau/Roblox scripting with Rokit + Wally.

## Current Status

- Rokit tools configured in [rokit.toml](rokit.toml): Wally and Darklua
- Wally manifest configured in [wally.toml](wally.toml)
- Lockfile generated: [wally.lock](wally.lock)
- Source folders prepared under [src](src)
- Modular entrypoint available at [src/init.lua](src/init.lua)

## Setup

1. Install toolchain from [rokit.toml](rokit.toml):

   rokit install

2. Install dependencies from [wally.toml](wally.toml):

   wally install

## Suggested Workflow

1. Develop modules in [src](src)
2. Add dependencies in [wally.toml](wally.toml)
3. Run dependency install again when dependencies change:

   wally install

4. (Optional) Minify/transform with Darklua:

   darklua --help

## Modular Structure

- [src/core](src/core): dependency loader and window factory
- [src/tabs](src/tabs): tab feature modules
- [src/init.lua](src/init.lua): main orchestrator entrypoint

## Build (Darklua)

1. One entry point (recommended):

   run.cmd dev

   run.cmd build

   run.cmd release

   run.cmd start

   run.cmd serve 8080

   run.cmd start 8080

2. Process source into output folder (manual):

   darklua process src build

3. Use explicit config (optional):

   darklua process --config .darklua.json src build

4. Watch mode while developing (manual):

   darklua process --watch src build

## Release One-File Output

1. One command release (recommended):

   run.cmd release

2. One command dev server:

   run.cmd start

3. Build processed files (manual):

   darklua process --config .darklua.json src build

4. Generate standalone release file:

   powershell -ExecutionPolicy Bypass -File tools/build-release.ps1

5. Output file is generated at [release/mahmut-hub.lua](release/mahmut-hub.lua).

## Localhost Development Loader

1. Use the single command:

   run.cmd start

2. This creates [live/src/main.lua](live/src/main.lua) and starts a local server. If port 8080 is busy, the server automatically tries the next free port.

3. Use this loader in development:

   loadstring(game:HttpGet("http://localhost:8080/src/main.lua"))()

   If the server falls back to another port, use the printed URL.

## Command Map

- `run.cmd dev` = watch mode, like `npm run dev`
- `run.cmd build` = one-time build to [build](build)
- `run.cmd release` = build + generate [release/mahmut-hub.lua](release/mahmut-hub.lua)
- `run.cmd start [port]` = build + publish + start localhost server
- `run.cmd serve 8080` = serve the existing [live](live) folder on a chosen port

## Notes

- The [wally.toml](wally.toml) is initialized with no external dependencies yet.
- Darklua config is in [.darklua.json](.darklua.json).
