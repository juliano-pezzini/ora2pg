-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW alto_custo_enferm_renal_v3_v (dt_generate, nr_seq_alto_custo, cd_campo_01, cd_campo_02, cd_campo_03, cd_campo_04, cd_campo_05, cd_campo_06, dt_campo_07, cd_campo_08, cd_campo_09, cd_campo_10, cd_campo_11, cd_campo_12, cd_campo_13, cd_campo_14, dt_campo_15, cd_campo_16, dt_campo_17, cd_campo_18, dt_campo_19, cd_campo_19_1, cd_campo_20, dt_campo_21, cd_campo_21_1, cd_campo_22, cd_campo_23, cd_campo_24, cd_campo_25, cd_campo_26, cd_campo_27, dt_campo_27_1, cd_campo_28, dt_campo_28_1, cd_campo_29, dt_campo_29_1, cd_campo_30, dt_campo_30_1, cd_campo_31, dt_campo_31_1, cd_campo_32, dt_campo_32_1, cd_campo_33, dt_campo_33_1, cd_campo_34, dt_campo_34_1, cd_campo_35, cd_campo_36, cd_campo_37, cd_campo_38, cd_campo_39, dt_campo_40, cd_campo_41, cd_campo_42, cd_campo_43, dt_campo_44, dt_campo_45, cd_campo_46, cd_campo_47, cd_campo_48, cd_campo_49, cd_campo_50, cd_campo_51, cd_campo_52, cd_campo_53, cd_campo_54, dt_campo_55, dt_campo_56, cd_campo_57, cd_campo_58, cd_campo_59, cd_campo_60, cd_campo_61, cd_campo_62, cd_campo_62_1, cd_campo_62_2, cd_campo_62_3, cd_campo_62_4, cd_campo_62_5, cd_campo_62_6, cd_campo_62_7, cd_campo_62_8, cd_campo_62_9, cd_campo_62_10, cd_campo_62_11, dt_campo_63, cd_campo_63_1, cd_campo_64, cd_campo_65, cd_campo_66, cd_campo_67, cd_campo_68, cd_campo_69, dt_campo_69_1, dt_campo_69_2, dt_campo_69_3, dt_campo_69_4, dt_campo_69_5, dt_campo_69_6, dt_campo_69_7, cd_campo_70, cd_campo_70_1, cd_campo_70_2, cd_campos_70_3, cd_campo_70_4, cd_campo_70_5, cd_campo_70_6, cd_campo_70_7, cd_campo_70_8, cd_campo_70_9, cd_campo_71, dt_campo_72, dt_campo_73, cd_campo_74, cd_campo_75, cd_campo_76, cd_campo_77, cd_campo_78, cd_campo_79, cd_campo_80, dt_campo_80_1, cd_campo_81, cd_campo_82) AS select	a.DT_GENERATE, a.NR_SEQ_ALTO_CUSTO,
 substr(obter_result_anzics_value(a.nr_sequencia,3332),1,20) CD_CAMPO_01,
 substr(obter_result_anzics_value(a.nr_sequencia,3265),1,30) CD_CAMPO_02,
 substr(obter_result_anzics_value(a.nr_sequencia,3281),1,20) CD_CAMPO_03,
 substr(obter_result_anzics_value(a.nr_sequencia,3315),1,30) CD_CAMPO_04,
 substr(obter_result_anzics_value(a.nr_sequencia,3266),1,2) CD_CAMPO_05,
 substr(obter_result_anzics_value(a.nr_sequencia,3302),1,20) CD_CAMPO_06,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3303), 'YYYY-MM-DD'), obter_anzics_value_default(3303)) DT_CAMPO_07,
 substr(obter_result_anzics_value(a.nr_sequencia,3267),1,1) CD_CAMPO_08,
 substr(obter_result_anzics_value(a.nr_sequencia,3268),1,1) CD_CAMPO_09,
 substr(obter_result_anzics_value(a.nr_sequencia,3263),1,6) CD_CAMPO_10,
 substr(obter_result_anzics_value(a.nr_sequencia,3269),1,1) CD_CAMPO_11,
 obter_result_anzics_number(a.nr_sequencia,3264) CD_CAMPO_12,
 substr(obter_result_anzics_value(a.nr_sequencia,3270),1,5) CD_CAMPO_13,
 substr(obter_result_anzics_value(a.nr_sequencia,3271),1,30) CD_CAMPO_14,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3304), 'YYYY-MM-DD'), obter_anzics_value_default(3304)) DT_CAMPO_15,
 obter_result_anzics_number(a.nr_sequencia,3348) CD_CAMPO_16,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3272), 'YYYY-MM-DD'), obter_anzics_value_default(3272)) DT_CAMPO_17,
 obter_result_anzics_number(a.nr_sequencia,3345) CD_CAMPO_18,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3346), 'YYYY-MM-DD'), obter_anzics_value_default(3346)) DT_CAMPO_19,
 obter_result_anzics_number(a.nr_sequencia,3347) CD_CAMPO_19_1,
 obter_result_anzics_number(a.nr_sequencia,3273) CD_CAMPO_20,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3289), 'YYYY-MM-DD'), obter_anzics_value_default(3289)) DT_CAMPO_21,
 obter_result_anzics_number(a.nr_sequencia,3274) CD_CAMPO_21_1,
 obter_result_anzics_number(a.nr_sequencia,3290) CD_CAMPO_22,
 substr(obter_result_anzics_value(a.nr_sequencia,3331),1,5) CD_CAMPO_23,
 obter_result_anzics_number(a.nr_sequencia,3318) CD_CAMPO_24,
 obter_result_anzics_number(a.nr_sequencia,3319) CD_CAMPO_25,
 obter_result_anzics_number(a.nr_sequencia,3320) CD_CAMPO_26,
 substr(obter_result_anzics_value(a.nr_sequencia,3322),1,5) CD_CAMPO_27,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3323), 'YYYY-MM-DD'), obter_anzics_value_default(3323)) DT_CAMPO_27_1,
 substr(obter_result_anzics_value(a.nr_sequencia,3338),1,5) CD_CAMPO_28,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3343), 'YYYY-MM-DD'), obter_anzics_value_default(3343)) DT_CAMPO_28_1,
 substr(obter_result_anzics_value(a.nr_sequencia,3333),1,5) CD_CAMPO_29,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3334), 'YYYY-MM-DD'), obter_anzics_value_default(3334)) DT_CAMPO_29_1,
 substr(obter_result_anzics_value(a.nr_sequencia,3310),1,5) CD_CAMPO_30,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3335), 'YYYY-MM-DD'), obter_anzics_value_default(3335)) DT_CAMPO_30_1,
 substr(obter_result_anzics_value(a.nr_sequencia,3324),1,5) CD_CAMPO_31,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3282), 'YYYY-MM-DD'), obter_anzics_value_default(3282)) DT_CAMPO_31_1,
 substr(obter_result_anzics_value(a.nr_sequencia,3283),1,5) CD_CAMPO_32,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3284), 'YYYY-MM-DD'), obter_anzics_value_default(3284)) DT_CAMPO_32_1,
 substr(obter_result_anzics_value(a.nr_sequencia,3276),1,5) CD_CAMPO_33,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3336), 'YYYY-MM-DD'), obter_anzics_value_default(3336)) DT_CAMPO_33_1,
 substr(obter_result_anzics_value(a.nr_sequencia,3337),1,5) CD_CAMPO_34,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3321), 'YYYY-MM-DD'), obter_anzics_value_default(3321)) DT_CAMPO_34_1,
 substr(obter_result_anzics_value(a.nr_sequencia,3285),1,5) CD_CAMPO_35,
 obter_result_anzics_number(a.nr_sequencia,3339) CD_CAMPO_36,
 obter_result_anzics_number(a.nr_sequencia,3286) CD_CAMPO_37,
 obter_result_anzics_number(a.nr_sequencia,3287) CD_CAMPO_38,
 obter_result_anzics_number(a.nr_sequencia,3311) CD_CAMPO_39,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3278), 'YYYY-MM-DD'), obter_anzics_value_default(3278)) DT_CAMPO_40,
 obter_result_anzics_number(a.nr_sequencia,3340) CD_CAMPO_41,
 obter_result_anzics_number(a.nr_sequencia,3288) CD_CAMPO_42,
 obter_result_anzics_number(a.nr_sequencia,3341) CD_CAMPO_43,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3294), 'YYYY-MM-DD'), obter_anzics_value_default(3294)) DT_CAMPO_44,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3342), 'YYYY-MM-DD'), obter_anzics_value_default(3342)) DT_CAMPO_45,
 obter_result_anzics_number(a.nr_sequencia,3325) CD_CAMPO_46,
 substr(obter_result_anzics_value(a.nr_sequencia,3313),1,5) CD_CAMPO_47,
 obter_result_anzics_number(a.nr_sequencia,3314) CD_CAMPO_48,
 obter_result_anzics_number(a.nr_sequencia,3344) CD_CAMPO_49,
 substr(obter_result_anzics_value(a.nr_sequencia,3275),1,5) CD_CAMPO_50,
 substr(obter_result_anzics_value(a.nr_sequencia,3291),1,5) CD_CAMPO_51,
 obter_result_anzics_number(a.nr_sequencia,3316) CD_CAMPO_52,
 obter_result_anzics_number(a.nr_sequencia,3305) CD_CAMPO_53,
 obter_result_anzics_number(a.nr_sequencia,3317) CD_CAMPO_54,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3292), 'YYYY-MM-DD'), obter_anzics_value_default(3292)) DT_CAMPO_55,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3293), 'YYYY-MM-DD'), obter_anzics_value_default(3293)) DT_CAMPO_56,
 obter_result_anzics_number(a.nr_sequencia,3280) CD_CAMPO_57,
 obter_result_anzics_number(a.nr_sequencia,3306) CD_CAMPO_58,
 substr(obter_result_anzics_value(a.nr_sequencia,3307),1,5) CD_CAMPO_59,
 substr(obter_result_anzics_value(a.nr_sequencia,3308),1,5) CD_CAMPO_60,
 substr(obter_result_anzics_value(a.nr_sequencia,3309),1,5) CD_CAMPO_61,
 obter_result_anzics_number(a.nr_sequencia,3277) CD_CAMPO_62,
 obter_result_anzics_number(a.nr_sequencia,3279) CD_CAMPO_62_1,
 obter_result_anzics_number(a.nr_sequencia,3312) CD_CAMPO_62_2,
 obter_result_anzics_number(a.nr_sequencia,3326) CD_CAMPO_62_3,
 obter_result_anzics_number(a.nr_sequencia,3327) CD_CAMPO_62_4,
 obter_result_anzics_number(a.nr_sequencia,3328) CD_CAMPO_62_5,
 obter_result_anzics_number(a.nr_sequencia,3329) CD_CAMPO_62_6,
 obter_result_anzics_number(a.nr_sequencia,3330) CD_CAMPO_62_7,
 obter_result_anzics_number(a.nr_sequencia,3295) CD_CAMPO_62_8,
 obter_result_anzics_number(a.nr_sequencia,3296) CD_CAMPO_62_9,
 obter_result_anzics_number(a.nr_sequencia,3297) CD_CAMPO_62_10,
 obter_result_anzics_number(a.nr_sequencia,3298) CD_CAMPO_62_11,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3299), 'YYYY-MM-DD'), obter_anzics_value_default(3299)) DT_CAMPO_63,
 substr(obter_result_anzics_value(a.nr_sequencia,3300),1,12) CD_CAMPO_63_1,
 obter_result_anzics_number(a.nr_sequencia,3301) CD_CAMPO_64,
 substr(obter_result_anzics_value(a.nr_sequencia,3349),1,12) CD_CAMPO_65,
 substr(obter_result_anzics_value(a.nr_sequencia,3350),1,12) CD_CAMPO_66,
 obter_result_anzics_number(a.nr_sequencia,3351) CD_CAMPO_67,
 obter_result_anzics_number(a.nr_sequencia,3352) CD_CAMPO_68,
 obter_result_anzics_number(a.nr_sequencia,3353) CD_CAMPO_69,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3354), 'YYYY-MM-DD'), obter_anzics_value_default(3354)) DT_CAMPO_69_1,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3355), 'YYYY-MM-DD'), obter_anzics_value_default(3355)) DT_CAMPO_69_2,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3356), 'YYYY-MM-DD'), obter_anzics_value_default(3356)) DT_CAMPO_69_3,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3357), 'YYYY-MM-DD'), obter_anzics_value_default(3357)) DT_CAMPO_69_4,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3379), 'YYYY-MM-DD'), obter_anzics_value_default(3379)) DT_CAMPO_69_5,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3358), 'YYYY-MM-DD'), obter_anzics_value_default(3358)) DT_CAMPO_69_6,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3380), 'YYYY-MM-DD'), obter_anzics_value_default(3380)) DT_CAMPO_69_7,
 obter_result_anzics_number(a.nr_sequencia,3381) CD_CAMPO_70,
 obter_result_anzics_number(a.nr_sequencia,3359) CD_CAMPO_70_1,
 obter_result_anzics_number(a.nr_sequencia,3382) CD_CAMPO_70_2,
 obter_result_anzics_number(a.nr_sequencia,3376) CD_CAMPOS_70_3,
 obter_result_anzics_number(a.nr_sequencia,3360) CD_CAMPO_70_4,
 obter_result_anzics_number(a.nr_sequencia,3383) CD_CAMPO_70_5,
 obter_result_anzics_number(a.nr_sequencia,3361) CD_CAMPO_70_6,
 substr(obter_result_anzics_value(a.nr_sequencia,3362),1,20) CD_CAMPO_70_7,
 substr(obter_result_anzics_value(a.nr_sequencia,3378),1,20) CD_CAMPO_70_8,
 substr(obter_result_anzics_value(a.nr_sequencia,3363),1,20) CD_CAMPO_70_9,
 obter_result_anzics_number(a.nr_sequencia,3377) CD_CAMPO_71,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3364), 'YYYY-MM-DD'), obter_anzics_value_default(3364)) DT_CAMPO_72,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3365), 'YYYY-MM-DD'), obter_anzics_value_default(3365)) DT_CAMPO_73,
 obter_result_anzics_number(a.nr_sequencia,3366) CD_CAMPO_74,
 obter_result_anzics_number(a.nr_sequencia,3367) CD_CAMPO_75,
 obter_result_anzics_number(a.nr_sequencia,3368) CD_CAMPO_76,
 obter_result_anzics_number(a.nr_sequencia,3369) CD_CAMPO_77,
 substr(obter_result_anzics_value(a.nr_sequencia,3370),1,6) CD_CAMPO_78,
 obter_result_anzics_number(a.nr_sequencia,3371) CD_CAMPO_79,
 obter_result_anzics_number(a.nr_sequencia,3372) CD_CAMPO_80,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3373), 'YYYY-MM-DD'), obter_anzics_value_default(3373)) DT_CAMPO_80_1,
 substr(obter_result_anzics_value(a.nr_sequencia,3374),1,10) CD_CAMPO_81,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3375), 'YYYY-MM-DD'), obter_anzics_value_default(3375)) CD_CAMPO_82
 FROM ATEND_ANZICS a
 where a.NR_SEQ_ANZICS = 39
 
 and a.dt_inativacao is null 
 order by a.DT_GENERATE;
