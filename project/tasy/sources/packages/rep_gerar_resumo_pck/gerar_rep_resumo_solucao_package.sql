-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE rep_gerar_resumo_pck.gerar_rep_resumo_solucao () AS $body$
DECLARE

	
	ds_solucao_w		varchar(255);
	nr_seq_solucao_w	integer;
	ds_material_w		varchar(400);
	ds_unidade_medida_w	varchar(30);
	qt_dose_w		double precision;
	ds_componentes_w	varchar(30000);
	ie_susp_sol_w		varchar(1);
	ie_susp_comp_w		varchar(1);
	ds_horarios_w		varchar(2000);
	ds_justificativa_w	varchar(255);
	ds_observacao_w		varchar(255);
	ds_dose_w			varchar(255);

	C01 CURSOR FOR
	SELECT	substr(obter_desc_volume_solucao(nr_prescricao, nr_seq_solucao),1,255),
		nr_seq_solucao,
		ie_suspenso,
		ds_horarios
	from	prescr_solucao
	where	nr_prescricao	= nr_prescricao_w
	and	coalesce(ie_hemodialise,'N') = 'N';
	
	C02 CURSOR FOR
	SELECT	b.ds_material,
		--substr(obter_desc_unid_med(a.cd_unidade_medida_dose),1,60),

		a.cd_unidade_medida_dose,
		a.qt_dose,
		a.ie_suspenso,
		substr(a.ds_observacao,1,255),
		substr(a.ds_justificativa,1,255)
	from	material b,
		prescr_material a
	where	a.cd_material		= b.cd_material
	and	a.nr_prescricao		= nr_prescricao_w
	and	a.nr_sequencia_solucao	= nr_seq_solucao_w;
	
	
BEGIN
	PERFORM set_config('rep_gerar_resumo_pck.ds_resumo_w', '', false);
	open C01;
	loop
	fetch C01 into	
		ds_solucao_w,
		nr_seq_solucao_w,
		ie_susp_sol_w,
		ds_horarios_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		
		if (current_setting('rep_gerar_resumo_pck.ie_rtf_w')::varchar(1) = 'N') then
			ds_componentes_w := '<table align="right" width="90%" border="0" cellpadding="2" cellspacing="0" >'	;
		end if;
		
		open C02;
		loop
		fetch C02 into	
			ds_material_w,
			ds_unidade_medida_w,
			qt_dose_w,
			ie_susp_comp_w,
			ds_observacao_w,
			ds_justificativa_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin

			ds_dose_w := to_char(qt_dose_w);

			if (qt_dose_w < 1) then
				ds_dose_w := '0' || to_char(qt_dose_w);
			end if;

			if (current_setting('rep_gerar_resumo_pck.ie_rtf_w')::varchar(1) = 'N') then
				ds_componentes_w	:= substr(ds_componentes_w ||
							rep_gerar_resumo_pck.get_tr_html(ds_dose_w||' '|| ds_unidade_medida_W || ' - ' ||ds_material_w,
								null,null,null,null,null,null,ie_susp_comp_w,3),1,30000);	
								
				if (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') then
					ds_componentes_w := substr(ds_componentes_w || rep_gerar_resumo_pck.get_tr_html_obs(ds_observacao_w),1,30000);
				end if;
			
				if (ds_justificativa_w IS NOT NULL AND ds_justificativa_w::text <> '') then
					ds_componentes_w := substr(ds_componentes_w || rep_gerar_resumo_pck.get_tr_html_justif(ds_justificativa_w),1,30000);
				end if;
				
			else
				ds_componentes_w	:= substr(ds_componentes_w ||
							rep_gerar_resumo_pck.get_tr_rtf(ds_dose_w||' '|| ds_unidade_medida_W || ' - ' ||ds_material_w,
								    null,null,null,null,null,null,3),1,30000);	
			end if;
			/*ds_resumo_w	:= ds_resumo_w || 
					' ' || to_char(qt_dose_w) ||' '|| ds_unidade_medida_w ||
					' ' || ds_material_w ||
					chr(13) || chr(10);*/

			end;
		end loop;
		close C02;
		
		if (current_setting('rep_gerar_resumo_pck.ie_rtf_w')::varchar(1) = 'N') then		
			ds_componentes_w := ds_componentes_w||'</table>';
		

			PERFORM set_config('rep_gerar_resumo_pck.ds_resumo_w', substr(current_setting('rep_gerar_resumo_pck.ds_resumo_w')::text ||
					rep_gerar_resumo_pck.get_tr_html(ds_solucao_w,ds_horarios_w,null,null,null,null,null,ie_susp_sol_w, 2)||
					rep_gerar_resumo_pck.get_tr_html(ds_componentes_w,null,null,null,null,null,null,null,1),1,30000), false);
		else
			PERFORM set_config('rep_gerar_resumo_pck.ds_resumo_w', substr(current_setting('rep_gerar_resumo_pck.ds_resumo_w')::text ||
					rep_gerar_resumo_pck.get_tr_rtf(ds_solucao_w,ds_horarios_w,null,null,null,null,null, 2)||
					rep_gerar_resumo_pck.get_tr_rtf(ds_componentes_w,null,null,null,null,null,null,1),1,30000), false);
		end if;
		end;
	end loop;
	close C01;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rep_gerar_resumo_pck.gerar_rep_resumo_solucao () FROM PUBLIC;