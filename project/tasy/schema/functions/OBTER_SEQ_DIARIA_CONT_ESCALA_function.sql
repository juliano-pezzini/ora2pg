-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_seq_diaria_cont_escala ( nr_seq_escala_p bigint, nr_seq_escala_diaria_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w 	varchar(1) := 'N';
nr_seq_w		bigint;


BEGIN
select	b.nr_sequencia
into STRICT	nr_seq_w
from	escala a,
		escala_diaria b
where	a.nr_sequencia = b.nr_seq_escala
and		a.nr_sequencia = nr_seq_escala_p
and		b.nr_sequencia = nr_seq_escala_diaria_p;

if (nr_seq_w = nr_seq_escala_diaria_p) then
		ds_retorno_w := 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_seq_diaria_cont_escala ( nr_seq_escala_p bigint, nr_seq_escala_diaria_p bigint) FROM PUBLIC;
