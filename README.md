![icon](TrueColors/Resources/Images.xcassets/AppIcon.appiconset/icon_256x256.png)

[![Build Status](https://travis-ci.org/vokal/TrueColors-macOS.svg?branch=master)](https://travis-ci.org/vokal/TrueColors-macOS) [![line cvr](https://cvr.vokal.io/vokal/TrueColors-macOS/shield.svg)](https://cvr.vokal.io/repo/vokal/TrueColors-macOS)


# TrueColors

A Mac app for designers to specify colors, fonts, and metrics in a standardized format for developers to consume.

## CyndiLauper
A Cocoa library for handling `.truecolors` files and the data contained therein.  To install
it, simply add the following line to your Podfile:

```ruby
pod "CyndiLauper"
```

## License

TrueColors and the included CyndiLauper library are both released under the MIT license.

> The MIT License (MIT)
> 
> Copyright (c) 2016 Vokal
> 
> Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
> 
> The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


## Related Projects
- [DevsJustWantToHaveFun](https://github.com/vokal/DevsJustWantToHaveFun-macOS): A Mac tool to generate iOS code from the design elements in a `.truecolors` file.
- [android-res-gen](https://github.com/vokal/android-res-gen): Automatic resource exporter plugin for android projects, including generating styles from a `.truecolors` file.
- [TrueColors-LESS](https://github.com/vokal/TrueColors-LESS): A tool for the Web team to use to generate whatever they need from `.truecolors` files.


## `.truecolors` File Format

### A Zip Archive
The extension `.truecolors` is associated with and opened/edited by TrueColors.  A `.truecolors` file is a zip archive containing:
- top-level directory (named the same as the file was when it was saved, though not necessarily the same as the file's current name as the file could be renamed after saving)
	- `fonts` subdirectory: contains all of the font files referenced in `data.json`
	- `flat-data.json`: the flattened data structure of all the colors, metrics, and fonts
	- `data.json`: the hierarchical data structure of all the colors, metrics, and fonts

### JSON Data Files

In general, the keys within a JSON object are not guaranteed to have any particular ordering.

Both `.json` files have the structure:
```json
{
  "colors" : [
    ...
  ],
  "metrics" : [
    ...
  ],
  "fonts" : [
    ...
  ]
}
```

#### Items
Each of the `colors`, `metrics`, and `fonts` arrays consists of objects with keys:
- `name`: the individual item name; may not be unique overall, but should be unique within its container
- `path` (only present in the flattened data): an array of names from the top-level container to the specific item's name; should be unique within its type (`colors`, `metrics`, `fonts`)
- `values` (only present on items that contain other items): an array of items contained by this item; container items are not present in the flattened data.

##### Colors
Color items also have:
- `rgba`: the eight-character hex representation of the color, with alpha (RRGGBBAA)

##### Metrics
Metric items also have:
- `value`: the (integer) value for the metric

##### Fonts
Font items also have:
- `font_name`: the name of the font face (e.g., `Gudea`, `Gudea-Bold`)
- `file_name`: the file name of the font file for this font (e.g., `Gudea-Regular.ttf`, `Gudea-Bold.ttf`)
- `size_path`: the path (see `path`, above) to the metric to use for the size of this font style
- `color_path`: the path (see `path`, above) to the color to use for this font style

#### Examples

##### `data.json`
```json
{
  "metrics" : [
    {
      "name" : "small text",
      "value" : 12
    },
    {
      "name" : "large text",
      "value" : 24
    }
  ],
  "fonts" : [
    {
      "name" : "headings",
      "values" : [
        {
          "color_path" : [
            "point",
            "x"
          ],
          "size_path" : [
            "small text"
          ],
          "name" : "small",
          "font_name" : "Gudea",
          "file_name" : "Gudea-Regular.ttf"
        },
        {
          "color_path" : [
            "point",
            "y"
          ],
          "size_path" : [
            "large text"
          ],
          "name" : "large",
          "font_name" : "Gudea-Bold",
          "file_name" : "Gudea-Bold.ttf"
        }
      ]
    }
  ],
  "colors" : [
    {
      "name" : "test",
      "rgba" : "#800000FF"
    },
    {
      "name" : "point",
      "values" : [
        {
          "name" : "x",
          "rgba" : "#0080FFFF"
        },
        {
          "name" : "y",
          "rgba" : "#FFCC66FF"
        }
      ]
    }
  ]
}
```

##### `flat-data.json`
```json
{
  "metrics" : [
    {
      "name" : "small text",
      "value" : 12,
      "path" : [
        "small text"
      ]
    },
    {
      "name" : "large text",
      "value" : 24,
      "path" : [
        "large text"
      ]
    }
  ],
  "fonts" : [
    {
      "path" : [
        "headings",
        "small"
      ],
      "color_path" : [
        "point",
        "x"
      ],
      "size_path" : [
        "small text"
      ],
      "name" : "small",
      "font_name" : "Gudea",
      "file_name" : "Gudea-Regular.ttf"
    },
    {
      "path" : [
        "headings",
        "large"
      ],
      "color_path" : [
        "point",
        "y"
      ],
      "size_path" : [
        "large text"
      ],
      "name" : "large",
      "font_name" : "Gudea-Bold",
      "file_name" : "Gudea-Bold.ttf"
    }
  ],
  "colors" : [
    {
      "name" : "test",
      "rgba" : "#800000FF",
      "path" : [
        "test"
      ]
    },
    {
      "name" : "x",
      "rgba" : "#0080FFFF",
      "path" : [
        "point",
        "x"
      ]
    },
    {
      "name" : "y",
      "rgba" : "#FFCC66FF",
      "path" : [
        "point",
        "y"
      ]
    }
  ]
}
```
