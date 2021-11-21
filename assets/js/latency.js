async function measure(socket) {
    const initialTime = performance.now("timeStart")
    await socket.pushEventTo("#latency-monitor", "ping", null)
    const responseTime = performance.now("timeEnd")
    const latencyMs = responseTime - initialTime
    socket.pushEventTo("#latency-monitor", "latency", latencyMs)
    return latencyMs
}

module.exports = {measure}