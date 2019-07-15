import gdb

def ge(*args, **kwargs):
    return gdb.execute(*args, **kwargs)

def eval(expr):
    return gdb.parse_and_eval(expr)

def start_ipython():
    from IPython import embed_kernel
    embed_kernel()

