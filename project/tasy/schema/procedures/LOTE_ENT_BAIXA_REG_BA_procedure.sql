-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lote_ent_baixa_reg_ba ( nr_seq_reconvocado_p bigint, nr_seq_mot_baixa_p bigint) AS $body$
BEGIN

if (nr_seq_reconvocado_p IS NOT NULL AND nr_seq_reconvocado_p::text <> '') and (nr_seq_mot_baixa_p IS NOT NULL AND nr_seq_mot_baixa_p::text <> '') then

	update	lote_ent_reconvocado
	set		nr_seq_mot_baixa = nr_seq_mot_baixa_p
	where	nr_sequencia = nr_seq_reconvocado_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lote_ent_baixa_reg_ba ( nr_seq_reconvocado_p bigint, nr_seq_mot_baixa_p bigint) FROM PUBLIC;

