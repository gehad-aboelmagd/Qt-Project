// WeatherService.js
.pragma library // <-- this is the key line, makes it a true singleton

var cityName = "Cairo"
var temperature = 0
var condition = ""
var humidity = 0
var windSpeed = 0
var vis = 0
var highTemp = "--"
var lowTemp = "--"
var feelsLike = "--"
var uvIndex = 0
var forecastData = []

var _callbacks = []

function onUpdate(cb) {
    _callbacks.push(cb)
}

function _notify() {
    for (var i = 0; i < _callbacks.length; i++)
        _callbacks[i]()
}

function fetchWeather() {
    var req = new XMLHttpRequest()

    req.onreadystatechange = function() {
        if (req.readyState === XMLHttpRequest.DONE) {
            if (req.status === 200) {
                _parse(req.responseText)
            } else {
                console.error("WeatherService: HTTP error", req.status)
            }
        }
    }

    req.open(
        "GET",
        "https://api.weatherapi.com/v1/forecast.json?key=ea923024c9434d8ea29100515262104&q=Cairo&days=3&aqi=no&alerts=no"
    )

    req.send()
}

function _parse(responseText) {
    try {
        var data = JSON.parse(responseText)

        if (data.error) {
            console.error("WeatherService API error:", data.error.message)
            return
        }

        cityName = data.location.name
        temperature = data.current.temp_c
        feelsLike = data.current.feelslike_c
        condition = data.current.condition.text
        humidity = data.current.humidity
        windSpeed = data.current.wind_kph
        vis = data.current.vis_km
        uvIndex = Math.round(data.current.uv)

        highTemp = data.forecast.forecastday[0].day.maxtemp_c
        lowTemp = data.forecast.forecastday[0].day.mintemp_c

        var dayNames = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat']
        var todayIdx = new Date().getDay()
        var newForecast = []

        for (var i = 0; i < data.forecast.forecastday.length; i++) {
            var fd = data.forecast.forecastday[i]

            newForecast.push({
                day: dayNames[(todayIdx + i) % 7],
                icon: _iconForCondition(fd.day.condition.text),
                high: Math.round(fd.day.maxtemp_c) + "°",
                low: Math.round(fd.day.mintemp_c) + "°",
                avgTemp: fd.day.avgtemp_c.toFixed(1)
            })
        }

        forecastData = newForecast
        _notify()

    } catch (e) {
        console.error("WeatherService: parse error", e)
    }
}

function _iconForCondition(cond) {
    cond = cond.toLowerCase()

    if (cond.includes("sunny")) return "☀️"
    if (cond.includes("clear")) return "🌙"
    if (cond.includes("partly cloudy")) return "⛅"
    if (cond.includes("cloudy")) return "☁️"
    if (cond.includes("rain")) return "🌧️"
    if (cond.includes("thunder")) return "⛈️"
    if (cond.includes("snow")) return "❄️"
    if (cond.includes("mist") || cond.includes("fog")) return "🌫️"

    return "🌤️"
}
