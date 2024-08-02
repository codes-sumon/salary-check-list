
DECLARE 
    P_DATE DATE := '31-JUL-2024';
    P_SALARY_MONTH NUMBER := 7;
    P_YEAR_ID NUMBER := 2024;
BEGIN
	DECLARE
		V_VC_SL NUMBER;
		V_VC_NO VARCHAR2(50);
		V_VC_ID NUMBER;
		V_SLNO NUMBER := 1;
		V_DESCRIPTION_DR VARCHAR2(2000);
		V_DESCRIPTION_CR VARCHAR2(2000);
		V_FOR VARCHAR2(50);
		V_DATE DATE := P_DATE;
		V_MESSAGE VARCHAR2(150);

		CURSOR C1 IS
		SELECT DISTINCT TRIM(REGION_STATUS) REGION_STATUS 
		FROM COM_LOCATION
		WHERE YSN_ACTIVE = 1;
	BEGIN
		FOR REC1 IN C1 LOOP
			IF REC1.REGION_STATUS = 'Corporate' THEN
				V_FOR := 'Corporate Office';
			ELSIF REC1.REGION_STATUS = 'Factory' THEN
				V_FOR := 'Factory';
			ELSIF REC1.REGION_STATUS = 'Marketing' THEN
				V_FOR := 'Field Force';
			END IF;
			BEGIN
				PRC_CODE_GENERATE(P_VJ_CODE => '07', P_DATE => V_DATE, P_VC_NO => V_VC_NO, P_VC_ID => V_VC_ID);
			END;

			SELECT MAX(NVL(VC_SL,0))+1
			INTO V_VC_SL
			FROM GL_VOUCHER_MAIN;
			
			V_DESCRIPTION_DR := 'Being the amount Provision to Salary and Allowance '||V_FOR||'. For the month of '|| TO_CHAR(V_DATE, 'Month YYYY');

			INSERT INTO GL_VOUCHER_MAIN(VC_NO, VC_ID, VC_DATE, VC_ENTERED, VJ_CODE, CUR_CODE, VC_CONV_RATE, VC_IS_POSTED, IS_SYSTEM, COMP_ID, VC_SL)
			VALUES( V_VC_NO, V_VC_ID, V_DATE, SYSDATE, '07',  '0001', 1, 'N', 'Y', 14,  V_VC_SL);

			INSERT INTO GL_VOUCHER_DETAIL (VC_NO, VC_ID, COA_CODE, RC_CODE, VD_DESCRIPTION, VD_UNPOSTED_DR_AMT, VD_UNPOSTED_CR_AMT, VD_ENTERED_DR_AMT, VD_ENTERED_CR_AMT, VD_POSTED_DR_AMT, VD_POSTED_CR_AMT, SLNO, COMP_ID, SUP_CODE)
			SELECT V_VC_NO, V_VC_ID, COA_CODE_DR, 'RC140500000' RC_CODE, V_DESCRIPTION_DR, DR_AMOUNT,  CR_AMOUNT, DR_AMOUNT,  CR_AMOUNT, 0, 0,  ROW_NUMBER() OVER (ORDER BY SL ) SL_NO, 14, SUP_CODE
				FROM (
						/* Salary Debit Part Start*/
						SELECT 1 SL, 1 SLNO, D.REGION_STATUS, C.COA_CODE_DR, E.COA_DESC_LONG,
						(SUM(MON_SALARY) 
								+         SUM(NVL(MON_NIGHT_ALLOWANCE,0)   +   NVL(MON_ATTENDANCE_BENEFIT,0) +   NVL(MON_NON_TAB_BENEFIT,0) +   NVL(MON_NIGHT_BENEFIT,0)  +   NVL(MON_DAY_OFF_BENEFIT,0) 
								+   NVL(MON_DO_FF_ERBENEFIT,0) +   NVL(MON_DORMATARY_BENEFIT,0) +   NVL(MON_SCOTT_BENEFIT,0) +   NVL(MON_LIEUBENEFIT,0)  +   NVL(MON_DRIVER_ALLOWANCE,0) 
								+   NVL(MONMOTORCYCLE_ALLOWANCE,0)  +   NVL(MON_HOUSERENT_ALLOWANCE,0) +   NVL(MON_UNION_DONATION_ALLOWANCE,0) 
								+   NVL(MON_SPECIAL_SALARY_ALLOWANCE,0) +   NVL(MON_TA_DA_AMOUNT,0) +   NVL(MON_HEAT_BENEFIT,0) +  NVL(MON_JORABENIFIT,0)))
								- SUM( NVL(MON_COIN_AMOUNT,0)  +   NVL(MON_ABSENT_PUNISHMENT_AMOUNT,0) 
								 +   NVL(MON_LEAVE_PUNISHMENT_AMOUNT,0)  +   NVL(MON_LATE_PUNISHMENT_AMOUNT,0)  +   NVL(MON_PUNISHMENT,0) +   NVL(MON_UNION_FEE,0)  +   NVL(MON_ELECTRIC_BILL,0) 
								 +   NVL(MON_DISH_BILL,0) +   NVL(MON_TRANSPORT_BILL,0)  +   NVL(MON_CAFETERIA_BILL,0) 
								+   NVL(MON_GYM_BILL,0) + NVL(MON_ACCOMMODATION,0) ) DR_AMOUNT, 0 CR_AMOUNT, NULL SUP_CODE
						FROM MONTHLY_SALARY_GENERATE A, EMP_INFO B,  SALARY_GL_TAG C, COM_LOCATION D, GL_COA E
						WHERE A.EMP_ID = B.EMP_ID
						AND B.LOCATION_ID = C.JOB_LOCATION_ID
						AND B.DEPARTMENT_ID = C.DEPARTMENT_ID
						AND B.LOCATION_ID = D.LOC_ID
						AND  C.COA_CODE_DR = E.COA_CODE(+)
						AND C.TYPE_ID = 48     --Salary and Allowance
						AND A.MONTH_ID = P_SALARY_MONTH
						AND A.YEAR_ID = P_YEAR_ID
						AND A.MON_NET_PAYABLE_SALARY > 0
						AND (B.LOCATION_ID, B.DEPARTMENT_ID, B.DESIGNATION_ID) NOT IN (SELECT JOB_LOCATION_ID, DEPARTMENT_ID,  DESIGNATION_ID 
																						FROM SALARY_GROUP_TAG
																						WHERE JOB_LOCATION_ID = 6001
																						AND  DESIG_GROUP_ID = 4)
						GROUP BY D.REGION_STATUS, COA_CODE_DR, E.COA_DESC_LONG
					UNION ALL
						SELECT 1 SL, 1 SLNO, D.REGION_STATUS, C.COA_CODE_DR, E.COA_DESC_LONG,
                        (SUM(MON_SALARY) 
                                +         SUM(NVL(MON_NIGHT_ALLOWANCE,0)   +   NVL(MON_ATTENDANCE_BENEFIT,0) +   NVL(MON_NON_TAB_BENEFIT,0) +   NVL(MON_NIGHT_BENEFIT,0)  +   NVL(MON_DAY_OFF_BENEFIT,0) 
                                +   NVL(MON_DO_FF_ERBENEFIT,0) +   NVL(MON_DORMATARY_BENEFIT,0) +   NVL(MON_SCOTT_BENEFIT,0) +   NVL(MON_LIEUBENEFIT,0)  +   NVL(MON_DRIVER_ALLOWANCE,0) 
                                +   NVL(MONMOTORCYCLE_ALLOWANCE,0)  +   NVL(MON_HOUSERENT_ALLOWANCE,0) +   NVL(MON_UNION_DONATION_ALLOWANCE,0) 
                                +   NVL(MON_SPECIAL_SALARY_ALLOWANCE,0) +   NVL(MON_TA_DA_AMOUNT,0) +   NVL(MON_HEAT_BENEFIT,0) +  NVL(MON_JORABENIFIT,0) + NVL(MON_OT_AMOUNT,0)) )
                                - SUM( NVL(MON_COIN_AMOUNT,0)  +   NVL(MON_ABSENT_PUNISHMENT_AMOUNT,0) 
                                 +   NVL(MON_LEAVE_PUNISHMENT_AMOUNT,0)  +   NVL(MON_LATE_PUNISHMENT_AMOUNT,0)  +   NVL(MON_PUNISHMENT,0) +   NVL(MON_UNION_FEE,0)  +   NVL(MON_ELECTRIC_BILL,0) 
                                 +   NVL(MON_DISH_BILL,0) +   NVL(MON_TRANSPORT_BILL,0)  +   NVL(MON_CAFETERIA_BILL,0) 
                                +   NVL(MON_GYM_BILL,0) + NVL(MON_ACCOMMODATION,0) ) DR_AMOUNT, 0 CR_AMOUNT, NULL SUP_CODE
                        FROM MONTHLY_SALARY_GENERATE A, EMP_INFO B,  SALARY_GL_TAG C, COM_LOCATION D, GL_COA E
                        WHERE A.EMP_ID = B.EMP_ID
                        AND B.LOCATION_ID = C.JOB_LOCATION_ID
                        AND B.DEPARTMENT_ID = C.DEPARTMENT_ID
                        AND B.LOCATION_ID = D.LOC_ID
                        AND  C.COA_CODE_DR = E.COA_CODE(+)
                        AND C.TYPE_ID = 56     --Wages and OT 
                        AND A.MONTH_ID = P_SALARY_MONTH
                        AND A.YEAR_ID = P_YEAR_ID
                        AND A.MON_NET_PAYABLE_SALARY > 0
                        AND (B.LOCATION_ID, B.DEPARTMENT_ID, B.DESIGNATION_ID)  IN (SELECT JOB_LOCATION_ID, DEPARTMENT_ID,  DESIGNATION_ID 
                                                                                        FROM SALARY_GROUP_TAG
                                                                                        WHERE JOB_LOCATION_ID = 6001
                                                                                        AND  DESIG_GROUP_ID = 4)
                        GROUP BY D.REGION_STATUS, COA_CODE_DR, E.COA_DESC_LONG
                    UNION ALL
                        SELECT 1 SL, 2 SLNO,  D.REGION_STATUS, C.COA_CODE_DR, E.COA_DESC_LONG, SUM(MON_OT_AMOUNT) DR_AMOUNT , 0 CR_AMOUNT, NULL SUP_CODE
                        FROM MONTHLY_SALARY_GENERATE A, EMP_INFO B,  SALARY_GL_TAG C, COM_LOCATION D, GL_COA E
                        WHERE A.EMP_ID = B.EMP_ID
                        AND B.LOCATION_ID = C.JOB_LOCATION_ID
                        AND B.DEPARTMENT_ID = C.DEPARTMENT_ID
                        AND B.LOCATION_ID = D.LOC_ID
                        AND  C.COA_CODE_DR = E.COA_CODE(+)
                        AND C.TYPE_ID = 50 --Overtime Bill 
                        AND A.MONTH_ID = P_SALARY_MONTH
                        AND A.YEAR_ID = P_YEAR_ID
                        AND A.MON_NET_PAYABLE_SALARY > 0
                        AND (B.LOCATION_ID, B.DEPARTMENT_ID, B.DESIGNATION_ID) NOT IN (SELECT JOB_LOCATION_ID, DEPARTMENT_ID,  DESIGNATION_ID 
                                                                                        FROM SALARY_GROUP_TAG
                                                                                        WHERE JOB_LOCATION_ID = 6001
                                                                                        AND  DESIG_GROUP_ID = 4)
                        GROUP BY D.REGION_STATUS, COA_CODE_DR, E.COA_DESC_LONG
                    UNION ALL
                        SELECT 1 SL, 3 SLNO,  D.REGION_STATUS, C.COA_CODE_DR, E.COA_DESC_LONG, SUM(MON_MOBILE_ALLOWANCE) DR_AMOUNT, 0 CR_AMOUNT, NULL SUP_CODE
                        FROM MONTHLY_SALARY_GENERATE A, EMP_INFO B,  SALARY_GL_TAG C, COM_LOCATION D, GL_COA E
                        WHERE A.EMP_ID = B.EMP_ID
                        AND B.LOCATION_ID = C.JOB_LOCATION_ID
                        AND B.DEPARTMENT_ID = C.DEPARTMENT_ID
                        AND B.LOCATION_ID = D.LOC_ID
                        AND  C.COA_CODE_DR = E.COA_CODE(+)
                        AND C.TYPE_ID = 1  --Postage, Courier and Telegram
                        AND A.MONTH_ID = P_SALARY_MONTH
                        AND A.YEAR_ID = P_YEAR_ID
                        AND A.MON_NET_PAYABLE_SALARY > 0
                        GROUP BY D.REGION_STATUS, COA_CODE_DR, E.COA_DESC_LONG
                    UNION ALL
                        SELECT 1 SL, 4 SLNO,  D.REGION_STATUS, C.COA_CODE_DR, E.COA_DESC_LONG, SUM(MON_PF_AMOUNT) DR_AMOUNT, 0 CR_AMOUNT, NULL SUP_CODE
                        FROM MONTHLY_SALARY_GENERATE A, EMP_INFO B,  SALARY_GL_TAG C, COM_LOCATION D, GL_COA E
                        WHERE A.EMP_ID = B.EMP_ID
                        AND B.LOCATION_ID = C.JOB_LOCATION_ID
                        AND B.DEPARTMENT_ID = C.DEPARTMENT_ID
                        AND B.LOCATION_ID = D.LOC_ID
                        AND C.COA_CODE_DR = E.COA_CODE(+)
                        AND C.TYPE_ID = 49  --Provident Fund Contribution
                        AND A.MONTH_ID = P_SALARY_MONTH
                        AND A.YEAR_ID = P_YEAR_ID
                        AND A.MON_NET_PAYABLE_SALARY > 0
                        GROUP BY D.REGION_STATUS, COA_CODE_DR, E.COA_DESC_LONG
                    UNION ALL
                        SELECT 1 SL, 5 SLNO, D.REGION_STATUS, C.COA_CODE_DR, E.COA_DESC_LONG, SUM(MON_CONVEYANCE_ALLOWANCE) DR_AMOUNT, 0 CR_AMOUNT, NULL SUP_CODE
                        FROM MONTHLY_SALARY_GENERATE A, EMP_INFO B,  SALARY_GL_TAG C, COM_LOCATION D, GL_COA E
                        WHERE A.EMP_ID = B.EMP_ID
                        AND B.LOCATION_ID = C.JOB_LOCATION_ID
                        AND B.DEPARTMENT_ID = C.DEPARTMENT_ID
                        AND B.LOCATION_ID = D.LOC_ID
                        AND C.COA_CODE_DR = E.COA_CODE(+)
                        AND C.TYPE_ID = 4  --Travelling and Conveyance
                        AND A.MONTH_ID = P_SALARY_MONTH
                        AND A.YEAR_ID = P_YEAR_ID
                        AND A.MON_NET_PAYABLE_SALARY > 0
                        GROUP BY D.REGION_STATUS, COA_CODE_DR, E.COA_DESC_LONG
                    UNION ALL
                        SELECT 1 SL, 6 SLNO, D.REGION_STATUS, C.COA_CODE_DR, E.COA_DESC_LONG, SUM(MON_PL_AMOUNT) DR_AMOUNT, 0 CR_AMOUNT, NULL SUP_CODE
                        FROM MONTHLY_SALARY_GENERATE A, EMP_INFO B,  SALARY_GL_TAG C, COM_LOCATION D, GL_COA E
                        WHERE A.EMP_ID = B.EMP_ID
                        AND B.LOCATION_ID = C.JOB_LOCATION_ID
                        AND B.DEPARTMENT_ID = C.DEPARTMENT_ID
                        AND B.LOCATION_ID = D.LOC_ID
                        AND C.COA_CODE_DR = E.COA_CODE(+)
                        AND C.TYPE_ID = 7  --Prevailage Leave Allowance
                        AND A.MONTH_ID = P_SALARY_MONTH
                        AND A.YEAR_ID = P_YEAR_ID
                        AND A.MON_NET_PAYABLE_SALARY > 0
                        GROUP BY D.REGION_STATUS, COA_CODE_DR, E.COA_DESC_LONG

                        /* Salary Debit Part End*/

                        /* Salary Cradit Part Start*/
                    UNION ALL
                        SELECT 2 SL, 9 SLNO,  D.REGION_STATUS, C.COA_CODE, E.COA_DESC_LONG,
                        0 DR_AMOUNT, SUM(MON_NET_PAYABLE_SALARY) CR_AMOUNT, NULL SUP_CODE
                        FROM MONTHLY_SALARY_GENERATE A, EMP_INFO B,  SALARY_GL_TAG C, COM_LOCATION D, GL_COA E
                        WHERE A.EMP_ID = B.EMP_ID
                        AND B.LOCATION_ID = C.JOB_LOCATION_ID
                        AND B.DEPARTMENT_ID = C.DEPARTMENT_ID
                        AND B.LOCATION_ID = D.LOC_ID
                        AND  C.COA_CODE = E.COA_CODE(+)
                        AND C.TYPE_ID = 48     --Outstanding Salary and Allowance
                        AND A.MONTH_ID = P_SALARY_MONTH
                        AND A.YEAR_ID = P_YEAR_ID
                        AND A.MON_NET_PAYABLE_SALARY > 0
                        GROUP BY D.REGION_STATUS, C.COA_CODE, E.COA_DESC_LONG
                    UNION ALL
                        SELECT SL, 8 SLNO,  REGION_STATUS, COA_CODE, COA_DESC_LONG, DR_AMOUNT,  CR_AMOUNT, SUP_CODE 
                            FROM (SELECT 2 SL,  D.REGION_STATUS, C.COA_CODE, E.COA_DESC_LONG, 0 DR_AMOUNT, SUM(MON_PF_AMOUNT) CR_AMOUNT, NULL SUP_CODE
                                    FROM MONTHLY_SALARY_GENERATE A, EMP_INFO B,  SALARY_GL_TAG C, COM_LOCATION D, GL_COA E
                                    WHERE A.EMP_ID = B.EMP_ID
                                    AND B.LOCATION_ID = C.JOB_LOCATION_ID
                                    AND B.DEPARTMENT_ID = C.DEPARTMENT_ID
                                    AND B.LOCATION_ID = D.LOC_ID
                                    AND C.COA_CODE = E.COA_CODE(+)
                                    AND C.TYPE_ID = 49  --Provident Fund Contribution
                                    AND A.MONTH_ID = P_SALARY_MONTH
                                    AND A.YEAR_ID = P_YEAR_ID
                                    AND A.MON_NET_PAYABLE_SALARY > 0
                                    GROUP BY D.REGION_STATUS, C.COA_CODE, E.COA_DESC_LONG
                                UNION ALL
                                    SELECT 2 SL,  D.REGION_STATUS, C.COA_CODE, E.COA_DESC_LONG, 0 DR_AMOUNT, SUM(MON_PF_AMOUNT) CR_AMOUNT, NULL SUP_CODE
                                    FROM MONTHLY_SALARY_GENERATE A, EMP_INFO B,  SALARY_GL_TAG C, COM_LOCATION D, GL_COA E
                                    WHERE A.EMP_ID = B.EMP_ID
                                    AND B.LOCATION_ID = C.JOB_LOCATION_ID
                                    AND B.DEPARTMENT_ID = C.DEPARTMENT_ID
                                    AND B.LOCATION_ID = D.LOC_ID
                                    AND C.COA_CODE = E.COA_CODE(+)
                                    AND C.TYPE_ID = 49  --Provident Fund Contribution
                                    AND A.MONTH_ID = P_SALARY_MONTH
                                    AND A.YEAR_ID = P_YEAR_ID
                                    AND A.MON_NET_PAYABLE_SALARY > 0
                                    GROUP BY D.REGION_STATUS, C.COA_CODE, E.COA_DESC_LONG)
                    UNION ALL
                        SELECT 2 SL, 10 SLNO,  D.REGION_STATUS, C.COA_CODE, E.COA_DESC_LONG, 0 DR_AMOUNT, SUM(TAX_AMOUNT) CR_AMOUNT, NULL SUP_CODE
                        FROM MONTHLY_SALARY_GENERATE A, EMP_INFO B,  SALARY_GL_TAG C, COM_LOCATION D, GL_COA E
                        WHERE A.EMP_ID = B.EMP_ID
                        AND B.LOCATION_ID = C.JOB_LOCATION_ID
                        AND B.DEPARTMENT_ID = C.DEPARTMENT_ID
                        AND B.LOCATION_ID = D.LOC_ID
                        AND C.COA_CODE = E.COA_CODE(+)
                        AND C.TYPE_ID = 51  --Liability For Withholding  Tax Deduction
                        AND A.MONTH_ID = P_SALARY_MONTH
                        AND A.YEAR_ID = P_YEAR_ID
                        AND A.MON_NET_PAYABLE_SALARY > 0
                        GROUP BY D.REGION_STATUS, C.COA_CODE, E.COA_DESC_LONG
                    UNION ALL
                        SELECT 2 SL, 11 SLNO,  D.REGION_STATUS, C.COA_CODE, E.COA_DESC_LONG, 0 DR_AMOUNT, SUM(MON_DUE_AEF_PS) CR_AMOUNT, NULL SUP_CODE
                        FROM MONTHLY_SALARY_GENERATE A, EMP_INFO B,  SALARY_GL_TAG C, COM_LOCATION D, GL_COA E
                        WHERE A.EMP_ID = B.EMP_ID
                        AND B.LOCATION_ID = C.JOB_LOCATION_ID
                        AND B.DEPARTMENT_ID = C.DEPARTMENT_ID
                        AND B.LOCATION_ID = D.LOC_ID
                        AND C.COA_CODE = E.COA_CODE(+)
                        AND C.TYPE_ID = 53  --Liability For Akij Employees Fair prisese shop
                        AND A.MONTH_ID = P_SALARY_MONTH
                        AND A.YEAR_ID = P_YEAR_ID
                        AND A.MON_NET_PAYABLE_SALARY > 0
                        GROUP BY D.REGION_STATUS, C.COA_CODE, E.COA_DESC_LONG
                    UNION ALL
                        SELECT 2 SL, 12 SLNO,  D.REGION_STATUS, C.COA_CODE, E.COA_DESC_LONG, 0 DR_AMOUNT, SUM(MON_CANTEEN_BILL) CR_AMOUNT, NULL SUP_CODE
                        FROM MONTHLY_SALARY_GENERATE A, EMP_INFO B,  SALARY_GL_TAG C, COM_LOCATION D, GL_COA E
                        WHERE A.EMP_ID = B.EMP_ID
                        AND B.LOCATION_ID = C.JOB_LOCATION_ID
                        AND B.DEPARTMENT_ID = C.DEPARTMENT_ID
                        AND B.LOCATION_ID = D.LOC_ID
                        AND C.COA_CODE = E.COA_CODE(+)
                        AND C.TYPE_ID = 35  --Liability For Food Corner Deduction
                        AND A.MONTH_ID = P_SALARY_MONTH
                        AND A.YEAR_ID = P_YEAR_ID
                        AND A.MON_NET_PAYABLE_SALARY > 0
                        GROUP BY D.REGION_STATUS, C.COA_CODE, E.COA_DESC_LONG
                    UNION ALL
                        SELECT 2 SL, 7 SLNO,  D.REGION_STATUS, '141205004' COA_CODE, CASE WHEN D.REGION_STATUS <> 'Marketing' THEN B.FULL_NAME||' ('|| B.EMP_ID ||')' ELSE E.COA_DESC_LONG END COA_DESC_LONG, 0 DR_AMOUNT, SUM (NVL(MON_LOAN_AMOUNT,0) + NVL(MON_HAJJ_LOAN,0) + NVL(MON_HOME_LOAN,0) 
                                +   NVL(MON_PUNISHMENT_SCHEDULE,0) +   NVL(MON_SECURITY_DEPOSIT,0)) CR_AMOUNT, B.EMP_ID SUP_CODE
                        FROM MONTHLY_SALARY_GENERATE A, EMP_INFO B,  COM_LOCATION D, GL_COA E
                        WHERE A.EMP_ID = B.EMP_ID
                        AND B.LOCATION_ID = D.LOC_ID
                        AND E.COA_CODE = 141205004  --Advance Against Salary
                        AND A.MONTH_ID = P_SALARY_MONTH
                        AND A.YEAR_ID = P_YEAR_ID
                        AND A.MON_NET_PAYABLE_SALARY > 0
                        AND (NVL(MON_LOAN_AMOUNT,0) + NVL(MON_HAJJ_LOAN,0) + NVL(MON_HOME_LOAN,0)
                                +   NVL(MON_PUNISHMENT_SCHEDULE,0) +   NVL(MON_SECURITY_DEPOSIT,0) ) > 0 
                        GROUP BY D.REGION_STATUS,  CASE WHEN D.REGION_STATUS <> 'Marketing' THEN B.FULL_NAME||' ('|| B.EMP_ID ||')' ELSE E.COA_DESC_LONG END,  B.EMP_ID
                    UNION ALL
                        SELECT 2 SL, 7 SLNO,  D.REGION_STATUS,  C.COA_CODE, E.COA_DESC_LONG, 0 DR_AMOUNT, 
                        SUM (NVL(MON_CAR_MOTORCYCLE_LOAN,0)) CR_AMOUNT, NULL SUP_CODE
                        FROM MONTHLY_SALARY_GENERATE A, EMP_INFO B,  SALARY_GL_TAG C, COM_LOCATION D, GL_COA E
                        WHERE A.EMP_ID = B.EMP_ID
                        AND B.LOCATION_ID = C.JOB_LOCATION_ID
                        AND B.DEPARTMENT_ID = C.DEPARTMENT_ID
                        AND B.LOCATION_ID = D.LOC_ID
                        AND C.COA_CODE = E.COA_CODE(+)
                        AND C.TYPE_ID = 54  --Advance Against Motor Cycle And Laptop (ASM-Marketing)
                        AND A.MONTH_ID = P_SALARY_MONTH
                        AND A.YEAR_ID = P_YEAR_ID
                        AND A.MON_NET_PAYABLE_SALARY > 0
                        GROUP BY D.REGION_STATUS, C.COA_CODE, E.COA_DESC_LONG
                    UNION ALL
                        SELECT 2 SL, 7 SLNO,  D.REGION_STATUS,  C.COA_CODE, E.COA_DESC_LONG, 0 DR_AMOUNT, 
                        SUM (NVL(MON_FLAT_INSTALLMENT,0)) CR_AMOUNT, NULL SUP_CODE
                        FROM MONTHLY_SALARY_GENERATE A, EMP_INFO B,  SALARY_GL_TAG C, COM_LOCATION D, GL_COA E
                        WHERE A.EMP_ID = B.EMP_ID
                        AND B.LOCATION_ID = C.JOB_LOCATION_ID
                        AND B.DEPARTMENT_ID = C.DEPARTMENT_ID
                        AND B.LOCATION_ID = D.LOC_ID
                        AND C.COA_CODE = E.COA_CODE(+)
                        AND C.TYPE_ID = 55  --Liability against Flat Deduction
                        AND A.MONTH_ID = P_SALARY_MONTH
                        AND A.YEAR_ID = P_YEAR_ID
                        AND A.MON_NET_PAYABLE_SALARY > 0
                        GROUP BY D.REGION_STATUS, C.COA_CODE, E.COA_DESC_LONG
                )
                WHERE REGION_STATUS= REC1.REGION_STATUS
                AND (DR_AMOUNT > 0 OR CR_AMOUNT > 0)
                ORDER BY  SL, SLNO, SL_NO, REGION_STATUS; 

                V_MESSAGE := V_MESSAGE ||' JV For ' || REC1.REGION_STATUS ||' CODE:'||V_VC_NO || '</br>';

                UPDATE MONTHLY_SALARY_GENERATE
                    SET JV_CODE = V_VC_NO
                WHERE EMP_ID IN (SELECT A.EMP_ID
                                    FROM MONTHLY_SALARY_GENERATE A, EMP_INFO B,  SALARY_GL_TAG C, COM_LOCATION D, GL_COA E
                                    WHERE A.EMP_ID = B.EMP_ID
                                    AND B.LOCATION_ID = C.JOB_LOCATION_ID
                                    AND B.DEPARTMENT_ID = C.DEPARTMENT_ID
                                    AND B.LOCATION_ID = D.LOC_ID
                                    AND  C.COA_CODE_DR = E.COA_CODE(+)
                                    AND C.TYPE_ID = 48     --Salary and Allowance
                                    AND A.MONTH_ID = P_SALARY_MONTH 
                                    AND A.YEAR_ID = P_YEAR_ID
                                    AND A.MON_NET_PAYABLE_SALARY > 0 
                                    AND D.REGION_STATUS = REC1.REGION_STATUS)
                AND MONTH_ID = P_SALARY_MONTH 
                AND YEAR_ID = P_YEAR_ID ;
        END LOOP;

    END;
END;