-- plugins/init.lua - 自动扫描插件配置（简化版本）
local M = {}

-- 默认配置
local default_config = {
    -- 是否启用调试输出
    debug = false,
    -- 需要跳过的目录
    skip_dirs = { "snippets" },
    -- 默认包含的插件
    default_plugins = { "folke/lazy.nvim" },
    -- 插件配置目录（相对于 lua/ 目录）
    plugin_dir = "plugins"
}

-- 全局配置，可以在外部设置
_G.auto_plugin_config = _G.auto_plugin_config or {}

-- 合并配置
local function get_config()
    return vim.tbl_deep_extend("force", default_config, _G.auto_plugin_config)
end

-- 调试输出函数
local function debug_print(...)
    local config = get_config()
    if config.debug then
        print("🔧[Plugin Loader]", ...)
    end
end

-- 安全加载函数（简化版本）
local function safe_require(module_name)
    debug_print("🔄 开始加载:", module_name)

    local ok, result = pcall(require, module_name)

    if not ok then
        debug_print("❌ 加载失败:", module_name)
        debug_print("  错误信息:", result)
        vim.notify("Failed to load: " .. module_name .. "\nError: " .. result, vim.log.levels.ERROR)
        return {}
    end

    debug_print("✅ 加载成功:", module_name, "类型:", type(result))

    -- 确保返回值是表格
    if type(result) ~= "table" then
        debug_print("⚠️ 返回类型错误:", module_name, "期望 table，得到:", type(result))
        vim.notify("Warning: " .. module_name .. " did not return a table, got: " .. type(result), vim.log.levels.WARN)
        return {}
    end

    local table_length = #result
    debug_print("📊 表格分析:", module_name, "数组长度:", table_length)

    -- 情况1：检查是否有插件属性（单个插件配置）
    local plugin_attrs = {
        -- 基本属性
        "name", "url", "dir", "pin",
        -- 加载相关
        "lazy", "enabled", "cond", "dependencies",
        -- 触发相关  
        "ft", "cmd", "event", "keys", "init", 
        -- 配置相关
        "opts", "config", "main", "build",
        -- 版本相关
        "tag", "branch", "commit", "version",
        -- 其他
        "priority", "dev", "submodules"
    }

    for _, key in ipairs(plugin_attrs) do
        if result[key] ~= nil then
            debug_print("📦 检测到插件属性:", key, "，包装为数组")
            return { result }
        end
    end

    -- 情况2：是插件数组 (长度 > 0)
    if table_length > 0 then
        debug_print("📦 插件数组，包含", table_length, "个插件")
        return result
    end

    -- 情况3：空表或无法识别的格式
    debug_print("⚠️ 空表或无效配置:", module_name)
    return {}
end

-- 检查是否应该跳过某个目录
local function should_skip_dir(dir_name, config)
    for _, skip_dir in ipairs(config.skip_dirs) do
        if dir_name == skip_dir then
            return true
        end
    end
    return false
end

-- 递归扫描目录，获取所有 .lua 文件
local function scan_directory(path, relative_path, config)
    local files = {}
    relative_path = relative_path or ""

    debug_print("扫描目录:", path, "相对路径:", relative_path)

    local handle = vim.loop.fs_scandir(path)
    if not handle then
        debug_print("❌ 无法打开目录:", path)
        return files
    end

    while true do
        local name, type = vim.loop.fs_scandir_next(handle)
        if not name then break end

        local full_path = path .. "/" .. name
        local module_path = relative_path == "" and name or (relative_path .. "." .. name)

        if type == "file" and name:match("%.lua$") and name ~= 'init.lua' then
            -- 是 .lua 文件
            local module_name = name:gsub("%.lua$", "")
            local final_module_path = relative_path == "" and module_name or (relative_path .. "." .. module_name)
            debug_print("📄 找到插件配置文件:", final_module_path)
            table.insert(files, final_module_path)

        elseif type == "directory" and not should_skip_dir(name, config) then
            -- 递归扫描子目录
            debug_print("📁 进入子目录:", name)
            local sub_files = scan_directory(full_path, module_path, config)
            for _, file in ipairs(sub_files) do
                table.insert(files, file)
            end
        elseif type == "directory" and should_skip_dir(name, config) then
            debug_print("⏭️ 跳过目录:", name)
        end
    end

    return files
end

-- 加载插件配置（使用 safe_require）
local function load_plugin_config(module_path, config)
    local full_module_path = config.plugin_dir .. "." .. module_path
    return safe_require(full_module_path)
end

-- 主函数：自动扫描并加载所有插件
function M.setup(user_config)
    -- 合并用户配置
    if user_config then
        _G.auto_plugin_config = vim.tbl_deep_extend("force", _G.auto_plugin_config, user_config)
    end

    local config = get_config()
    debug_print("🚀 开始自动扫描插件配置")
    debug_print("配置:", vim.inspect(config))

    -- 初始化插件列表
    local plugins = {}
    for _, plugin in ipairs(config.default_plugins) do
        table.insert(plugins, plugin)
    end

    local config_path = vim.fn.stdpath("config") .. "/lua/" .. config.plugin_dir
    debug_print("📂 插件配置目录:", config_path)

    -- 检查plugins目录是否存在
    if vim.fn.isdirectory(config_path) == 0 then
        debug_print("❌ 插件目录不存在:", config_path)
        vim.notify("Plugins directory not found: " .. config_path, vim.log.levels.ERROR)
        return plugins
    end

    -- 扫描所有插件配置文件
    local plugin_modules = scan_directory(config_path, "", config)
    debug_print("📋 找到", #plugin_modules, "个插件配置模块:", table.concat(plugin_modules, ", "))

    -- 加载每个插件配置
    for _, module_path in ipairs(plugin_modules) do
        local plugin_config = load_plugin_config(module_path, config)

        -- 合并到主插件列表（safe_require 已经返回数组格式）
        for _, plugin in ipairs(plugin_config) do
            table.insert(plugins, plugin)
        end
    end

    debug_print("🎉 总共加载了", #plugins, "个插件")

    if config.debug then
        debug_print("插件列表:")
        for i, plugin in ipairs(plugins) do
            if type(plugin) == "string" then
                debug_print(string.format("  %d. %s", i, plugin))
            elseif type(plugin) == "table" and plugin[1] then
                debug_print(string.format("  %d. %s", i, plugin[1]))
            else
                debug_print(string.format("  %d. %s", i, vim.inspect(plugin)))
            end
        end

        -- 检查返回值类型
        debug_print("\n📤 返回值类型检查:")
        debug_print("  返回类型:", type(plugins))
        debug_print("  是否为数组:", #plugins > 0)
        if #plugins > 0 then
            debug_print("  第一个元素类型:", type(plugins[1]))
        end
    end

    return plugins
end

-- 提供配置接口
function M.config(user_config)
    _G.auto_plugin_config = vim.tbl_deep_extend("force", _G.auto_plugin_config or {}, user_config)
end

return M.setup()
