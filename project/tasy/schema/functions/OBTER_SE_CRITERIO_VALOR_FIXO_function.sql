-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_criterio_valor_fixo ( nr_seq_proc_crit_repasse_p bigint, nr_seq_mat_crit_repasse_p bigint) RETURNS varchar AS $body$
DECLARE


cont_w		bigint;
ds_retorno_w	varchar(10);


BEGIN

if (nr_seq_proc_crit_repasse_p IS NOT NULL AND nr_seq_proc_crit_repasse_p::text <> '') then

		select	count(*)
		into STRICT		cont_w
		from	proc_criterio_repasse a
		where	a.nr_sequencia				= nr_seq_proc_crit_repasse_p
		and		ie_forma_calculo				in ('V','U');

elsif (nr_seq_mat_crit_repasse_p IS NOT NULL AND nr_seq_mat_crit_repasse_p::text <> '') then

		select	count(*)
		into STRICT		cont_w
		from	mat_criterio_repasse a
		where	a.nr_sequencia				= nr_seq_mat_crit_repasse_p
		and		ie_forma_calculo				in ('V','U');
end if;

if (cont_w >  0) then
		ds_retorno_w		:= 'S';
else
		ds_retorno_w		:= 'N';
end if;

return	ds_retorno_w;

end		;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_criterio_valor_fixo ( nr_seq_proc_crit_repasse_p bigint, nr_seq_mat_crit_repasse_p bigint) FROM PUBLIC;
