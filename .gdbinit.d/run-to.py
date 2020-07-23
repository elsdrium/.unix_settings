import gdb

class RunToCommand(gdb.Command):

    """Run to target child process from parent (wrapper script)"""

    def __init__(self):
        super(RunToCommand, self).__init__(
                "run-to",
                gdb.COMMAND_USER
                )
        self.dump_args = False
        self.target_keyword = 'NeVeR mAtChEd'

    def exit_handler(self, event=None):
        for i in range(len(gdb.inferiors())-1, -1, -1):
            if not gdb.inferiors()[i].pid:
                continue
            try:
                gdb.execute('inferior {}'.format(gdb.inferiors()[i].num))
                self.do_continue()
            except:
                pass
            else:
                return

    def stop_handler(self, event=None):
        if isinstance(event, gdb.SignalEvent):
            pass
        elif isinstance(event, gdb.BreakpointEvent):
            pass
        elif self.is_target():
            gdb.post_event(self.do_restore)
        else:
            gdb.post_event(self.do_continue)

    def is_target(self):
        inf = gdb.selected_inferior()
        name = inf.progspace.filename.split('/')[-1].lower()
        return self.target_keyword in name

    def do_continue(self):
        gdb.execute('continue')

    def do_restore(self):
        gdb.events.exited.disconnect(self.exit_handler)
        gdb.events.stop.disconnect(self.stop_handler)

        gdb.execute('delete')
        gdb.execute('set follow-fork-mode parent')
        gdb.execute('set detach-on-fork on')

        if self.dump_args:
            import os
            try:
                cmdline = gdb.execute('cmdline', to_string=True).strip()
                with open(os.environ.get('GDB_DUMP', '~/.cmdline4gdb'), 'w') as f:
                    f.write(cmdline)
            except:
                pass
            else:
                gdb.execute('tbreak main')
                gdb.execute('da -enable on')
                gdb.do_continue()
            finally:
                gdb.execute('quit')

    def invoke(self, args, from_tty):
        args = args.split(' ')
        if len(args) == 1:
            self.target_keyword = args[0]
        elif len(args) == 2 and args[1] == '-dump':
            self.target_keyword = args[0]
            self.dump_args = True
        else:
            print('ERROR: Unrecognized arguments: "{}"'.format(str(args)))

        gdb.execute('set follow-fork-mode child')
        gdb.execute('set detach-on-fork off')
        gdb.execute('catch exec')
        gdb.execute('da -enable off')

        gdb.events.stop.connect(self.stop_handler)
        gdb.events.exited.connect(self.exit_handler)
        gdb.execute('run')

RunToCommand()
