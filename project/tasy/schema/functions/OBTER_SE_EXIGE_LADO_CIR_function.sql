-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exige_lado_cir (nr_cirurgia_p bigint, nr_seq_pepo_p bigint) RETURNS varchar AS $body$
DECLARE

qt_exige_lado_w 	bigint;
ds_retorno_w		varchar(1);


BEGIN

if 	((coalesce(nr_seq_pepo_p,0) > 0) or (coalesce(nr_cirurgia_p,0) > 0)) then

	select   count(*)
	into STRICT	 qt_exige_lado_w
	from     cirurgia
	where    ((nr_cirurgia = nr_cirurgia_p) or (nr_seq_pepo = nr_seq_pepo_p))
	and	((obter_se_proc_exige_lado(nr_seq_proc_interno,cd_procedimento_princ,ie_origem_proced)) = 'S' or (obter_se_proc_exige_lado(nr_seq_proc_interno,cd_procedimento_princ,ie_origem_proced)) = 'L');


	if (coalesce(qt_exige_lado_w,0) = 0) then

		select   count(*)
		into STRICT	 qt_exige_lado_w
		from     cirurgia a,
			 prescr_procedimento b
		where    ((a.nr_cirurgia = nr_cirurgia_p) or (a.nr_seq_pepo = nr_seq_pepo_p))
		and	 a.nr_prescricao = b.nr_prescricao
		and	((obter_se_proc_exige_lado(b.nr_seq_proc_interno,b.cd_procedimento,b.ie_origem_proced)) = 'S' or (obter_se_proc_exige_lado(b.nr_seq_proc_interno,b.cd_procedimento,b.ie_origem_proced)) = 'L');

	end if;

	if (qt_exige_lado_w > 0) then
		ds_retorno_w := 'S';
	else
		ds_retorno_w := 'N';
	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exige_lado_cir (nr_cirurgia_p bigint, nr_seq_pepo_p bigint) FROM PUBLIC;
