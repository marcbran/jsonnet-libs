# rison

Jsonnet library that implements conversion to [rison](https://github.com/Nanonid/rison).

## Install

To add rison to a jsonnet project:

```console
jb install github.com/marcbran/jsonnet-libs/rison/gen/rison@main
```

## Usage

```jsonnet
// main.jsonnet
local rison = import 'github.com/marcbran/jsonnet-libs/rison/gen/rison/main.libsonnet';

rison({
    "menu": {
        "id": "file",
        "popup": {
            "menuitem": [
                {
                    "onclick": "CreateNewDoc()",
                    "value": "New"
                },
                {
                    "onclick": "OpenDoc()",
                    "value": "Open"
                },
                {
                    "onclick": "CloseDoc()",
                    "value": "Close"
                }
            ]
        },
        "value": "File"
    }
})
```

```shell
$ jsonnet -J vendor main.jsonnet

# (menu:(id:file,popup:(menuitem:!((onclick:'CreateNewDoc()',value:New),(onclick:'OpenDoc()',value:Open),(onclick:'CloseDoc()',value:Close))),value:File)))
```

## Example

You can find more examples in the [test cases](./test/main.jsonnet).
