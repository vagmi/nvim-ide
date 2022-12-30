# DevBox

This sets up neovim IDE and also exposes an SSH port. 

It has node, ruby, go, rust and kotlin out of the box. It has a fairly simple
and neovim config that has treesitter and lsp configured.


To run this container, you can do the following.

```
docker build --build-arg GITHUB_HANDLE=<yourhandle> -t nvim-ide base
docker run -v $HOME:/root/work -p 2222:22 -it nvim-ide
```

You can then ssh into the container.

```
ssh -A root@localhost -p 2222
```

Enjoy!
