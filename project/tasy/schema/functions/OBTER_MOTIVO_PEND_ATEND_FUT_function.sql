-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_motivo_pend_atend_fut (nr_seq_atend_futuro_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_espera_w	bigint;
ds_retorno_w	varchar(255);


BEGIN
if (nr_seq_atend_futuro_p IS NOT NULL AND nr_seq_atend_futuro_p::text <> '') then

	select	max(nr_sequencia)
	into STRICT	nr_seq_espera_w
	from	paciente_espera
	where	nr_seq_atend_futuro = nr_seq_atend_futuro_p;

	select	max(obter_motivo_pend_fila(nr_seq_motivo_pend_fila))
	into STRICT	ds_retorno_w
	from	paciente_espera
	where	nr_sequencia = nr_seq_espera_w;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_motivo_pend_atend_fut (nr_seq_atend_futuro_p bigint) FROM PUBLIC;

