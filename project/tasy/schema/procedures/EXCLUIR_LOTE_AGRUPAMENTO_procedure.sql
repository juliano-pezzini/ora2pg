-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_lote_agrupamento ( nr_seq_lote_p bigint, nr_lote_agrup_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_lotes_agrupados_w 	bigint;

BEGIN

update	ap_lote
set 	nr_lote_agrupamento  = NULL,
	dt_impressao  = NULL,
	nm_usuario = nm_usuario_p
where	nr_sequencia = nr_seq_lote_p;

insert into ap_lote_historico(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	nr_seq_lote,
	ds_evento,
	ds_log)
values (	nextval('ap_lote_historico_seq'),
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_lote_p,
	wheb_mensagem_pck.get_texto(1088349),
	wheb_mensagem_pck.get_texto(1088351,'NR_AGRUPAMENTO='||nr_lote_agrup_p) || '-' || dbms_utility.format_call_stack);

select	count(*)
into STRICT	qt_lotes_agrupados_w
from	ap_lote a
where 	a.nr_lote_agrupamento  = nr_lote_agrup_p;

if (qt_lotes_agrupados_w = 0) then
	update	ap_lote
	set 	ie_status_lote = 'C',
			nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_lote_agrup_p;

	insert into ap_lote_historico(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		nr_seq_lote,
		ds_evento,
		ds_log)
	values (	nextval('ap_lote_historico_seq'),
		clock_timestamp(),
		nm_usuario_p,
		nr_lote_agrup_p,
		wheb_mensagem_pck.get_texto(1088349),
		substr(wheb_mensagem_pck.get_texto(1088350) || '-' || dbms_utility.format_call_stack,1,2000));		
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_lote_agrupamento ( nr_seq_lote_p bigint, nr_lote_agrup_p bigint, nm_usuario_p text) FROM PUBLIC;
