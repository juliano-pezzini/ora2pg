-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ordem_etapa_npi (nr_seq_cronograma_p bigint, nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE

result_w	integer;


BEGIN

select	coalesce(max(ordem),0)
into STRICT	result_w
from (WITH RECURSIVE cte AS (

	SELECT	z.nr_sequencia,z.nr_seq_superior,row_number() OVER () AS ordem
	from (
		SELECT	x.nr_sequencia,
			row_number() OVER () AS ordem,
			x.nr_seq_superior
		from	proj_cron_etapa x
		where	x.nr_seq_cronograma = nr_seq_cronograma_p
		order by x.nr_seq_superior
	) z WHERE coalesce(z.nr_seq_superior::text, '') = ''
  UNION ALL

	SELECT	z.nr_sequencia,z.nr_seq_superior,row_number() OVER () AS ordem
	from (
		SELECT	x.nr_sequencia,
			row_number() OVER () AS ordem,
			x.nr_seq_superior
		from	proj_cron_etapa x
		where	x.nr_seq_cronograma = nr_seq_cronograma_p
		order by x.nr_seq_superior
	) JOIN cte c ON (c.prior nr_sequencia = z.nr_seq_superior)

) SELECT * FROM cte;
) alias4
where	nr_sequencia = nr_sequencia_p;

return	result_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ordem_etapa_npi (nr_seq_cronograma_p bigint, nr_sequencia_p bigint) FROM PUBLIC;

