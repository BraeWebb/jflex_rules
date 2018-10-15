"""Bazel rules for cup. """

# CUP can only read from stdin, which Skylark rules don't support. Use a genrule for now.
def cup(name, src, parser = "parser", symbols = "sym", interface = False):
    """Generate a parser with CUP.

    Args:
      name: name of the rule.
      src: the cup specifications.
      parser: name of the generated parser class.
      symbols: name of the generated symbols class.
      interface: whether to generate an interface.
    """
    opts = [
        "-parser",
        parser,
        "-symbols",
        symbols,
    ]
    if interface:
        opts = opts + ["-interface"]
    options = " ".join(opts)
    cmd = ("$(location //third_party/cup:cup_bin) -destdir $(@D) " + options + " < $<")
    native.genrule(
        name = name,
        srcs = [src],
        tools = ["//third_party/cup:cup_bin"],
        outs = [parser + ".java", symbols + ".java"],
        cmd = cmd,
    )
