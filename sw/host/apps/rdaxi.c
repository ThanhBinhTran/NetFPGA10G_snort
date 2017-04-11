/*******************************************************************************
 *
 *  NetFPGA-10G http://www.netfpga.org
 *
 *  File:
 *        rdaxi.c
 *
 *  Project:
 *        nic
 *
 *  Author:
 *        Mario Flajslik
 *
 *  Description:
 *        Example C application that shows how to use the driver to read AXI
 *        registers from the NetFPGA card.
 *        Usage example: ./rdaxi 0x7d400000
 *
 *        NIC project contains 8 AXI registers that can be read/written for
 *        test purposes (they have no effect on the NIC). Check hw/system.mhs
 *        file to find the the AXI addresses (under dma section look for
 *        C_BASEADDR; the addresses are C_BASEADDR...C_BASEADDR+7) 
 *
 *  Copyright notice:
 *        Copyright (C) 2010, 2011 The Board of Trustees of The Leland Stanford
 *                                 Junior University
 *
 *  Licence:
 *        This file is part of the NetFPGA 10G development base package.
 *
 *        This file is free code: you can redistribute it and/or modify it under
 *        the terms of the GNU Lesser General Public License version 2.1 as
 *        published by the Free Software Foundation.
 *
 *        This package is distributed in the hope that it will be useful, but
 *        WITHOUT ANY WARRANTY; without even the implied warranty of
 *        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *        Lesser General Public License for more details.
 *
 *        You should have received a copy of the GNU Lesser General Public
 *        License along with the NetFPGA source package.  If not, see
 *        http://www.gnu.org/licenses/.
 *
 */

#include <fcntl.h>
#include <sys/ioctl.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>

#define NF10_IOCTL_CMD_READ_STAT (SIOCDEVPRIVATE+0)
#define NF10_IOCTL_CMD_WRITE_REG (SIOCDEVPRIVATE+1)
#define NF10_IOCTL_CMD_READ_REG (SIOCDEVPRIVATE+2)

int main(int argc, char* argv[]){
    int f;
    int i;
    uint64_t v;
    uint64_t addr;
    char RegNumArgc[2];
    int  RegNum;
    if(argc < 4){
        printf("usage: rdaxi reg_addr(address in hex) -n number_of_read_registers\n\n");
        return 0;
    }
    else{
        sscanf(argv[1], "%llx", &addr);
        sscanf(argv[2], "%s", &RegNumArgc );
        sscanf(argv[3], "%s", &RegNum );
        if(RegNumArgc[0] != '-' || (RegNumArgc[0] != 'n' && RegNumArgc[0] != 'N') ){
            printf("usage: rdaxi reg_addr(address in hex) -n number_of_read_registers\n\n");
            return 0;
        }
    }

    //----------------------------------------------------
    //-- open nf10 file descriptor for all the fun stuff
    //----------------------------------------------------
    f = open("/dev/nf10", O_RDWR);
    if(f < 0){
        perror("/dev/nf10");
        return 0;
    }
    
    printf("\n");

    
    for(i = 0; i < RegNum; i ++){
        v = addr + i *4;
        if(ioctl(f, NF10_IOCTL_CMD_READ_REG, &v) < 0){
            perror("nf10 ioctl failed");
            return 0;
        }
        // upper 32bits contain the address and are masked away here
        // lower 32bits contain the data
        v &= 0xffffffff;

        printf("AXI reg 0x%llx=0x%llx (hex) = %d (dec)\n", addr, v, v);
        
        printf("\n");    
    }
    

    close(f);
    
    return 0;
}
