-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_regra_adic_mat (nr_seq_criterio_p bigint, nr_seq_mat_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1);
nr_Seq_adic_w		bigint;
vl_retorno_w		integer;
ds_function_w		varchar(255);
ds_comando_aux_w	varchar(2000);
ds_comando_w		varchar(2000);
qt_reg_w		bigint := 0;

BEGIN

ds_retorno_w	:= 'S';

select 	count(1)
into STRICT	qt_reg_w
from 	mat_crit_repasse_adic
where	nr_seq_criterio = nr_seq_criterio_p  LIMIT 1;

if (qt_reg_w > 0) then
	begin

	select 	coalesce(Max(nr_Sequencia),0)
	into STRICT	nr_Seq_adic_w
	from 	mat_crit_repasse_adic
	where	nr_seq_criterio = nr_seq_criterio_p;

	if (nr_Seq_adic_w > 0) then

		select 	Upper(ds_function)
		into STRICT	ds_function_w
		from 	mat_crit_repasse_adic
		where	nr_sequencia = nr_Seq_adic_w;

		ds_comando_aux_w	:= replace(ds_function_w,':NR_SEQ_MAT',nr_seq_mat_p);
		ds_comando_w		:= 'select ' ||  ds_comando_aux_w || ' from dual';

		vl_retorno_w := Obter_Valor_Dinamico(ds_comando_w, vl_retorno_w);

		if (coalesce(vl_retorno_w,0) > 0) then
			ds_retorno_w := 'N';
		end if;
	end if;

	end;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_regra_adic_mat (nr_seq_criterio_p bigint, nr_seq_mat_p bigint) FROM PUBLIC;

