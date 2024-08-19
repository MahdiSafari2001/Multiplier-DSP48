library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity Multiplier is
  Port (
    CLK : in STD_LOGIC;
    RST : in STD_LOGIC;
    AA : in STD_LOGIC_VECTOR(44 downto 0);
    BB : in STD_LOGIC_VECTOR(34 downto 0);
    PP : out STD_LOGIC_VECTOR(81 downto 0)
  );
end Multiplier;

architecture Behavioral of Multiplier is
signal A_low : STD_LOGIC_VECTOR(16 downto 0):= (others => '0');
signal A_high : STD_LOGIC_VECTOR(44 downto 17):= (others => '0');
signal B_low : STD_LOGIC_VECTOR(16 downto 0):= (others => '0');
signal B_high : STD_LOGIC_VECTOR(34 downto 17):= (others => '0');
signal P_signal_1 : STD_LOGIC_VECTOR(47 downto 0):= (others => '0');
signal P_signal_2 : STD_LOGIC_VECTOR(47 downto 0):= (others => '0');
signal P_signal_3 : STD_LOGIC_VECTOR(47 downto 0):= (others => '0');
signal P_signal_4 : STD_LOGIC_VECTOR(47 downto 0):= (others => '0');
signal A1 : STD_LOGIC_VECTOR(29 downto 0):= (others => '0');
signal A2 : STD_LOGIC_VECTOR(29 downto 0):= (others => '0');
signal A3 : STD_LOGIC_VECTOR(29 downto 0):= (others => '0');
signal A4 : STD_LOGIC_VECTOR(29 downto 0):= (others => '0');
signal B1 : STD_LOGIC_VECTOR(17 downto 0):= (others => '0');
signal B2 : STD_LOGIC_VECTOR(17 downto 0):= (others => '0');
signal B3 : STD_LOGIC_VECTOR(17 downto 0):= (others => '0');
signal B4 : STD_LOGIC_VECTOR(17 downto 0):= (others => '0');

begin
  process(CLK)
  begin
    if rising_edge(CLK) then
		  A_low <= AA(16 downto 0);
		  A_high <= AA(44 downto 17);
          B_low <= BB(16 downto 0);
		  B_high <= BB(34 downto 17);
	 end if;
   end process;
      A1 <= "0000000000000" & A_low;
      B1 <= '0' & B_low;
      -- First DSP48E1 instance for P = A_low * B_low   
      DSP48E1_inst1 : DSP48E1
        generic map (
          -- Feature Control Attributes: Data Path Selection
          A_INPUT => "DIRECT",               -- Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
          B_INPUT => "DIRECT",               -- Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
          USE_DPORT => FALSE,                -- Select D port usage (TRUE or FALSE)
          USE_MULT => "MULTIPLY",            -- Select multiplier usage ("MULTIPLY", "DYNAMIC", or "NONE")
          USE_SIMD => "ONE48",               -- SIMD selection ("ONE48", "TWO24", "FOUR12")
          -- Pattern Detector Attributes: Pattern Detection Configuration
          AUTORESET_PATDET => "NO_RESET",    -- "NO_RESET", "RESET_MATCH", "RESET_NOT_MATCH" 
          MASK => X"3fffffffffff",           -- 48-bit mask value for pattern detect (1=ignore)
          PATTERN => X"000000000000",        -- 48-bit pattern match for pattern detect
          SEL_MASK => "MASK",                -- "C", "MASK", "ROUNDING_MODE1", "ROUNDING_MODE2" 
          SEL_PATTERN => "PATTERN",          -- Select pattern value ("PATTERN" or "C")
          USE_PATTERN_DETECT => "NO_PATDET", -- Enable pattern detect ("PATDET" or "NO_PATDET")
          -- Register Control Attributes: Pipeline Register Configuration
          ACASCREG => 1,                     -- Number of pipeline stages between A/ACIN and ACOUT (0, 1 or 2)
          ADREG => 1,                        -- Number of pipeline stages for pre-adder (0 or 1)
          ALUMODEREG => 1,                   -- Number of pipeline stages for ALUMODE (0 or 1)
          AREG => 1,                         -- Number of pipeline stages for A (0, 1 or 2)
          BCASCREG => 1,                     -- Number of pipeline stages between B/BCIN and BCOUT (0, 1 or 2)
          BREG => 1,                         -- Number of pipeline stages for B (0, 1 or 2)
          CARRYINREG => 1,                   -- Number of pipeline stages for CARRYIN (0 or 1)
          CARRYINSELREG => 1,                -- Number of pipeline stages for CARRYINSEL (0 or 1)
          CREG => 1,                         -- Number of pipeline stages for C (0 or 1)
          DREG => 1,                         -- Number of pipeline stages for D (0 or 1)
          INMODEREG => 1,                    -- Number of pipeline stages for INMODE (0 or 1)
          MREG => 1,                         -- Number of multiplier pipeline stages (0 or 1)
          OPMODEREG => 1,                    -- Number of pipeline stages for OPMODE (0 or 1)
          PREG => 1                          -- Number of pipeline stages for P (0 or 1)
        )
        port map (
          -- Cascade: 30-bit (each) input: Cascade Ports
          ACIN => (others => '0'), 							-- 30-bit input: A cascade data input
          BCIN => (others => '0'), 							-- 18-bit input: B cascade input
          CARRYCASCIN => '0',                         -- 1-bit input: Cascade carry input
          MULTSIGNIN => '0',                          -- 1-bit input: Multiplier sign input
          PCIN => (others => '0'),							-- 48-bit input: P cascade input
          -- Control: 4-bit (each) input: Control Inputs/Status Bits
          ALUMODE => "0000",                          -- 4-bit input: ALU control input
          CARRYINSEL => "000",                        -- 3-bit input: Carry select input
          CLK => CLK,                                 -- 1-bit input: Clock input
          INMODE => "01101",                          -- 5-bit input: INMODE control input
          OPMODE => "0110101",                        -- 7-bit input: Operation mode input(C)
          -- Data: 30-bit (each) input: Data Ports
          A => A1,               -- 30-bit input: A data input
          B => B1,              -- 18-bit input: B data input
          C => (others => '0'),                       -- 48-bit input: C data input
          D => (others => '0'),  -- 25-bit input: D data input
          CARRYIN => '0',                             -- 1-bit input: Carry input signal
          -- Reset/Clock Enable: 1-bit (each) input: Reset/Clock Enable Inputs
          CEA1 => '1',                                -- 1-bit input: Clock enable input for 1st stage AREG
          CEA2 => '1',                                -- 1-bit input: Clock enable input for 2nd stage AREG
          CEAD => '1',                                -- 1-bit input: Clock enable input for ADREG
          CEALUMODE => '0',                           -- 1-bit input: Clock enable input for ALUMODE
          CEB1 => '1',                                -- 1-bit input: Clock enable input for 1st stage BREG
          CEB2 => '1',                                -- 1-bit input: Clock enable input for 2nd stage BREG
          CEC => '0',                                 -- 1-bit input: Clock enable input for CREG
          CECARRYIN => '0',                           -- 1-bit input: Clock enable input for CARRYINREG
          CECTRL => '0',                              -- 1-bit input: Clock enable input for OPMODEREG and CARRYINSELREG
          CED => '1',                                 -- 1-bit input: Clock enable input for DREG
          CEINMODE => '0',                            -- 1-bit input: Clock enable input for INMODEREG
          CEM => '0',                                 -- 1-bit input: Clock enable input for MREG
          CEP => '1',                                 -- 1-bit input: Clock enable input for PREG
          RSTA => RST,                                -- 1-bit input: Reset input for AREG
          RSTALLCARRYIN => '0',                       -- 1-bit input: Reset input for CARRYINREG
          RSTALUMODE => '0',                          -- 1-bit input: Reset input for ALUMODEREG
          RSTB => RST,                                -- 1-bit input: Reset input for BREG
          RSTC => '0',                                -- 1-bit input: Reset input for CREG
          RSTCTRL => RST,                             -- 1-bit input: Reset input for OPMODEREG and CARRYINSELREG
          RSTD => RST,                                -- 1-bit input: Reset input for DREG and ADREG
          RSTINMODE => RST,                           -- 1-bit input: Reset input for INMODEREG
          RSTM => RST,                                -- 1-bit input: Reset input for MREG
          RSTP => RST,                                -- 1-bit input: Reset input for PREG
			 --P => P_signal_1,
          PCOUT => P_signal_1    			
        );
	  A2 <= "0000000000000" & A_low;
	  B2 <= B_high;
      -- Second DSP48E1 instance for P = A_low * B_high 
      DSP48E1_inst2 : DSP48E1
        generic map (
          -- Feature Control Attributes: Data Path Selection
          A_INPUT => "DIRECT",               -- Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
          B_INPUT => "DIRECT",               -- Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
          USE_DPORT => FALSE,                -- Select D port usage (TRUE or FALSE)
          USE_MULT => "MULTIPLY",            -- Select multiplier usage ("MULTIPLY", "DYNAMIC", or "NONE")
          USE_SIMD => "ONE48",               -- SIMD selection ("ONE48", "TWO24", "FOUR12")
          -- Pattern Detector Attributes: Pattern Detection Configuration
          AUTORESET_PATDET => "NO_RESET",    -- "NO_RESET", "RESET_MATCH", "RESET_NOT_MATCH" 
          MASK => X"3fffffffffff",           -- 48-bit mask value for pattern detect (1=ignore)
          PATTERN => X"000000000000",        -- 48-bit pattern match for pattern detect
          SEL_MASK => "MASK",                -- "C", "MASK", "ROUNDING_MODE1", "ROUNDING_MODE2" 
          SEL_PATTERN => "PATTERN",          -- Select pattern value ("PATTERN" or "C")
          USE_PATTERN_DETECT => "NO_PATDET", -- Enable pattern detect ("PATDET" or "NO_PATDET")
          -- Register Control Attributes: Pipeline Register Configuration
          ACASCREG => 1,                     -- Number of pipeline stages between A/ACIN and ACOUT (0, 1 or 2)
          ADREG => 1,                        -- Number of pipeline stages for pre-adder (0 or 1)
          ALUMODEREG => 1,                   -- Number of pipeline stages for ALUMODE (0 or 1)
          AREG => 1,                         -- Number of pipeline stages for A (0, 1 or 2)
          BCASCREG => 1,                     -- Number of pipeline stages between B/BCIN and BCOUT (0, 1 or 2)
          BREG => 1,                         -- Number of pipeline stages for B (0, 1 or 2)
          CARRYINREG => 1,                   -- Number of pipeline stages for CARRYIN (0 or 1)
          CARRYINSELREG => 1,                -- Number of pipeline stages for CARRYINSEL (0 or 1)
          CREG => 1,                         -- Number of pipeline stages for C (0 or 1)
          DREG => 1,                         -- Number of pipeline stages for D (0 or 1)
          INMODEREG => 1,                    -- Number of pipeline stages for INMODE (0 or 1)
          MREG => 1,                         -- Number of multiplier pipeline stages (0 or 1)
          OPMODEREG => 1,                    -- Number of pipeline stages for OPMODE (0 or 1)
          PREG => 1                          -- Number of pipeline stages for P (0 or 1)
        )
        port map (
          -- Cascade: 30-bit (each) input: Cascade Ports
          ACIN => (others => '0'), 							-- 30-bit input: A cascade data input
          BCIN => (others => '0'), 							-- 18-bit input: B cascade input
          CARRYCASCIN => '0',                         -- 1-bit input: Cascade carry input
          MULTSIGNIN => '0',                          -- 1-bit input: Multiplier sign input
          PCIN => P_signal_1,					       		-- 48-bit input: P cascade input
          -- Control: 4-bit (each) input: Control Inputs/Status Bits
          ALUMODE => "0000",                          -- 4-bit input: ALU control input
          CARRYINSEL => "000",                        -- 3-bit input: Carry select input
          CLK => CLK,                                 -- 1-bit input: Clock input
          INMODE => "01101",                          -- 5-bit input: INMODE control input
          OPMODE => "1010101",                        -- 7-bit input: Operation mode input(17-bit shift)
          -- Data: 30-bit (each) input: Data Ports
          A => A2,               -- 30-bit input: A data input
          B => B2,                 				   -- 18-bit input: B data input
          C => (others => '0'),                       -- 48-bit input: C data input
          D => (others => '0'),  							-- 25-bit input: D data input
          CARRYIN => '0',                             -- 1-bit input: Carry input signal
          -- Reset/Clock Enable: 1-bit (each) input: Reset/Clock Enable Inputs
          CEA1 => '1',                                -- 1-bit input: Clock enable input for 1st stage AREG
          CEA2 => '1',                                -- 1-bit input: Clock enable input for 2nd stage AREG
          CEAD => '1',                                -- 1-bit input: Clock enable input for ADREG
          CEALUMODE => '0',                           -- 1-bit input: Clock enable input for ALUMODE
          CEB1 => '1',                                -- 1-bit input: Clock enable input for 1st stage BREG
          CEB2 => '1',                                -- 1-bit input: Clock enable input for 2nd stage BREG
          CEC => '0',                                 -- 1-bit input: Clock enable input for CREG
          CECARRYIN => '0',                           -- 1-bit input: Clock enable input for CARRYINREG
          CECTRL => '0',                              -- 1-bit input: Clock enable input for OPMODEREG and CARRYINSELREG
          CED => '1',                                 -- 1-bit input: Clock enable input for DREG
          CEINMODE => '0',                            -- 1-bit input: Clock enable input for INMODEREG
          CEM => '0',                                 -- 1-bit input: Clock enable input for MREG
          CEP => '1',                                 -- 1-bit input: Clock enable input for PREG
          RSTA => RST,                                -- 1-bit input: Reset input for AREG
          RSTALLCARRYIN => '0',                       -- 1-bit input: Reset input for CARRYINREG
          RSTALUMODE => '0',                          -- 1-bit input: Reset input for ALUMODEREG
          RSTB => RST,                                -- 1-bit input: Reset input for BREG
          RSTC => '0',                                -- 1-bit input: Reset input for CREG
          RSTCTRL => RST,                             -- 1-bit input: Reset input for OPMODEREG and CARRYINSELREG
          RSTD => RST,                                -- 1-bit input: Reset input for DREG and ADREG
          RSTINMODE => RST,                           -- 1-bit input: Reset input for INMODEREG
          RSTM => RST,                                -- 1-bit input: Reset input for MREG
          RSTP => RST,                                -- 1-bit input: Reset input for PREG
			 --P => P_signal_2,
          PCOUT => P_signal_2
        );
      A3 <= "00" & A_high;
      B3 <= '0' & B_low;
	   -- Third DSP48E1 instance for P = A_high * B_low 
      DSP48E1_inst3 : DSP48E1
        generic map (
          -- Feature Control Attributes: Data Path Selection
          A_INPUT => "DIRECT",               -- Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
          B_INPUT => "DIRECT",               -- Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
          USE_DPORT => FALSE,                -- Select D port usage (TRUE or FALSE)
          USE_MULT => "MULTIPLY",            -- Select multiplier usage ("MULTIPLY", "DYNAMIC", or "NONE")
          USE_SIMD => "ONE48",               -- SIMD selection ("ONE48", "TWO24", "FOUR12")
          -- Pattern Detector Attributes: Pattern Detection Configuration
          AUTORESET_PATDET => "NO_RESET",    -- "NO_RESET", "RESET_MATCH", "RESET_NOT_MATCH" 
          MASK => X"3fffffffffff",           -- 48-bit mask value for pattern detect (1=ignore)
          PATTERN => X"000000000000",        -- 48-bit pattern match for pattern detect
          SEL_MASK => "MASK",                -- "C", "MASK", "ROUNDING_MODE1", "ROUNDING_MODE2" 
          SEL_PATTERN => "PATTERN",          -- Select pattern value ("PATTERN" or "C")
          USE_PATTERN_DETECT => "NO_PATDET", -- Enable pattern detect ("PATDET" or "NO_PATDET")
          -- Register Control Attributes: Pipeline Register Configuration
          ACASCREG => 1,                     -- Number of pipeline stages between A/ACIN and ACOUT (0, 1 or 2)
          ADREG => 1,                        -- Number of pipeline stages for pre-adder (0 or 1)
          ALUMODEREG => 1,                   -- Number of pipeline stages for ALUMODE (0 or 1)
          AREG => 1,                         -- Number of pipeline stages for A (0, 1 or 2)
          BCASCREG => 1,                     -- Number of pipeline stages between B/BCIN and BCOUT (0, 1 or 2)
          BREG => 1,                         -- Number of pipeline stages for B (0, 1 or 2)
          CARRYINREG => 1,                   -- Number of pipeline stages for CARRYIN (0 or 1)
          CARRYINSELREG => 1,                -- Number of pipeline stages for CARRYINSEL (0 or 1)
          CREG => 1,                         -- Number of pipeline stages for C (0 or 1)
          DREG => 1,                         -- Number of pipeline stages for D (0 or 1)
          INMODEREG => 1,                    -- Number of pipeline stages for INMODE (0 or 1)
          MREG => 1,                         -- Number of multiplier pipeline stages (0 or 1)
          OPMODEREG => 1,                    -- Number of pipeline stages for OPMODE (0 or 1)
          PREG => 1                          -- Number of pipeline stages for P (0 or 1)
        )
        port map (
          -- Cascade: 30-bit (each) input: Cascade Ports
          ACIN => (others => '0'), 							-- 30-bit input: A cascade data input
          BCIN => (others => '0'), 							-- 18-bit input: B cascade input
          CARRYCASCIN => '0',                         -- 1-bit input: Cascade carry input
          MULTSIGNIN => '0',                          -- 1-bit input: Multiplier sign input
          PCIN => P_signal_2,							    	-- 48-bit input: P cascade input
          -- Control: 4-bit (each) input: Control Inputs/Status Bits
          ALUMODE => "0000",                          -- 4-bit input: ALU control input
          CARRYINSEL => "000",                        -- 3-bit input: Carry select input
          CLK => CLK,                                 -- 1-bit input: Clock input
          INMODE => "01101",                          -- 5-bit input: INMODE control input
          OPMODE => "0010101",                        -- 7-bit input: Operation mode input(PCIN)
          -- Data: 30-bit (each) input: Data Ports
          A => A3,          			      -- 30-bit input: A data input
          B => B3,                 		      -- 18-bit input: B data input
          C => (others => '0'),                       -- 48-bit input: C data input
          D => (others => '0'),  							-- 25-bit input: D data input
          CARRYIN => '0',                             -- 1-bit input: Carry input signal
          -- Reset/Clock Enable: 1-bit (each) input: Reset/Clock Enable Inputs
          CEA1 => '1',                                -- 1-bit input: Clock enable input for 1st stage AREG
          CEA2 => '1',                                -- 1-bit input: Clock enable input for 2nd stage AREG
          CEAD => '1',                                -- 1-bit input: Clock enable input for ADREG
          CEALUMODE => '0',                           -- 1-bit input: Clock enable input for ALUMODE
          CEB1 => '1',                                -- 1-bit input: Clock enable input for 1st stage BREG
          CEB2 => '1',                                -- 1-bit input: Clock enable input for 2nd stage BREG
          CEC => '0',                                 -- 1-bit input: Clock enable input for CREG
          CECARRYIN => '0',                           -- 1-bit input: Clock enable input for CARRYINREG
          CECTRL => '0',                              -- 1-bit input: Clock enable input for OPMODEREG and CARRYINSELREG
          CED => '1',                                 -- 1-bit input: Clock enable input for DREG
          CEINMODE => '0',                            -- 1-bit input: Clock enable input for INMODEREG
          CEM => '0',                                 -- 1-bit input: Clock enable input for MREG
          CEP => '1',                                 -- 1-bit input: Clock enable input for PREG
          RSTA => RST,                                -- 1-bit input: Reset input for AREG
          RSTALLCARRYIN => '0',                       -- 1-bit input: Reset input for CARRYINREG
          RSTALUMODE => '0',                          -- 1-bit input: Reset input for ALUMODEREG
          RSTB => RST,                                -- 1-bit input: Reset input for BREG
          RSTC => '0',                                -- 1-bit input: Reset input for CREG
          RSTCTRL => RST,                             -- 1-bit input: Reset input for OPMODEREG and CARRYINSELREG
          RSTD => RST,                                -- 1-bit input: Reset input for DREG and ADREG
          RSTINMODE => RST,                           -- 1-bit input: Reset input for INMODEREG
          RSTM => RST,                                -- 1-bit input: Reset input for MREG
          RSTP => RST,                                -- 1-bit input: Reset input for PREG
			 --P => P_signal_3,
          PCOUT => P_signal_3					        
        );
	  A4 <= "00" & A_high;  
	  B4 <= B_high;
      -- Fourth DSP48E1 instance for P = A_high * B_high 
      DSP48E1_inst4 : DSP48E1
        generic map (
          -- Feature Control Attributes: Data Path Selection
          A_INPUT => "DIRECT",               -- Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
          B_INPUT => "DIRECT",               -- Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
          USE_DPORT => FALSE,                -- Select D port usage (TRUE or FALSE)
          USE_MULT => "MULTIPLY",            -- Select multiplier usage ("MULTIPLY", "DYNAMIC", or "NONE")
          USE_SIMD => "ONE48",               -- SIMD selection ("ONE48", "TWO24", "FOUR12")
          -- Pattern Detector Attributes: Pattern Detection Configuration
          AUTORESET_PATDET => "NO_RESET",    -- "NO_RESET", "RESET_MATCH", "RESET_NOT_MATCH" 
          MASK => X"3fffffffffff",           -- 48-bit mask value for pattern detect (1=ignore)
          PATTERN => X"000000000000",        -- 48-bit pattern match for pattern detect
          SEL_MASK => "MASK",                -- "C", "MASK", "ROUNDING_MODE1", "ROUNDING_MODE2" 
          SEL_PATTERN => "PATTERN",          -- Select pattern value ("PATTERN" or "C")
          USE_PATTERN_DETECT => "NO_PATDET", -- Enable pattern detect ("PATDET" or "NO_PATDET")
          -- Register Control Attributes: Pipeline Register Configuration
          ACASCREG => 1,                     -- Number of pipeline stages between A/ACIN and ACOUT (0, 1 or 2)
          ADREG => 1,                        -- Number of pipeline stages for pre-adder (0 or 1)
          ALUMODEREG => 1,                   -- Number of pipeline stages for ALUMODE (0 or 1)
          AREG => 1,                         -- Number of pipeline stages for A (0, 1 or 2)
          BCASCREG => 1,                     -- Number of pipeline stages between B/BCIN and BCOUT (0, 1 or 2)
          BREG => 1,                         -- Number of pipeline stages for B (0, 1 or 2)
          CARRYINREG => 1,                   -- Number of pipeline stages for CARRYIN (0 or 1)
          CARRYINSELREG => 1,                -- Number of pipeline stages for CARRYINSEL (0 or 1)
          CREG => 1,                         -- Number of pipeline stages for C (0 or 1)
          DREG => 1,                         -- Number of pipeline stages for D (0 or 1)
          INMODEREG => 1,                    -- Number of pipeline stages for INMODE (0 or 1)
          MREG => 1,                         -- Number of multiplier pipeline stages (0 or 1)
          OPMODEREG => 1,                    -- Number of pipeline stages for OPMODE (0 or 1)
          PREG => 1                          -- Number of pipeline stages for P (0 or 1)
        )
        port map (
          -- Cascade: 30-bit (each) input: Cascade Ports
          ACIN => (others => '0'), 							-- 30-bit input: A cascade data input
          BCIN => (others => '0'), 							-- 18-bit input: B cascade input
          CARRYCASCIN => '0',                         -- 1-bit input: Cascade carry input
          MULTSIGNIN => '0',                          -- 1-bit input: Multiplier sign input
          PCIN => P_signal_3,									-- 48-bit input: P cascade input
          -- Control: 4-bit (each) input: Control Inputs/Status Bits
          ALUMODE => "0000",                          -- 4-bit input: ALU control input
          CARRYINSEL => "000",                        -- 3-bit input: Carry select input
          CLK => CLK,                                 -- 1-bit input: Clock input
          INMODE => "01101",                          -- 5-bit input: INMODE control input
          OPMODE => "1010101",                        -- 7-bit input: Operation mode input(17-bit shift)
          -- Data: 30-bit (each) input: Data Ports
          A => A4,				               -- 30-bit input: A data input
          B => B4,                 				   -- 18-bit input: B data input
          C => (others => '0'),                       -- 48-bit input: C data input
          D => (others => '0'),  							-- 25-bit input: D data input
          CARRYIN => '0',                             -- 1-bit input: Carry input signal
          -- Reset/Clock Enable: 1-bit (each) input: Reset/Clock Enable Inputs
          CEA1 => '1',                                -- 1-bit input: Clock enable input for 1st stage AREG
          CEA2 => '1',                                -- 1-bit input: Clock enable input for 2nd stage AREG
          CEAD => '1',                                -- 1-bit input: Clock enable input for ADREG
          CEALUMODE => '0',                           -- 1-bit input: Clock enable input for ALUMODE
          CEB1 => '1',                                -- 1-bit input: Clock enable input for 1st stage BREG
          CEB2 => '1',                                -- 1-bit input: Clock enable input for 2nd stage BREG
          CEC => '0',                                 -- 1-bit input: Clock enable input for CREG
          CECARRYIN => '0',                           -- 1-bit input: Clock enable input for CARRYINREG
          CECTRL => '0',                              -- 1-bit input: Clock enable input for OPMODEREG and CARRYINSELREG
          CED => '1',                                 -- 1-bit input: Clock enable input for DREG
          CEINMODE => '0',                            -- 1-bit input: Clock enable input for INMODEREG
          CEM => '0',                                 -- 1-bit input: Clock enable input for MREG
          CEP => '1',                                 -- 1-bit input: Clock enable input for PREG
          RSTA => RST,                                -- 1-bit input: Reset input for AREG
          RSTALLCARRYIN => '0',                       -- 1-bit input: Reset input for CARRYINREG
          RSTALUMODE => '0',                          -- 1-bit input: Reset input for ALUMODEREG
          RSTB => RST,                                -- 1-bit input: Reset input for BREG
          RSTC => '0',                                -- 1-bit input: Reset input for CREG
          RSTCTRL => RST,                             -- 1-bit input: Reset input for OPMODEREG and CARRYINSELREG
          RSTD => RST,                                -- 1-bit input: Reset input for DREG and ADREG
          RSTINMODE => RST,                           -- 1-bit input: Reset input for INMODEREG
          RSTM => RST,                                -- 1-bit input: Reset input for MREG
          RSTP => RST,                                -- 1-bit input: Reset input for PREG
          P => P_signal_4				     					      
        );
		  
		  PP <= P_signal_4 & P_signal_3(33 downto 17) & P_signal_1(16 downto 0);
end Behavioral;
