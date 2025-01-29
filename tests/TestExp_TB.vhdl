LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY TestExp_TB IS
END TestExp_TB;

ARCHITECTURE behavior OF TestExp_TB IS
    -- Component declaration for the Unit Under Test (UUT)
    COMPONENT TestExp
        PORT(
            A, B: IN std_logic_vector(6 DOWNTO 0);
            clock: IN std_logic;
            A_gt_B, B_gt_A: OUT std_logic;
            ResultReg: OUT std_logic_vector(7 DOWNTO 0);
            clk: OUT std_logic;
            inputALUA: OUT std_logic_vector(7 DOWNTO 0);
            inputALUB: OUT std_logic_vector(7 DOWNTO 0)
        );
    END COMPONENT;

    -- Testbench signals
    SIGNAL A, B: std_logic_vector(6 DOWNTO 0) := (OTHERS => '0');
    SIGNAL clock: std_logic := '0';
    SIGNAL A_gt_B, B_gt_A: std_logic;
    SIGNAL ResultReg: std_logic_vector(7 DOWNTO 0);
    SIGNAL cloook: std_logic;
    SIGNAL inputALUA, inputALUB: std_logic_vector(7 DOWNTO 0);
    
    CONSTANT clk_period: TIME := 10 ns;
BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut: TestExp PORT MAP (
        A => A,
        B => B,
        clock => clock,
        A_gt_B => A_gt_B,
        B_gt_A => B_gt_A,
        ResultReg => ResultReg,
        cloook => clock,
        inputALUA => inputALUA,
        inputALUB => inputALUB
    );

    -- Clock process
    clock_process: PROCESS
    BEGIN
        WHILE NOW < 200 ns LOOP
            clock <= '0';
            WAIT FOR clk_period / 2;
            clock <= '1';
            WAIT FOR clk_period / 2;
        END LOOP;
        WAIT;
    END PROCESS;

    -- Stimulus process
    stim_proc: PROCESS
    BEGIN
        -- Test case 1: A > B
        A <= "0001010"; -- 10
        B <= "0000011"; -- 3
        WAIT FOR clk_period;
        ASSERT (A_gt_B = '1' AND B_gt_A = '0') REPORT "Test Case 1 Failed: A > B" SEVERITY ERROR;

        -- Test case 2: A < B
        A <= "0000010"; -- 2
        B <= "0000111"; -- 7
        WAIT FOR clk_period;
        ASSERT (A_gt_B = '0' AND B_gt_A = '1') REPORT "Test Case 2 Failed: A < B" SEVERITY ERROR;

        -- Test case 3: A = B
        A <= "0001001"; -- 9
        B <= "0001001"; -- 9
        WAIT FOR clk_period;
        ASSERT (A_gt_B = '0' AND B_gt_A = '0') REPORT "Test Case 3 Failed: A = B" SEVERITY ERROR;

        -- Test case 4: Edge case (Max values)
        A <= "1111111"; -- 127
        B <= "1111110"; -- 126
        WAIT FOR clk_period;
        ASSERT (A_gt_B = '1' AND B_gt_A = '0') REPORT "Test Case 4 Failed: A > B (Edge Case)" SEVERITY ERROR;

        -- Test case 5: Edge case (Min values)
        A <= "0000000"; -- 0
        B <= "0000001"; -- 1
        WAIT FOR clk_period;
        ASSERT (A_gt_B = '0' AND B_gt_A = '1') REPORT "Test Case 5 Failed: A < B (Edge Case)" SEVERITY ERROR;

        REPORT "Testbench completed successfully!" SEVERITY NOTE;
        WAIT;
    END PROCESS;
END behavior;