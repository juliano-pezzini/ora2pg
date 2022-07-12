-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_terceiro_data ( nr_seq_proc_repasse_p bigint, nr_seq_mat_repasse_p bigint, dt_referencia_p timestamp, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/* ie_opcao_p

S	sequência
N	nome

*/
ds_retorno_w		varchar(255);
nr_seq_terceiro_w	bigint;

c01 CURSOR FOR
SELECT 	nr_seq_terc_novo
from	proc_mat_repasse_terc a
where 	coalesce(a.nr_seq_proc_repasse,0)	= coalesce(nr_seq_proc_repasse_p,0)
and	coalesce(a.nr_seq_mat_repasse,0)	= coalesce(nr_seq_mat_repasse_p,0)
and	trunc(dt_troca, 'dd')		<= trunc(dt_referencia_p, 'dd')
order 	by dt_troca,
	nr_sequencia;

c02 CURSOR FOR
SELECT 	nr_seq_terc_ant
from	proc_mat_repasse_terc a
where 	coalesce(a.nr_seq_proc_repasse,0)	= coalesce(nr_seq_proc_repasse_p,0)
and	coalesce(a.nr_seq_mat_repasse,0)	= coalesce(nr_seq_mat_repasse_p,0)
and	trunc(dt_troca, 'dd')		>= trunc(dt_referencia_p, 'dd')
order 	by dt_troca desc,
	nr_sequencia desc;


BEGIN

open c01;
loop
fetch c01 into
	nr_seq_terceiro_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close c01;

if (coalesce(nr_seq_terceiro_w::text, '') = '') then

	open c02;
	loop
	fetch c02 into
		nr_seq_terceiro_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
	end loop;
	close c02;

	if (coalesce(nr_seq_terceiro_w::text, '') = '') then

		select 	max(nr_seq_terceiro)
		into STRICT	nr_seq_terceiro_w
		from (SELECT	a.nr_seq_terceiro
			from	procedimento_repasse a
			where 	a.nr_sequencia	= nr_seq_proc_repasse_p
			
union

			SELECT	a.nr_seq_terceiro
			from	material_repasse a
			where	a.nr_sequencia	= nr_seq_mat_repasse_p) alias3;

	end if;

end if;

if (ie_opcao_p	= 'S') then
	ds_retorno_w	:= nr_seq_terceiro_w;
elsif (ie_opcao_p	= 'N') then
	select	substr(obter_nome_terceiro(a.nr_sequencia),1,255)
	into STRICT	ds_retorno_w
	from	terceiro a
	where	a.nr_sequencia	= nr_seq_terceiro_w;
end if;

RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_terceiro_data ( nr_seq_proc_repasse_p bigint, nr_seq_mat_repasse_p bigint, dt_referencia_p timestamp, ie_opcao_p text) FROM PUBLIC;

