const fs = require("fs");

function rgb2hsv(rI, gI, bI) {
  const r = rI / 255;
  const g = gI / 255;
  const b = bI / 255;

  let v = Math.max(r, g, b),
    c = v - Math.min(r, g, b);
  let h =
    c && (v == r ? (g - b) / c : v == g ? 2 + (b - r) / c : 4 + (r - g) / c);
  return [(60 * (h < 0 ? h + 6 : h)) / 360, v && c / v, v];
}

const contents = fs.readFileSync("./colourlist.txt").toString();

const prefix = `import Foundation

extension SColor {
`;

const suffix = `}
`;

let output = "";
output += prefix;

contents.split("\n").map((line) => {
  const [name, components] = line.split(/\s/);
  const [r, g, b] = components.split(",").map((c) => parseInt(c));
  const [h, s, v] = rgb2hsv(r, g, b);

  output += `  public static let ${name} = SColor(hue: ${h}, saturation: ${s}, brightness: ${v})\n`;
});

output += suffix;

fs.writeFileSync("SColor+Named.swift", output);
