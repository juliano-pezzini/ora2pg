-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tabulacao_etapa_npi (nr_seq_cronograma_p bigint, nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


level_w		integer;
ds_atividade_w	varchar(255);
result_w		varchar(1000);


BEGIN

select	coalesce(max(ordem),0),
	max(ds_atividade)
into STRICT	level_w,
	ds_atividade_w
from (WITH RECURSIVE cte AS (
SELECT	z.nr_sequencia,z.nr_seq_superior,1 ordem,z.ds_atividade
	from (select	x.nr_sequencia,
			x.nr_seq_superior,
			ds_atividade
		from	proj_cron_etapa x
		where	x.nr_seq_cronograma = nr_seq_cronograma_p
		order by x.nr_seq_superior
	) z WHERE coalesce(z.nr_seq_superior::text, '') = ''
  UNION ALL
SELECT	z.nr_sequencia,z.nr_seq_superior,(c.level+1) ordem,z.ds_atividade
	from (select	x.nr_sequencia,
			x.nr_seq_superior,
			ds_atividade
		from	proj_cron_etapa x
		where	x.nr_seq_cronograma = nr_seq_cronograma_p
		order by x.nr_seq_superior
	) JOIN cte c ON (c.prior nr_sequencia = z.nr_seq_superior)

) SELECT * FROM cte;
) alias5
where	nr_sequencia = nr_sequencia_p;

select	lpad(ds_atividade_w,length(ds_atividade_w)+((level_w-1)*5),' ')
into STRICT	result_w
;

return	result_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tabulacao_etapa_npi (nr_seq_cronograma_p bigint, nr_sequencia_p bigint) FROM PUBLIC;
