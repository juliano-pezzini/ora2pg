-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW alto_custo_vih_v (dt_generate, nr_seq_alto_custo, cd_convenio, nm_campo_1, nm_campo_2, nm_campo_3, nm_campo_4, cd_campo_5, cd_campo_6, dt_campo_16, cd_campo_7, cd_campo_8, cd_campo_9, dt_campo_10, cd_campo_11, cd_campo_12, ds_campo_13, cd_campo_14, cd_campo_15, ie_campo_17, cd_campo_18, ie_campo_19, cd_campo_20, dt_campo_21, dt_campo_22, cd_campo_23, cd_campo_24, cd_campo_25, cd_campo_26, cd_campo_27_1, cd_campo_28, cd_campo_29, dt_campo_30, cd_campo_31, cd_campo_32, cd_campo_33, cd_campo_34, cd_campo_35, cd_campo_36, cd_campo_37, cd_campo_38, cd_campo_39, cd_campo_40, cd_campo_41, cd_campo_42, ie_campo_43, cd_campo_44_1, cd_campo_44_2, cd_campo_44_3, cd_campo_44_4, cd_campo_44_5, cd_campo_44_6, cd_campo_44_7, cd_campo_44_8, cd_campo_44_9, cd_campo_44_10, cd_campo_44_11, cd_campo_44_12, cd_campo_44_13, cd_campo_44_14, cd_campo_44_15, cd_campo_44_16, cd_campo_44_17, cd_campo_44_18, cd_campo_44_19, cd_campo_44_20, cd_campo_45, ie_campo_46, cd_campo_47, cd_campo_48, dt_campo_49, cd_campo_50, qt_campo_51, cd_campo_52, ie_campo_53_1, ie_campo_53_2, ie_campo_53_3, ie_campo_53_4, ie_campo_53_5, ie_campo_53_6, ie_campo_53_7, ie_campo_53_8, ie_campo_53_9, ie_campo_53_10, ie_campo_53_11, ie_campo_53_12, ie_campo_53_13, ie_campo_53_14, ie_campo_53_15, ie_campo_53_16, ie_campo_56_17, ie_campo_56_18, ie_campo_53_19, ie_campo_53_20, cd_campo_54, dt_campo_55, cd_campo_56, cd_campo_57, cd_campo_58, cd_campo_59, cd_campo_60, cd_campo_61, cd_campo_62, cd_campo_63, cd_campo_64, cd_campo_65, cd_campo_66, cd_campo_67, cd_campo_68, cd_campo_69, cd_campo_70, cd_campo_71, cd_campo_72, cd_campo_73, cd_campo_74, dt_campo_75, cd_campo_76, dt_campo_77, cd_campo_78, dt_campo_79, cd_campo_80, cd_campo_81, cd_campo_81_1, cd_campo_82, cd_campo_83, cd_campo_84, cd_campo_85, cd_campo_86, cd_campo_87, cd_campo_88, cd_campo_89, dt_campo_90, cd_campo_91_1, cd_campo_91_2, cd_campo_91_3, cd_campo_91_4, cd_campo_91_5, cd_campo_91_6, cd_campo_91_7, cd_campo_91_8, cd_campo_91_9, cd_campo_91_10, cd_campo_91_11, cd_campo_91_12, cd_campo_91_13, cd_campo_91_14, cd_campo_91_15, cd_campo_91_16, cd_campo_91_17, cd_campo_91_18, cd_campo_91_19, cd_campo_91_20, cd_campo_92, cd_campo_92_1, cd_campo_92_2, cd_campo_92_3, cd_campo_92_4, cd_campo_92_5, cd_campo_93, dt_campo_94, cd_campo_95_1, cd_campo_95_2, cd_campo_95_3, cd_campo_95_4, cd_campo_95_5, cd_campo_95_6, cd_campo_95_7, cd_campo_95_8, cd_campo_95_9, cd_campo_95_10, cd_campo_95_11, cd_campo_95_12, cd_campo_95_13, cd_campo_95_14, cd_campo_96, cd_campo_97, cd_campo_98, cd_campo_99, dt_campo_100, dt_campo_101, cd_campo_102, cd_campo_103, dt_campo_104, cd_campo_105, dt_campo_106, cd_campo_107) AS select	a.DT_GENERATE, a.NR_SEQ_ALTO_CUSTO, CD_CONVENIO,
     substr(obter_result_anzics_value(a.nr_sequencia,155),1,20) NM_CAMPO_1,
     substr(obter_result_anzics_value(a.nr_sequencia,156),1,30) NM_CAMPO_2,
     substr(obter_result_anzics_value(a.nr_sequencia,157),1,30) NM_CAMPO_3,
     substr(obter_result_anzics_value(a.nr_sequencia,158),1,30) NM_CAMPO_4,
     substr(obter_result_anzics_value(a.nr_sequencia,162),1,6) CD_CAMPO_5,
     substr(obter_result_anzics_value(a.nr_sequencia,165),1,10) CD_CAMPO_6,
     COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,184), 'YYYY-MM-DD'), obter_anzics_value_default(184)) DT_CAMPO_16,
     obter_result_anzics_number(a.nr_sequencia,169) CD_CAMPO_7,
     substr(obter_result_anzics_value(a.nr_sequencia,172),1,2) CD_CAMPO_8,
     substr(obter_result_anzics_value(a.nr_sequencia,175),1,20) CD_CAMPO_9,
     COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,177), 'YYYY-MM-DD'), obter_anzics_value_default(177)) DT_CAMPO_10,
     substr(obter_result_anzics_value(a.nr_sequencia,178),1,1) CD_CAMPO_11,
     substr(obter_result_anzics_value(a.nr_sequencia,179),1,5) CD_CAMPO_12,
     substr(obter_result_anzics_value(a.nr_sequencia,181),1,150) DS_CAMPO_13,
     obter_result_anzics_number(a.nr_sequencia,182) CD_CAMPO_14,
     substr(obter_result_anzics_value(a.nr_sequencia,183),1,50) CD_CAMPO_15,
     substr(obter_result_anzics_value(a.nr_sequencia,185),1,4000) IE_CAMPO_17,
     substr(obter_result_anzics_value(a.nr_sequencia,201),1,4000) CD_CAMPO_18,
     substr(obter_result_anzics_value(a.nr_sequencia,205),1,4000) IE_CAMPO_19,
     substr(obter_result_anzics_value(a.nr_sequencia,213),1,3) CD_CAMPO_20,
     COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,217), 'YYYY-MM-DD'), obter_anzics_value_default(217)) DT_CAMPO_21,
     COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,220), 'YYYY-MM-DD'), obter_anzics_value_default(220)) DT_CAMPO_22,
     substr(obter_result_anzics_value(a.nr_sequencia,221),1,3) CD_CAMPO_23,
     substr(obter_result_anzics_value(a.nr_sequencia,223),1,5) CD_CAMPO_24,
     substr(obter_result_anzics_value(a.nr_sequencia,225),1,10) CD_CAMPO_25,
     substr(obter_result_anzics_value(a.nr_sequencia,234),1,50) CD_CAMPO_26,
     substr(obter_result_anzics_value(a.nr_sequencia,235),1,5) CD_CAMPO_27_1,
     obter_result_anzics_number(a.nr_sequencia,236) CD_CAMPO_28,
     obter_result_anzics_number(a.nr_sequencia,237) CD_CAMPO_29,
     COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,408), 'YYYY-MM-DD'), obter_anzics_value_default(408)) DT_CAMPO_30,
     obter_result_anzics_number(a.nr_sequencia,409) CD_CAMPO_31,
     obter_result_anzics_number(a.nr_sequencia,411) CD_CAMPO_32,
     substr(obter_result_anzics_value(a.nr_sequencia,420),1,2) CD_CAMPO_33,
     substr(obter_result_anzics_value(a.nr_sequencia,422),1,2) CD_CAMPO_34,
     substr(obter_result_anzics_value(a.nr_sequencia,423),1,2) CD_CAMPO_35,
     substr(obter_result_anzics_value(a.nr_sequencia,426),1,2) CD_CAMPO_36,
     substr(obter_result_anzics_value(a.nr_sequencia,427),1,2) CD_CAMPO_37,
     substr(obter_result_anzics_value(a.nr_sequencia,433),1,2) CD_CAMPO_38,
     substr(obter_result_anzics_value(a.nr_sequencia,437),1,2) CD_CAMPO_39,
     substr(obter_result_anzics_value(a.nr_sequencia,474),1,2) CD_CAMPO_40,
     substr(obter_result_anzics_value(a.nr_sequencia,438),1,2) CD_CAMPO_41,
     substr(obter_result_anzics_value(a.nr_sequencia,476),1,2) CD_CAMPO_42,
     substr(obter_result_anzics_value(a.nr_sequencia,477),1,2) IE_CAMPO_43,
     substr(obter_result_anzics_value(a.nr_sequencia,478),1,2) CD_CAMPO_44_1,
     substr(obter_result_anzics_value(a.nr_sequencia,480),1,2) CD_CAMPO_44_2,
     substr(obter_result_anzics_value(a.nr_sequencia,482),1,2) CD_CAMPO_44_3,
     substr(obter_result_anzics_value(a.nr_sequencia,483),1,2) CD_CAMPO_44_4,
     substr(obter_result_anzics_value(a.nr_sequencia,485),1,2) CD_CAMPO_44_5,
     substr(obter_result_anzics_value(a.nr_sequencia,486),1,2) CD_CAMPO_44_6,
     substr(obter_result_anzics_value(a.nr_sequencia,488),1,2) CD_CAMPO_44_7,
     substr(obter_result_anzics_value(a.nr_sequencia,487),1,2) CD_CAMPO_44_8,
     substr(obter_result_anzics_value(a.nr_sequencia,489),1,2) CD_CAMPO_44_9,
     substr(obter_result_anzics_value(a.nr_sequencia,491),1,2) CD_CAMPO_44_10,
     substr(obter_result_anzics_value(a.nr_sequencia,493),1,2) CD_CAMPO_44_11,
     substr(obter_result_anzics_value(a.nr_sequencia,494),1,2) CD_CAMPO_44_12,
     substr(obter_result_anzics_value(a.nr_sequencia,495),1,2) CD_CAMPO_44_13,
     substr(obter_result_anzics_value(a.nr_sequencia,496),1,2) CD_CAMPO_44_14,
     substr(obter_result_anzics_value(a.nr_sequencia,497),1,2) CD_CAMPO_44_15,
     substr(obter_result_anzics_value(a.nr_sequencia,498),1,2) CD_CAMPO_44_16,
     substr(obter_result_anzics_value(a.nr_sequencia,499),1,2) CD_CAMPO_44_17,
     substr(obter_result_anzics_value(a.nr_sequencia,500),1,2) CD_CAMPO_44_18,
     substr(obter_result_anzics_value(a.nr_sequencia,501),1,2) CD_CAMPO_44_19,
     substr(obter_result_anzics_value(a.nr_sequencia,502),1,2) CD_CAMPO_44_20,
     substr(obter_result_anzics_value(a.nr_sequencia,503),1,2) CD_CAMPO_45,
     substr(obter_result_anzics_value(a.nr_sequencia,586),1,2) IE_CAMPO_46,
     substr(obter_result_anzics_value(a.nr_sequencia,588),1,2) CD_CAMPO_47,
     substr(obter_result_anzics_value(a.nr_sequencia,589),1,2) CD_CAMPO_48,
     COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,590), 'YYYY-MM-DD'), obter_anzics_value_default(590)) DT_CAMPO_49,
     substr(obter_result_anzics_value(a.nr_sequencia,591),1,2) CD_CAMPO_50,
     obter_result_anzics_number(a.nr_sequencia,592) QT_CAMPO_51,
     obter_result_anzics_number(a.nr_sequencia,594) CD_CAMPO_52,
     substr(obter_result_anzics_value(a.nr_sequencia,415),1,2) IE_CAMPO_53_1,
     substr(obter_result_anzics_value(a.nr_sequencia,421),1,2) IE_CAMPO_53_2,
     substr(obter_result_anzics_value(a.nr_sequencia,424),1,2) IE_CAMPO_53_3,
     substr(obter_result_anzics_value(a.nr_sequencia,425),1,2) IE_CAMPO_53_4,
     substr(obter_result_anzics_value(a.nr_sequencia,434),1,2) IE_CAMPO_53_5,
     substr(obter_result_anzics_value(a.nr_sequencia,436),1,2) IE_CAMPO_53_6,
     substr(obter_result_anzics_value(a.nr_sequencia,441),1,2) IE_CAMPO_53_7,
     substr(obter_result_anzics_value(a.nr_sequencia,450),1,2) IE_CAMPO_53_8,
     substr(obter_result_anzics_value(a.nr_sequencia,451),1,2) IE_CAMPO_53_9,
     substr(obter_result_anzics_value(a.nr_sequencia,452),1,2) IE_CAMPO_53_10,
     substr(obter_result_anzics_value(a.nr_sequencia,454),1,2) IE_CAMPO_53_11,
     substr(obter_result_anzics_value(a.nr_sequencia,457),1,2) IE_CAMPO_53_12,
     substr(obter_result_anzics_value(a.nr_sequencia,461),1,2) IE_CAMPO_53_13,
     substr(obter_result_anzics_value(a.nr_sequencia,462),1,2) IE_CAMPO_53_14,
     substr(obter_result_anzics_value(a.nr_sequencia,465),1,2) IE_CAMPO_53_15,
     substr(obter_result_anzics_value(a.nr_sequencia,466),1,2) IE_CAMPO_53_16,
     substr(obter_result_anzics_value(a.nr_sequencia,467),1,2) IE_CAMPO_56_17,
     substr(obter_result_anzics_value(a.nr_sequencia,468),1,2) IE_CAMPO_56_18,
     substr(obter_result_anzics_value(a.nr_sequencia,470),1,2) IE_CAMPO_53_19,
     substr(obter_result_anzics_value(a.nr_sequencia,472),1,2) IE_CAMPO_53_20,
     substr(obter_result_anzics_value(a.nr_sequencia,504),1,9) CD_CAMPO_54,
     COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,505), 'YYYY-MM-DD'), obter_anzics_value_default(505)) DT_CAMPO_55,
     obter_result_anzics_number(a.nr_sequencia,764) CD_CAMPO_56,
     obter_result_anzics_number(a.nr_sequencia,813) CD_CAMPO_57,
     obter_result_anzics_number(a.nr_sequencia,814) CD_CAMPO_58,
     obter_result_anzics_number(a.nr_sequencia,815) CD_CAMPO_59,
     obter_result_anzics_number(a.nr_sequencia,816) CD_CAMPO_60,
     obter_result_anzics_number(a.nr_sequencia,817) CD_CAMPO_61,
     obter_result_anzics_number(a.nr_sequencia,818) CD_CAMPO_62,
     obter_result_anzics_number(a.nr_sequencia,819) CD_CAMPO_63,
     obter_result_anzics_number(a.nr_sequencia,820) CD_CAMPO_64,
     obter_result_anzics_number(a.nr_sequencia,821) CD_CAMPO_65,
     obter_result_anzics_number(a.nr_sequencia,822) CD_CAMPO_66,
     obter_result_anzics_number(a.nr_sequencia,823) CD_CAMPO_67,
     obter_result_anzics_number(a.nr_sequencia,824) CD_CAMPO_68,
     obter_result_anzics_number(a.nr_sequencia,825) CD_CAMPO_69,
     obter_result_anzics_number(a.nr_sequencia,826) CD_CAMPO_70,
     obter_result_anzics_number(a.nr_sequencia,827) CD_CAMPO_71,
     obter_result_anzics_number(a.nr_sequencia,828) CD_CAMPO_72,
     obter_result_anzics_number(a.nr_sequencia,829) CD_CAMPO_73,
     obter_result_anzics_number(a.nr_sequencia,830) CD_CAMPO_74,
     COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,831), 'YYYY-MM-DD'), obter_anzics_value_default(831)) DT_CAMPO_75,
     obter_result_anzics_number(a.nr_sequencia,832) CD_CAMPO_76,
     COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,833), 'YYYY-MM-DD'), obter_anzics_value_default(833)) DT_CAMPO_77,
     obter_result_anzics_number(a.nr_sequencia,834) CD_CAMPO_78,
     COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,835), 'YYYY-MM-DD'), obter_anzics_value_default(835)) DT_CAMPO_79,
     obter_result_anzics_number(a.nr_sequencia,836) CD_CAMPO_80,
     obter_result_anzics_number(a.nr_sequencia,837) CD_CAMPO_81,
     obter_result_anzics_number(a.nr_sequencia,848) CD_CAMPO_81_1,
     obter_result_anzics_number(a.nr_sequencia,849) CD_CAMPO_82,
     obter_result_anzics_number(a.nr_sequencia,850) CD_CAMPO_83,
     obter_result_anzics_number(a.nr_sequencia,853) CD_CAMPO_84,
     obter_result_anzics_number(a.nr_sequencia,857) CD_CAMPO_85,
     obter_result_anzics_number(a.nr_sequencia,859) CD_CAMPO_86,
     obter_result_anzics_number(a.nr_sequencia,860) CD_CAMPO_87,
     obter_result_anzics_number(a.nr_sequencia,862) CD_CAMPO_88,
     substr(obter_result_anzics_value(a.nr_sequencia,619),1,2) CD_CAMPO_89,
     COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,640), 'YYYY-MM-DD'), obter_anzics_value_default(640)) DT_CAMPO_90,
     substr(obter_result_anzics_value(a.nr_sequencia,641),1,2) CD_CAMPO_91_1,
     substr(obter_result_anzics_value(a.nr_sequencia,642),1,2) CD_CAMPO_91_2,
     substr(obter_result_anzics_value(a.nr_sequencia,643),1,2) CD_CAMPO_91_3,
     substr(obter_result_anzics_value(a.nr_sequencia,646),1,2) CD_CAMPO_91_4,
     substr(obter_result_anzics_value(a.nr_sequencia,661),1,2) CD_CAMPO_91_5,
     substr(obter_result_anzics_value(a.nr_sequencia,662),1,2) CD_CAMPO_91_6,
     substr(obter_result_anzics_value(a.nr_sequencia,663),1,2) CD_CAMPO_91_7,
     substr(obter_result_anzics_value(a.nr_sequencia,664),1,2) CD_CAMPO_91_8,
     substr(obter_result_anzics_value(a.nr_sequencia,665),1,2) CD_CAMPO_91_9,
     substr(obter_result_anzics_value(a.nr_sequencia,666),1,2) CD_CAMPO_91_10,
     substr(obter_result_anzics_value(a.nr_sequencia,667),1,2) CD_CAMPO_91_11,
     substr(obter_result_anzics_value(a.nr_sequencia,668),1,2) CD_CAMPO_91_12,
     substr(obter_result_anzics_value(a.nr_sequencia,708),1,2) CD_CAMPO_91_13,
     substr(obter_result_anzics_value(a.nr_sequencia,710),1,2) CD_CAMPO_91_14,
     substr(obter_result_anzics_value(a.nr_sequencia,711),1,2) CD_CAMPO_91_15,
     substr(obter_result_anzics_value(a.nr_sequencia,712),1,2) CD_CAMPO_91_16,
     substr(obter_result_anzics_value(a.nr_sequencia,713),1,2) CD_CAMPO_91_17,
     substr(obter_result_anzics_value(a.nr_sequencia,714),1,2) CD_CAMPO_91_18,
     substr(obter_result_anzics_value(a.nr_sequencia,715),1,2) CD_CAMPO_91_19,
     substr(obter_result_anzics_value(a.nr_sequencia,717),1,2) CD_CAMPO_91_20,
     substr(obter_result_anzics_value(a.nr_sequencia,718),1,2) CD_CAMPO_92,
     substr(obter_result_anzics_value(a.nr_sequencia,719),1,2) CD_CAMPO_92_1,
     substr(obter_result_anzics_value(a.nr_sequencia,720),1,2) CD_CAMPO_92_2,
     substr(obter_result_anzics_value(a.nr_sequencia,721),1,2) CD_CAMPO_92_3,
     substr(obter_result_anzics_value(a.nr_sequencia,722),1,2) CD_CAMPO_92_4,
     substr(obter_result_anzics_value(a.nr_sequencia,724),1,2) CD_CAMPO_92_5,
     substr(obter_result_anzics_value(a.nr_sequencia,795),1,2) CD_CAMPO_93,
     COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,796), 'YYYY-MM-DD'), obter_anzics_value_default(796)) DT_CAMPO_94,
     substr(obter_result_anzics_value(a.nr_sequencia,797),1,2) CD_CAMPO_95_1,
     substr(obter_result_anzics_value(a.nr_sequencia,798),1,2) CD_CAMPO_95_2,
     substr(obter_result_anzics_value(a.nr_sequencia,799),1,2) CD_CAMPO_95_3,
     substr(obter_result_anzics_value(a.nr_sequencia,801),1,2) CD_CAMPO_95_4,
     substr(obter_result_anzics_value(a.nr_sequencia,802),1,2) CD_CAMPO_95_5,
     substr(obter_result_anzics_value(a.nr_sequencia,803),1,2) CD_CAMPO_95_6,
     substr(obter_result_anzics_value(a.nr_sequencia,804),1,2) CD_CAMPO_95_7,
     substr(obter_result_anzics_value(a.nr_sequencia,806),1,2) CD_CAMPO_95_8,
     substr(obter_result_anzics_value(a.nr_sequencia,807),1,2) CD_CAMPO_95_9,
     substr(obter_result_anzics_value(a.nr_sequencia,808),1,2) CD_CAMPO_95_10,
     substr(obter_result_anzics_value(a.nr_sequencia,809),1,2) CD_CAMPO_95_11,
     substr(obter_result_anzics_value(a.nr_sequencia,810),1,2) CD_CAMPO_95_12,
     substr(obter_result_anzics_value(a.nr_sequencia,811),1,2) CD_CAMPO_95_13,
     substr(obter_result_anzics_value(a.nr_sequencia,812),1,2) CD_CAMPO_95_14,
     substr(obter_result_anzics_value(a.nr_sequencia,838),1,2) CD_CAMPO_96,
     substr(obter_result_anzics_value(a.nr_sequencia,839),1,2) CD_CAMPO_97,
     substr(obter_result_anzics_value(a.nr_sequencia,840),1,2) CD_CAMPO_98,
     substr(obter_result_anzics_value(a.nr_sequencia,841),1,2) CD_CAMPO_99,
     COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,842), 'YYYY-MM-DD'), obter_anzics_value_default(842)) DT_CAMPO_100,
     COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,843), 'YYYY-MM-DD'), obter_anzics_value_default(843)) DT_CAMPO_101,
     COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,844), 'YYYY-MM-DD'), obter_anzics_value_default(844)) CD_CAMPO_102,
     obter_result_anzics_number(a.nr_sequencia,878) CD_CAMPO_103,
     COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,881), 'YYYY-MM-DD'), obter_anzics_value_default(881)) DT_CAMPO_104,
     substr(obter_result_anzics_value(a.nr_sequencia,882),1,50) CD_CAMPO_105,
     COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,883), 'YYYY-MM-DD'), obter_anzics_value_default(883)) DT_CAMPO_106,
     obter_result_anzics_number(a.nr_sequencia,886) CD_CAMPO_107
     FROM ATEND_ANZICS a
     where a.NR_SEQ_ANZICS = 5
     and a.dt_inativacao is null 
     order by a.DT_GENERATE;
