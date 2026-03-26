SET SERVEROUTPUT ON;

DECLARE
    v_full_name  VARCHAR2(100);
    v_emp_id     hr.employees.employee_id%TYPE := &Enter_Employee_ID;
    v_salary     hr.employees.salary%TYPE;  -- Using %TYPE to ensure data compatibility with the HR schema
    v_dept_id    hr.employees.department_id%TYPE;
    v_bonus      NUMBER := 0;
    v_total_pay  NUMBER := 0;

BEGIN
    -- Fetching employee details into variables
    SELECT (first_name || ' ' || last_name), salary, department_id
    INTO   v_full_name, v_salary, v_dept_id
    FROM   hr.employees
    WHERE  employee_id = v_emp_id;

    -- Bonus Calculation
    IF    v_dept_id = 10 THEN v_bonus := 0.15 * v_salary; -- 15% Bonus
    ELSIF v_dept_id = 20 THEN v_bonus := 0.10 * v_salary; -- 10% Bonus
    ELSE  v_bonus := 0.05 * v_salary;                     -- 5% Bonus for others
    END IF;

    -- Initial Total Calculation
    v_total_pay := v_salary + v_bonus;

    -- Additional $500 support for low-income  < 3000
    IF v_total_pay < 3000 THEN 
       v_total_pay := v_total_pay + 500;
    END IF;

    -- Final Output
    DBMS_OUTPUT.PUT_LINE('---------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Employee Name : ' || v_full_name);
    DBMS_OUTPUT.PUT_LINE('Base Salary   : ' || TO_CHAR(v_salary, '$99,999.00'));
    DBMS_OUTPUT.PUT_LINE('Bonus Amount  : ' || TO_CHAR(v_bonus, '$99,999.00'));
    DBMS_OUTPUT.PUT_LINE('Total Income  : ' || TO_CHAR(v_total_pay, '$99,999.00'));
    DBMS_OUTPUT.PUT_LINE('---------------------------------------');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Employee ID (' || v_emp_id || ') does not exist.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: An unexpected system error occurred.');
END;
/