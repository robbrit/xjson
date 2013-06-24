assert = require "assert"
xjson = require("../lib/interpreter").xjson
toLisp = require("../lib/interpreter").toLisp

describe "arithmetic functions", ->
  it "should add properly", ->
    assert.equal 7,  xjson ["+", 2, 5]
    assert.equal -2, xjson ["+", 2, -4]
    assert.equal 23, xjson ["+", 12, -2, 7, 6]

  it "should subtract properly", ->
    assert.equal 3,  xjson ["-", 7, 4]
    assert.equal -5, xjson ["-", 7, 4, 8]

  it "should multiply properly", ->
    assert.equal 21, xjson ["*", 3, 7]
    assert.equal 0,  xjson ["*", 2, 3, 2, -12, 0]

  it "should compute factorials", ->
    xjson ["defun", "fact", ["n"],
      ["defun", "factn", ["a", "i"],
        ["if", [">", "i", "n"],
          "a",
          ["factn", ["*", "a", "i"],
                    ["+", "i", 1],
                    "n"]]],
      ["factn", 1, 1]]

    assert.equal 24,  xjson ["fact", 4]
    assert.equal 720, xjson ["fact", 6]

describe "list functions", ->
  it "list - should create a list", ->
    assert.deepEqual [1, 2, 3], xjson ["list", 1, 2, 3]
    assert.deepEqual [1, 3, 3], xjson ["list", 1, ["+", 2, 1], 3]
    assert.deepEqual [1, ["+", 2, 1], 3],
                  xjson ["list", 1, ["quote", ["+", 2, 1]], 3]
    assert.deepEqual [], xjson ["list"]

  it "car - should get the first element", ->
    assert.equal 1, xjson ["car", ["list", 1, 2, 3]]
    assert.equal 2, xjson ["car", ["car", ["list", ["list", 2, 1, 3]]]]
    assert.throws ->
      xjson ["car", ["list"]]

  it "cdr - should get the rest of the list", ->
    assert.deepEqual [2, 3], xjson ["cdr", ["list", 1, 2, 3]]
    assert.deepEqual [3], xjson ["cdr", ["cdr", ["list", 1, 2, 3]]]
    assert.deepEqual [], xjson ["cdr", ["list", 1]]
    assert.throws ->
      xjson ["cdr", ["list"]]

  it "null? - should check empty lists", ->
    assert xjson ["null?", ["list"]]
    assert !xjson ["null?", ["list", 1]]
    assert !xjson ["null?", 1]
    assert !xjson ["null?", ["list", ["list"]]]

describe "toLisp", ->
  it "should convert a simple sexp properly", ->
    assert.equal "(+ 2 3)", toLisp ["+", 2, 3]

###
  ["display", [["lambda", ["x"], ["*", "x", 2]], 3]],
  ["display", ["fact", 3]],
  ["display", [["lambda", ["x"], ["*", "x", 2]],
                    ["car", ["list", 1, 2, 3]]]],

  # test higher-order functions
  ["display", ["map",
        ["lambda", ["x"], ["*", "x", 2]],
        ["list", 1, 2, 3]]],

  ["display", ["reduce",
        ["lambda", ["a", "b"], ["+", "a", "b"]],
        0,
        ["list", 1, 2, 3, 4]]],

  ["display", ["filter",
        ["lambda", ["a"], ["=", 0, ["%", "a", 2]]],
        ["list", 1, 2, 3, 4]]],

  # test closures
  ["defun", "adder", ["a"],
      ["lambda", ["b"], ["+", "a", "b"]]],

  ["let", [["add2", ["adder", 2]],
                ["add5", ["adder", 5]]],
            ["display", ["add2", 4]],
            ["display", ["add5", -2]],
            ["display", ["add2", 8]],
            ["display", ["add5", 12]]]
###
