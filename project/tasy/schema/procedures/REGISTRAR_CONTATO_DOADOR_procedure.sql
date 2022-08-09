-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE registrar_contato_doador ( cd_pessoa_fisica_p text, cd_estabelecimento_p bigint, ds_observacao_p text, nm_usuario_p text, ie_opcao_p text) AS $body$
DECLARE



nr_seq_tipo_doc_w	bigint;
nr_seq_forma_cont_w 	bigint;



BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then

	if (ie_opcao_p = 'S') then
		select	max(nr_seq_forma_contato_soro),
			max(nr_seq_tipo_doc_soro)
		into STRICT	nr_seq_forma_cont_w,
			nr_seq_tipo_doc_w
		from	san_parametro
		where	cd_estabelecimento = cd_estabelecimento_p;
	else
		select	max(nr_seq_forma_contato),
			max(nr_seq_tipo_doc)
		into STRICT	nr_seq_forma_cont_w,
			nr_seq_tipo_doc_w
		from	san_parametro
		where	cd_estabelecimento = cd_estabelecimento_p;
	end if;

	if (coalesce(nr_seq_tipo_doc_w::text, '') = '') then
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(257616);
	end if;

	insert into pessoa_fisica_contato(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			cd_pessoa_fisica,
			ie_tipo_contato,
			nr_seq_forma_cont,
			nr_seq_tipo_doc,
			dt_atualizacao_cad,
			ds_observacao,
			cd_estabelecimento)
		values (
			nextval('pessoa_fisica_contato_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			cd_pessoa_fisica_p,
			'P',
			nr_seq_forma_cont_w,
			nr_seq_tipo_doc_w,
			clock_timestamp(),
			ds_observacao_p,
			cd_estabelecimento_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE registrar_contato_doador ( cd_pessoa_fisica_p text, cd_estabelecimento_p bigint, ds_observacao_p text, nm_usuario_p text, ie_opcao_p text) FROM PUBLIC;
