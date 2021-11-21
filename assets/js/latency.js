async function measure(socket) {
    const initialTime = performance.now("timeStart")
    await socket.pushEventTo("#latency-monitor", "ping", null)
    const responseTime = performance.now("timeEnd")
    const latencyMs = Number.parseInt(responseTime - initialTime, 10)
    socket.pushEventTo("#latency-monitor", "latency", latencyMs)
    return latencyMs
}

module.exports = {measure}