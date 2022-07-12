-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW alto_custo_hemofilia_v3_v (dt_generate, nr_seq_alto_custo, cd_campo_1, cd_campo_2, cd_campo_3, cd_campo_4, cd_campo_5, cd_campo_6, dt_campo_7, cd_campo_8, cd_campo_9, cd_campo_10, cd_campo_11, cd_campo_12, cd_campo_13, cd_campo_14, cd_campo_15, dt_campo_16, cd_campo_17, cd_campo_18, cd_campo_19, cd_campo_20, dt_campo_21, cd_campo_22, cd_campo_23, cd_campo_24, cd_campo_25, cd_campo_26, cd_campo_27, cd_campo_28, dt_campo_29, cd_campo_30, cd_campo_31, cd_campo_32, cd_campo_32_1, cd_campo_32_2, cd_campo_32_3, cd_campo_32_4, cd_campo_33, cd_campo_34, cd_campo_35, cd_campo_36, cd_campo_37, cd_campo_38, cd_campo_39, cd_campo_40, cd_campo_40_1, cd_campo_40_2, cd_campo_41, cd_campo_42, cd_campo_44, cd_campo_43, cd_campo_45, cd_campo_46, cd_campo_47_1, cd_campo_47_2, cd_campo_47_3, cd_campo_48, cd_campo_48_1, cd_campo_48_2, cd_campo_48_3, cd_campo_48_4, cd_campo_49, cd_campo_49_1, cd_campo_50, cd_campo_51, cd_campo_52, cd_campo_53, cd_campo_54, cd_campo_55, cd_campo_55_1, cd_campo_56, cd_campo_56_1, cd_campo_57, cd_campo_57_1, cd_campo_57_2, cd_campo_57_3, cd_campo_57_4, cd_campo_57_5, cd_campo_57_6, cd_campo_57_7, cd_campo_57_8, cd_campo_57_9, cd_campo_57_10, cd_campo_57_11, cd_campo_57_12, cd_campo_57_13, cd_campo_57_14, cd_campo_58, cd_campo_59, cd_campo_60, cd_campo_61, cd_campo_62, cd_campo_63, cd_campo_64, cd_campo_64_1, cd_campo_64_2, cd_campo_65, cd_campo_66) AS select	a.DT_GENERATE, a.NR_SEQ_ALTO_CUSTO,
 substr(obter_result_anzics_value(a.nr_sequencia,3635),1,20) CD_CAMPO_1,
 substr(obter_result_anzics_value(a.nr_sequencia,3636),1,30) CD_CAMPO_2,
 substr(obter_result_anzics_value(a.nr_sequencia,3637),1,20) CD_CAMPO_3,
 substr(obter_result_anzics_value(a.nr_sequencia,3631),1,30) CD_CAMPO_4,
 substr(obter_result_anzics_value(a.nr_sequencia,3639),1,2) CD_CAMPO_5,
 substr(obter_result_anzics_value(a.nr_sequencia,3640),1,20) CD_CAMPO_6,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3638), 'YYYY-MM-DD'), obter_anzics_value_default(3638)) DT_CAMPO_7,
 substr(obter_result_anzics_value(a.nr_sequencia,3641),1,1) CD_CAMPO_8,
 substr(obter_result_anzics_value(a.nr_sequencia,3642),1,4) CD_CAMPO_9,
 substr(obter_result_anzics_value(a.nr_sequencia,3643),1,1) CD_CAMPO_10,
 substr(obter_result_anzics_value(a.nr_sequencia,3644),1,6) CD_CAMPO_11,
 obter_result_anzics_number(a.nr_sequencia,3632) CD_CAMPO_12,
 substr(obter_result_anzics_value(a.nr_sequencia,3645),1,2) CD_CAMPO_13,
 obter_result_anzics_number(a.nr_sequencia,3646) CD_CAMPO_14,
 substr(obter_result_anzics_value(a.nr_sequencia,3647),1,21) CD_CAMPO_15,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3648), 'YYYY-MM-DD'), obter_anzics_value_default(3648)) DT_CAMPO_16,
 obter_result_anzics_number(a.nr_sequencia,3633) CD_CAMPO_17,
 obter_result_anzics_number(a.nr_sequencia,3634) CD_CAMPO_18,
 obter_result_anzics_number(a.nr_sequencia,3582) CD_CAMPO_19,
 obter_result_anzics_number(a.nr_sequencia,3583) CD_CAMPO_20,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3586), 'YYYY-MM-DD'), obter_anzics_value_default(3586)) DT_CAMPO_21,
 obter_result_anzics_number(a.nr_sequencia,3584) CD_CAMPO_22,
 obter_result_anzics_number(a.nr_sequencia,3585) CD_CAMPO_23,
 obter_result_anzics_number(a.nr_sequencia,3587) CD_CAMPO_24,
 obter_result_anzics_number(a.nr_sequencia,3588) CD_CAMPO_25,
 obter_result_anzics_number(a.nr_sequencia,3604) CD_CAMPO_26,
 obter_result_anzics_number(a.nr_sequencia,3607) CD_CAMPO_27,
 obter_result_anzics_number(a.nr_sequencia,3606) CD_CAMPO_28,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3605), 'YYYY-MM-DD'), obter_anzics_value_default(3605)) DT_CAMPO_29,
 obter_result_anzics_number(a.nr_sequencia,3675) CD_CAMPO_30,
 obter_result_anzics_number(a.nr_sequencia,3669) CD_CAMPO_31,
 substr(obter_result_anzics_value(a.nr_sequencia,3678),1,5) CD_CAMPO_32,
 obter_result_anzics_number(a.nr_sequencia,3665) CD_CAMPO_32_1,
 obter_result_anzics_number(a.nr_sequencia,3676) CD_CAMPO_32_2,
 obter_result_anzics_number(a.nr_sequencia,3677) CD_CAMPO_32_3,
 obter_result_anzics_number(a.nr_sequencia,3666) CD_CAMPO_32_4,
 obter_result_anzics_number(a.nr_sequencia,3670) CD_CAMPO_33,
 obter_result_anzics_number(a.nr_sequencia,3667) CD_CAMPO_34,
 substr(obter_result_anzics_value(a.nr_sequencia,3672),1,12) CD_CAMPO_35,
 substr(obter_result_anzics_value(a.nr_sequencia,3668),1,12) CD_CAMPO_36,
 substr(obter_result_anzics_value(a.nr_sequencia,3671),1,12) CD_CAMPO_37,
 substr(obter_result_anzics_value(a.nr_sequencia,3673),1,12) CD_CAMPO_38,
 obter_result_anzics_number(a.nr_sequencia,3674) CD_CAMPO_39,
 obter_result_anzics_number(a.nr_sequencia,3608) CD_CAMPO_40,
 obter_result_anzics_number(a.nr_sequencia,3609) CD_CAMPO_40_1,
 obter_result_anzics_number(a.nr_sequencia,3610) CD_CAMPO_40_2,
 obter_result_anzics_number(a.nr_sequencia,3611) CD_CAMPO_41,
 obter_result_anzics_number(a.nr_sequencia,3612) CD_CAMPO_42,
 obter_result_anzics_number(a.nr_sequencia,3614) CD_CAMPO_44,
 obter_result_anzics_number(a.nr_sequencia,3613) CD_CAMPO_43,
 obter_result_anzics_number(a.nr_sequencia,3615) CD_CAMPO_45,
 obter_result_anzics_number(a.nr_sequencia,3616) CD_CAMPO_46,
 obter_result_anzics_number(a.nr_sequencia,3617) CD_CAMPO_47_1,
 obter_result_anzics_number(a.nr_sequencia,3618) CD_CAMPO_47_2,
 obter_result_anzics_number(a.nr_sequencia,3619) CD_CAMPO_47_3,
 obter_result_anzics_number(a.nr_sequencia,3654) CD_CAMPO_48,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3655), 'YYYY-MM-DD'), obter_anzics_value_default(3655)) CD_CAMPO_48_1,
 obter_result_anzics_number(a.nr_sequencia,3649) CD_CAMPO_48_2,
 obter_result_anzics_number(a.nr_sequencia,3650) CD_CAMPO_48_3,
 obter_result_anzics_number(a.nr_sequencia,3656) CD_CAMPO_48_4,
 obter_result_anzics_number(a.nr_sequencia,3651) CD_CAMPO_49,
 obter_result_anzics_number(a.nr_sequencia,3657) CD_CAMPO_49_1,
 obter_result_anzics_number(a.nr_sequencia,3659) CD_CAMPO_50,
 obter_result_anzics_number(a.nr_sequencia,3658) CD_CAMPO_51,
 obter_result_anzics_number(a.nr_sequencia,3663) CD_CAMPO_52,
 obter_result_anzics_number(a.nr_sequencia,3660) CD_CAMPO_53,
 obter_result_anzics_number(a.nr_sequencia,3661) CD_CAMPO_54,
 obter_result_anzics_number(a.nr_sequencia,3662) CD_CAMPO_55,
 obter_result_anzics_number(a.nr_sequencia,3652) CD_CAMPO_55_1,
 obter_result_anzics_number(a.nr_sequencia,3664) CD_CAMPO_56,
 obter_result_anzics_number(a.nr_sequencia,3653) CD_CAMPO_56_1,
 obter_result_anzics_number(a.nr_sequencia,3602) CD_CAMPO_57,
 obter_result_anzics_number(a.nr_sequencia,3603) CD_CAMPO_57_1,
 obter_result_anzics_number(a.nr_sequencia,3591) CD_CAMPO_57_2,
 obter_result_anzics_number(a.nr_sequencia,3600) CD_CAMPO_57_3,
 obter_result_anzics_number(a.nr_sequencia,3589) CD_CAMPO_57_4,
 obter_result_anzics_number(a.nr_sequencia,3601) CD_CAMPO_57_5,
 obter_result_anzics_number(a.nr_sequencia,3597) CD_CAMPO_57_6,
 obter_result_anzics_number(a.nr_sequencia,3598) CD_CAMPO_57_7,
 obter_result_anzics_number(a.nr_sequencia,3593) CD_CAMPO_57_8,
 obter_result_anzics_number(a.nr_sequencia,3594) CD_CAMPO_57_9,
 obter_result_anzics_number(a.nr_sequencia,3595) CD_CAMPO_57_10,
 substr(obter_result_anzics_value(a.nr_sequencia,3599),1,20) CD_CAMPO_57_11,
 substr(obter_result_anzics_value(a.nr_sequencia,3596),1,20) CD_CAMPO_57_12,
 substr(obter_result_anzics_value(a.nr_sequencia,3590),1,20) CD_CAMPO_57_13,
 substr(obter_result_anzics_value(a.nr_sequencia,3592),1,20) CD_CAMPO_57_14,
 obter_result_anzics_number(a.nr_sequencia,3620) CD_CAMPO_58,
 obter_result_anzics_number(a.nr_sequencia,3621) CD_CAMPO_59,
 obter_result_anzics_number(a.nr_sequencia,3622) CD_CAMPO_60,
 obter_result_anzics_number(a.nr_sequencia,3623) CD_CAMPO_61,
 obter_result_anzics_number(a.nr_sequencia,3624) CD_CAMPO_62,
 obter_result_anzics_number(a.nr_sequencia,3625) CD_CAMPO_63,
 obter_result_anzics_number(a.nr_sequencia,3626) CD_CAMPO_64,
 obter_result_anzics_number(a.nr_sequencia,3630) CD_CAMPO_64_1,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3628), 'YYYY-MM-DD'), obter_anzics_value_default(3628)) CD_CAMPO_64_2,
 obter_result_anzics_number(a.nr_sequencia,3627) CD_CAMPO_65,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3629), 'YYYY-MM-DD'), obter_anzics_value_default(3629)) CD_CAMPO_66
 FROM ATEND_ANZICS a
 where a.NR_SEQ_ANZICS = 42
 
 and a.dt_inativacao is null 
 order by a.DT_GENERATE;
