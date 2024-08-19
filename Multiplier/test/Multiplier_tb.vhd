--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:05:54 05/19/2024
-- Design Name:   
-- Module Name:   C:/Users/asus/Desktop/New folder3/FPGA_PROJECT/Multiplier_tb.vhd
-- Project Name:  FPGA_PROJECT
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Multiplier
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Multiplier_tb IS
END Multiplier_tb;
 
ARCHITECTURE behavior OF Multiplier_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Multiplier
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         AA : IN  std_logic_vector(44 downto 0);
         BB : IN  std_logic_vector(34 downto 0);
         PP : OUT  std_logic_vector(81 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal AA : std_logic_vector(44 downto 0) := (others => '0');
   signal BB : std_logic_vector(34 downto 0) := (others => '0');

 	--Outputs
   signal PP : std_logic_vector(81 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Multiplier PORT MAP (
          CLK => CLK,
          RST => RST,
          AA => AA,
          BB => BB,
          PP => PP
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      RST <= '1';
      wait for 102 ns;	

      wait for CLK_period*10;

      RST <= '0'; 
		AA <= std_logic_vector(to_unsigned(2,45));
		BB <= std_logic_vector(to_unsigned(3,35));
		wait for CLK_period*10;
		
		AA <= std_logic_vector(to_unsigned(4,45));
		BB <= std_logic_vector(to_unsigned(2,35));
		wait for CLK_period*10;
		
		AA <= std_logic_vector(to_unsigned(5,45));
		BB <= std_logic_vector(to_unsigned(5,35));
		wait for CLK_period*10;
		
		AA <= std_logic_vector(to_unsigned(6,45));
		BB <= std_logic_vector(to_unsigned(5,35));
		wait for CLK_period*10;
		
		AA <= std_logic_vector(to_unsigned(5,45));
		BB <= std_logic_vector(to_unsigned(6,35));
		wait for CLK_period*10;
		
		AA <= std_logic_vector(to_unsigned(6,45));
		BB <= std_logic_vector(to_unsigned(6,35));
		wait for CLK_period*10;
		
		AA <= std_logic_vector(to_unsigned(10,45));
		BB <= std_logic_vector(to_unsigned(2,35));
		wait for CLK_period*10;
		
		AA <= std_logic_vector(to_unsigned(10,45));
		BB <= std_logic_vector(to_unsigned(20,35));
		wait for CLK_period*10;
		
		AA <= std_logic_vector(to_unsigned(20,45));
		BB <= std_logic_vector(to_unsigned(15,35));
		wait for CLK_period*10;
		
		AA <= std_logic_vector(to_unsigned(16,45));
		BB <= std_logic_vector(to_unsigned(17,35));
		wait for CLK_period*10;
		
      wait;
   end process;

END;
