# _expensely-backend_

## Prerequisites

- Git `2.39+`
- Ruby `3.2.1`

## Install & development

1. Clone repository and change directory


2. Check Ruby version

```bash
ruby -v
```

If the output does not start with something like `ruby 3.2.1 ...`, then install correct ruby version using [rbenv](https://github.com/rbenv/rbenv)

```bash
rbenv install 3.2.1
rbenv local 3.2.1 # set ruby version (optional)
```

3. Install dependencies

```bash
bundle install
```

4. Initialize the database

```bash
rails db:create
rails db:migrate
```

5. Serve

```bash
rails s
```

The backend should start running on `http://localhost:3000`

**OPTIONAL:** Start server on a different port rather than the default one

```bash
rails s -p <port_number>
```

The backend will now run on `http://localhost:<port_number>`
