## Usage

Install postgresql, libpq etc. like described in https://github.com/zig-postgres/zig-postgres.

You need to create some database, i.e. `mydb`.

```shell
% zig build run -Ddb=postgresql://rfrolow@localhost:5432/mydb
```
