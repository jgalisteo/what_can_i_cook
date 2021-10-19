# What can I cook?

Rails app to search recipes by a list of ingredients.

There is a demo running in https://secret-waters-21743.herokuapp.com/

## Configuration

Ensure that are installed:

- ruby 3.0.2
- node 14.16.0
- postgresql 12.8

The first step is to install `bundler` and ruby dependencies:

```
gem install bundler
bundle install
```

The next step is to setup the database:

```
bundle exec rails db:migrate
```

Finally, start development server:

```
bundle exec rails server
```

And visit http://localhost:3000

### Database seed

Recipes can be inserted into the datebase with a rails task and a JSON file. The entry format is
described in the [python-marmiton README](https://github.com/remaudcorentin-dev/python-marmiton#marmitonget-return-a-dictionary-like-).

There is an example file in `examples` directory in the root of this repository:

```
bundle exec rails db:insert_json_recipes[examples/recipes.json]
```

## Tests

For running tests:

```
bundle exec rspec
```
