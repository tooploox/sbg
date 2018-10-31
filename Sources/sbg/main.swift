import SBGCore

let appBuilder = ApplicationBuilder()
let app = appBuilder.build()
do {
    try app.run()
} catch {
    print(error)
}