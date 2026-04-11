%% Manual Board Solution Files Download
h = zynq('linux','169.254.0.2');
h.putFile('soc_rfsoc_top-XilinxZynqUltraScale_RFSoCZCU216EvaluationKit.bit','/mnt');
h.putFile('soc_prjTestTrain.output.dtb','/mnt');
h.putFile('RF_Init.cfg','/mnt');
h.putFile('init.sh','/mnt');

h.system('fw_setbitstream /mnt/soc_rfsoc_top-XilinxZynqUltraScale_RFSoCZCU216EvaluationKit.bit');
h.system('fw_setdevicetree /mnt/soc_prjTestTrain.output.dtb');
 
pause(0.1)
h.system('cp /mnt/RF_Init.cfg /mnt/hdlcoder_rd/RF_Init.cfg');

h.system('reboot');