# TranslitKit

[![Build Status](https://travis-ci.org/AnalyzePlatypus/TranslitKit.svg?branch=master)](https://travis-ci.org/AnalyzePlatypus/TranslitKit)
[![Code Climate](https://codeclimate.com/github/AnalyzePlatypus/TranslitKit/badges/gpa.svg)](https://codeclimate.com/github/AnalyzePlatypus/TranslitKit)
[![Coverage Status](https://coveralls.io/repos/github/AnalyzePlatypus/TranslitKit/badge.svg?branch=master)](https://coveralls.io/github/AnalyzePlatypus/TranslitKit?branch=master)
[![Inline docs](http://inch-ci.org/github/AnalyzePlatypus/TranslitKit.svg?branch=master)](http://inch-ci.org/github/AnalyzePlatypus/TranslitKit)

*TranslitKit* is a framework for Hebrew-English transliteration.

Example:
```ruby
  require 'translit_kit'
  word = HebrewWord.new "אַברָהָם"
  word.transliterate(:single)
  # => ["avrohom"]

  # Shortcut
  word.t(:single)
  # => ["avrohom"]
```
Transliteration is powered by _phoneme maps_, files that map between Hebrew _phonemes_, or units of sound, and English characters. (see below)

Three `phoneme_maps` are provided: `:long`, `:short`, and `:single`.
You can easily add your own (see below)

```ruby
word.t(:single)
# => ["avrohom"]
word.t(:short)
# => ["avroom", "avroam", "avroem", "avrohom", "avroham",
# "avrohem", "avraom", "avraam", "avraem", "avrahom",
# "avraham", "avrahem", "avreom", "avream", "avreem",
# "avrehom", "avreham", "avrehem" ]
word.t(:long)
# => ["avroom", "avrooom", "avroohm", ... ] # 5,997 more!
```

The default is `:short`:
```ruby
  word.t == word.t(:short)
  # => true
```
To get the total permutation count, call `HebrewWord#inspect`
```ruby
word.inspect
# => "אַברָהָם: Permutations: 1 single | 18 short | 6000 long"
```

## Adding Custom Phoneme maps
###### Format
_Phoneme Maps_ are simply JSON files, placed in the `lib/resources` directory.

The file should map between each `String` (the phonemes) and an `Array`s of replacement characters.

```json
{
  "ב": ["v"],
  "בּ": ["b", "bb"]
}
```

A _phoneme_ can be a Hebrew character `א`, _nekuda_ (`ָ`), or character with modifiers, such as a _dagesh_ (`בּ`). Keep in mind that many characters will be normalized (see below).

###### Installation
To install your custom map, place the file in `lib/resources`

Your file will be available as the symbol`:<filename>` without the `.json` extension.

Example: `klingon.json` becomes `:klingon`

Now you can use it anywhere:
```ruby
  word.transliterate(:klingon)
  # => (Results)
```

At present, your map will not display results in `HebrewWord#inspect`

## Appendix: Pre-Processing
When a word is transliterated, it is pre-processed to normalize certain characters.
Specifically:
* Whitespace is stripped
* The final letters `[םןךףץ]` are normalized to their standard forms 
* _CHATAF_ _nekudos_ `['ֲ','ֳ','ֱ']` are normalized to their standard forms
* Full _CHIRIK_, _TZEIREI_, and _CHOLOM_ _nekudos_ have their letters removed
* _DAGESH_ characters are removed from all but the characters `[בוכפת]`
