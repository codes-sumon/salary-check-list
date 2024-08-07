SELECT * 
INTO MONTHLY_SALARY_GENERATE_ATML_07_2024
FROM ATML_DB.[dbo].[MONTHLY_SALARY_GENERATE_VW]
WHERE MONTH_ID = 7
AND YEAR_ID = 2024

--------------------------------------------------------------------------------
UPDATE A SET
       A.[intWorkingDays]               = B.[WORKING_DAYS]
      ,A.[intPresent]                   = B.[PRESENT]
      ,A.[intAbsent]                    = B.[ABSENT]
      ,A.[intOffday]                    = B.[OFF_DAY]
      ,A.[intHoliday]                   = B.[HOLIDAY]
      ,A.[intCL]                        = B.[CL]
      ,A.[intSL]                        = B.[SL]
      ,A.[intEL]                        = B.[EL]
      ,A.[intML]                        = B.[ML]
      ,A.[intPL]                        = B.[PL]
      ,A.[intBL]                        = B.[BL]
      ,A.[intLWP]                       = B.[LWP]
      ,A.[intLate]                      = B.[LATE]
      ,A.[intNightDuty]                 = B.[NIGHT_DUTY]
      ,A.[monTotalOTHour]               = B.[MON_TOTAL_OT_HOUR]
      ,A.[monPerHourSalary]             = B.[MON_PER_HOUR_SALARY]
      ,A.[monBasicAmount]               = B.[MON_BASIC_AMOUNT]
      ,A.[monHouseRentAmount]           = B.[MON_HOUSE_RENT_AMOUNT]
      ,A.[monMedicalAllowanceAmount]    = B.[MON_MEDICAL_ALLOWANCE_AMOUNT]
      ,A.[monTransportAmount]           = B.[MON_TRANSPORT_AMOUNT]
      ,A.[monOtherAmount]               = B.[MON_OTHER_AMOUNT]
      ,A.[monGrossSalary]               = B.[MON_GROSS_SALARY]
      ,A.[monJoindatePenalty]           = B.[MON_JOIN_DATE_PENALTY]
      ,A.[monSalary]                    = B.[MON_SALARY]
      ,A.[monPFAmount]                  = B.[MON_PF_AMOUNT]
      ,A.[monTaxAmount]                 = B.[TAX_AMOUNT]
      ,A.[monLoanAmount]                = B.[MON_LOAN_AMOUNT]
      ,A.[monCoinAmount]                = 0
      ,A.[monAbsentPunishmentAmount]    = B.[MON_ABSENT_PUNISHMENT_AMOUNT]
      ,A.[monLeavePunishmentAmount]     = B.[MON_LEAVE_PUNISHMENT_AMOUNT]
      ,A.[monLatePunishmentAmount]      = B.[MON_LATE_PUNISHMENT_AMOUNT]
      ,A.[monPunishment]                = B.[MON_PUNISHMENT]
      ,A.[monDueAEFPS]                  = B.[MON_DUE_AEF_PS]
      ,A.[monUnionFee]                  = B.[MON_UNION_FEE]
      ,A.[monElectricBill]              = B.[MON_ELECTRIC_BILL]
      ,A.[monDishBill]                  = B.[MON_DISH_BILL]
      ,A.[monTransportBill]             = B.[MON_TRANSPORT_BILL]
      ,A.[monCafeteriaBill]             = B.[MON_CAFETERIA_BILL]
      ,A.[monGymBill]                   = B.[MON_GYM_BILL]
      ,A.[monCanteenBill]               = B.[MON_CANTEEN_BILL]
      ,A.[monAccommodation]             = B.[MON_ACCOMMODATION]
      ,A.[monNightAllowance]            = B.[MON_NIGHT_ALLOWANCE]
      ,A.[monAttendanceBenefit]         = B.[MON_ATTENDANCE_BENEFIT]
      ,A.[monNontabBenefit]             = B.[MON_NON_TAB_BENEFIT]
      ,A.[monNightBenefit]              = B.[MON_NIGHT_BENEFIT]
      ,A.[monDayoffBenefit]             = B.[MON_DAY_OFF_BENEFIT]
      ,A.[monDofferBenefit]             = B.[MON_DO_FF_ERBENEFIT]
      ,A.[monDormataryBenefit]          = B.[MON_DORMATARY_BENEFIT]
      ,A.[monScottBenefit]              = B.[MON_SCOTT_BENEFIT]
      ,A.[monLieuBenefit]               = B.[MON_LIEUBENEFIT]
      ,A.[monHeatBenefit]               = B.[MON_HEAT_BENEFIT]
      ,A.[monDriverAllowance]           = B.[MON_DRIVER_ALLOWANCE]
      ,A.[monMotorCycleAllowance]       = B.[MONMOTORCYCLE_ALLOWANCE]
      ,A.[monConveyanceAllowance]       = B.[MON_CONVEYANCE_ALLOWANCE]
      ,A.[monHouseRentAllowance]        = B.[MON_HOUSERENT_ALLOWANCE]
      ,A.[monUnionDonationAllowance]    = B.[MON_UNION_DONATION_ALLOWANCE]
      ,A.[monSpecialSalaryAllowance]    = B.[MON_SPECIAL_SALARY_ALLOWANCE]
      ,A.[monMobileAllowance]           = B.[MON_MOBILE_ALLOWANCE]
      ,A.[monOTAmount]                  = B.[MON_OT_AMOUNT]
      ,A.[monPLAmount]                  = B.[MON_PL_AMOUNT]
      ,A.[monTADAAmount]                = B.[MON_TA_DA_AMOUNT]
      ,A.[monSalaryPayInBankFix]        = B.[MON_SALARY_PAY_IN_BANK_FIX]
      --,A.[monSalaryPayInBank]           = B.[MON_SALARY_PAY_IN_BANK]
      --,A.[monSalaryAllowancePayInCash]  = B.[MON_SALARY_ALLOW_PAYINCASH]
      ,A.[monPFEmployeeContribution]    = B.[MON_PF_EMPLOYEE_CONTRIBUTION]
      ,A.[monPFEmployerContribution]    = B.[MON_PF_EMPLOYER_CONTRIBUTION]
      ,A.[monGratuity]                  = B.[MON_GRATUITY]
      ,A.[monLoan]                      = B.[MON_LOAN]
      --,A.[monServiceBenefits]           = B.[MON_SERVICE_BENEFITS]
      ,A.[monHajjLoan]                  = B.[MON_HAJJ_LOAN]
      ,A.[monHomeLoan]                  = B.[MON_HOME_LOAN]
      ,A.[monCarMotorcycleLoan]         = B.[MON_CAR_MOTORCYCLE_LOAN]
      ,A.[monPunishmentSchedule]        = B.[MON_PUNISHMENT_SCHEDULE]
      ,A.[monSecurityDeposit]           = B.[MON_SECURITY_DEPOSIT]
      ,A.[monFlatInstallment]           = B.[MON_FLAT_INSTALLMENT]
      ,A.[monJoraBenifit]               = B.[MON_JORABENIFIT]
      ,A.[monManualAdd]                 = B.[MON_MANUAL_ADD]
      ,A.[monManualDeduct]              = B.[MON_MANUAL_DEDUCT]
      ,A.[monTada]                      = B.[MON_TA_DA]
from [10.12.17.16].ERP_HR.DBO.tblMonthlySalaryGenerate A 
INNER JOIN ATML_DB.[dbo].MONTHLY_SALARY_GENERATE_ATML_07_2024 B
ON  A.intEmpID = B.EMP_ID
AND A.intMonthId = B.MONTH_ID
and A.intYearID = B.YEAR_ID
WHERE  B.MONTH_ID = 7
AND    B.YEAR_ID = 2024
AND    A.intMonthID = 7
and	   A.intYearId = 2024
------------------------------------------------------------------------------------------


 select A.[monSalaryPayInBank]           - B.[MON_SALARY_PAY_IN_BANK]
		,A.[monSalaryAllowancePayInCash]  -B.[MON_SALARY_ALLOW_PAYINCASH]
      ,A.[monNetPayableSalary]          - B.[MON_NET_PAYABLE_SALARY]
	  ,A.[monTotalAllowance]            - B.[MON_TOTAL_ALLOWANCE]
	  ,A.[monTotalDeduction]           - B.[MON_TOTAL_DEDUCTION]
from [10.12.17.16].ERP_HR.DBO.tblMonthlySalaryGenerate A 
INNER JOIN ATML_DB.[dbo].MONTHLY_SALARY_GENERATE_ATML_07_2024 B
ON  A.intEmpID = B.EMP_ID
AND A.intMonthId = B.MONTH_ID
and A.intYearID = B.YEAR_ID
WHERE  B.MONTH_ID = 7
AND    B.YEAR_ID = 2024
AND    A.intMonthID = 7
and	   A.intYearId = 2024


--------------------------------------------------------------------------------------------------


select * 
from ERP_HR.dbo.tblSalaryAdvice
where intMonthID = 7
and intYearID = 2024
and intUnitID not in (14,53,98)

--Description:	<Description,,>--Corporate, Factory, Marketing
-- EXEC ERP_HR.dbo.sprSalaryVoucherEntryManual @strStatus='Factory', @dteGenerateDate='2024-07-31', @intUnitID=56