-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desvincular_titulo_receber ( nr_titulo_p bigint, nr_contrato_p bigint, ds_justificativa_p text, nm_usuario_p text) AS $body$
BEGIN

update	titulo_receber
set		nr_seq_contrato  = NULL
where	nr_titulo =	nr_titulo_p;

update	titulo_receber_classif
set		nr_seq_contrato  = NULL
where	nr_titulo =	nr_titulo_p;

insert into	titulo_receber_hist(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_titulo,
			dt_historico,
			ds_historico,
			dt_liberacao)
values (nextval('titulo_receber_hist_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_titulo_p,
			clock_timestamp(),
			wheb_mensagem_pck.get_texto(374416, 'NR_CONTRATO=' || nr_contrato_p || ';DS_JUSTIFICATIVA=' || ds_justificativa_p),
			clock_timestamp());

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desvincular_titulo_receber ( nr_titulo_p bigint, nr_contrato_p bigint, ds_justificativa_p text, nm_usuario_p text) FROM PUBLIC;

