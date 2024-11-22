library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity updowncounter is
    Port ( CLK : in  STD_LOGIC;
			  RESET : in STD_LOGIC;
			  L0 : out STD_LOGIC;              
			  L1 : out STD_LOGIC;              
           L2 : out STD_LOGIC;              
           L3 : out STD_LOGIC;            
			  Q : out STD_LOGIC_VECTOR(3 downto 0));
end updowncounter;

architecture Behavioral of updowncounter is
	signal counter: integer :=0;
	signal CLK_devided : STD_LOGIC := '0';
	signal Qn : STD_LOGIC_VECTOR(3 downto 0) := "0000";
	signal up_direction  : STD_LOGIC := '1';
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
            Qn <= "0000"; 
            up_direction <= '1'; 
        elsif rising_edge(CLK_devided) then
            if up_direction = '1' then
                if Qn = "1111" then
                    up_direction <= '0'; 
                    Qn <= Qn - 1; 
                else
                    Qn <= Qn + 1; 
                end if;
            else
                if Qn = "0000" then
                    up_direction <= '1'; 
                    Qn <= Qn + 1;
                else
                    Qn <= Qn - 1; 
                end if;
            end if;
        end if;
    end process;
	 Q <= Qn;
	 
	 L0 <= Qn(0); -- LSB
    L1 <= Qn(1);
    L2 <= Qn(2);
    L3 <= Qn(3); -- MSB
	 
end Behavioral;
