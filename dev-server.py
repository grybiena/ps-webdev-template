import io
from aiohttp import web
import asyncio
from watchfiles import awatch
import subprocess

hostName = "192.168.1.165"
serverPort = 8080

async def index_handler(request):
    return web.Response(text=io.open("index.html","r").read(),content_type="text/html")

async def index_js_handler(request):
    return web.Response(text=io.open("index.js","r").read(),content_type="text/javascript")

async def websocket_handler(request):
    ws = web.WebSocketResponse()
    await ws.prepare(request)
    async for changes in awatch("./src"):
        subprocess.run(["spago","bundle-app"])
        await ws.send_str("file changed %s" % changes)
        break
    return ws


def create_runner():
    app = web.Application()
    app.add_routes([
        web.get('/',   index_handler),
        web.get('/index.js', index_js_handler),
        web.get('/ws', websocket_handler),
    ])
    return web.AppRunner(app)


async def start_server(host=hostName, port=serverPort):
    print("Server started http://%s:%s" % (hostName, serverPort))
    runner = create_runner()
    await runner.setup()
    site = web.TCPSite(runner, host, port)
    await site.start()


if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(start_server())
    loop.run_forever()
