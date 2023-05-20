#!/bin/bash

starfive_ker_source_dir0="../../starfive-tech"
starfive_ker_source_dir1="../"
starfive_ker_source_dir=${starfive_ker_source_dir0}

starfive_ker_source_path="${starfive_ker_source_dir}/linux"
starfive_ker_source_http="https://github.com/starfive-tech/linux"
ksrc=${starfive_ker_source_path}

PWD0=${PWD}

make_vf2_kernel(){
    
    if ! [[ -d "${starfive_ker_source_path}" ]];
    then
        if ! [[ -d "${starfive_ker_source_dir}" ]];
        then
            mkdir -p ${starfive_ker_source_dir}
        fi
        cd ${starfive_ker_source_dir}
        echo "Clone ${starfive_ker_source_http} ......"
        git clone ${starfive_ker_source_http}.git \
            --depth=1 \
            -b JH7110_VisionFive2_devel
    fi

    cd ${starfive_ker_source_path}
    make starfive_visionfive2_defconfig
    echo "Enter '-starfive' for 'General setup -> Local version - \
append to kernel release'."
    read  -n 1 -p "(Y)es, I knew. :"
    make menuconfig
    echo "make......"
    make -j4
    echo "Finished!"
    cd ${PWD0}

}

make_src(){
    make_vf2_kernel
    echo "make ......"
    cp Makefile.vf2.cp Makefile.vf2
    sed -i -e "s#VF2_KSRC#${starfive_ker_source_path}#g" Makefile.vf2
    make -f Makefile.vf2
}

install_bin(){
    echo "Install rtl8188eus ......"
    [[ -x $(which sudo) ]] && \
    sudo make install || \
    make install
}

uninstall_bin(){
    [[ -x $(which sudo) ]] && \
    sudo make uninstall || \
    make uninstall
}

if [[ $# == 0 ]];
then
    make_src
    install_bin
else
    $*
fi


