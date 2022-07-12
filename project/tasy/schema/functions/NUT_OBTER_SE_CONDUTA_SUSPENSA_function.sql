-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nut_obter_se_conduta_suspensa ( nr_seq_serv_dia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);
ds_observacao_w	varchar(4000);


BEGIN

if (nr_seq_serv_dia_p IS NOT NULL AND nr_seq_serv_dia_p::text <> '') then

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ds_retorno_w
	from	nut_atend_serv_dieta b,
		nut_atend_serv_dia_dieta c
	where	b.nr_seq_dieta 	= c.nr_sequencia
	and	b.nr_seq_servico = nr_seq_serv_dia_p
	and	(c.dt_suspensao IS NOT NULL AND c.dt_suspensao::text <> '')
	and	c.ie_tipo_nutricao <> 'O'
	and not exists (SELECT	1
			from	nut_atend_serv_dieta d,
				nut_atend_serv_dia_dieta e
			where	d.nr_seq_dieta 	= e.nr_sequencia
			and	d.nr_seq_servico = nr_seq_serv_dia_p
			and	coalesce(e.dt_suspensao::text, '') = '');

	/*select	max(ds_observacao)
	into	ds_observacao_w
	from	nut_atend_serv_dia
	where	nr_sequencia = nr_seq_serv_dia_p;

	if (ds_observacao_w is not null) then
		ds_retorno_w := 'N';
	end if;*/
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nut_obter_se_conduta_suspensa ( nr_seq_serv_dia_p bigint) FROM PUBLIC;

