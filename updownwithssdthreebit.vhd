library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity updownwithssdthreebit is
    Port ( 
        CLK      : in  STD_LOGIC;              -- 50 MHz clock input
        RESET    : in  STD_LOGIC;              -- Reset signal
        UP_DOWN  : in  STD_LOGIC;              -- Direction control signal (1 = up, 0 = down)
        SSD      : out STD_LOGIC_VECTOR(6 downto 0) -- Seven Segment Display (Common cathode)
    );
end updownwithssdthreebit;

architecture Behavioral of updownwithssdthreebit is
    signal counter       : integer := 0;
    signal CLK_divided   : STD_LOGIC := '0';
    signal Qn            : STD_LOGIC_VECTOR(2 downto 0) := "000"; -- 3-bit counter value
begin

    -- Clock Divider Process: Divide 50 MHz clock to 1 Hz
    process(CLK)
    begin
        if CLK'event and CLK = '1' then
            if counter = 50000000 / 2 then -- Divides clock frequency to 1 Hz
                counter <= 0;
                CLK_divided <= not CLK_divided;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    -- Counter Process
    process(CLK_divided, RESET)
    begin
        if RESET = '1' then
            Qn <= "000"; -- Reset counter to 0
        elsif rising_edge(CLK_divided) then
            if UP_DOWN = '1' then
                if Qn = "111" then
                    Qn <= "000"; -- Wrap around on overflow
                else
                    Qn <= Qn + 1; -- Count up
                end if;
            else
                if Qn = "000" then
                    Qn <= "111"; -- Wrap around on underflow
                else
                    Qn <= Qn - 1; -- Count down
                end if;
            end if;
        end if;
    end process;

    -- SSD Decoder: Convert 3-bit counter value to SSD segments
    process(Qn)
    begin
        case Qn is
            when "000" => SSD <= "0000001"; -- Display 0
            when "001" => SSD <= "1001111"; -- Display 1
            when "010" => SSD <= "0010010"; -- Display 2
            when "011" => SSD <= "0000110"; -- Display 3
            when "100" => SSD <= "1001100"; -- Display 4
            when "101" => SSD <= "0100100"; -- Display 5
            when "110" => SSD <= "0100000"; -- Display 6
            when "111" => SSD <= "0001111"; -- Display 7
            when others => SSD <= "1111111"; -- Blank display (default)
        end case;
    end process;

end Behavioral;