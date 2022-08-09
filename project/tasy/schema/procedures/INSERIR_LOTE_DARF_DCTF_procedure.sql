-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_lote_darf_dctf (nr_lote_p bigint, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
BEGIN
if (nr_lote_p IS NOT NULL AND nr_lote_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	insert
	into	dctf_lote_darf(nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_lote, nr_seq_darf)
	values (nextval('dctf_lote_darf_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, nr_lote_p, nr_sequencia_p);
	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_lote_darf_dctf (nr_lote_p bigint, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
