-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_enviar_sms_analise ( ds_remetente_p text, ds_destinatario_p text, ds_mensagem_p text, nr_seq_analise_p bigint, nm_usuario_p text) AS $body$
DECLARE


id_sms_w	bigint;

BEGIN
if (ds_remetente_p IS NOT NULL AND ds_remetente_p::text <> '') and (ds_destinatario_p IS NOT NULL AND ds_destinatario_p::text <> '') and (ds_mensagem_p IS NOT NULL AND ds_mensagem_p::text <> '') and (nr_seq_analise_p IS NOT NULL AND nr_seq_analise_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	/* enviar sms */

	id_sms_w := wheb_sms.enviar_sms(ds_remetente_p, ds_destinatario_p, ds_mensagem_p, nm_usuario_p, id_sms_w);

	/*insert into logxxxx_tasy(cd_log, dt_atualizacao, nm_usuario, ds_log)
		values (92222, sysdate, nm_usuario_p, 'Remetente = ' || ds_remetente_p || '  -  ' ||
						      'Destinatário = ' || ds_destinatario_p || '  -  ' ||
						      'Mensagem = ' || substr(ds_mensagem_p,1,1400));*/
	insert into LOG_ENVIO_SMS(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_envio,
		nr_telefone,
		ds_mensagem,
		nr_seq_analise,
		id_sms)
	values (nextval('log_envio_sms_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		ds_destinatario_p,
		ds_mensagem_p,
		nr_seq_analise_p,
		id_sms_w);

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_enviar_sms_analise ( ds_remetente_p text, ds_destinatario_p text, ds_mensagem_p text, nr_seq_analise_p bigint, nm_usuario_p text) FROM PUBLIC;

