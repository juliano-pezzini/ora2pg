-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE com_import_faq ( ds_pergunta_p text, nr_seq_tipo_p bigint, dt_pergunta_p timestamp, ds_palavra_chave_p text, ds_resposta_p text, nm_usuario_p text ) AS $body$
BEGIN
/*
This procedure does not have an commit, because it will be commited all at once
in the file ImportFaqAction.java, at tasy-backend repository.
*/
if (	(nr_seq_tipo_p IS NOT NULL AND nr_seq_tipo_p::text <> '')
	and	(nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '')
	and	(ds_pergunta_p IS NOT NULL AND ds_pergunta_p::text <> '')) then
	begin

	insert into com_faq(
		nr_sequencia,
		dt_pergunta,
		ds_pergunta,
		ds_resposta,
		nr_seq_tipo,
		ds_palavra_chave,
		dt_atualizacao_nrec,
		dt_atualizacao,
		nm_usuario_nrec,
		nm_usuario,
		ie_situacao)
	values (nextval('com_faq_seq'),
		dt_pergunta_p,
		substr(ds_pergunta_p, 1, 255),
		substr(ds_resposta_p, 1, 4000),
		nr_seq_tipo_p,
		substr(ds_palavra_chave_p, 1, 255),
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		nm_usuario_p,
		'A');
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE com_import_faq ( ds_pergunta_p text, nr_seq_tipo_p bigint, dt_pergunta_p timestamp, ds_palavra_chave_p text, ds_resposta_p text, nm_usuario_p text ) FROM PUBLIC;
