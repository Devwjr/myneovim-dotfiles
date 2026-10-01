return {
    "mfussenegger/nvim-dap",
    dependencies = { "nvim-neotest/nvim-nio" },

    config = function()
        local dap = require("dap")
        local uv = vim.uv or vim.loop

        local function file_exists(path)
            return path and uv.fs_stat(path) ~= nil
        end

        local function is_executable(path)
            return file_exists(path) and vim.fn.executable(path) == 1
        end

        local function workspace_root()
            local current = vim.api.nvim_buf_get_name(0)
            local root_markers = {
                ".git",
                "compile_commands.json",
                "CMakeLists.txt",
                "Cargo.toml",
                "Makefile",
            }

            local root = vim.fs.dirname(vim.fs.find(root_markers, {
                path = current ~= "" and current or vim.fn.getcwd(),
                upward = true,
            })[1] or "")

            return root ~= "" and root or vim.fn.getcwd()
        end

        local function pick_cpp_binary()
            local cwd = workspace_root()
            local current = vim.api.nvim_buf_get_name(0)
            local stem = vim.fn.fnamemodify(current, ":t:r")
            local candidates = {
                cwd .. "/" .. stem,
                cwd .. "/build/" .. stem,
                cwd .. "/bin/" .. stem,
                cwd .. "/build/debug/" .. stem,
                cwd .. "/build/Debug/" .. stem,
                cwd .. "/out/" .. stem,
            }

            for _, candidate in ipairs(candidates) do
                if is_executable(candidate) then
                    vim.notify("DAP launching " .. candidate, vim.log.levels.INFO)
                    return candidate
                end
            end

            local picked = vim.fn.input("Path to executable: ", cwd .. "/", "file")
            if picked == "" then
                vim.notify("DAP launch cancelled: no executable selected", vim.log.levels.WARN)
                return nil
            end
            if not is_executable(picked) then
                vim.notify("DAP launch aborted: not executable: " .. picked, vim.log.levels.ERROR)
                return nil
            end
            return picked
        end

        local function split_args(input)
            local args = {}
            for arg in string.gmatch(input, "%S+") do
                table.insert(args, arg)
            end
            return args
        end

        local function prompt_args()
            return split_args(vim.fn.input("Program arguments: "))
        end

        local lldb_dap = vim.fn.exepath("lldb-dap")
        local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
        local codelldb = vim.fn.exepath("codelldb")
        if codelldb == "" then
            codelldb = mason_bin .. "/codelldb"
        end

        -----------------------------------------------------------------------
        -- Adapter setup
        -----------------------------------------------------------------------
        if lldb_dap ~= "" then
            dap.adapters.lldb = {
                type = "executable",
                command = lldb_dap,
                name = "lldb",
            }
        elseif codelldb ~= "" then
            dap.adapters.lldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = codelldb,
                    args = { "--port", "${port}" },
                },
            }
        else
            vim.notify(
                "No C/C++ DAP adapter found. Install `lldb-dap` or `codelldb`.",
                vim.log.levels.WARN
            )
        end

        -----------------------------------------------------------------------
        -- Debug configurations for C, C++, Rust
        -----------------------------------------------------------------------
        local cpp_configurations = {
            {
                name = "Launch",
                type = "lldb",
                request = "launch",
                program = pick_cpp_binary,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
            },
            {
                name = "Launch with args",
                type = "lldb",
                request = "launch",
                program = pick_cpp_binary,
                args = prompt_args,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
            },
            {
                name = "Attach to process",
                type = "lldb",
                request = "attach",
                pid = require("dap.utils").pick_process,
                cwd = "${workspaceFolder}",
            },
        }

        dap.configurations.cpp = cpp_configurations
        dap.configurations.c = cpp_configurations
        dap.configurations.rust = cpp_configurations

        -----------------------------------------------------------------------
        -- Adapters for other languages (resolved via Mason)
        -----------------------------------------------------------------------
        local function mason_path(name)
            local p = mason_bin .. "/" .. name
            return (is_executable(p) or file_exists(p)) and p or vim.fn.exepath(name)
        end

        -- Python (debugpy)
        local python = mason_path("debugpy-adapter")
        if python ~= "" then
            dap.adapters.python = {
                type = "executable",
                command = python,
                args = {},
            }
            dap.configurations.python = {
                {
                    type = "python",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    cwd = "${workspaceFolder}",
                    console = "integratedTerminal",
                    justMyCode = false,
                },
            }
        end

        -- Go (delve)
        local go = mason_path("dlv")
        if go == "" then
            go = mason_bin .. "/dlv"
        end
        if file_exists(go) or go ~= "" and vim.fn.executable(go) == 1 then
            dap.adapters.dlv = {
                type = "server",
                port = "${port}",
                executable = { command = go, args = { "dap", "-l", "127.0.0.1:${port}" } },
            }
            dap.configurations.go = {
                {
                    type = "dlv",
                    request = "launch",
                    name = "Debug",
                    program = "${fileDirname}",
                    cwd = "${workspaceFolder}",
                },
            }
        end

        -- JavaScript / TypeScript (js-debug-adapter via node)
        local jsd = mason_path("js-debug-adapter")
        if jsd ~= "" then
            dap.adapters.node2 = {
                type = "executable",
                command = "node",
                args = { jsd, "${port}" },
            }
            dap.configurations.javascript = {
                {
                    type = "node2",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    cwd = "${workspaceFolder}",
                },
            }
            dap.configurations.typescript = dap.configurations.javascript
        end

        -- Java (java-debug-adapter via java)
        local java_jar = vim.fn.stdpath("data")
            .. "/mason/packages/java-debug-adapter/extension/server/"
        local java_plugin = vim.fn.stdpath("data")
            .. "/mason/packages/java-test/extension/server/"
        local function glob_first(dir, pattern)
            local glob = vim.fn.glob(vim.fs.joinpath(dir, pattern))
            if glob ~= "" then
                return glob, true
            end
            return nil, false
        end

        if file_exists(vim.fn.stdpath("data") .. "/mason/bin/java-debug-adapter") or vim.fn.executable("java") == 1 then
            local jar, ok_jar = glob_first(java_jar, "*.jar")
            if ok_jar then
                local java_cmd = "java"
                dap.adapters.java = {
                    type = "executable",
                    command = java_cmd,
                    args = {
                        "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005",
                        "-jar",
                        jar,
                    },
                }
                local plugin, ok_plugin = glob_first(java_plugin, "*.jar")
                local sep = package.config:sub(1, 1) == "\\" and ";" or ":"
                local args = { "-cp", jar }
                if ok_plugin then
                    args = {
                        "-cp",
                        vim.fn.join({ jar, plugin }, sep),
                        "com.microsoft.java.debug.core.Main",
                    }
                end
                dap.configurations.java = {
                    {
                        type = "java",
                        request = "launch",
                        name = "Debug (Attach) - Remote",
                        hostName = "127.0.0.1",
                        port = 5005,
                    },
                    {
                        type = "java",
                        request = "attach",
                        name = "Attach to process",
                        hostName = "127.0.0.1",
                        port = 5005,
                    },
                }
                _ = args
            end
        end

        -- C# / .NET (netcoredbg)
        local cs = mason_path("netcoredbg")
        if cs ~= "" then
            dap.adapters.netcoredbg = {
                type = "executable",
                command = cs,
                args = { "--interpreter=vscode" },
            }
            dap.configurations.cs = {
                {
                    type = "netcoredbg",
                    request = "launch",
                    name = "Launch (netcoredbg)",
                    program = function()
                        return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                },
            }
            dap.configurations.fsharp = dap.configurations.cs
            dap.configurations.vb = dap.configurations.cs
        end

        -----------------------------------------------------------------------
        -- Keybindings
        -----------------------------------------------------------------------
        vim.keymap.set("n", "<leader>dc", dap.continue,          { desc = "Continue" })
        vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Breakpoint" })
        vim.keymap.set("n", "<leader>ds", dap.step_over,         { desc = "Step Over" })
        vim.keymap.set("n", "<leader>di", dap.step_into,         { desc = "Step Into" })
        vim.keymap.set("n", "<leader>do", dap.step_out,          { desc = "Step Out" })
        vim.keymap.set("n", "<leader>dr", dap.restart,           { desc = "Restart" })
        vim.keymap.set("n", "<leader>dt", dap.terminate,         { desc = "Terminate" })
    end,
}
