-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_pac_familiar_alerta (cd_pessoa_fisica_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w		varchar(1) := 'N';
cd_pessoa_fisica_w	varchar(10);
ie_vacinado_w		varchar(1) := 'S';
qt_agendamentos_w	integer;
qt_dias_receitas_w	bigint;
nr_seq_vacina_w		vacina.nr_sequencia%type;
ie_dose_w			vacina_calendario.ie_dose%type;
dt_agenda_max_w		agenda_consulta.dt_agenda%type;

/* OPÇÕES 
 T - Todos. 
 V - Vacinas. 
 A - Agendamentos. 
 R - Receita amb. 
 */
 
 
C01 CURSOR FOR 
	SELECT	b.nr_sequencia, 
			ie_dose 
	from 	vacina b, 
			vacina_calendario c 
	where	b.nr_sequencia	= c.nr_seq_vacina 
	and		((clock_timestamp()-coalesce(to_Date(obter_dados_pf(cd_pessoa_fisica_p,'DN'),'dd/mm/yyyy'),clock_timestamp())) between Obter_idade_min_max_vacina(c.nr_sequencia,'MIN') and Obter_idade_min_max_vacina(c.nr_sequencia,'MAX')) 
	and 	(Obter_idade_min_max_vacina(c.nr_sequencia,'MIN') IS NOT NULL AND (Obter_idade_min_max_vacina(c.nr_sequencia,'MIN'))::text <> '') 
	and 	(Obter_idade_min_max_vacina(c.nr_sequencia,'MAX') IS NOT NULL AND (Obter_idade_min_max_vacina(c.nr_sequencia,'MAX'))::text <> '') 
	and  	not exists (SELECT 1 from paciente_vacina e where e.nr_seq_vacina = b.nr_sequencia and e.cd_pessoa_fisica = cd_pessoa_fisica_p and c.ie_dose = e.ie_dose);

	 
C02 CURSOR FOR 
	SELECT (fim_dia(a.dt_validade_receita) - clock_timestamp()) qt_dias_receita 
	from fa_receita_farmacia a, 
		 fa_receita_farmacia_item b 
	where a.nr_sequencia = b.nr_seq_receita 
	and coalesce(b.ie_uso_continuo,'N') = 'S' 
	and	a.dt_validade_receita > clock_timestamp() 
	and a.cd_pessoa_fisica = cd_pessoa_fisica_p 
	order by a.dt_receita desc;
	
	 

BEGIN 
 
 
if	((ie_opcao_p = 'T') or (ie_opcao_p = 'V')) and (ds_retorno_w = 'N') then 
	 
	open c01;
	loop 
	fetch c01 into 
		nr_seq_vacina_w, 
		ie_dose_w;	
		EXIT WHEN NOT FOUND; /* apply on c01 */
		begin 
		 
		 
		select	coalesce(max('S'),'N') 
		into STRICT	ie_vacinado_w 
		from 	paciente_vacina 
		where 	nr_seq_vacina = nr_seq_vacina_w 
		and		ie_dose = ie_dose_w 
		and 	cd_pessoa_fisica = cd_pessoa_fisica_p;
		 
		if (ie_vacinado_w = 'N') then 
			ds_retorno_w	:= 'S';
			goto final;
		end if;
		 
		end;
	end loop;
	close c01;
end if;
 
if	((ie_opcao_p = 'T') or (ie_opcao_p = 'A')) and (ds_retorno_w = 'N') then 
		select	count(*) 
		into STRICT	qt_agendamentos_w 
		from	agenda_consulta 
		where	cd_pessoa_fisica = cd_pessoa_fisica_p 
		and	dt_agenda > clock_timestamp();
 
	if (qt_agendamentos_w > 0) then 
		ds_retorno_w	:= 'S';
		goto final;
	else 
		select	max(dt_agendamento) 
		into STRICT	dt_agenda_max_w 
		from	agenda_consulta 
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
		 
		if (round(clock_timestamp() - dt_agenda_max_w) > 365) then 
			ds_retorno_w	:= 'S';
			goto final;
		end if;
	end if;
end if;
 
if	((ie_opcao_p = 'T') or (ie_opcao_p = 'R')) and (ds_retorno_w = 'N') then 
	 
 
	open c02;
	loop 
	fetch c02 into 
		qt_dias_receitas_w;	
	EXIT WHEN NOT FOUND; /* apply on c02 */
	begin 
			 
		if	(qt_dias_receitas_w <= 15 AND qt_dias_receitas_w > 0) then 
			ds_retorno_w	:= 'S';
			goto final;
		end if;
		 
	end;
	end loop;
	close c02;
 
end if;
 
 
<<final>> return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_pac_familiar_alerta (cd_pessoa_fisica_p text, ie_opcao_p text) FROM PUBLIC;

