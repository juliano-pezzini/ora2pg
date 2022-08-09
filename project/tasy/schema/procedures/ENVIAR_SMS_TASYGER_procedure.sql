-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_sms_tasyger ( ds_remetente_p text, ds_destinatario_p text, ds_mensagem_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w	bigint;
id_sms_w		bigint;

BEGIN
if (ds_remetente_p IS NOT NULL AND ds_remetente_p::text <> '') and (ds_destinatario_p IS NOT NULL AND ds_destinatario_p::text <> '') and (ds_mensagem_p IS NOT NULL AND ds_mensagem_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	/* enviar sms */

	id_sms_w := wheb_sms.enviar_sms(ds_remetente_p, ds_destinatario_p, ds_mensagem_p, nm_usuario_p, id_sms_w);

	/* gravar log */

	CALL Gravar_log_erro_tasyger('SMS','Envio SMS. Aviso falta memória ' || ds_destinatario_p, nm_usuario_p);


end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_sms_tasyger ( ds_remetente_p text, ds_destinatario_p text, ds_mensagem_p text, nm_usuario_p text) FROM PUBLIC;
