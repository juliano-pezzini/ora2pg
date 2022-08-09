-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE grava_solic_compra_hist_envio ( nr_seq_historico_p bigint, ds_destinatario_p text, ds_observacao_p text, nm_usuario_p text) AS $body$
DECLARE


nr_solic_compra_w			bigint;

BEGIN

select	nr_solic_compra
into STRICT	nr_solic_compra_w
from	solic_compra_hist
where	nr_sequencia = nr_seq_historico_p;

insert into solic_compra_hist_envio(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_solic_compra,
	nr_seq_hist,
	ds_destinatario,
	ds_observacao)
values (	nextval('solic_compra_hist_envio_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_solic_compra_w,
	nr_seq_historico_p,
	ds_destinatario_p,
	ds_observacao_p);
commit;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_solic_compra_hist_envio ( nr_seq_historico_p bigint, ds_destinatario_p text, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;
