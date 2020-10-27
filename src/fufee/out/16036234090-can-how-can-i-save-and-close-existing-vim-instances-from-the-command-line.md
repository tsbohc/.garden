# Can how can I save and close existing vim instance/s from the command line?

1 | 1603623409.0

I have a virtual machine setup which uses single gpu passthrough so it quits the host's X session before booting the graphical interface for the vm.

The issue is that vim messes up when graphical control is handed back to the host; the paste registers are all messed up causing me to need to reload vim.

To circumvent this I was thinking to save any open instances as a temp session file when the host shuts down X and reload when it starts it again.

So how would I do the equivalent of the command used within vim of `:mks /filepath/session.vim` on the command line so it could be automated within the vm's start/end hooks?