-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_conta_contab_pf ( cd_pessoa_fisica_p text, cd_empresa_p bigint, cd_conta_contabil_pag_p text, cd_conta_contabil_receb_p text, nm_usuario_p text) AS $body$
DECLARE


ds_erro_W		varchar(4000);
qt_w			bigint;

BEGIN

select	count(*)
into STRICT	qt_w
from	pessoa_fisica
where	cd_pessoa_fisica = cd_pessoa_fisica_p;

if (qt_w > 0) then

	if (cd_conta_contabil_pag_p IS NOT NULL AND cd_conta_contabil_pag_p::text <> '') then
		begin

		insert into pessoa_fisica_conta_ctb(
			nr_sequencia,
			cd_pessoa_fisica,
			cd_conta_contabil,
			cd_empresa,
			dt_atualizacao,
			nm_usuario,
			ie_tipo_conta,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			dt_inicio_vigencia,
			dt_fim_vigencia)
		values (	nextval('pessoa_fisica_conta_ctb_seq'),
			cd_pessoa_fisica_p,
			cd_conta_contabil_pag_p,
			cd_empresa_p,
			clock_timestamp(),
			nm_usuario_p,
			'P',
			clock_timestamp(),
			nm_usuario_p,
			null,
			null);

		exception when others then
			ds_erro_w := sqlerrm(SQLSTATE);
			CALL wheb_mensagem_pck.exibir_mensagem_abort(183208,'DS_ERRO_P='|| ds_Erro_W);
		end;
	end if;
	if (cd_conta_contabil_receb_p IS NOT NULL AND cd_conta_contabil_receb_p::text <> '') then
		begin
		insert into pessoa_fisica_conta_ctb(
			nr_sequencia,
			cd_pessoa_fisica,
			cd_conta_contabil,
			cd_empresa,
			dt_atualizacao,
			nm_usuario,
			ie_tipo_conta,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			dt_inicio_vigencia,
			dt_fim_vigencia)
		values (	nextval('pessoa_fisica_conta_ctb_seq'),
			cd_pessoa_fisica_p,
			cd_conta_contabil_receb_p,
			cd_empresa_p,
			clock_timestamp(),
			nm_usuario_p,
			'R',
			clock_timestamp(),
			nm_usuario_p,
			null,
			null);

		exception when others then
			ds_erro_w := sqlerrm(SQLSTATE);
			CALL wheb_mensagem_pck.exibir_mensagem_abort(183208,'DS_ERRO_P='|| ds_Erro_W);
		end;
	end if;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_conta_contab_pf ( cd_pessoa_fisica_p text, cd_empresa_p bigint, cd_conta_contabil_pag_p text, cd_conta_contabil_receb_p text, nm_usuario_p text) FROM PUBLIC;
