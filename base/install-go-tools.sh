set -e

export ARCH=`uname -i`
case $ARCH in 
    x86_64)
        export TARGETARCH=amd64
        ;;
    aarch64)
        export TARGETARCH=arm64
        ;;
    *)
        export TARGETARCH=$ARCH
        ;;

esac

env
mkdir -p /opt/sources &&  cd /opt/sources && wget -q https://go.dev/dl/go1.19.4.linux-$TARGETARCH.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf /opt/sources/go1.19.4.linux-$TARGETARCH.tar.gz && rm -rf /root/sources

export PATH=$PATH:/usr/local/go/bin

go install github.com/klauspost/asmfmt/cmd/asmfmt@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install github.com/kisielk/errcheck@latest
go install github.com/davidrjenni/reftools/cmd/fillstruct@master
go install github.com/rogpeppe/godef@latest
go install golang.org/x/tools/cmd/goimports@master
go install github.com/mgechev/revive@latest
go install golang.org/x/tools/gopls@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install honnef.co/go/tools/cmd/staticcheck@latest
go install github.com/fatih/gomodifytags@latest
go install golang.org/x/tools/cmd/gorename@master
go install github.com/jstemmer/gotags@master
go install golang.org/x/tools/cmd/guru@master
go install github.com/josharian/impl@master
go install honnef.co/go/tools/cmd/keyify@master
go install github.com/fatih/motion@latest
go install github.com/koron/iferr@master

cd /root
