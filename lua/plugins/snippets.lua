return function()
  local ok, ls = pcall(require, "luasnip")
  if not ok then return end

  local csharp_snippets = {
    -- Classes & Structs
    ls.parser.parse_snippet({ trig = "class", name = "class" }, "public class ${1:ClassName}\n{\n\t${0}\n}"),
    ls.parser.parse_snippet({ trig = "record", name = "record" }, "public record ${1:RecordName}(${2:parameters});"),
    ls.parser.parse_snippet({ trig = "struct", name = "struct" }, "public struct ${1:StructName}\n{\n\t${0}\n}"),
    ls.parser.parse_snippet({ trig = "interface", name = "interface" }, "public interface ${1:IInterfaceName}\n{\n\t${0}\n}"),

    -- Properties
    ls.parser.parse_snippet({ trig = "prop", name = "prop" }, "public ${1:string} ${2:PropertyName} { get; set; }"),
    ls.parser.parse_snippet({ trig = "propg", name = "propg" }, "public ${1:string} ${2:PropertyName} { get; private set; }"),
    ls.parser.parse_snippet({ trig = "propi", name = "propi" }, "public ${1:string} ${2:PropertyName} { get; init; }"),
    ls.parser.parse_snippet({ trig = "propfull", name = "propfull" }, "private ${1:string} ${2:_field};\n\npublic ${1:string} ${3:PropertyName}\n{\n\tget => ${2:_field};\n\tset => ${2:_field} = value;\n}"),

    -- Constructor & Methods
    ls.parser.parse_snippet({ trig = "ctor", name = "ctor" }, "public ${1:ClassName}(${2:parameters})\n{\n\t${0}\n}"),
    ls.parser.parse_snippet({ trig = "method", name = "method" }, "public ${1:void} ${2:MethodName}(${3:parameters})\n{\n\t${0}\n}"),
    ls.parser.parse_snippet({ trig = "async_method", name = "async_method" }, "public async Task<${1:T}> ${2:MethodName}Async(${3:parameters})\n{\n\t${0}\n}"),

    -- Console
    ls.parser.parse_snippet({ trig = "cw", name = "cw" }, "Console.WriteLine(${0});"),
    ls.parser.parse_snippet({ trig = "cr", name = "cr" }, "Console.ReadLine();"),
    ls.parser.parse_snippet({ trig = "cw_format", name = "cw_format" }, 'Console.WriteLine($"${0}");'),

    -- Control Flow
    ls.parser.parse_snippet({ trig = "if", name = "if" }, "if (${1:condition})\n{\n\t${0}\n}"),
    ls.parser.parse_snippet({ trig = "ifelse", name = "ifelse" }, "if (${1:condition})\n{\n\t${2}\n}\nelse\n{\n\t${0}\n}"),
    ls.parser.parse_snippet({ trig = "switch", name = "switch" }, "switch (${1:value})\n{\n\tcase ${2:pattern}:\n\t\t${0}\n\t\tbreak;\n\tdefault:\n\t\tbreak;\n}"),
    ls.parser.parse_snippet({ trig = "switchexp", name = "switchexp" }, "var ${1:result} = ${2:value} switch\n{\n\t${3:pattern} => ${4:result},\n\t_ => ${0:default}\n};"),

    -- Loops
    ls.parser.parse_snippet({ trig = "for", name = "for" }, "for (int ${1:i} = 0; ${1:i} < ${2:length}; ${1:i}++)\n{\n\t${0}\n}"),
    ls.parser.parse_snippet({ trig = "foreach", name = "foreach" }, "foreach (var ${1:item} in ${2:collection})\n{\n\t${0}\n}"),
    ls.parser.parse_snippet({ trig = "while", name = "while" }, "while (${1:condition})\n{\n\t${0}\n}"),
    ls.parser.parse_snippet({ trig = "dowhile", name = "dowhile" }, "do\n{\n\t${0}\n} while (${1:condition});"),

    -- LINQ
    ls.parser.parse_snippet({ trig = "linq", name = "linq" }, "var ${1:query} = ${2:collection}\n\t.Where(${3:x} => ${4:condition})\n\t.Select(${5:x} => ${6:projection});"),
    ls.parser.parse_snippet({ trig = "linq_order", name = "linq_order" }, "var ${1:query} = ${2:collection}\n\t.Where(${3:x} => ${4:condition})\n\t.OrderBy(${5:x} => ${6:key})\n\t.Select(${7:x} => ${8:projection});"),
    ls.parser.parse_snippet({ trig = "linq_join", name = "linq_join" }, "var ${1:query} = from ${2:x} in ${3:collection1}\n\tjoin ${4:y} in ${5:collection2} on ${2:x}.${6:key1} equals ${4:y}.${7:key2}\n\tselect new { ${2:x}, ${4:y} };"),

    -- Lambda
    ls.parser.parse_snippet({ trig = "lambda", name = "lambda" }, "(${1:parameters}) => ${2:expression}"),
    ls.parser.parse_snippet({ trig = "lambda_body", name = "lambda_body" }, "(${1:parameters}) =>\n{\n\t${0}\n}"),
    ls.parser.parse_snippet({ trig = "func", name = "func" }, "Func<${1:TInput}, ${2:TOutput}> ${3:name} = (${4:x}) => ${5:expression};"),
    ls.parser.parse_snippet({ trig = "action", name = "action" }, "Action<${1:T}> ${2:name} = (${3:x}) => ${4:expression};"),

    -- Exception
    ls.parser.parse_snippet({ trig = "try", name = "try" }, "try\n{\n\t${0}\n}\ncatch (${1:Exception} ${2:ex})\n{\n\t${3}\n}"),
    ls.parser.parse_snippet({ trig = "tryf", name = "tryf" }, "try\n{\n\t${0}\n}\ncatch (${1:Exception} ${2:ex})\n{\n\t${3}\n}\nfinally\n{\n\t${4}\n}"),

    -- Patterns
    ls.parser.parse_snippet({ trig = "singleton", name = "singleton" }, "private static readonly ${1:ClassName} _instance = new ${1:ClassName}();\npublic static ${1:ClassName} Instance => _instance;\nprivate ${1:ClassName}() { }"),
    ls.parser.parse_snippet({ trig = "dispose", name = "dispose" }, "public void Dispose()\n{\n\t${0}\n\tGC.SuppressFinalize(this);\n}"),

    -- Tests
    ls.parser.parse_snippet({ trig = "fact", name = "fact" }, "[Fact]\npublic void ${1:TestMethodName}()\n{\n\t// Arrange\n\t${2}\n\n\t// Act\n\t${3}\n\n\t// Assert\n\t${0}\n}"),
    ls.parser.parse_snippet({ trig = "theory", name = "theory" }, "[Theory]\n[InlineData(${1:data})]\npublic void ${2:TestMethodName}(${3:parameters})\n{\n\t${0}\n}"),
  }

  ls.add_snippets("cs", csharp_snippets)
end
