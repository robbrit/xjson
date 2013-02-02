Wat
===

It's an interpreter for Lisp-styled JSON.

Example:

    var xjson = require("xjson").xjson;

    console.log(xjson(["+", 5, 9]));  // outputs 14

    // factorial
    var fact =
      ["defun", "fact", ["n"],
        ["if", ["=", 0, "n"],
          1,
          ["*", "n", ["fact", ["-", "n", 1]]]]];

    // tail-recursive factorial (there is no TCO at the moment though)
    fact =
      ["defun", "fact", ["n"],
        ["defun", "factn", ["a", "i"],
          ["if", [">", "i", "n"],
            "a",
            ["factn", ["*", "a", "i"],
                      ["+", "i", 1],
                      "n"]]],
        ["factn", 1, 1]];

    xjson(fact);
    xjson(["display", ["fact", 5]]); // outputs 120

Installation
============

    npm install xjson

Licensing
========

MIT License
