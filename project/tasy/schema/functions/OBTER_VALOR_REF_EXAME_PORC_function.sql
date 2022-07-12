-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_ref_exame_porc ( nr_seq_resultado_p bigint, nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_resultado_w		varchar(4000);
ds_referencia_w		varchar(4000);
pr_minimo_w		double precision;
pr_maximo_w		double precision;
qt_minima_w		double precision;
qt_maxima_w		double precision;



BEGIN

select	ds_referencia,
	pr_minimo,
	pr_maximo,
	qt_minima,
	qt_maxima
into STRICT	ds_referencia_w,
	pr_minimo_w,
	pr_maximo_w,
	qt_minima_w,
	qt_maxima_w
from	exame_lab_result_item
where	nr_seq_resultado	= nr_seq_resultado_p
and	nr_sequencia		= nr_sequencia_p;

if (pr_minimo_w IS NOT NULL AND pr_minimo_w::text <> '') and (pr_maximo_w IS NOT NULL AND pr_maximo_w::text <> '') then
	ds_resultado_w	:= pr_minimo_w ||'% a '||pr_maximo_w ||'%';
else
	ds_resultado_w	:= ds_referencia_w;
end if;

return ds_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_ref_exame_porc ( nr_seq_resultado_p bigint, nr_sequencia_p bigint) FROM PUBLIC;
