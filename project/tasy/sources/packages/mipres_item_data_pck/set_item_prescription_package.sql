-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE mipres_item_data_pck.set_item_prescription () AS $body$
BEGIN

		<<case_type>>
		CASE
			--Medicine/Material/Nutrition/Material associated with gas therap
			WHEN ie_tipo_item_presc_p in ('M', 'MAT', 'D', 'ASS', 'MAG', 'MAD') THEN
				ds_sql_cursor_w := 'select  a.nr_atendimento nr_encounter, '
                        || '        a.dt_prescricao, '
                        || '        b.qt_dose, '
                        || '        b.cd_unidade_medida, '
                        || '        b.ie_via_aplicacao, '
                        || '        b.cd_intervalo, '
                        || '        a.cd_medico, '
                        || '        null cd_resident, '
                        || '        b.dt_suspensao, '
                        || '        substr(m.ds_material, 1, 255) ds_item, '
                        || '        m.cd_cum item_code, '
                        || '        m.ie_conselho_medico, '
                        || '        nvl(m.ie_med_unirs, ''N'') ie_med_unirs, '
                        || '        a.dt_prescricao dt_item_prescription, '
                        || '        a.cd_prescritor cd_item_prescriber '
                        || 'from    prescr_medica a, '
                        || '        prescr_material b, '
                        || '        material m '
                        || 'where   a.nr_prescricao = b.nr_prescricao '
                        || 'and     b.cd_material = m.cd_material '
                        || 'and     a.nr_prescricao = :nr_prescricao_p '
                        || 'and     b.nr_sequencia = :nr_seq_item_presc_p ';

				if (ie_tipo_item_presc_p = 'M') then
					ds_sql_cursor_w := ds_sql_cursor_w || ' and b.ie_agrupador in (1, 3, 7, 9) ';
				elsif (ie_tipo_item_presc_p = 'MAT') then
          if (nr_seq_cpoe_p IS NOT NULL AND nr_seq_cpoe_p::text <> '') then
					  ds_sql_cursor_w := ds_sql_cursor_w || ' and b.ie_agrupador = 2 ';
          end if;
				elsif (ie_tipo_item_presc_p = 'ASS') then
					ds_sql_cursor_w := ds_sql_cursor_w || ' and b.ie_agrupador = 5 ';
				elsif (ie_tipo_item_presc_p = 'D') then
					ds_sql_cursor_w := ds_sql_cursor_w || ' and b.ie_agrupador in (8, 12, 16) ';
				elsif (ie_tipo_item_presc_p = 'MAG') then
					ds_sql_cursor_w := ds_sql_cursor_w || ' and b.ie_agrupador = 15 ';
				elsif (ie_tipo_item_presc_p = 'MAD') then
					ds_sql_cursor_w := ds_sql_cursor_w || ' and b.ie_agrupador = 17 ';
				end if;

				ds_bind_cCursor_w := sql_pck.bind_variable(':nr_prescricao_p', nr_prescricao_p, ds_bind_cCursor_w);
				ds_bind_cCursor_w := sql_pck.bind_variable(':nr_seq_item_presc_p', nr_seq_item_presc_p, ds_bind_cCursor_w);

			--Solution
			WHEN ie_tipo_item_presc_p = 'SOL' THEN
				ds_sql_cursor_w :=
					   'select distinct a.nr_atendimento nr_encounter, '
					|| '       a.dt_prescricao, b.qt_dose, c.cd_unidade_medida, c.ie_via_aplicacao, nvl(c.cd_intervalo, b.cd_intervalo), '
					|| '       a.cd_medico, null cd_resident, c.dt_suspensao, '
					|| '       nvl(c.ds_solucao, substr(m.ds_material, 1, 255)) ds_item, '
					|| '       m.cd_cum item_code, m.ie_conselho_medico, nvl(m.ie_med_unirs, ''N'') ie_med_unirs, '
                    || '       a.dt_prescricao dt_item_prescription, a.cd_prescritor cd_item_prescriber '
					|| '  from prescr_medica a, '
					|| '	   prescr_material b, '
					|| '       prescr_solucao c, '
					|| '	   material m '
					|| ' where a.nr_prescricao = b.nr_prescricao '
					|| '   and b.nr_prescricao = c.nr_prescricao '
					|| '   and b.cd_material = m.cd_material '
					|| '   and c.nr_seq_solucao = b.nr_sequencia_solucao '
					|| '   and a.nr_prescricao = :nr_prescricao_p '
					|| '   and b.nr_sequencia = :nr_seq_item_presc_p '
					|| '   and b.ie_agrupador = 4';

				ds_bind_cCursor_w := sql_pck.bind_variable(':nr_prescricao_p', nr_prescricao_p, ds_bind_cCursor_w);
				ds_bind_cCursor_w := sql_pck.bind_variable(':nr_seq_item_presc_p', nr_seq_item_presc_p, ds_bind_cCursor_w);

			--Material associated with Blood and Blood Products
			WHEN ie_tipo_item_presc_p = 'MAH' THEN
                ds_sql_cursor_w :=
                       'select distinct cph.nr_atendimento nr_encounter, '
                    || '        med.dt_prescricao, '
                    || '        prm.qt_dose, '
                    || '        prm.cd_unidade_medida, '
                    || '        prm.ie_via_aplicacao, '
                    || '        prm.cd_intervalo, '
                    || '        cph.cd_medico, '
                    || '        null cd_resident, '
                    || '        cph.dt_suspensao, '
                    || '        substr(mat.ds_material, 1, 255) ds_item, '
                    || '        mat.cd_material item_code, '
                    || '        mat.ie_conselho_medico, '
                    || '        nvl(mat.ie_med_unirs, ''N'') ie_med_unirs, '
                    || '        med.dt_prescricao dt_item_prescription, '
                    || '        med.cd_prescritor cd_item_prescriber '
                    || 'from    cpoe_material cmt, '
                    || '        cpoe_hemoterapia cph, '
                    || '        prescr_solic_bco_sangue ph, '
                    || '        prescr_material prm, '
                    || '        prescr_medica med, '
                    || '        material mat '
                    || 'where   cmt.nr_sequencia = prm.nr_seq_mat_cpoe '
                    || 'and     cmt.nr_seq_hemoterapia = cph.nr_sequencia '
                    || 'and     mat.cd_material = prm.cd_material '
                    || 'and     prm.nr_prescricao = med.nr_prescricao '
                    || 'and     cmt.nr_seq_hemoterapia = cph.nr_sequencia '
                    || 'and     mat.cd_material in ( '
                    || '                            cph.cd_mat_dil1, cph.cd_mat_dil2, cph.cd_mat_dil3, cph.cd_mat_dil4, cph.cd_mat_dil5, '
                    || '                            cph.cd_mat_hem1, cph.cd_mat_hem2, cph.cd_mat_hem3, cph.cd_mat_hem4, cph.cd_mat_hem5, '
                    || '                            cph.cd_mat_red1, cph.cd_mat_red2, cph.cd_mat_red3, cph.cd_mat_red4, cph.cd_mat_red5, '
                    || '                            cph.cd_mat_recons1, cph.cd_mat_recons2, cph.cd_mat_recons3, cph.cd_mat_recons4, cph.cd_mat_recons5 '
                    || '                            ) '
                    || 'and     prm.nr_prescricao = :nr_prescricao_p '
                    || 'and     prm.nr_sequencia = :nr_seq_item_presc_p ';

				ds_bind_cCursor_w := sql_pck.bind_variable(':nr_prescricao_p', nr_prescricao_p, ds_bind_cCursor_w);
				ds_bind_cCursor_w := sql_pck.bind_variable(':nr_seq_item_presc_p', nr_seq_item_presc_p, ds_bind_cCursor_w);

			--Procedure associated with Blood and Blood Products
			WHEN ie_tipo_item_presc_p in ('PRH') THEN
                ds_sql_cursor_w :=
				      'select  distinct cph.nr_atendimento nr_encounter, '
				    ||'		   med.dt_prescricao, pp.qt_procedimento qt_dose, null cd_unidade_medida, pp.ie_via_aplicacao, pp.cd_intervalo, '
				    ||'		   cph.cd_medico, null cd_resident, cph.dt_lib_suspensao,  '
				    ||'		   obter_desc_proc_interno(cph.nr_seq_proc_interno) ds_item,  '
				    ||'		   prc.cd_procedimento_loc item_code, prc.ie_conselho_medico, ''N'' ie_med_unirs, '
				    ||'		   med.dt_prescricao dt_item_prescription, cph.cd_medico cd_item_prescriber '
				    ||'from    cpoe_hemoterapia cph, '
				    ||'		   cpoe_procedimento cpp, '
				    ||'		   prescr_procedimento pp, '
				    ||'		   proc_interno pri, '
				    ||'		   procedimento prc, '
					||'        prescr_medica med '
				    ||'where   cph.nr_sequencia = cpp.nr_seq_hemoterapia '
				    ||'and     cpp.nr_sequencia = pp.nr_seq_proc_cpoe '
				    ||'and     cph.nr_seq_proc_interno = pri.nr_sequencia '
				    ||'and     pri.cd_procedimento = prc.cd_procedimento '
				    ||'and     pri.ie_origem_proced = prc.ie_origem_proced '
					||'and     pp.nr_prescricao = med.nr_prescricao '
				    ||'and 	   pp.nr_prescricao = :nr_prescricao_p '
				    ||'and     pp.nr_sequencia = :nr_seq_item_presc_p ';

				ds_bind_cCursor_w := sql_pck.bind_variable(':nr_prescricao_p', nr_prescricao_p, ds_bind_cCursor_w);
				ds_bind_cCursor_w := sql_pck.bind_variable(':nr_seq_item_presc_p', nr_seq_item_presc_p, ds_bind_cCursor_w);

			--Procedure
			WHEN ie_tipo_item_presc_p = 'P' THEN
				ds_sql_cursor_w :=
					   'select distinct a.nr_atendimento nr_encounter, '
					|| '       a.dt_prescricao, b.qt_procedimento qt_dose, null cd_unidade_medida, b.ie_via_aplicacao, b.cd_intervalo, ' -- revisar estes campos
					|| '       a.cd_medico, null cd_resident, b.dt_suspensao, '
					|| '       substr(pi.ds_proc_exame, 1, 255) ds_item, '
					|| '	   p.cd_procedimento_loc item_code, p.ie_conselho_medico, ''N'' ie_med_unirs, '
                    || '       a.dt_prescricao dt_item_prescription, a.cd_prescritor cd_item_prescriber '
					|| '  from prescr_medica a, '
					|| '       prescr_procedimento b, '
					|| ' 	   proc_interno pi, '
					|| '	   procedimento p '
					|| ' where a.nr_prescricao = b.nr_prescricao '
					|| '   and pi.nr_sequencia = b.nr_seq_proc_interno '
					|| '   and p.cd_procedimento = pi.cd_procedimento '
					|| '   and p.ie_origem_proced = pi.ie_origem_proced '
					|| '   and (obter_se_exibe_proced(b.nr_prescricao,b.nr_sequencia, b.ie_tipo_proced,''O'') = ''S'''
 					|| '    or obter_se_exibe_proced(b.nr_prescricao,b.nr_sequencia, b.ie_tipo_proced,''IVC'') = ''S'')'
					|| '   and a.nr_prescricao = :nr_prescricao_p'
					|| '   and b.nr_sequencia = :nr_seq_item_presc_p ';

				ds_bind_cCursor_w := sql_pck.bind_variable(':nr_prescricao_p', nr_prescricao_p, ds_bind_cCursor_w);
				ds_bind_cCursor_w := sql_pck.bind_variable(':nr_seq_item_presc_p', nr_seq_item_presc_p, ds_bind_cCursor_w);
				
			--Anatomic pathology exams
			WHEN ie_tipo_item_presc_p = 'AP' THEN
                ds_sql_cursor_w :=
                      ' select distinct a.nr_atendimento nr_encounter, '
                   || '        a.dt_prescricao, b.qt_procedimento qt_dose, null cd_unidade_medida, b.ie_via_aplicacao, b.cd_intervalo, '
		           || '        a.cd_medico, null cd_resident, b.dt_suspensao, '
		           || '        substr(pi.ds_proc_exame, 1, 255) ds_item, '
		           || '	       p.cd_procedimento_loc item_code, p.ie_conselho_medico, ''N'' ie_med_unirs,  '
                   || '        a.dt_prescricao dt_item_prescription, a.cd_prescritor cd_item_prescriber '
		           || ' from   prescr_medica a, '
		           || '        prescr_procedimento b, '
		           || ' 	   proc_interno pi, '
		           || '	       procedimento p '
		           || ' where  a.nr_prescricao = b.nr_prescricao '
		           || ' and    pi.nr_sequencia = b.nr_seq_proc_interno '
		           || ' and    p.cd_procedimento = pi.cd_procedimento '
		           || ' and    p.ie_origem_proced = pi.ie_origem_proced '
	               || ' and    obter_se_exib_proced_patologia(b.nr_prescricao,b.nr_sequencia) = ''S'''
		           || ' and    a.nr_prescricao = :nr_prescricao_p'
		           || ' and    b.nr_sequencia = :nr_seq_item_presc_p ';

				ds_bind_cCursor_w := sql_pck.bind_variable(':nr_prescricao_p', nr_prescricao_p, ds_bind_cCursor_w);
				ds_bind_cCursor_w := sql_pck.bind_variable(':nr_seq_item_presc_p', nr_seq_item_presc_p, ds_bind_cCursor_w);

            --Recommendation
            WHEN ie_tipo_item_presc_p = 'R' THEN
              ds_sql_cursor_w := 'select  a.nr_atendimento nr_encounter,'
                              || '        b.dt_inicio,'
                              || '        c.qt_procedimento qt_dose,'
                              || '        null cd_unidade_medida,'
                              || '        null ie_via_aplicacao,'
                              || '        b.cd_intervalo,'
                              || '        a.cd_medico,'
                              || '        null cd_resident,'
                              || '        a.dt_lib_suspensao,'
                              || '        obter_desc_recomendacao(a.cd_recomendacao) ds_item,'
                              || '        d.cd_procedimento_loc item_code,'
                              || '        d.ie_conselho_medico,'
                              || '        ''N'' ie_med_unirs, '
                              || '        null dt_item_prescription, '
                              || '        null cd_item_prescriber '
                              || 'from    cpoe_recomendacao a,'
                              || '        prescr_recomendacao b,'
                              || '        regra_proced_recomendacao c,'
                              || '        procedimento d,'
                              || '        proc_interno f '
                              || 'where   a.nr_sequencia = :nr_seq_cpoe_p '
                              || 'and     a.dt_liberacao is not null '
                              || 'and     b.nr_seq_rec_cpoe = a.nr_sequencia '
                              || 'and     c.cd_tipo_recomendacao = b.cd_recomendacao '
                              || 'and     c.cd_tipo_recomendacao is not null '
                              || 'and     d.cd_procedimento = c.cd_procedimento '
                              || 'and     d.ie_origem_proced = c.ie_origem_proced '
                              || 'and     f.cd_procedimento = d.cd_procedimento '
                              || 'and     f.ie_origem_proced = d.ie_origem_proced ';
	
              ds_bind_cCursor_w := sql_pck.bind_variable(':nr_seq_cpoe_p', nr_seq_cpoe_p, ds_bind_cCursor_w);

            --Material associated with Recommendation
            WHEN ie_tipo_item_presc_p = 'MREC' THEN
                ds_sql_cursor_w :=
                       'select  a.nr_atendimento nr_encounter, '
                    || '        b.dt_inicio, '
                    || '        c.qt_procedimento qt_dose, '
                    || '        null cd_unidade_medida, '
                    || '        null ie_via_aplicacao, '
                    || '        b.cd_intervalo, '
                    || '        a.cd_medico, '
                    || '        null cd_resident, '
                    || '        a.dt_lib_suspensao, '
                    || '        substr(f.ds_material, 1, 255) ds_item, '
                    || '        f.cd_cum item_code, '
                    || '        f.ie_conselho_medico, '
                    || '        ''N'' ie_med_unirs, '
                    || '        a.dt_inicio dt_item_prescription, '
                    || '        a.cd_medico cd_item_prescriber '
                    || 'from    cpoe_recomendacao a,'
                    || '        prescr_recomendacao b,'
                    || '        regra_proced_recomendacao c,'
                    || '        prescr_material d,'
                    || '        kit_mat_recomendacao e, '
                    || '        material f '
                    || 'where   a.nr_sequencia = :nr_seq_cpoe_p '
                    || 'and     d.nr_sequencia = :nr_seq_item_presc_p '
                    || 'and     a.nr_sequencia = b.nr_seq_rec_cpoe '
                    || 'and     a.dt_liberacao is not null '
                    || 'and     b.nr_prescricao = d.nr_prescricao '
                    || 'and     b.cd_recomendacao = c.cd_tipo_recomendacao '
                    || 'and     c.cd_tipo_recomendacao is not null '
                    || 'and     d.cd_kit_material = e.cd_kit '
                    || 'and     d.cd_material = f.cd_material';
	
                ds_bind_cCursor_w := sql_pck.bind_variable(':nr_seq_cpoe_p', nr_seq_cpoe_p, ds_bind_cCursor_w);
                ds_bind_cCursor_w := sql_pck.bind_variable(':nr_seq_item_presc_p', nr_seq_item_presc_p, ds_bind_cCursor_w);
				
			WHEN ie_tipo_item_presc_p = 'PH' THEN
				ds_sql_cursor_w :=
			           'select  hem.nr_atendimento nr_encounter, '
			        || '		hem.dt_inicio,  '
			        || '		hem.qt_procedimento qt_dose,  '
			        || '		hem.ie_unid_med_hemo cd_unidade_medida,  '
			        || '		hem.ie_via_aplicacao,  '
			        || '		hem.cd_intervalo, '
			        || '		hem.cd_medico,  '
			        || '		null cd_resident,  '
			        || '		hem.dt_lib_suspensao, '
			        || '		substr(sd.ds_derivado, 1, 255) ds_item, '
			        || '		prc.cd_procedimento_loc item_code,  '
			        || '		prc.ie_conselho_medico, '
			        || '		''N'' ie_med_unirs, '
			        || '		hem.dt_inicio dt_item_prescription,  '
			        || '		hem.cd_medico cd_item_prescriber '
			        || 'from	cpoe_hemoterapia hem, '
			        || '		prescr_solic_bco_sangue ph, '
			        || '		san_derivado sd, '
			        || '		proc_interno pri, '
			        || '		procedimento prc '
			        || 'where   hem.nr_sequencia = ph.nr_seq_hemo_cpoe '
			        || 'and     hem.nr_seq_derivado      = sd.nr_sequencia '
			        || 'and     sd.nr_seq_proc_interno   = pri.nr_sequencia '
			        || 'and     pri.cd_procedimento      = prc.cd_procedimento '
			        || 'and     pri.ie_origem_proced     = prc.ie_origem_proced '
			        || 'and     hem.dt_liberacao is not null '
			        || 'and     ph.nr_sequencia = :nr_seq_item_presc_p '
			        || 'and     ph.nr_prescricao = :nr_prescricao_p ';

				ds_bind_cCursor_w := sql_pck.bind_variable(':nr_prescricao_p', nr_prescricao_p, ds_bind_cCursor_w);
				ds_bind_cCursor_w := sql_pck.bind_variable(':nr_seq_item_presc_p', nr_seq_item_presc_p, ds_bind_cCursor_w);

			ELSE
				ds_sql_cursor_w := null;
		END CASE case_type;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mipres_item_data_pck.set_item_prescription () FROM PUBLIC;
