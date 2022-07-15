-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_dep_proj_migr ( nr_seq_projeto_p bigint, nr_seq_atividade_p bigint, nr_seq_projeto_dep_p bigint, nr_seq_os_dep_p bigint, cd_funcao_dep_p bigint, ie_nivel_dependencia_p text, ds_observacao_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_projeto_w	bigint;
ie_dep_reg_w	varchar(1);


BEGIN
if (nr_seq_projeto_p IS NOT NULL AND nr_seq_projeto_p::text <> '') and
	((nr_seq_projeto_dep_p IS NOT NULL AND nr_seq_projeto_dep_p::text <> '') or (nr_seq_os_dep_p IS NOT NULL AND nr_seq_os_dep_p::text <> '') or (cd_funcao_dep_p IS NOT NULL AND cd_funcao_dep_p::text <> '')) and (ie_nivel_dependencia_p IS NOT NULL AND ie_nivel_dependencia_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_dep_reg_w
	from	proj_dependencia
	where	nr_seq_projeto = nr_seq_projeto_p
	and	(((coalesce(nr_seq_atividade_p::text, '') = '') and (coalesce(nr_seq_ativ_cron::text, '') = '')) or
		 (nr_seq_atividade_p IS NOT NULL AND nr_seq_atividade_p::text <> '' AND nr_seq_ativ_cron = nr_seq_atividade_p))
	and	(((coalesce(nr_seq_projeto_dep_p::text, '') = '') and (coalesce(nr_seq_proj_dep::text, '') = '')) or
		 (nr_seq_projeto_dep_p IS NOT NULL AND nr_seq_projeto_dep_p::text <> '' AND nr_seq_proj_dep = nr_seq_projeto_dep_p))
	and	(((coalesce(nr_seq_os_dep_p::text, '') = '') and (coalesce(nr_seq_ordem_serv::text, '') = '')) or
		 (nr_seq_os_dep_p IS NOT NULL AND nr_seq_os_dep_p::text <> '' AND nr_seq_ordem_serv = nr_seq_os_dep_p))
	and	(((coalesce(cd_funcao_dep_p::text, '') = '') and (coalesce(cd_funcao::text, '') = '')) or
		 (cd_funcao_dep_p IS NOT NULL AND cd_funcao_dep_p::text <> '' AND cd_funcao = cd_funcao_dep_p));

	if (ie_dep_reg_w = 'N') then
		begin
		insert into proj_dependencia(
			nr_sequencia,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			dt_atualizacao,
			nm_usuario,
			nr_seq_projeto,
			nr_seq_ativ_cron,
			nr_seq_ordem_serv,
			nr_seq_proj_dep,
			ie_nivel_dependencia,
			ie_status,
			cd_funcao,
			ds_observacao)
		values (
			nextval('proj_dependencia_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_projeto_p,
			nr_seq_atividade_p,
			nr_seq_os_dep_p,
			nr_seq_projeto_dep_p,
			ie_nivel_dependencia_p,
			'N',
			cd_funcao_dep_p,
			ds_observacao_p);
		end;
	else
		begin
		CALL wheb_mensagem_pck.exibir_mensagem_abort(282411);
		end;
	end if;
	end;
else
	begin
	CALL wheb_mensagem_pck.exibir_mensagem_abort(282412);
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_dep_proj_migr ( nr_seq_projeto_p bigint, nr_seq_atividade_p bigint, nr_seq_projeto_dep_p bigint, nr_seq_os_dep_p bigint, cd_funcao_dep_p bigint, ie_nivel_dependencia_p text, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;

