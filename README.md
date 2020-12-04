# Easy FIFO

Easy FIFO is a FIFO written systemverilog. It supports regular FIFO interface and AXI4-Stream interface for both asynchronouse and synchronous FIFOs.

The main motivation of making Easy FIFO is that the large latency (3 cycles for synchronous and 7 cycles for asynchronous) for the Xilinx FIFO IPs killed my application's performance.

## Intallation:

1. git clone https://github.com/QianfengClarkShen/easy_fifo.git
    
**Vivado IP flow:**
  
2. in Vivado GUI: 
   add the git folder as a User IP repository in IP Catalog.
   Alternatively, in Vivado Tcl Console, run command :
   **set_property  ip_repo_paths  [list [get_property ip_repo_paths [current_project]] \<path to the cloned repository\>] [current_project]**
            
3. instantiate the IP named "easy_fifo"
        
**Verilog flow:**
    
2. there are 4 files in **verilog/top**: easy_fifo_async.sv, easy_fifo_sync.sv, easy_fifo_axis_async.sv, easy_fifo_axis_sync.sv. Choose one of the top modules based on your use case. Don't forgot to include all the files in **verilog/async_fifo** and **verilog/async_fifo**

## Example design:

After instantiated Easy FIFO in Vivado, right click the IP and click "Open IP Example Design". A testbench would be automatically generated based on the IP configuration.
    
Example synthesis design is currently not provided.
    
## Bug Report:
Please email qianfeng.shen@gmail.com if you find a bug, or open an issue here.

## Latency Performance:
0 cycle for synchronous, 3 cycles for asynchronous.

**The asynchronous FIFO is written after I read the guide in http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf.**
