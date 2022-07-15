-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_hcm_message ( ds_conteudo_p text) AS $body$
DECLARE



nr_seq_mensagem_w		bigint;
ds_conteudo_w			varchar(32000);


BEGIN

	ds_conteudo_w	:=	replace(ds_conteudo_p, chr(13), null);

	select	nextval('hcm_message_seq')
	into STRICT	nr_seq_mensagem_w
	;

	insert into hcm_message(
		nr_sequencia,
		ds_conteudo,
		ie_status,
		dt_atualizacao,
		nm_usuario)
	values (	nr_seq_mensagem_w,
		ds_conteudo_w,
		'P',
		clock_timestamp(),
		'INTPDTASY');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_hcm_message ( ds_conteudo_p text) FROM PUBLIC;

