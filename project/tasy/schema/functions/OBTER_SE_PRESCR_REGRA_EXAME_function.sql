-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_prescr_regra_exame (nr_prescricao_p bigint, nr_seq_proc_p bigint, nr_seq_regra_exame_p bigint ) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1) := 'N';

nr_seq_exame_w		bigint;
nr_seq_proc_interno_w	bigint;


BEGIN


if	(nr_prescricao_p > 0 AND nr_seq_proc_p > 0 )then
	begin


	select	coalesce(max(nr_seq_exame),0),
		coalesce(max(nr_seq_proc_interno),0)
	into STRICT	nr_seq_exame_w,
		nr_seq_proc_interno_w
	from 	prescr_procedimento
	where	nr_prescricao 	= nr_prescricao_p
	and	nr_sequencia	= nr_seq_proc_p;


	if (nr_seq_exame_w > 0) then

		select  coalesce(max('S'),'N')
		into STRICT 	ds_retorno_w
		from	cih_exame_regra
		where (nr_seq_exame = nr_seq_exame_w)
		and	((nr_seq_regra_exame_p = 0) or (nr_seq_regra = nr_seq_regra_exame_p));

	else

		select  coalesce(max('S'),'N')
		into STRICT 	ds_retorno_w
		from	cih_exame_regra
		where	nr_seq_proc_interno = nr_seq_proc_interno_w
		and	((nr_seq_regra_exame_p = 0) or (nr_seq_regra = nr_seq_regra_exame_p));

	end if;

	end;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_prescr_regra_exame (nr_prescricao_p bigint, nr_seq_proc_p bigint, nr_seq_regra_exame_p bigint ) FROM PUBLIC;

