<?xml version="1.0" encoding="UTF-8"?>
<Project Version="1" Path="E:/TD_Projects/1.blink/prj_td">
    <Project_Created_Time>2022-02-14 14:31:58</Project_Created_Time>
    <TD_Version>5.0.29524</TD_Version>
    <UCode>00000000</UCode>
    <Name>blink</Name>
    <HardWare>
        <Family>EG4</Family>
        <Device>EG4S20NG88</Device>
    </HardWare>
    <Source_Files>
        <Verilog>
            <File Path="../src/blink_top.v">
                <FileInfo>
                    <Attr Name="UsedInSyn" Val="true"/>
                    <Attr Name="UsedInP&R" Val="true"/>
                    <Attr Name="BelongTo" Val="design_1"/>
                    <Attr Name="CompileOrder" Val="1"/>
                </FileInfo>
            </File>
        </Verilog>
        <ADC_FILE>
            <File Path="blink.adc">
                <FileInfo>
                    <Attr Name="UsedInSyn" Val="true"/>
                    <Attr Name="UsedInP&R" Val="true"/>
                    <Attr Name="BelongTo" Val="constrain_1"/>
                    <Attr Name="CompileOrder" Val="1"/>
                </FileInfo>
            </File>
        </ADC_FILE>
    </Source_Files>
    <FileSets>
        <FileSet Name="constrain_1" Type="ConstrainFiles">
        </FileSet>
        <FileSet Name="design_1" Type="DesignFiles">
        </FileSet>
    </FileSets>
    <TOP_MODULE>
        <LABEL></LABEL>
        <MODULE>blink_top</MODULE>
        <CREATEINDEX>auto</CREATEINDEX>
    </TOP_MODULE>
    <Property>
    </Property>
    <Device_Settings>
    </Device_Settings>
    <Configurations>
    </Configurations>
    <Project_Settings>
        <Step_Last_Change>2022-02-14 14:32:04.600</Step_Last_Change>
        <Current_Step>60</Current_Step>
        <Step_Status>true</Step_Status>
    </Project_Settings>
</Project>
