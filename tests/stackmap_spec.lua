describe("stackmap", function()
  it("can be required", function()
    require("stackmap")
  end)

  it("can push a single mapping", function()
    require("stackmap").push("test1", "n", {
      asdfasdf = "echo 'This is a test'",
    })

  end)
end)
