-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_maquina_controle (nr_seq_dialise_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_dialisador_w	bigint;
nr_seq_maquina_w	bigint;

BEGIN
if (nr_seq_dialise_p IS NOT NULL AND nr_seq_dialise_p::text <> '') then
	select	max(nr_sequencia)
	into STRICT	nr_seq_dialisador_w
	from	hd_dialise_dialisador
	where	nr_seq_dialise = nr_seq_dialise_p;

	select	max(nr_seq_maquina)
	into STRICT	nr_seq_maquina_w
	from	hd_dialise_dialisador
	where	nr_sequencia = nr_seq_dialisador_w;
end if;

return	nr_seq_maquina_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_maquina_controle (nr_seq_dialise_p bigint) FROM PUBLIC;
