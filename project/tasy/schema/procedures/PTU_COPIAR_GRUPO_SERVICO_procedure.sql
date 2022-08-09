-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_copiar_grupo_servico ( nr_seq_versao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
BEGIN
insert into	ptu_versao_tabela( dt_atualizacao, dt_atualizacao_nrec, ie_situacao,
				    nm_usuario, nm_usuario_nrec, nr_seq_grupo_servico,
				    nr_sequencia, nr_seq_versao)
		SELECT		 clock_timestamp(), clock_timestamp(), a.ie_situacao,
				 nm_usuario_p, nm_usuario_p, a.cd_grupo_servico,
				 nextval('ptu_versao_tabela_seq'), nr_seq_versao_p
		from		ptu_grupo_servico a
		where		cd_estabelecimento = cd_estabelecimento_p
		and		not exists (	SELECT 1
							from	ptu_versao_tabela x
							where	x.nr_seq_grupo_servico = a.cd_grupo_servico
							and	x.nr_seq_versao	= nr_seq_versao_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_copiar_grupo_servico ( nr_seq_versao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
