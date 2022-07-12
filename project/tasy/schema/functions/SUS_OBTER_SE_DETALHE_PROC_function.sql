-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_se_detalhe_proc ( cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_detalhe_p text, dt_competencia_p timestamp default clock_timestamp()) RETURNS bigint AS $body$
DECLARE


ds_retorno_w			integer	:= 0;
nr_seq_detalhe_w		bigint;	
nr_seq_det_proc_w		bigint	:= 0;	
dt_compt_ini_w			sus_detalhe_proc.dt_compt_ini%type;
	

BEGIN

begin
return sus_proc_detalhe_pck.get_qtde_detalhe_proc(cd_procedimento_p, ie_origem_proced_p, cd_detalhe_p, dt_competencia_p);
exception
when no_data_found then

begin
select	nr_sequencia
into STRICT	nr_seq_detalhe_w
from	sus_detalhe
where	cd_detalhe	= cd_detalhe_p  LIMIT 1;
exception
when others then
	nr_seq_detalhe_w := 0;
end;

select	max(dt_compt_ini)
into STRICT	dt_compt_ini_w
from	sus_detalhe_proc
where	nr_seq_detalhe		= nr_seq_detalhe_w
and	cd_procedimento		= cd_procedimento_p
and	ie_origem_proced	= ie_origem_proced_p;

begin
select	nr_sequencia
into STRICT	nr_seq_det_proc_w
from	sus_detalhe_proc
where	nr_seq_detalhe	= nr_seq_detalhe_w
and	cd_procedimento		= cd_procedimento_p
and	ie_origem_proced	= ie_origem_proced_p
and	(dt_compt_fim IS NOT NULL AND dt_compt_fim::text <> '')
and	dt_compt_ini 		= coalesce(dt_compt_ini_w,clock_timestamp())  LIMIT 1;
exception
when others then
	nr_seq_det_proc_w := 0;
end;


if (coalesce(nr_seq_det_proc_w,0) = 0) then
	begin
	
	select	count(1)
	into STRICT	ds_retorno_w
	from	sus_detalhe_proc
	where	nr_seq_detalhe		= nr_seq_detalhe_w
	and	cd_procedimento		= cd_procedimento_p
	and	ie_origem_proced	= ie_origem_proced_p  LIMIT 1;

	end;
elsif (cd_detalhe_p in ('014','022','023','025','033','040','041','33','40')) then
	begin
	
	select	count(1)
	into STRICT	ds_retorno_w
	from	sus_detalhe_proc
	where	nr_seq_detalhe	= nr_seq_detalhe_w
	and	cd_procedimento		= cd_procedimento_p
	and	ie_origem_proced	= ie_origem_proced_p
	and	nr_sequencia		= nr_seq_det_proc_w  LIMIT 1;
	
	end;
else
	begin
	
	select	count(1)
	into STRICT	ds_retorno_w
	from	sus_detalhe_proc
	where	nr_seq_detalhe	= nr_seq_detalhe_w
	and	cd_procedimento		= cd_procedimento_p
	and	ie_origem_proced	= ie_origem_proced_p
	and	nr_sequencia		= nr_seq_det_proc_w
	and (establishment_timezone_utils.startOfMonth(dt_competencia_p) <= establishment_timezone_utils.startOfMonth(coalesce(dt_compt_fim,clock_timestamp() + interval '999 days')))  LIMIT 1;
	
	end;
end if;

if (cd_detalhe_p = '10057')then
	begin
		select	nr_sequencia
		into STRICT	nr_seq_detalhe_w
		from	sus_detalhe
		where	cd_detalhe	= 10047  LIMIT 1;
		exception
			when others then
				nr_seq_detalhe_w := 0;
	end;			
	begin			
		select	count(1)
		into STRICT	ds_retorno_w
		from	sus_detalhe_proc
		where	nr_seq_detalhe		= nr_seq_detalhe_w
		and	cd_procedimento		= cd_procedimento_p
		and	ie_origem_proced	= ie_origem_proced_p  LIMIT 1;
		exception
			when others then
				ds_retorno_w := 0;
	end;
	
	
end if;

return	ds_retorno_w;
end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_se_detalhe_proc ( cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_detalhe_p text, dt_competencia_p timestamp default clock_timestamp()) FROM PUBLIC;

