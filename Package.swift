// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "",
  products: [
    .library(
      name: "nback",
      targets: ["nback"])
  ],
  targets: [
    .target(
      name: "nback", path: "Source", exclude: ["Info.plist"])
  ]
)
