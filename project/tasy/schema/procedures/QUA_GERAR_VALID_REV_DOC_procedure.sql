-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qua_gerar_valid_rev_doc ( nr_seq_revisao_p bigint, cd_pessoa_validacao_p text, nm_usuario_p text) AS $body$
DECLARE


qt_existe_w	integer;


BEGIN

if (coalesce(nr_seq_revisao_p,0) > 0) and (cd_pessoa_validacao_p IS NOT NULL AND cd_pessoa_validacao_p::text <> '') then
	select	count(*)
	into STRICT	qt_existe_w
	from	qua_doc_revisao_validacao
	where	nr_seq_doc_revisao	= nr_seq_revisao_p
	and	cd_pessoa_validacao	= cd_pessoa_validacao_p;

	if (qt_existe_w = 0) then
		insert into qua_doc_revisao_validacao(
			nr_sequencia,
			nr_seq_doc_revisao,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			cd_pessoa_validacao,
			dt_validacao)
		values (	nextval('qua_doc_revisao_validacao_seq'),
			nr_seq_revisao_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			cd_pessoa_validacao_p,
			null);
		commit;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qua_gerar_valid_rev_doc ( nr_seq_revisao_p bigint, cd_pessoa_validacao_p text, nm_usuario_p text) FROM PUBLIC;

