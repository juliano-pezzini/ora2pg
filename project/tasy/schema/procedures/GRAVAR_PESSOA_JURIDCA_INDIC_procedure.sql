-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_pessoa_juridca_indic ( nr_atendimento_p bigint, nr_seq_indicacao_p bigint, cd_medico_p text, cd_pessoa_fisica_p text, cd_cgc_indicacao_p text, ie_opcao_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ds_observacao_p text default null) AS $body$
BEGIN
 
if (coalesce(nr_atendimento_p,0) > 0) and (ie_opcao_p = 'J') then 
	 
	update atendimento_paciente 
	set cd_pessoa_juridica_indic = cd_cgc_indicacao_p 
	where nr_atendimento = nr_atendimento_p;
	 
end if;
CALL gravar_indicacao_transferencia(nr_atendimento_p, nr_seq_indicacao_p, cd_medico_p, 
				cd_pessoa_fisica_p, cd_cgc_indicacao_p, ie_opcao_p, 
				cd_estabelecimento_p, nm_usuario_p, null, ds_observacao_p);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_pessoa_juridca_indic ( nr_atendimento_p bigint, nr_seq_indicacao_p bigint, cd_medico_p text, cd_pessoa_fisica_p text, cd_cgc_indicacao_p text, ie_opcao_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ds_observacao_p text default null) FROM PUBLIC;

