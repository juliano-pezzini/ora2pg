-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_mensagem_tit_rec ( nr_titulo_p bigint, ds_mensagem_p text, ie_acao_mensagem_p text, nm_usuario_p text, ie_commit_p text default 'S') AS $body$
DECLARE


nr_seq_tipo_w	tipo_mensagem_tit_rec.nr_sequencia%type;


BEGIN

select	max(a.nr_sequencia)
into STRICT 	nr_seq_tipo_w
from 	tipo_mensagem_tit_rec a
where 	a.ie_acao_mensagem 	= ie_acao_mensagem_p;

if (coalesce(ie_acao_mensagem_p::text, '') = '') or (nr_seq_tipo_w IS NOT NULL AND nr_seq_tipo_w::text <> '') then

	insert	into titulo_receber_mensagem(nr_sequencia,
		dt_atualizacao,
		ds_mensagem,
		nm_usuario,
		nr_titulo,
		nr_seq_tipo)
	values (nextval('titulo_receber_mensagem_seq'),
		clock_timestamp(),
		ds_mensagem_p,
		nm_usuario_p,
		nr_titulo_p,
		nr_seq_tipo_w);

end if;

if (coalesce(ie_commit_p,'S')	= 'S') then

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_mensagem_tit_rec ( nr_titulo_p bigint, ds_mensagem_p text, ie_acao_mensagem_p text, nm_usuario_p text, ie_commit_p text default 'S') FROM PUBLIC;

