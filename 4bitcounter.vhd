library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity fourbitcounterup is
    Port ( CLK : in  STD_LOGIC;
			  RESET : in STD_LOGIC;
			  L0 : out STD_LOGIC;              
			  L1 : out STD_LOGIC;              
           L2 : out STD_LOGIC;              
           L3 : out STD_LOGIC;            
			  Q : out STD_LOGIC_VECTOR(3 downto 0));
end fourbitcounterup;

architecture Behavioral of fourbitcounterup is
	signal counter: integer :=0;
	signal CLK_devided : STD_LOGIC := '0';
	signal Qn : STD_LOGIC_VECTOR(3 downto 0) := "0000";
begin
    process(CLK)
    begin  
			if CLK' event and CLK = '1' then
            if counter = 50000000 / 2  then
                counter <= 0;
					 CLK_devided <= not CLK_devided;
				else
					counter <= counter + 1;	 
            end if;
        end if;	
    end process;
	 
	 
	 process(CLK_devided,RESET)
	 begin
        if RESET = '1' then
            Qn <= "0000"; -- Reset counter to 0
        elsif rising_edge(CLK_devided) then
            Qn <= Qn + 1; -- Increment counter on divided clock pulse
        end if;
    end process;
	 Q <= Qn;
	 
	 L0 <= Qn(0); -- LSB
    L1 <= Qn(1);
    L2 <= Qn(2);
    L3 <= Qn(3); -- MSB
	 
end Behavioral;
