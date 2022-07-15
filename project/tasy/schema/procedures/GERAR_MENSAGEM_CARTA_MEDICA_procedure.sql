-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_mensagem_carta_medica ( nr_seq_carta_p bigint, nm_usuario_p text, ds_mensagem_p text, nm_destinatario_p text) AS $body$
DECLARE


nr_sequencia_w			carta_comunicacao.nr_sequencia%type;


BEGIN

select	nextval('carta_comunicacao_seq')
into STRICT	nr_sequencia_w
;

insert	into carta_comunicacao(
								DS_MENSAGEM,
								DT_ATUALIZACAO,
								DT_ATUALIZACAO_NREC,
								IE_LEITURA,
								NM_USUARIO,
								NM_USUARIO_NREC,
								NR_SEQ_CARTA,
								NR_SEQUENCIA,
								NM_DESTINATARIO,
								DT_LIBERACAO)
				values (
					ds_mensagem_p,
					clock_timestamp(),
					clock_timestamp(),
					'N',
					nm_usuario_p,
					nm_usuario_p,
					nr_seq_carta_p,
					nr_sequencia_w,
					nm_destinatario_p,
					clock_timestamp());

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_mensagem_carta_medica ( nr_seq_carta_p bigint, nm_usuario_p text, ds_mensagem_p text, nm_destinatario_p text) FROM PUBLIC;

