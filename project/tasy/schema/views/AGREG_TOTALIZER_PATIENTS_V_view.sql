-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW agreg_totalizer_patients_v (nr_order, ds_text, qt_sum, nr_seq_main_daily_rep) AS select  10 nr_order,
        obter_desc_expressao(1046021) ds_text,
        QT_FIXED_BEDS QT_SUM,
        nr_seq_main_daily_rep
FROM AGREG_NUMBER_PATIENT

union all

select  20 nr_order,
        obter_desc_expressao(751131) ds_text,
        QT_CURRENT_PATIENTS_HOSP QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  30 nr_order,
        obter_desc_expressao(341603) ds_text,
        QT_PATIENTS_HOSP QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  40  nr_order,
        obter_desc_expressao(283375) ds_text,
        QT_DISCHARGE_PATIENTS QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  50  nr_order,
        obter_desc_expressao(294559) ds_text,
        QT_DECEASED_PATIENTS QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  60  nr_order,
        obter_desc_expressao(1046119) ds_text,
        QT_TRANSF_PATIENTS_IN QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  70  nr_order,
        obter_desc_expressao(1046127) ds_text,
        QT_TRANSF_PATIENTS_OUT QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  80  nr_order,
        obter_desc_expressao(1046133) ds_text,
        qt_leaving_patients_temp QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  90  nr_order,
        obter_desc_expressao(1046139) ds_text,
        qt_outnight_patients QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  100  nr_order,
        obter_desc_expressao(1046143) ds_text,
        qt_family_attend QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  110  nr_order,
        obter_desc_expressao(888795) ds_text,
        qt_litter_patients QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  120  nr_order,
        obter_desc_expressao(1046163) ds_text,
        qt_accomp_patients QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  130  nr_order,
        obter_desc_expressao(1046167) ds_text,
        qt_indep_patients QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  140  nr_order,
        obter_desc_expressao(1046239) ds_text,
        qt_operations QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  150  nr_order,
        obter_desc_expressao(1046243) ds_text,
        qt_deliveries QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  160  nr_order,
        obter_desc_expressao(1046249) ds_text,
        qt_newborns QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  170  nr_order,
        obter_desc_expressao(1049230) ds_text,
        qt_patients_a_i QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  180  nr_order,
        obter_desc_expressao(1049232) ds_text,
        qt_patients_a_ii QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  190  nr_order,
        obter_desc_expressao(1049234) ds_text,
        qt_patients_a_iii QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  200  nr_order,
        obter_desc_expressao(1049236) ds_text,
        qt_patients_a_iv QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  210  nr_order,
        obter_desc_expressao(1049238) ds_text,
        qt_patients_b_i QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  220  nr_order,
        obter_desc_expressao(1049240) ds_text,
        qt_patients_b_ii QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  230  nr_order,
        obter_desc_expressao(1049242) ds_text,
        qt_patients_b_iii QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  240  nr_order,
        obter_desc_expressao(1049244) ds_text,
        qt_patients_b_iv QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  250  nr_order,
        obter_desc_expressao(1049246) ds_text,
        qt_patients_c_i QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  260  nr_order,
        obter_desc_expressao(1049248) ds_text,
        qt_patients_c_ii QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  270  nr_order,
        obter_desc_expressao(1049250) ds_text,
        qt_patients_c_iii QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  280  nr_order,
        obter_desc_expressao(1049252) ds_text,
        qt_patients_c_iv QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  290  nr_order,
        obter_desc_expressao(1049254) ds_text,
        qt_fall_risk_patients_i QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  300  nr_order,
        obter_desc_expressao(1049256) ds_text,
        qt_fall_risk_patients_ii QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT

union all

select  310  nr_order,
        obter_desc_expressao(1049258) ds_text,
        qt_fall_risk_patients_iii QT_SUM,
        nr_seq_main_daily_rep
from AGREG_NUMBER_PATIENT;

