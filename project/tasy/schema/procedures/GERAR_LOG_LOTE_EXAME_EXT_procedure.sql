-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_log_lote_exame_ext ( nr_seq_lote_p bigint, nr_prescricao_p bigint, nr_seq_prescr_p bigint, nm_usuario_p text, ie_opcao_p text) AS $body$
DECLARE


ds_evento_w	varchar(255);

/*
ie_opcao:
E - Enviar
TR - Tirar data de retorno
TE - Tirar data de envio
I - Importar arquivo
F - Fechar lote
TX - Tirar exame do Lote
*/
BEGIN

if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') and (ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '') then

	if (ie_opcao_p = 'E') 	then
		ds_evento_w := wheb_mensagem_pck.get_texto(307847); -- Lote enviado
	elsif (ie_opcao_p = 'TR')	then
		ds_evento_w := wheb_mensagem_pck.get_texto(307848); -- Retirada data de retorno
	elsif (ie_opcao_p = 'TE') 	then
		ds_evento_w := wheb_mensagem_pck.get_texto(307849); -- Retirada data de envio
	elsif (ie_opcao_p = 'I') 	then
		ds_evento_w := wheb_mensagem_pck.get_texto(307850); -- Importado arquivo
	elsif (ie_opcao_p = 'F')	then
		ds_evento_w := wheb_mensagem_pck.get_texto(307851); -- Lote fechado
	elsif (ie_opcao_p = 'TX')	then
		ds_evento_w := wheb_mensagem_pck.get_texto(307852); -- Retirada de exame do lote
	end if;

	insert into lab_lote_externo_log(
		nr_seq_lote,
		nr_sequencia,
		ds_evento,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_prescricao,
		nr_seq_prescr
		) values (
		nr_seq_lote_p,
		nextval('lab_lote_externo_log_seq'),
		ds_evento_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_prescricao_p,
		nr_seq_prescr_p);

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_log_lote_exame_ext ( nr_seq_lote_p bigint, nr_prescricao_p bigint, nr_seq_prescr_p bigint, nm_usuario_p text, ie_opcao_p text) FROM PUBLIC;

