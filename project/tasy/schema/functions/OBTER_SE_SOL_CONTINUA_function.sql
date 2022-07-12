-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_sol_continua ( nr_prescricao_p bigint, nr_seq_solucao_p bigint, ds_solucao_p text, dt_inicio_plano_p timestamp default clock_timestamp()) RETURNS varchar AS $body$
DECLARE

			
ie_retorno_w			varchar(1);
ds_solucao_w			varchar(255);
nr_seq_solucao_w		integer;
nr_seq_solucao_ww		integer:= null;
ie_status_w				prescr_solucao.ie_status%type;
cd_estabelecimento_w	bigint;
cd_material_ww			integer;
cd_material_w			integer;
qt_comp_atual_w			integer;
qt_comp_sol_w			integer;
ie_verifica_comp_w		varchar(1);
nr_atendimento_w		bigint;
nr_prescricao_w			bigint;
nr_prescricao_ww		bigint:= null;
ie_verifica_componentes_w varchar(1);
ie_existe_comp_w		varchar(1);
ie_continua_w			varchar(1) := 'N';
ie_parametro_w			varchar(15);
nr_etapas_atual_w		integer;
nr_etapas_w				integer;
ie_via_aplicacao_atual_w varchar(10);
ie_via_aplicacao_w		varchar(10);
qt_dose_atual_w			double precision;
qt_dose_w				double precision;
dt_prescricao_w		timestamp;
dt_validade_prescr_w		timestamp;

C01 CURSOR FOR  --Buscar todas solucoes do atendimento com o mesmo titulo
	SELECT	a.nr_seq_solucao,
			a.nr_prescricao
	from	prescr_solucao a,
			prescr_medica b
	where	a.nr_prescricao = b.nr_prescricao
	and		coalesce(a.ds_solucao,'XPTO') = coalesce(ds_solucao_p,'XPTO')
	and		coalesce(a.ie_suspenso,'N') = 'N'
	and		((b.dt_validade_prescr > trunc(clock_timestamp() - interval '30 days')) or (obter_se_acm_sn(a.ie_acm, a.ie_se_necessario) = 'S' and (b.dt_prescricao > dt_prescricao_w)))
	and		b.nr_prescricao < nr_prescricao_p
	and		b.nr_atendimento = nr_atendimento_w	
	order by 	a.nr_prescricao desc;
	
C02 CURSOR FOR  --Componentes da solucao atual
	SELECT	a.cd_material		
	from	prescr_material a,
			prescr_solucao b
	where	b.nr_seq_solucao = a.nr_sequencia_solucao
	and		b.nr_prescricao = a.nr_prescricao
	and		b.nr_seq_solucao = nr_seq_solucao_p
	and		b.nr_prescricao = nr_prescricao_p;
	
C03 CURSOR FOR  --Componentes das demais solucoes
	SELECT	a.nr_seq_solucao,
			a.nr_prescricao		
	from	prescr_solucao a,
			prescr_material b,
			prescr_medica c
	where	c.nr_prescricao = a.nr_prescricao
	and		c.nr_prescricao = b.nr_prescricao
	and		b.nr_sequencia_solucao = a.nr_seq_solucao
	and		b.cd_material in (	SELECT	d.cd_material
								from	prescr_material d
								where	d.nr_sequencia_solucao = nr_seq_solucao_p
								and		d.nr_prescricao	= nr_prescricao_p)
	and		c.dt_validade_prescr > trunc(clock_timestamp() - interval '30 days')	
	and		c.nr_prescricao < nr_prescricao_p
	and		c.nr_atendimento = nr_atendimento_w
	order by a.nr_prescricao desc;
	
C04 CURSOR FOR
	SELECT	a.nr_seq_solucao,
			a.nr_prescricao,
			b.qt_dose,
			a.ie_via_aplicacao,
			a.nr_etapas
	from	prescr_solucao a,
			prescr_material b,
			prescr_medica c
	where	c.nr_prescricao = a.nr_prescricao
	and		c.nr_prescricao = b.nr_prescricao
	and		b.nr_sequencia_solucao = a.nr_seq_solucao
	and		b.cd_material in (	SELECT	d.cd_material
								from	prescr_material d
								where	d.nr_sequencia_solucao = nr_seq_solucao_p
								and		d.nr_prescricao	= nr_prescricao_p)
	and		c.dt_validade_prescr > trunc(clock_timestamp() - interval '30 days')
	and		c.nr_prescricao < nr_prescricao_p
	and		c.nr_atendimento = nr_atendimento_w
	order by a.nr_prescricao desc;
	


BEGIN

select 	max(nr_atendimento),
		max(cd_estabelecimento),
		max(dt_prescricao),
		max(dt_validade_prescr)
into STRICT	nr_atendimento_w,
		cd_estabelecimento_w,
		dt_prescricao_w,
		dt_validade_prescr_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;

select	coalesce(max(ie_solucao_continua),'X') --Parametro
into STRICT	ie_parametro_w
from	parametro_medico
where	cd_estabelecimento = cd_estabelecimento_w;

select	count(*) --Quantidade de componentes da solucao atual
into STRICT	qt_comp_atual_w
from	prescr_material
where	nr_prescricao = nr_prescricao_p
and	nr_sequencia_solucao = nr_seq_solucao_p;

select	ie_via_aplicacao,
		nr_etapas
into STRICT	ie_via_aplicacao_atual_w,
		nr_etapas_atual_w	
from	prescr_solucao
where	nr_prescricao = nr_prescricao_p
and		nr_seq_solucao = nr_seq_solucao_p;

--ie_parametro_w:= 'X';
if (ie_parametro_w = 'A') then --Titulo e componentes
	open C01;
	loop
	fetch C01 into	
		nr_seq_solucao_w,
		nr_prescricao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		
		select	count(*)
		into STRICT	qt_comp_sol_w
		from	prescr_material
		where	nr_prescricao = nr_prescricao_w
		and	nr_sequencia_solucao = nr_seq_solucao_w;
		
		if (qt_comp_sol_w = qt_comp_atual_w) then --Verificar se a solucao tem a mesma quantidade de compoentes da solucao atual
			ie_verifica_componentes_w := 'S';
		else
			ie_verifica_componentes_w := 'N';
		end if;
		
		if (ie_verifica_componentes_w = 'S') then --Verificar se a solucao tem os mesmo componentes da Sol. atual
		
			open C02;
			loop
			fetch C02 into	
				cd_material_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin
				
				select	coalesce(max('S'),'N')
				into STRICT	ie_existe_comp_w
				from	prescr_material
				where	nr_prescricao = nr_prescricao_w
				and		nr_sequencia_solucao = nr_seq_solucao_w;
				
				if (ie_existe_comp_w = 'N') then
					Exit;
				end if;		
				
				end;
			end loop;
			close C02;
			
			if (ie_existe_comp_w = 'S') then
				nr_prescricao_ww 	:= nr_prescricao_w;
				nr_seq_solucao_ww	:= nr_seq_solucao_w;
				ie_continua_w := 'S';
				Exit;
			end if;
		
		end if;
			
		end;
	end loop;
	close C01;
	
elsif (ie_parametro_w = 'C') then --Componentes
	open C03;
	loop
	fetch C03 into	
		nr_seq_solucao_w,
		nr_prescricao_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		
		select	count(*)
		into STRICT	qt_comp_sol_w
		from	prescr_material
		where	nr_prescricao = nr_prescricao_w
		and	nr_sequencia_solucao = nr_seq_solucao_w;
		
		if (qt_comp_sol_w = qt_comp_atual_w) then
			nr_prescricao_ww 	:= nr_prescricao_w;
			nr_seq_solucao_ww	:= nr_seq_solucao_w;
			ie_continua_w := 'S';
			Exit;
		else
			ie_continua_w := 'N';
		end if;
		
					
		end;
	end loop;
	close C03;	

elsif (ie_parametro_w = 'T') then --Titulo
	open C01;
	loop
	fetch C01 into	
		nr_seq_solucao_w,
		nr_prescricao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		nr_prescricao_ww 	:= nr_prescricao_w;
		nr_seq_solucao_ww	:= nr_seq_solucao_w;
		ie_continua_w := 'S';
		Exit;	
		
		end;
	end loop;
	close C01;
	
elsif (ie_parametro_w = 'CDVF') then --HSL
	open C04;
	loop
	fetch C04 into	
		nr_seq_solucao_w,
		nr_prescricao_w,
		qt_dose_w,
		ie_via_aplicacao_w,
		nr_etapas_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		
		select	count(*)
		into STRICT	qt_comp_sol_w
		from	prescr_material a
		where	a.nr_prescricao = nr_prescricao_w
		and	a.nr_sequencia_solucao = nr_seq_solucao_w;
		
		if (qt_comp_sol_w = qt_comp_atual_w) then
			select	count(*)
			into STRICT	qt_comp_sol_w
			from	prescr_material a
			where	a.nr_prescricao = nr_prescricao_w
			and	a.nr_sequencia_solucao = nr_seq_solucao_w		
			and	a.qt_dose  in (	SELECT 	x.qt_dose
						from	prescr_material x
						where 	x.nr_prescricao = nr_prescricao_p
						and	x.nr_sequencia_solucao = nr_seq_solucao_p
						and	x.cd_material = a.cd_material);
		end if;
				
		if (qt_comp_sol_w = qt_comp_atual_w) and
		--	(qt_dose_w = qt_dose_atual_w) and
			(ie_via_aplicacao_w = ie_via_aplicacao_atual_w) and (nr_etapas_w = nr_etapas_atual_w) then
			nr_prescricao_ww 	:= nr_prescricao_w;
			nr_seq_solucao_ww	:= nr_seq_solucao_w;
			ie_continua_w := 'S';
			Exit;
		else
			ie_continua_w := 'N';
		end if;
		
		
		end;
	end loop;
	close C04;
	
end if;

if (ie_continua_w = 'S') then
		
	select	coalesce(ie_status,'N')
	into STRICT	ie_status_w
	from	prescr_solucao
	where	nr_prescricao = nr_prescricao_ww
	and	nr_seq_solucao = nr_seq_solucao_ww;
			
	if (ie_status_w not in ('P', 'T')) then
	
		select 	coalesce(max('N'),'S')
		into STRICT	ie_retorno_w
		from 	prescr_medica
		where	nr_prescricao = nr_prescricao_ww
		and	dt_validade_prescr < dt_inicio_plano_p;
	else
		ie_retorno_w := 'N';
					
	end if;		
else
	ie_retorno_w	:=  'N';
end if;	

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_sol_continua ( nr_prescricao_p bigint, nr_seq_solucao_p bigint, ds_solucao_p text, dt_inicio_plano_p timestamp default clock_timestamp()) FROM PUBLIC;

