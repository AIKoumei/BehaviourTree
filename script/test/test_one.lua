require "test/test_two"

TestOne = {}

function TestOne.Print()
    print("TestOne.Print")
end

if DEBUG then print("[require] TestOne loaded.") end
