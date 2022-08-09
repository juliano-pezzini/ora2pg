-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gravar_atendimento_portal ( nr_seq_atendimento_p bigint, nr_seq_evento_p bigint, nm_usuario_envio_p text, dt_envio_p timestamp, ds_mensagem_p text, ds_jid_usuario_envio_p text, ds_jid_consulta_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_atendimento_w	bigint;


BEGIN

nr_seq_atendimento_w	:= nr_seq_atendimento_p;

if (coalesce(nr_seq_atendimento_w::text, '') = '' and (ds_jid_consulta_p IS NOT NULL AND ds_jid_consulta_p::text <> '')) then
	select	max(nr_seq_atendimento)
	into STRICT	nr_seq_atendimento_w
	from	pls_atendimento_chat
	where	ds_jid_usuario_envio = ds_jid_consulta_p;
end if;

if (nr_seq_atendimento_w IS NOT NULL AND nr_seq_atendimento_w::text <> '') then
	insert into pls_atendimento_chat(
		nr_sequencia, dt_atualizacao, nm_usuario,
		dt_atualizacao_nrec, nm_usuario_nrec, ds_mensagem,
		ie_status_atendimento, nr_seq_atendimento, nr_seq_solicitacao,
		dt_envio_mensagem, nm_usuario_envio, ds_jid_usuario_envio)
	values (	nextval('pls_atendimento_chat_seq'), clock_timestamp(), nm_usuario_p,
		clock_timestamp(), nm_usuario_p, ds_mensagem_p,
		'A', nr_seq_atendimento_w, null,
		dt_envio_p, nm_usuario_envio_p, ds_jid_usuario_envio_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gravar_atendimento_portal ( nr_seq_atendimento_p bigint, nr_seq_evento_p bigint, nm_usuario_envio_p text, dt_envio_p timestamp, ds_mensagem_p text, ds_jid_usuario_envio_p text, ds_jid_consulta_p text, nm_usuario_p text) FROM PUBLIC;
