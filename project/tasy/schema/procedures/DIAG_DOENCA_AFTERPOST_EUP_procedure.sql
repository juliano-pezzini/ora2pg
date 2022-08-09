-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE diag_doenca_afterpost_eup ( nr_atendimento_p bigint, cd_doenca_p text, nr_seq_interno_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_tipo_diagnostico_p bigint, ie_classificacao_doenca_p text, ie_liberar_diagnostico_p text, ie_novo_p text, ds_msg_isolamento_p INOUT text) AS $body$
DECLARE

 
ie_isolamento_w	varchar(255);			
			 

BEGIN 
 
if (ie_tipo_diagnostico_p = 1) and (ie_classificacao_doenca_p = 'P') then 
 
	CALL atualizar_dias_inter_cid(nr_atendimento_p,cd_doenca_p,nr_seq_interno_p,cd_estabelecimento_p,nm_usuario_p);
end if;
 
select	substr(obter_tipo_isolamento_cid(cd_doenca_p,1),1,255) 
into STRICT	ie_isolamento_w
;
 
if (ie_isolamento_w IS NOT NULL AND ie_isolamento_w::text <> '') then 
	 
	ds_msg_isolamento_p := obter_texto_dic_objeto(68761, 1, 'ITEM=' || ie_isolamento_w);
end if;
 
if (coalesce(ie_liberar_diagnostico_p,'N') = 'S') then 
 
	CALL liberar_diagnostico_doenca(nm_usuario_p,nr_atendimento_p,nr_seq_interno_p);
end if;
 
if (coalesce(ie_novo_p,'N') = 'S') then 
 
	CALL gerar_ev_intern_diagnostico(nr_atendimento_p,nm_usuario_p);
 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE diag_doenca_afterpost_eup ( nr_atendimento_p bigint, cd_doenca_p text, nr_seq_interno_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_tipo_diagnostico_p bigint, ie_classificacao_doenca_p text, ie_liberar_diagnostico_p text, ie_novo_p text, ds_msg_isolamento_p INOUT text) FROM PUBLIC;
