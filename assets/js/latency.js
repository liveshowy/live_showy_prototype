async function measure(socket) {
    const targetElement = `#${socket.el.id}`
    const initialTime = performance.now("timeStart")
    await socket.pushEventTo(targetElement, "ping", null)
    const responseTime = performance.now("timeEnd")
    const latencyMs = Number.parseInt(responseTime - initialTime, 10)
    socket.pushEventTo(targetElement, "latency", latencyMs)
    return latencyMs
}

module.exports = {measure}
