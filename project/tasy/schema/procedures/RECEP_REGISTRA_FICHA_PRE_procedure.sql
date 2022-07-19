-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE recep_registra_ficha_pre ( cd_pessoa_fisica_p bigint, cd_recepcao_p bigint, cd_setor_atendimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, cd_empresa_p bigint, nr_seq_ficha_p INOUT bigint) AS $body$
BEGIN



if ((cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '')
	and (cd_recepcao_p IS NOT NULL AND cd_recepcao_p::text <> '')
	and (cd_setor_atendimento_p IS NOT NULL AND cd_setor_atendimento_p::text <> '')) then
	begin


	select 	nextval('recep_ficha_pre_seq')
	into STRICT 	nr_seq_ficha_p
	;

	insert into RECEP_FICHA_PRE(NR_SEQUENCIA,
		DT_ATUALIZACAO,
		CD_ESTABELECIMENTO,
		CD_SETOR_ATENDIMENTO,
		NM_USUARIO,
		CD_EMPRESA,
		CD_PESSOA_FISICA,
		CD_RECEPCAO,
		DT_PRE_RECEPCAO,
		IE_STATUS,
		IE_PAC_RECEPCAO,
		DT_ATUALIZACAO_NREC,
		NM_USUARIO_NREC)
	values (
		nr_seq_ficha_p,
		clock_timestamp(),
		cd_estabelecimento_p,
		cd_setor_atendimento_p,
		nm_usuario_p,
		cd_empresa_p,
		cd_pessoa_fisica_p,
		cd_recepcao_p,
		clock_timestamp(),
		1,
		'N',
		clock_timestamp(),
		nm_usuario_p);
	end;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE recep_registra_ficha_pre ( cd_pessoa_fisica_p bigint, cd_recepcao_p bigint, cd_setor_atendimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, cd_empresa_p bigint, nr_seq_ficha_p INOUT bigint) FROM PUBLIC;

