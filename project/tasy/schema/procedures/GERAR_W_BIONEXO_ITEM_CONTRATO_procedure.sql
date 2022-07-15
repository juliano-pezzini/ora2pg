-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_bionexo_item_contrato ( nr_contrato_p text, nr_seq_item_p text, nm_usuario_p text) AS $body$
DECLARE



nr_sequencia_w	bigint;



BEGIN
--apapandini OS613017
select	nextval('w_bionexo_item_contrato_seq')
into STRICT	nr_sequencia_w
;


insert into w_bionexo_item_contrato(
			nr_contrato,
			nr_seq_item,
			nr_sequencia,
			nm_usuario,
			nm_usuario_nrec,
			dt_atualizacao,
			dt_atualizacao_nrec    )
values (	nr_contrato_p,
	nr_seq_item_p,
	nr_sequencia_w,
	nm_usuario_p,
	nm_usuario_p,
	clock_timestamp(),
	clock_timestamp());

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_bionexo_item_contrato ( nr_contrato_p text, nr_seq_item_p text, nm_usuario_p text) FROM PUBLIC;

