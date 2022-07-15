-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE interditar_leito ( cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, nr_seq_interno_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
BEGIN
 
if (cd_setor_atendimento_p IS NOT NULL AND cd_setor_atendimento_p::text <> '') and (cd_unidade_basica_p IS NOT NULL AND cd_unidade_basica_p::text <> '') and (cd_unidade_compl_p IS NOT NULL AND cd_unidade_compl_p::text <> '') and (nr_seq_interno_p IS NOT NULL AND nr_seq_interno_p::text <> '') then 
	begin 
	 
	update	unidade_atendimento 
	set	ie_status_unidade	= 'I', 
		nm_usuario		= nm_usuario_p, 
		dt_atualizacao		= clock_timestamp() 
	where	cd_unidade_basica	= cd_unidade_basica_p 
	and	cd_unidade_compl	= cd_unidade_compl_p 
	and	cd_setor_atendimento	= cd_setor_atendimento_p;
 
	CALL gerar_higienizacao_leito_unid(clock_timestamp(), nm_usuario_p, cd_estabelecimento_p, 'IL', nr_seq_interno_p, null);	
	 
	commit;
 
	end;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE interditar_leito ( cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, nr_seq_interno_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

