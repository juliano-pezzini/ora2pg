-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pep_gerar_resumo_pck.gerar_pep_resumo_recomend () AS $body$
DECLARE

	
	ds_tipo_recomendacao_w		varchar(255);
	ds_observacao_w			varchar(255);
	
	C01 CURSOR FOR
	SELECT	substr(coalesce(b.ds_tipo_recomendacao,ds_recomendacao),1,255),
		substr(a.ds_recomendacao,1,255)
	FROM protocolo_medic_rec a
LEFT OUTER JOIN tipo_recomendacao b ON (a.cd_recomendacao = b.cd_tipo_recomendacao)
WHERE a.cd_protocolo		= cd_protocolo_w and a.nr_sequencia 		= nr_seq_medicacao_w;
	
	
BEGIN
	
	PERFORM set_config('pep_gerar_resumo_pck.ds_resumo_w', '', false);
	open C01;
	loop
	fetch C01 into	
		ds_tipo_recomendacao_w,
		ds_observacao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (current_setting('pep_gerar_resumo_pck.ie_rtf_w')::varchar(1) = 'N') then
		
			PERFORM set_config('pep_gerar_resumo_pck.ds_resumo_w', substr(current_setting('pep_gerar_resumo_pck.ds_resumo_w')::text ||
					pep_gerar_resumo_pck.get_tr_html(ds_tipo_recomendacao_w, null, null, 
							null, null, null,2),1,30000), false);
							
			if (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') then
				PERFORM set_config('pep_gerar_resumo_pck.ds_resumo_w', substr(current_setting('pep_gerar_resumo_pck.ds_resumo_w')::text || pep_gerar_resumo_pck.get_tr_html_obs(ds_observacao_w),1,30000), false);
			end if;
							
		else
			PERFORM set_config('pep_gerar_resumo_pck.ds_resumo_w', substr(current_setting('pep_gerar_resumo_pck.ds_resumo_w')::text ||
					pep_gerar_resumo_pck.get_tr_rtf(ds_tipo_recomendacao_w, null, null, 
							null, null, null,2),1,30000), false);

		end if;
		
		end;
	end loop;
	close C01;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pep_gerar_resumo_pck.gerar_pep_resumo_recomend () FROM PUBLIC;
