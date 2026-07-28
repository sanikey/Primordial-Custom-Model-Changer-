-- ============================================================================
-- Custom Player Model Changer v1.1 for Primordial
-- ============================================================================

print("[Model Changer v1.1] Loading script by @l_sanikey_l...")

local ffi = require("ffi")

ffi.cdef [[
    typedef struct 
    {
        void*   fnHandle;        
        char    szName[260];     
        int     nLoadFlags;      
        int     nServerCount;    
        int     type;            
        int     flags;           
        float   vecMins[3];       
        float   vecMaxs[3];       
        float   radius;          
        char    pad[0x1C];       
    } model_t;
    
    typedef int(__thiscall* get_model_index_t)(void*, const char*);
    typedef const model_t*(__thiscall* find_or_load_model_t)(void*, const char*);
    typedef int(__thiscall* add_string_t)(void*, bool, const char*, int, const void*);
    typedef void*(__thiscall* find_table_t)(void*, const char*);
    typedef void(__thiscall* set_model_index_t)(void*, int);
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
]]

-- ============================================================================
-- HOW TO ADD YOUR OWN CUSTOM MODELS:
-- 1. Place your custom .mdl files into your game directory (e.g., csgo/models/player/... or csgo/custom/... ).
-- 2. Add a new line to the 'model_list' table below using the following format:
--    { name = "Menu Display Name", path = "path/to/your/model.mdl" },
-- 3. Always use forward slashes (/) in the file paths.
-- 4. Note: Make sure "Bypass sv_pure" is enabled in your cheat settings for online servers!
-- ============================================================================
local model_list = {
    { name = "None (Default)",     path = "" },
    { name = "Example Model 1",    path = "models/player/custom_player/example/model1.mdl" },
    { name = "Example Model 2",    path = "models/player/custom_player/example/model2.mdl" }
}

local model_names = {}
for i = 1, #model_list do
    table.insert(model_names, model_list[i].name)
end

-- UI Elements
local enable_checkbox = menu.add_checkbox("Model Changer", "Enable Model Changer", false)
local model_selection = menu.add_selection("Model Changer", "Select Model", model_names)
menu.add_text("Model Changer", "Script by @l_sanikey_l (v1.1)")
menu.add_text("Model Changer", "(based on original idea by @gabrielzenly)")

-- Internal variables & caching
local initialized = false
local ientitylist, ivmodelinfo, networkstringtablecontainer
local get_client_entity, get_model_index, find_or_load_model, find_table
local class_ptr = ffi.typeof("void***")
local cached_indices = {}

local function is_valid_ptr(ptr)
    if ptr == nil or ptr == 0 then return false end
    if type(ptr) == "cdata" and ffi.cast("uintptr_t", ptr) == 0 then return false end
    return true
end

local function get_interface(dll, name)
    local ptr = memory.create_interface(dll, name)
    if not is_valid_ptr(ptr) then
        error("[Model Changer v1.1] Failed to find interface: " .. name .. " in " .. dll)
    end
    return ffi.cast(class_ptr, ptr)
end

local function try_init()
    if initialized then return true end
    
    local ok, err = pcall(function()
        ientitylist = get_interface("client.dll", "VClientEntityList003")
        get_client_entity = ffi.cast("get_client_entity_t", ientitylist[0][3])

        ivmodelinfo = get_interface("engine.dll", "VModelInfoClient004")
        get_model_index = ffi.cast("get_model_index_t", ivmodelinfo[0][2])
        find_or_load_model = ffi.cast("find_or_load_model_t", ivmodelinfo[0][39])

        networkstringtablecontainer = get_interface("engine.dll", "VEngineClientStringTable001")
        find_table = ffi.cast("find_table_t", networkstringtablecontainer[0][3])
    end)

    if ok then
        initialized = true
        return true
    else
        print("[Model Changer v1.1] Initialization error: " .. tostring(err))
        return false
    end
end

local function precache_model(modelname)
    local rawprecache_table = find_table(networkstringtablecontainer, "modelprecache")
    if not rawprecache_table then return false end
    
    local precache_table = ffi.cast(class_ptr, rawprecache_table)
    local add_string = ffi.cast("add_string_t", precache_table[0][8])
    if not add_string then return false end

    find_or_load_model(ivmodelinfo, modelname)
    -- v1.1 FIX: Passing 'true' (bIsServer) to bypass online table lock (m_bLocked)
    local idx = add_string(precache_table, true, modelname, -1, nil)
    return idx ~= -1
end

local function get_or_precache_index(model_path)
    if cached_indices[model_path] then
        return cached_indices[model_path]
    end
    
    if not precache_model(model_path) then
        cached_indices[model_path] = -1
        return -1
    end
    
    local idx = get_model_index(ivmodelinfo, model_path)
    cached_indices[model_path] = idx
    return idx
end

local function set_model_index(entity_index, idx)
    local raw_entity = get_client_entity(ientitylist, entity_index)
    if not raw_entity then return end
    
    local gce_entity = ffi.cast(class_ptr, raw_entity)
    local a_set_model_index = ffi.cast("set_model_index_t", gce_entity[0][75])
    if a_set_model_index then
        a_set_model_index(gce_entity, idx)
    end
end

callbacks.add(e_callbacks.NET_UPDATE, function()
    if not enable_checkbox:get() then return end

    if not initialized then
        if not try_init() then
            enable_checkbox:set(false)
            return
        end
    end

    local me = entity_list.get_local_player()
    if not me then 
        -- v1.1 FIX: Clear index cache when disconnected or changing servers/maps
        if next(cached_indices) ~= nil then
            cached_indices = {}
        end
        return 
    end

    local team = me:get_prop('m_iTeamNum')
    if team ~= 2 and team ~= 3 then return end

    local selected_idx = model_selection:get()
    local selected_data = model_list[selected_idx]
    
    if not selected_data or selected_data.path == "" then return end

    local desired_idx = get_or_precache_index(selected_data.path)
    if desired_idx == -1 then return end

    local current_idx = me:get_prop("m_nModelIndex") or -1
    if current_idx ~= desired_idx then
        set_model_index(me:get_index(), desired_idx)
    end
end)