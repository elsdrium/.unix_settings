import gdb

class CmdlineCommand(gdb.Command):

    """Retrieve starting command line for current inferior"""

    def __init__(self):
        super(CmdlineCommand, self).__init__(
                "cmdline",
                gdb.COMMAND_USER
                )

    def print_args(self, args):
        print(args)

    def trim_trailing_quote(self, string):
        return string[:-1] if string[-1] == "'" else string

    def invoke(self, args, from_tty):
        try:
            func_name = gdb.newest_frame().name()
        except:
            func_name = ''

        if func_name == 'main':
            gdb.execute('set print address off')
            gdb.execute('set print array-indexes off')
            try:
                argv_str = str(gdb.parse_and_eval('*(char **)$rsi@$rdi'))
                argv_str = '[{}]'.format(argv_str[1:-1])
                argv = eval(argv_str)

                args = ' '.join(argv)
                args = self.trim_trailing_quote(args)
                self.print_args(args)
            finally:
                gdb.execute('set print array-indexes on')
                gdb.execute('set print address on')
        else:
            try:
                cmdline = gdb.execute('info proc cmdline', to_string=True)
            except:
                cmdline = ''

            if ' = ' not in cmdline:
                return
            else:
                args = cmdline.split(' = ')[1][1:-1]
                args = self.trim_trailing_quote(args)
                self.print_args(args)

CmdlineCommand()
