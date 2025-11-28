local cmd = require("cmd")
local file = require("file")

--- Called after the tool is installed.
--- Used for additional setup like extracting pkg files on macOS.
--- @param ctx table
--- @field ctx.rootPath string Installation directory
function PLUGIN:PostInstall(ctx)
    local os_type = RUNTIME.osType
    local root_path = ctx.rootPath

    if os_type == "darwin" then
        -- On macOS, the download is a .pkg file that needs to be extracted
        -- Find the pkg file using shell
        local find_result = cmd.exec("ls " .. root_path .. "/*.pkg 2>/dev/null || true")
        local pkg_file = find_result:match("([^\n]+%.pkg)")

        if pkg_file then
            local extracted_dir = root_path .. "/extracted"

            -- Expand the pkg
            cmd.exec("pkgutil --expand \"" .. pkg_file .. "\" \"" .. extracted_dir .. "\"")

            -- Extract the payload using cpio
            local payload = extracted_dir .. "/op.pkg/Payload"
            if file.exists(payload) then
                cmd.exec("cd \"" .. root_path .. "\" && cpio -i -F \"" .. payload .. "\" 2>/dev/null")
            end

            -- Clean up
            cmd.exec("rm -f \"" .. pkg_file .. "\"")
            cmd.exec("rm -rf \"" .. extracted_dir .. "\"")
        end
    end

    -- Ensure op is executable
    local op_path = root_path .. "/op"
    if file.exists(op_path) then
        cmd.exec("chmod +x \"" .. op_path .. "\"")
    end
end
