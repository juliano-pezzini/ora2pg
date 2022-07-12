-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_cor_regra_exame ( ds_resultado_p text, nr_seq_exame_p bigint) RETURNS varchar AS $body$
DECLARE


ds_cor_w	varchar(15);
vl_resultado_w	double precision;


BEGIN

if  (ds_resultado_p IS NOT NULL AND ds_resultado_p::text <> '' AND nr_seq_exame_p IS NOT NULL AND nr_seq_exame_p::text <> '') then

	begin
	vl_resultado_w := (ds_resultado_p)::numeric;
	exception
	when others then
		vl_resultado_w := 0;
	end;

	select	max(ds_cor)
	into STRICT	ds_cor_w
	from    san_regra_cor_resultado a
	where (upper(a.ds_resultado)  = upper(ds_resultado_p)
	or (vl_resultado_w > 0
	and ((vl_resultado_min IS NOT NULL AND vl_resultado_min::text <> '') or (vl_resultado_max IS NOT NULL AND vl_resultado_max::text <> ''))
	and	vl_resultado_w between coalesce(vl_resultado_min,vl_resultado_w) and coalesce(vl_resultado_max,vl_resultado_w)))
	and	a.nr_seq_exame	= nr_seq_exame_p;

end if;
return	ds_cor_w;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_cor_regra_exame ( ds_resultado_p text, nr_seq_exame_p bigint) FROM PUBLIC;
