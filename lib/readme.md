# How Transliteration Works

LectureLab uses a pile of helper classes to ease mass-editing strings

## The HebrewWord class

`HebrewWord` takes a a Hebrew word (with _nikkud_) and a _phoneme list_, which maps Hebrew phonemes (letters with optional modifiers) unto English characters.
(If phonemes are not supplied, it loads a default set. See the implementation)

Example:
```ruby
@phonemes = {"ב" => ["v"], "בּ" => ["b","bb"]}
h = new HebrewWord "בָּעוֹמֶר", @phonemes
h.transliterate
# => ...
```

Let's see the implementation:
```ruby
def transliterate list_name = nil
  Transliterator.new(@hebword, list_name).transliterate
end
```

`Hebrew` delegates the actual work to the `Transliterator` class.

## The Transliterator class


```ruby
class Transliterator
  def transliterate
    @permuter.permutations
  end
...
```

In the initializer:
```ruby
@permuter = Permuter.new
```

So HebrewWord delegates the actual permuting to the _Permuter_ class

## The Permuter class

The `Permuter` class is a general purpose object for generating combinations:
```ruby
p = Permuter.new
3.times { p.add_array [1,2,3] }


p.permutations
# => [1,1,1]
[1,1,2]
[1,1,3]
[1,2,3]
...
```

In our case, the arrays are the possible English letters for every Hebrew phoneme:

```ruby
def setup_permuter
  heb_letters.each do |heb_letter|
    @permuter.add_array @possible_english_letters[heb_letter]
  end
end
```
Suppose that:

```ruby
@possible_english_letters = {"ב" => ["v"], "בּ" => ["b","bb"]}
@possible_english_letters["בּ"]
# => "["b","bb"]"`
```

If the word contains the letter _'בּ'_, permutations will be generated containing both _'b'_ and _bb_.

###### And how does Permuter work?
`Permuter` uses a basic recursive strategy to generate the permutations.

From the implementation
```ruby
 private
  # permute (indices)
  # Recursively generate every permutation of the arrays (Courtesy of Ari Fordsham)
  #
  # The classic recursive permutation algorithm:
  # Imagine picking a combination lock: [0][0][0]
  # Each cylinder is the index to one of the arrays
  # On each recursion, we add another cylinder [0], [0][0], [0][0][0]
  # When we have enough cylinders, we generate the permutation (base case)
  # and iterate to the next value by dropping a cylinder, [0][0]
  # iterating the loop in else, and recursing again  [0][0][1]
  # Simple and elegant
  def permute indices
    # Base case
    if indices.length == @arrays.length
      build_permutation indices
    else
      @arrays[indices.length].each_with_index do |item,i|
        permute indices.dup << i
      end
    end
  end
```

## Summary

* Transliteration is performed en masse by the `Transliterator` plugin for `String Pipeline`
* `Transliterator` wraps the Hebrew plaintext in a `HebrewWord` object.
* `HebrewWord` uses the generic `Permuter` class to generate every possible permutation.

###### What happens next?
Once everything is done, the `Transliterator` hands a array of hashes back to the calling `StringPipeline`.
```ruby
# => ["<heb for shabbos>": ["shabes","shabb"], "heb for purim": ["purim", "poorim"]]
```

`StringPipeline` then logs the operation, collects statistics, and forwards the list into the `SynonymFileGenerator`, for generating a new synonym file.
The file is then installed in the database, and is ready for use.  
