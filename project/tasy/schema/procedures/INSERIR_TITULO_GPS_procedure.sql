-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_titulo_gps ( nm_usuario_p text, nr_seq_gps_p bigint, nr_titulo_p bigint) AS $body$
BEGIN
if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (nr_seq_gps_p IS NOT NULL AND nr_seq_gps_p::text <> '') and (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then
	begin
	insert
	into	gps_titulo(nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_gps, nr_titulo)
	values (nextval('gps_titulo_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, nr_seq_gps_p, nr_titulo_p);
	commit;
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_titulo_gps ( nm_usuario_p text, nr_seq_gps_p bigint, nr_titulo_p bigint) FROM PUBLIC;

