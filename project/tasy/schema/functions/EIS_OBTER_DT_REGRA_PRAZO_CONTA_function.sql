-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION eis_obter_dt_regra_prazo_conta ( nr_interno_conta_p bigint, ie_opcao_p text) RETURNS timestamp AS $body$
DECLARE

					 
/*	ie_opção_p 
	P - Prazo entrega 
	PL - Prazo entrega e Limite	*/
 
 
dt_retorno_w			timestamp;
dt_regra_w			timestamp;
dt_entrada_w			timestamp;
dt_alta_w				timestamp;
dt_inicio_vigencia_w		timestamp;
qt_dia_entrega_w			integer;
qt_dia_limite_w			integer;
ie_data_referencia_w		varchar(15);
cd_convenio_w			integer;
cd_categoria_w			varchar(10);

C01 CURSOR FOR 
	SELECT	qt_dia_entrega, 
		qt_dia_limite, 
		ie_data_referencia 
	from	eis_regra_prazo_conta_pend 
	where	coalesce(cd_convenio,coalesce(cd_convenio_w,0)) = coalesce(cd_convenio_w,0) 
	and	coalesce(cd_categoria,coalesce(cd_categoria_w,'X')) = coalesce(cd_categoria_w,'X') 
	order by cd_convenio desc, 
		cd_categoria desc, 
		nr_sequencia;

BEGIN
 
if (coalesce(nr_interno_conta_p,0) <> 0) then 
	begin 
	 
	select	b.cd_convenio_parametro, 
		b.cd_categoria_parametro, 
		trunc(a.dt_entrada), 
		trunc(a.dt_alta) 
	into STRICT	cd_convenio_w, 
		cd_categoria_w, 
		dt_entrada_w, 
		dt_alta_w 
	from	conta_paciente b, 
		atendimento_paciente a 
	where	a.nr_atendimento = b.nr_atendimento 
	and	nr_interno_conta = nr_interno_conta_p;
	 
	open C01;
	loop 
	fetch C01 into	 
		qt_dia_entrega_w, 
		qt_dia_limite_w, 
		ie_data_referencia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	end loop;
	close C01;
	 
	if (qt_dia_entrega_w IS NOT NULL AND qt_dia_entrega_w::text <> '') and (qt_dia_limite_w IS NOT NULL AND qt_dia_limite_w::text <> '') and (ie_data_referencia_w IS NOT NULL AND ie_data_referencia_w::text <> '') then 
		begin 
		if (ie_data_referencia_w = 'A') then 
			dt_regra_w := dt_entrada_w + qt_dia_entrega_w;
		elsif (ie_data_referencia_w = 'L') then 
			dt_regra_w := dt_alta_w + qt_dia_entrega_w;
		elsif (ie_data_referencia_w = 'Z') then 
			begin 
			select	trunc(max(b.dt_inicio_vigencia)) 
			into STRICT	dt_inicio_vigencia_w 
			from	conta_paciente c, 
				autorizacao_convenio b, 
				atendimento_paciente a 
			where	a.nr_atendimento = b.nr_atendimento 
			and	a.nr_atendimento = c.nr_atendimento 
			and	c.nr_interno_conta = nr_interno_conta_p;
			 
			dt_regra_w := dt_inicio_vigencia_w + qt_dia_entrega_w;
			end;
		end if;
		 
		 
		if (ie_opcao_p = 'P') then 
			dt_retorno_w := dt_regra_w;
		elsif (ie_opcao_p = 'PL') then 
			dt_retorno_w := dt_regra_w - qt_dia_limite_w;
		end if;
		end;
	end if;
	end;
end if;
 
return	dt_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION eis_obter_dt_regra_prazo_conta ( nr_interno_conta_p bigint, ie_opcao_p text) FROM PUBLIC;

