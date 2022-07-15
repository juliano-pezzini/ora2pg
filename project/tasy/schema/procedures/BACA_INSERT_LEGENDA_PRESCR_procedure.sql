-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_insert_legenda_prescr () AS $body$
BEGIN
insert into tasy_padrao_cor_cliente(
	nr_sequencia,
	nr_seq_legenda,
	ds_item,
	nr_seq_cor,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	ds_hint,
	nr_seq_apres)
SELECT nextval('tasy_padrao_cor_cliente_seq'),
	a.nr_Seq_legenda,
	a.ds_item,
	a.nr_Sequencia,
	clock_timestamp(),
	'Tasy',
	clock_timestamp(),
	'Tasy',
	a.ds_hint,
	a.nr_seq_apres
from	tasy_padrao_cor a
where	a.nr_seq_legenda = 19
and	a.nr_sequencia <> 2075
and not exists (
	SELECT	1
	from	tasy_padrao_cor_cliente x
	where	x.nr_seq_legenda = 19
	and	x.nr_seq_cor = a.nr_sequencia);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_insert_legenda_prescr () FROM PUBLIC;

