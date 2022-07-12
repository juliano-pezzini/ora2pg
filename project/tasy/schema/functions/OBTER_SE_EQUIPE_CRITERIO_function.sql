-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_equipe_criterio (nr_seq_propaci_p bigint, nr_seq_criterio_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(2);
ie_funcao_proc_med_w	varchar(10);
ie_funcao_partic_w	varchar(10);
count_w			bigint;
count_exec_w		bigint;
count_regra_w		bigint;
cont_w			bigint;


BEGIN
ds_retorno_w	:= 'S';

select	count(1)
into STRICT	cont_w
from	proc_crit_repasse_equipe a
where	a.nr_seq_proc_criterio	= nr_seq_criterio_p  LIMIT 1;

if (cont_w	<> 0) then
	select	count(1)
	into STRICT	count_regra_w
	from	proc_crit_repasse_equipe a
	where	a.nr_seq_proc_criterio	= nr_seq_criterio_p
	and	not exists (	SELECT	1
				from	procedimento_paciente x
				where	x.nr_sequencia	= nr_seq_propaci_p
				and	x.ie_funcao_medico	= a.ie_funcao_medico
				
union

				SELECT	1
				from	procedimento_participante y,
					procedimento_paciente x
				where	x.nr_sequencia	= y.nr_sequencia
				and	x.nr_sequencia	= nr_seq_propaci_p
				and	y.ie_funcao	= a.ie_funcao_medico);

	select	count(1)
	into STRICT	count_exec_w
	from	procedimento_paciente a
	where	a.nr_sequencia	= nr_seq_propaci_p
	and	not exists (	SELECT	1
				from	proc_crit_repasse_equipe x
				where	x.nr_seq_proc_criterio	= nr_seq_criterio_p
				and	x.ie_funcao_medico	= a.ie_funcao_medico);

	if (count_exec_w	= 0) then
		select	count(*)
		into STRICT	count_w
		from	procedimento_participante b,
			procedimento_paciente a
		where	a.nr_sequencia	= b.nr_sequencia
		and	a.nr_sequencia	= nr_seq_propaci_p
		and	not exists (	SELECT	1
				from	proc_crit_repasse_equipe x
				where	x.nr_seq_proc_criterio	= nr_seq_criterio_p
				and	x.ie_funcao_medico = b.ie_funcao);

	end if;

	if (count_regra_w	<> 0) or (count_exec_w	<> 0) or (count_w	<> 0) then
		ds_retorno_w	:= 'N';
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_equipe_criterio (nr_seq_propaci_p bigint, nr_seq_criterio_p bigint) FROM PUBLIC;

