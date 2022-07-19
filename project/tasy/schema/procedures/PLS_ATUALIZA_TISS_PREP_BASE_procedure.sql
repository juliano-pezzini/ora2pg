-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualiza_tiss_prep_base (nr_seq_lote_p bigint) AS $body$
BEGIN

update 	pls_monitor_tiss_lote
set 	ie_status 	= 'PE'
where 	nr_sequencia = nr_seq_lote_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualiza_tiss_prep_base (nr_seq_lote_p bigint) FROM PUBLIC;

