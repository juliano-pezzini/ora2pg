-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_susp_item_prescr_js ( nr_prescricao_p bigint, nr_sequencia_p bigint, nm_tabela_p text, ie_exame_p text, cd_estabelecimento_p bigint, ie_exige_mot_susp_p text, nm_proc_integracao_p text, ds_erro_p INOUT text, nm_usuario_p text) AS $body$
DECLARE

 
ds_erro_w		varchar(255);
ie_consistencia_w	varchar(5);


BEGIN 
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	begin 
	ie_consistencia_w := consiste_supensao_prescr( 
		nr_prescricao_p, nr_sequencia_p, nm_tabela_p, ie_exame_p, cd_estabelecimento_p, ie_consistencia_w, nm_usuario_p, Obter_perfil_Ativo);
 
	if (ie_exige_mot_susp_p <> 'S') then 
		begin 
		 
		CALL suspender_item_prescricao( 
			nr_prescricao_p, 
			nr_sequencia_p, 
			0, 
			null, 
			nm_tabela_p, 
			nm_usuario_p, 
			'S', 
			924);
 
		if (nm_proc_integracao_p <> '') then 
			begin 
			begin 
			CALL exec_sql_dinamico('PROC_INTEG','begin ' || nm_proc_integracao_p || '('|| nr_prescricao_p || ',' || chr(39) || '2' || chr(39) ||'); end;');
			exception 
				when others then 
				ds_erro_w := substr(obter_texto_dic_objeto(76164, wheb_usuario_pck.get_nr_seq_idioma, null),1,255);
			end;
			end;
		end if;
		end;
	end if;
	end;
end if;
commit;
ds_erro_p	:= ds_erro_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_susp_item_prescr_js ( nr_prescricao_p bigint, nr_sequencia_p bigint, nm_tabela_p text, ie_exame_p text, cd_estabelecimento_p bigint, ie_exige_mot_susp_p text, nm_proc_integracao_p text, ds_erro_p INOUT text, nm_usuario_p text) FROM PUBLIC;
