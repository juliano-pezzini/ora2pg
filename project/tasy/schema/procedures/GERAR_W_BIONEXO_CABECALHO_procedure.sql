-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_bionexo_cabecalho ( dt_vencimento_p text, hr_vencimento_p text, nr_pdc_p text, nr_requisicao_p text, nm_usuario_p text, nr_seq_cabecalho_p INOUT text) AS $body$
DECLARE



nr_seq_cabecalho_w	bigint;



BEGIN
--Criada por apapandini OS 613017
select	nextval('w_bionexo_cabecalho_seq')
into STRICT	nr_seq_cabecalho_w
;

insert into w_bionexo_cabecalho(
	dt_atualizacao,
	dt_atualizacao_nrec,
	dt_vencimento,
	hr_vencimento,
	nm_usuario,
	nm_usuario_nrec,
	nr_pdc,
	nr_requisicao,
	nr_sequencia  )
values (	clock_timestamp(),
	clock_timestamp(),
	to_date(dt_vencimento_p, 'dd/mm/yyyy'),
	to_date(hr_vencimento_p, 'hh24:mi'),
	nm_usuario_p,
	nm_usuario_p,
	nr_pdc_p,
	nr_requisicao_p,
	nr_seq_cabecalho_w);

nr_seq_cabecalho_p := nr_seq_cabecalho_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_bionexo_cabecalho ( dt_vencimento_p text, hr_vencimento_p text, nr_pdc_p text, nr_requisicao_p text, nm_usuario_p text, nr_seq_cabecalho_p INOUT text) FROM PUBLIC;

