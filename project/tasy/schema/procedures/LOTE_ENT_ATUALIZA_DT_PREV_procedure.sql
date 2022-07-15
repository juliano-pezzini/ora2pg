-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lote_ent_atualiza_dt_prev ( nr_seq_reconvocado_p bigint, nr_seq_item_p bigint, dt_prev_p timestamp) AS $body$
BEGIN

if (nr_seq_reconvocado_p IS NOT NULL AND nr_seq_reconvocado_p::text <> '') and (nr_seq_item_p IS NOT NULL AND nr_seq_item_p::text <> '') and (dt_prev_p IS NOT NULL AND dt_prev_p::text <> '') then

	update	lote_ent_reconvocado_item
	set		dt_prevista = dt_prev_p
	where	nr_sequencia = nr_seq_item_p
	and		nr_seq_reconvocado = nr_seq_reconvocado_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lote_ent_atualiza_dt_prev ( nr_seq_reconvocado_p bigint, nr_seq_item_p bigint, dt_prev_p timestamp) FROM PUBLIC;

