-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_diaria_margem_pos (nr_interno_conta_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w			varchar(1):= 'N';
dt_alta_w			timestamp;
cd_setor_atendimento_w		integer;
dt_entrada_unidade_w		timestamp;
nr_seq_atepacu_w		bigint;
cd_tipo_acomodacao_w		smallint;
hr_margem_pos_virdia_w		timestamp;
dt_margem_pos_w			timestamp;
dt_procedimento_w		timestamp;
			
C01 CURSOR FOR
	SELECT	cd_setor_atendimento,		
		dt_entrada_unidade,
		nr_seq_atepacu,
		dt_procedimento
	from	procedimento		d,
		procedimento_paciente   a,
		conta_paciente          b,
		atendimento_paciente    c
	where	b.nr_interno_conta = nr_interno_conta_p
	and	b.nr_interno_conta = a.nr_interno_conta
	and	b.nr_atendimento   = c.nr_atendimento
	and 	d.cd_procedimento = a.cd_procedimento
	and 	d.ie_origem_proced = a.ie_origem_proced
	and 	d.ie_classificacao = 3
	and	coalesce(a.cd_motivo_exc_conta::text, '') = ''
	and	a.ds_observacao like '%'||OBTER_DESC_EXPRESSAO(729624)||'%'
	and 	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(a.dt_procedimento) = ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(c.dt_alta)
	order by a.dt_procedimento;
			

BEGIN

select 	max(dt_alta)
into STRICT	dt_alta_w
from 	conta_paciente		b,
	atendimento_paciente	a
where 	a.nr_atendimento = b.nr_atendimento
and 	b.nr_interno_conta = nr_interno_conta_p;

if (dt_alta_w IS NOT NULL AND dt_alta_w::text <> '') then

	open C01;
	loop
	fetch C01 into	
		cd_setor_atendimento_w,
		dt_entrada_unidade_w,
		nr_seq_atepacu_w,
		dt_procedimento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		
		select 	coalesce(max(cd_tipo_acomodacao),0)
		into STRICT	cd_tipo_acomodacao_w
		from 	atend_paciente_unidade
		where 	cd_setor_atendimento = cd_setor_atendimento_w
		and 	nr_seq_interno = nr_seq_atepacu_w
		and 	dt_entrada_unidade = dt_entrada_unidade_w;
		
		if (cd_tipo_acomodacao_w <> 0) then
		
			select	coalesce(max(a.hr_margem_pos_virdia),dt_alta_w)
			into STRICT	hr_margem_pos_virdia_w
			from	tipo_acomodacao a
			where 	a.cd_tipo_acomodacao 	= cd_tipo_acomodacao_w;
			
			dt_margem_pos_w := to_date((to_char(dt_alta_w, 'dd/mm/yyyy') ||
						    to_char(hr_margem_pos_virdia_w, 'hh24:mi:ss')), 'dd/mm/yyyy hh24:mi:ss');
			
		end if;

		if	(dt_alta_w >= dt_procedimento_w AND dt_alta_w <= dt_margem_pos_w) then
					
			ie_retorno_w:= 'S';
			
		end if;
		
		
		end;
	end loop;
	close C01;
	
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_diaria_margem_pos (nr_interno_conta_p bigint) FROM PUBLIC;
