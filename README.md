# Pairs

Constraint solver for pairs

## Installation

```
gem install pairs
```

## Usage

Running the following file:

```ruby
require 'pairs'

pairs = Pairs.new do
  senior "Alice"
  senior "Brad"
  senior "Charles"
  senior "Debbie"

  junior "Edward"
  junior "Felicia"
  junior "Justin"

  constraint { |a, b| !(junior?(a) && junior?(b)) }
  together "Alice", "Edward"
  separate "Brad", "Felicia"
  alone "Justin"
end

pairs.solution.each do |pair|
  puts pair.join(' & ')
end
```

...could produce this output:

```
Felicia & Debbie
Charles & Brad
Edward & Alice
Justin
```
