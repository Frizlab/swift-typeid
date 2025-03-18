# Tests Data

The data in the `Tests/Data` folder.

## `invalid-typeids.json`
The upstream provides a list of typeids that must be considered invalid, with the reason why it should.
The list is provided [as a YAML file](<https://github.com/jetpack-io/typeid-go/blob/main/testdata/invalid.yml>).

Swift does not have a builtin YAML parser.
(Personal Note: Thank God for that! Have you seen the specs of YAML? What a mess…)

To workaround the lack of parser, we convert the YAML file to a JSON file using `yj`, because Swift does have a JSON parser builtin.

We keep the original file for reference, but we could drop it altogether.

To update the files, run this:
```bash
curl --location https://github.com/jetpack-io/typeid-go/raw/main/testdata/invalid.yml >Docs/TestsData/upstream/invalid-typeids.yml
cat Docs/TestsData/upstream/invalid-typeids.yml | yj >Tests/Data/invalid-typeids.json
```

Of course, if we did not want to save the upstream file, we could do
```bash
curl --location https://github.com/jetpack-io/typeid-go/raw/main/testdata/invalid.yml | yj >Tests/Data/invalid-typeids.json
```

## `valid-typeids.json`
Same as above, but for the valid typeids.
```bash
curl --location https://github.com/jetpack-io/typeid-go/raw/main/testdata/valid.yml >Docs/TestsData/upstream/valid-typeids.yml
cat Docs/TestsData/upstream/valid-typeids.yml | yj >Tests/Data/valid-typeids.json
```
