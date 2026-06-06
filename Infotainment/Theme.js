// Theme.js

function bg(cDark, cLight)
{
    return darkMode ? cDark : cLight
}

function txt(dark, light) {
    return Theme.darkMode ? dark : light
}


// ======================================================
// CORE BACKGROUNDS
// ======================================================

function background() {
    return darkMode ? "#0b0f14": "#e9edf2"
}

function surface() {
    return darkMode ? "#1c2530" : "#ffffff"
}

function surface2() {
    return darkMode ? "#242f3b" : "#dfe7f0"
}

// ======================================================
// TEXT
// ======================================================

function textPrimary() {
    return darkMode ? "#ffffff" : "#1a1f26"
}

function textSecondary() {
    return darkMode ? "#9aa6b2" : "#5c6773"
}

// ======================================================
// UI ELEMENTS
// ======================================================

function border() {
    return darkMode ? "#2a3442" : "#e3e8ef"
}

function accent() {
    return "#2f80ff"
}

// ======================================================
// CARDS
// ======================================================

function card() {
    return darkMode ? "#1c2530" : "#ffffff"
}

function cardElevated() {
    return darkMode ? "#202b36" : "#f7f9fc"
}

// ======================================================
// HOVER
// ======================================================
function hovering()
{
    return darkMode? "#2a3644" : "#cfdae7"
}
