-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pep_gerar_resumo_pck.gerar_pep_desc_protocolo (ie_rtf_html_p text default '') AS $body$
DECLARE


	ds_desc_protocolo_w		text;
	nr_seq_conversao_w		bigint;
	qt_reg_w				bigint;

	
BEGIN
	
	PERFORM set_config('pep_gerar_resumo_pck.ds_resumo_w', '', false);

	Select count(*)
	into STRICT   qt_reg_w
	from   protocolo
	where  cd_protocolo	= current_setting('pep_gerar_resumo_pck.cd_protocolo_w')::bigint
	and	   (ds_protocolo IS NOT NULL AND ds_protocolo::text <> '');
	
	if (qt_reg_w > 0) then
	






		qt_reg_w := 0;
	
		if (ie_rtf_html_p = 'HTML5') then
			Select ds_protocolo
			into STRICT   ds_desc_protocolo_w 
			from   protocolo 
			where  cd_protocolo = current_setting('pep_gerar_resumo_pck.cd_protocolo_w')::bigint;
			
			qt_reg_w := DBMS_LOB.position('<html' in ds_desc_protocolo_w);
		end if;
		
		if (qt_reg_w <= 0) then
			CONVERTE_RTF_HTML('Select ds_protocolo from protocolo where cd_protocolo = :nr', current_setting('pep_gerar_resumo_pck.cd_protocolo_w')::bigint, current_setting('pep_gerar_resumo_pck.nm_usuario_w')::varchar(255), nr_seq_conversao_w);	
		
			select  ds_texto
			into STRICT	ds_desc_protocolo_w
			from 	TASY_CONVERSAO_RTF
			where	nr_sequencia = nr_seq_conversao_w;
		end if;
		
		if (ds_desc_protocolo_w IS NOT NULL AND ds_desc_protocolo_w::text <> '') then
		
			if (current_setting('pep_gerar_resumo_pck.ie_rtf_w')::varchar(1) = 'N') then		
				PERFORM set_config('pep_gerar_resumo_pck.ds_resumo_w', substr(pep_gerar_resumo_pck.get_tr_html_desc_protocolo(ds_desc_protocolo_w),1,30000), false);									
			else
				PERFORM set_config('pep_gerar_resumo_pck.ds_resumo_w', substr(pep_gerar_resumo_pck.get_tr_rtf(substr(ds_desc_protocolo_w,1,30000), null, null, null, null, null,1),1,30000), false);							
			end if;
					
		end if;
		
	end if;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pep_gerar_resumo_pck.gerar_pep_desc_protocolo (ie_rtf_html_p text default '') FROM PUBLIC;
