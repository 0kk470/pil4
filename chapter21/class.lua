--cocos2d's class implement
function class(classname, ...)
    local cls = { __cname = classname }

    local supers = { ... }
    for _, super in ipairs(supers)
    do
        local superType = type(super)
        assert(superType == "nil" or superType == "table" or superType == "function",
                string.format("class() - create class \"%s\" with invalid super class type \"%s\"",
                        classname, superType))

        if superType == "function" then
            assert(cls.__create == nil,
                    string.format("class() - create class \"%s\" with more than one creating function",
                            classname));
            cls.__create = super
        elseif superType == "table" then
            if super[".isclass"] then
                assert(cls.__create == nil,
                        string.format("class() - create class \"%s\" with more than one creating function or native class",
                                classname));
                cls.__create = function()
                    return super:create()
                end
            else

                cls.__supers = cls.__supers or {}
                cls.__supers[#cls.__supers + 1] = super
                if not cls.super then
                    cls.super = super
                end
            end
        else

            error(string.format("class() - create class \"%s\" with invalid super type",
                    classname), 0)
        end
    end

    cls.__index = cls
    if not cls.__supers or #cls.__supers == 1 then
        setmetatable(cls, { __index = cls.super })
    else
        setmetatable(cls, { __index = function(_, key)
            local supers = cls.__supers
            for i = 1, #supers do
                local super = supers[i]
                if super[key] then
                    return super[key]
                end
            end
        end })
    end

    if not cls.ctor then
        cls.ctor = function()
        end
    end
    cls.new = function(...)
        local instance
        if cls.__create then
            instance = cls.__create(...)
        else
            instance = {}
        end
        setmetatableindex(instance, cls)
        instance.class = cls
        instance:ctor(...)
        return instance
    end
    cls.create = function(_, ...)
        return cls.new(...)
    end

    return cls
end

setmetatableindex = function(instance, cls)
    --if type(instance) == "userdata" then
    --    local peer = tolua.getpeer(instance)
    --    if not peer then
    --        peer = {}
    --        tolua.setpeer(instance, peer)
    --    end
    --    setmetatableindex(peer, cls)
    --else
        local mt = getmetatable(instance)
        if not mt then
            mt = {}
        end
        if not mt.__index then
            mt.__index = cls
            setmetatable(instance, mt)
        elseif mt.__index ~= cls then
            setmetatableindex(mt, cls)
        end
    --end
end