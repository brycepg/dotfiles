def call(args):
    """Call subprocess, split arguments"""
    if isinstance(args, str):
        args = args.split(" ")
    subprocess.check_call(args)
