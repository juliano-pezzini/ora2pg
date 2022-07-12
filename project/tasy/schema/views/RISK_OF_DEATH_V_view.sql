-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW risk_of_death_v (nr_atendimento, fld_nm_first_col_content, fld_nm_second_col_sub_info, fld_nm_chart_tooltip, fld_nm_chart_first_val, fld_nm_chart_seccond_val, fld_nm_third_col_content, fld_nm_second_col_content, fld_nm_sub_content) AS select   c.nr_atendimento,
         d.fld_nm_first_col_content,
         d.fld_nm_second_col_sub_info,
         trim(both to_char(d.fld_nm_chart_first_val, '990.99')) || ' - ' || trim(both to_char(d.fld_nm_chart_seccond_val, '990.99')) fld_nm_chart_tooltip,
         d.fld_nm_chart_first_val,
         d.fld_nm_chart_seccond_val,
         d.fld_nm_third_col_content,
         d.fld_nm_second_col_content,
		 d.fld_nm_sub_content
FROM (select b.nr_atendimento from risk_of_death b group by b.nr_atendimento) c,
         (
         select   a.nr_sequencia,
                  a.nr_atendimento,
                  substr(obter_desc_expressao_idioma(1032413,null,wheb_usuario_pck.get_nr_seq_idioma),1,255) fld_nm_second_col_content,
                  substr(get_drs_category_info(a.ie_categoria, 'T'), 1, 50) fld_nm_second_col_sub_info,
                  coalesce(trim(both to_char(obter_pontuacao_telehealth(a.nr_atendimento, 'risk_of_death', 'nr_pontuacao', 'dt_pontuacao', 1), '990.99')), '--') fld_nm_third_col_content,
                  a.dt_pontuacao,
                  null fld_nm_first_col_content,
				  obter_pontuacao_telehealth(a.nr_atendimento, 'risk_of_death', 'nr_pontuacao_min', 'dt_pontuacao', 1) fld_nm_chart_first_val,
				  obter_pontuacao_telehealth(a.nr_atendimento, 'risk_of_death', 'nr_pontuacao_max', 'dt_pontuacao', 1) fld_nm_chart_seccond_val,
				  substr(get_drs_category_info(a.ie_categoria, 'C'), 1, 50) fld_nm_sub_content
         from     risk_of_death a
         ) d
where    c.nr_atendimento = d.nr_atendimento and
         d.dt_pontuacao   = (select   max(b.dt_pontuacao)
                             from     risk_of_death b
                             where    b.nr_atendimento = c.nr_atendimento) and
         d.nr_sequencia   = (select   max(b.nr_sequencia)
                             from     risk_of_death b
                             where    b.dt_pontuacao   = d.dt_pontuacao);
