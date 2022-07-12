-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW get_macro_for_filename (ds_valor_dominio, ds_macro) AS select
obter_desc_expressao(vd.cd_exp_valor_dominio) ds_valor_dominio,
CASE vl_dominio  
                 WHEN 'LNU' THEN '#@lifetime_number#@'
                 WHEN 'ENU' THEN '#@encouter_number#@'
                 WHEN 'API' THEN '#@alternative_id#@'
                 WHEN 'FNA' THEN '#@first_name#@' 
                 WHEN 'MNA' THEN '#@middle_name#@'
                 WHEN 'LNA' THEN '#@last_name#@'
                 WHEN 'CUN' THEN '#@care_unit#@'
                 WHEN 'DTY' THEN '#@document_type#@'
                 WHEN 'DSI' THEN '#@document_schedule_id#@'
                 WHEN 'DET' THEN '#@document_end_time#@'
          END as ds_macro
FROM valor_dominio vd
where vd.cd_dominio = 10537
order by vd.nr_seq_apresent;

