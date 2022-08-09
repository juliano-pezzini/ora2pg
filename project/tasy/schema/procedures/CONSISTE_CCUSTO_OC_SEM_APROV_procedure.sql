-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_ccusto_oc_sem_aprov ( cd_centro_custo_p bigint, cd_local_estoque_p bigint, cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint, ie_urgente_p text, ds_erro_p INOUT text) AS $body$
DECLARE

 
 
cd_processo_Aprov_w	bigint;
ds_erro_w		varchar(255) := '';

 

BEGIN 
 
cd_processo_Aprov_w := obter_processo_aprov_sem_mat( 
		cd_centro_custo_p, cd_setor_atendimento_p, cd_local_estoque_p, 'O', ie_urgente_p, cd_estabelecimento_p, null, null, null, cd_processo_Aprov_w);
 
if (coalesce(cd_processo_aprov_w,0) = 0) then 
	ds_erro_w := 	WHEB_MENSAGEM_PCK.get_texto(277338);
end if;
 
ds_erro_p := ds_erro_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_ccusto_oc_sem_aprov ( cd_centro_custo_p bigint, cd_local_estoque_p bigint, cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint, ie_urgente_p text, ds_erro_p INOUT text) FROM PUBLIC;
