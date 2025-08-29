function detect_osname()
    local os_name = os.getenv("OS") or os.getenv("OSTYPE") or "unknown"
    local os_name = os.getenv("OS") or os.getenv("OSTYPE") or "unknown"
    if os_name == "Windows_NT" then
        os_name = "Windows"
    elseif os_name:match("linux") then
        os_name = "Linux"
    elseif os_name:match("darwin") then
        os_name = "macOS"
    else
        -- Fallback: try uname
        local f = io.popen("uname -s 2>/dev/null", "r")
        if f then
            local uname = f:read("*a"):gsub("\n", "")
            f:close()
            if uname == "Darwin" then
                os_name = "macOS"
            elseif uname == "Linux" then
                os_name = "Linux"
            else
                os_name = uname
            end
        end
    end
    return os_name
end
function print_os_info()
    print("=== OS INFORMATION DUMP ===\n")

    -- 1. Detect OS Name
    local os_name = os_name
    print("OS Name:", os_name)

    -- 2. Detect Architecture
    local arch = os.getenv("PROCESSOR_ARCHITECTURE") or os.getenv("MACHTYPE")
    if not arch then
        local f = io.popen("uname -m 2>/dev/null", "r")
        if f then
            arch = f:read("*a"):gsub("\n", "")
            f:close()
        end
    end
    arch = arch or "unknown"
    print("Architecture:", arch)

    -- 3. Current Working Directory
    local cwd = os.getenv("PWD") or os.getenv("CD")
    if not cwd then
        local f = io.popen("pwd 2>/dev/null", "r")
        if f then
            cwd = f:read("*a"):gsub("\n", "")
            f:close()
        end
    end
    cwd = cwd or "N/A"
    print("Current Directory:", cwd)

    -- 4. Current Time & Date
    local now = os.date("*t")
    print("Current Time:", os.date("%Y-%m-%d %H:%M:%S"))
    -- print("Year:", now.year)
    -- print("Month:", now.month)
    -- print("Day:", now.day)
    -- print("Hour:", now.hour)
    -- print("Minute:", now.minute)
    -- print("Second:", now.second)
    --
    -- 5. Common Environment Variables
    local env_vars = {
        "HOME",
        "USER",
        "USERNAME",
        "PATH",
        "LANG",
        "SHELL",
        "USERPROFILE",  -- Windows
    }

    print("\n=== Environment Variables ===")
    for _, var in ipairs(env_vars) do
        local val = os.getenv(var)
        if val then
            print(string.format("%-12s : %s", var, val))
        else
            print(string.format("%-12s : [not set]", var))
        end
    end

    -- 6. OS-Specific Detection
    print("\n=== OS-SPECIFIC DETECTION ===")
    if os_name == "Windows" then
        print("Detected: Windows")
    elseif os_name == "Linux" or os_name == "macOS" then
        print("Detected: Unix-like OS")
    else
        print("Unknown OS type")
    end

    -- 7. OS Version (Linux / macOS)
    if os_name == "Linux" then
        local f = io.popen("cat /etc/os-release 2>/dev/null", "r")
        if f then
            local content = f:read("*a")
            f:close()
            local pretty = content:match('PRETTY_NAME="([^"]+)"')
            print("OS Version (from /etc/os-release):", pretty or "Unknown")
        end
    elseif os_name == "macOS" then
        local f = io.popen("sw_vers -productVersion", "r")
        if f then
            local ver = f:read("*a"):gsub("\n", "")
            f:close()
            print("macOS Version:", ver)
        end
    end

    -- 8. Lua Info
    print("\n=== Lua Info ===")
    print("Lua Version:", _VERSION)
    print("Lua Implementation:", jit and "LuaJIT" or "Standard Lua")

    print("\n=== END OF REPORT ===")
end
local function install_binary_with_deb(package_name, deb_url)
    -- Determine OS
    local os_name = detect_osname() 
    local is_macos = os_name:match("macOS")
    local is_linux = os_name == "Linux"

    if is_macos then
        print("⚠️ macOS does not support .deb packages. Skipping installation.")
        return false
    elseif is_linux then
        print("Detected Linux (Ubuntu/Debian)")

        -- Step 1: Download the .deb file
        local temp_file = string.format("/tmp/%s.deb", package_name)
        local download_cmd = string.format("curl -L %s -o %s", deb_url, temp_file)

        print("Downloading .deb package from: " .. deb_url)
        local success, _, _ = os.execute(download_cmd)
        if not success then
            print("❌ Failed to download .deb file.")
            return false
        end

        -- Step 2: Install using dpkg (and apt for dependency resolution)
        local install_cmd = string.format("sudo dpkg -i %s && sudo apt-get install -f -y", temp_file)
        print("Installing .deb package...")
        success, _, _ = os.execute(install_cmd)
        if not success then
            print("❌ Failed to install .deb package.")
            -- Optional: cleanup on failure
            os.execute("rm -f " .. temp_file)
            return false
        end

        -- Cleanup
        os.execute("rm -f " .. temp_file)
        print("✅ Successfully installed " .. package_name .. " from .deb")
        return true

    else
        print("❌ Unsupported operating system.")
        return false
    end
end
local function install_binary(package_name, installer_type, url_or_command)
    -- Determine OS
    local os_name = detect_osname()
    if os_name:match("macOS") then
        print("Detected macOS")
        if installer_type == "brew" then
            local cmd = url_or_command 
            print("Installing via Homebrew: " .. cmd)
            local success, _, _ = os.execute(cmd)
            if not success then
                print("❌ Failed to install via brew.")
                return false
            end
            print("✅ Installed successfully via brew.")
        elseif installer_type == "url" then
            local download_cmd = string.format("curl -L %s -o /tmp/%s", url_or_command, package_name)
            local install_cmd = string.format("chmod +x /tmp/%s && sudo mv /tmp/%s /usr/local/bin/", package_name, package_name)

            print("Downloading from URL: " .. url_or_command)
            local success, _, _ = os.execute(download_cmd)
            if not success then
                print("❌ Failed to download binary.")
                return false
            end

            success, _, _ = os.execute(install_cmd)
            if not success then
                print("❌ Failed to move binary to /usr/local/bin.")
                return false
            end

            print("✅ Binary installed to /usr/local/bin/")
        else
            print("❌ Unsupported installer type for macOS.")
            return false
        end
    elseif os_name == "Linux" or package_name:match("ubuntu") then
        print("Detected Ubuntu/Linux")
        if installer_type == "apt" then
            local cmd = string.format("sudo apt update && sudo apt install -y %s", package_name)
            print("Installing via APT: " .. cmd)
            local success, _, _ = os.execute(cmd)
            if not success then
                print("❌ Failed to install via apt.")
                return false
            end
            print("✅ Installed successfully via apt.")
        elseif installer_type == "deb" then
            install_binary_with_deb(package_name, url)
        elseif installer_type == "url" then
            local download_cmd = string.format("curl -L %s -o /tmp/%s", url_or_command, package_name)
            local install_cmd = string.format("chmod +x /tmp/%s && sudo mv /tmp/%s /usr/local/bin/", package_name, package_name)

            print("Downloading from URL: " .. url_or_command)
            local success, _, _ = os.execute(download_cmd)
            if not success then
                print("❌ Failed to download binary.")
                return false
            end

            success, _, _ = os.execute(install_cmd)
            if not success then
                print("❌ Failed to move binary to /usr/local/bin.")
                return false
            end

            print("✅ Binary installed to /usr/local/bin/")
        else
            print("❌ Unsupported installer type for Linux.")
            return false
        end
    else
        print("❌ Unsupported operating system:".. os_name)
        return false
    end

    return true
end


binaries = {
    {
        package_name = "ueberzugpp",
        installer_type = "brew",
        command = "brew install jstkdng/programs/ueberzugpp",
    },
    {
        package_name = "ctags",
        installer_type = "brew",
        command = "brew install ctags",
    },
    {
        package_name = "yazi",
        installer_type = "brew",
        command = "brew install yazi"
    }
}

function install_package(pkg)
    if not pkg.package_name or not pkg.installer_type then
        print("invalid package")
        return false
    end

    if pkg.installer_type == "brew" then
        local ok = install_binary(pkg.package_name, pkg.installer_type, pkg.command)
        return ok
    end

    return false

end

function install_packages()
    for idx, bin in ipairs(binaries) do
        print("trying to install ".. bin.package_name)
        install_package(bin)
    end
end

print_os_info()
install_packages()
