-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lote_ent_enviar_sms_busca_at ( ds_remetente_p text, ds_destinatario_p text, ds_mensagem_p text, nr_seq_recon_cont_p bigint, nr_seq_reconvocado_p bigint, nr_seq_status_atual_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w	bigint;
id_sms_w		bigint;


BEGIN
if (ds_remetente_p IS NOT NULL AND ds_remetente_p::text <> '') and (ds_destinatario_p IS NOT NULL AND ds_destinatario_p::text <> '') and (ds_mensagem_p IS NOT NULL AND ds_mensagem_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	/* enviar sms */

	id_sms_w := wheb_sms.enviar_sms(ds_remetente_p, ds_destinatario_p, ds_mensagem_p, nm_usuario_p, id_sms_w);

	/* gravar log */

	select	nextval('log_envio_sms_seq')
	into STRICT	nr_sequencia_w
	;

	insert into log_envio_sms(
		nr_sequencia,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		dt_atualizacao,
		nm_usuario,
		dt_envio,
		nr_telefone,
		ds_mensagem,
		id_sms
	) values (
		nr_sequencia_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		ds_destinatario_p,
		ds_mensagem_p,
		id_sms_w
	);

	insert into LOTE_ENT_REC_CONT_HIST(
		DT_ATUALIZACAO,
		DT_ATUALIZACAO_NREC,
		NM_USUARIO,
		NM_USUARIO_NREC,
		NR_SEQ_RECON_CONT,
		NR_SEQ_RECONVOCADO,
		NR_SEQUENCIA,
		NR_SEQ_STATUS_ATUAL,
		DS_OBSERVACAO
	) values (
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		nm_usuario_p,
		nr_seq_recon_cont_p,
		nr_seq_reconvocado_p,
		nextval('lote_ent_rec_cont_hist_seq'),
		nr_seq_status_atual_p,
		substr(wheb_mensagem_pck.get_texto(805146,'DS_DESTINATARIO='||ds_destinatario_p||';'),1,2000)
	);

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lote_ent_enviar_sms_busca_at ( ds_remetente_p text, ds_destinatario_p text, ds_mensagem_p text, nr_seq_recon_cont_p bigint, nr_seq_reconvocado_p bigint, nr_seq_status_atual_p bigint, nm_usuario_p text) FROM PUBLIC;
