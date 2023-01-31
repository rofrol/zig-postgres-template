## Usage

Install postgresql, libpq etc. like described in https://github.com/rofrol/zig-postgres.

```shell
% mkdir deps
% cd deps
% git clone https://github.com/rofrol/zig-postgres
% cd ..
zig build run -Ddb=postgresql://rfrolow@localhost:5432/mydb
```
