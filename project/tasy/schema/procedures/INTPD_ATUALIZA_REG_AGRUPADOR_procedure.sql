-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE intpd_atualiza_reg_agrupador (nr_sequencia_p bigint, is_status_p text) AS $body$
BEGIN

update	intpd_fila_transmissao
set	ie_status 		= is_status_p
where	nr_seq_dependencia 	= nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE intpd_atualiza_reg_agrupador (nr_sequencia_p bigint, is_status_p text) FROM PUBLIC;

