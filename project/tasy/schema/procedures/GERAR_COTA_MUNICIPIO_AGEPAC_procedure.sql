-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cota_municipio_agepac ( nr_seq_agenda_p bigint, cd_agenda_p bigint, dt_agenda_p timestamp, cd_pessoa_fisica_p text, cd_convenio_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, cd_medico_exec_p text, ie_novo_registro_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
dt_agenda_w		timestamp;
cd_municipio_ibge_w	varchar(06);
cd_area_proced_w	integer;
cd_espec_proced_w	integer;
cd_grupo_proced_w	bigint;
nr_seq_regra_w		bigint;
ie_perm_agenda_w	varchar(01);
qt_regra_w		smallint;
qt_agenda_w		integer;
qt_saldo_w		integer;
ie_novo_w		varchar(01);
qt_proc_adic_w		integer;
nr_seq_forma_org_w	bigint;
nr_seq_grupo_w 		bigint;
nr_seq_subgrupo_w	bigint;
ie_utiliza_med_ant_w	varchar(1)	:= 'S';
qt_saldo_ant_w		integer;
qt_saldo_proximo_w	integer;

C01 CURSOR FOR 
	SELECT	coalesce(nr_sequencia,0) 
	from	agenda_regra 
	where	cd_agenda		= cd_agenda_p 
	and	cd_estabelecimento	= cd_estabelecimento_p 
	and	((cd_convenio	= cd_convenio_p) or (coalesce(cd_convenio::text, '') = '')) 
	and	((cd_area_proc	= cd_area_proced_w) or (coalesce(cd_area_proc::text, '') = '')) 
	and	((cd_especialidade	= cd_espec_proced_w) or (coalesce(cd_especialidade::text, '') = '')) 
	and	((cd_grupo_proc	= cd_grupo_proced_w) or (coalesce(cd_grupo_proc::text, '') = '')) 
	and	coalesce(nr_seq_forma_org, nr_seq_forma_org_w)	= nr_seq_forma_org_w 	 
	and	coalesce(nr_seq_grupo, nr_seq_grupo_w)		= nr_seq_grupo_w 	 
	and	coalesce(nr_seq_subgrupo, nr_seq_subgrupo_w)		= nr_seq_subgrupo_w 
	and	((cd_procedimento	= cd_procedimento_p) or (coalesce(cd_procedimento::text, '') = '')) 
	and	((coalesce(cd_procedimento::text, '') = '') or ((ie_origem_proced = ie_origem_proced_p) or (coalesce(ie_origem_proced::text, '') = ''))) 
	and	((nr_seq_proc_interno	= nr_seq_proc_interno_p) or (coalesce(nr_seq_proc_interno::text, '') = '')) 
	and	((cd_medico		= cd_medico_exec_p) or (coalesce(cd_medico::text, '') = '')) 
	and	((cd_municipio_ibge	= coalesce(cd_municipio_ibge_w, 'X')) or (coalesce(cd_municipio_ibge::text, '') = ''))	 
	order by	coalesce(cd_procedimento,0), 
		coalesce(nr_seq_proc_interno,0), 
		coalesce(cd_grupo_proc,0), 
		coalesce(cd_especialidade,0), 
		coalesce(cd_area_proc,0), 
		coalesce(nr_seq_forma_org,0), 
		coalesce(nr_seq_subgrupo,0), 
		coalesce(nr_seq_grupo,0), 
		coalesce(cd_medico,'0');


BEGIN 
 
select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
into STRICT	ie_novo_w 
from	agenda_paciente 
where	nr_sequencia	= nr_seq_agenda_p 
and	coalesce(cd_pessoa_fisica::text, '') = '';
 
/* Obter os dados da agenda */
 
select	PKG_DATE_UTILS.start_of(dt_agenda_p, 'month', 0), 
	substr(obter_compl_pf(cd_pessoa_fisica_p, 1,'CDM'),1,6)		 
into STRICT	dt_agenda_w, 
	cd_municipio_ibge_w
;
 
/* obter informação do procedimento */
 
select	coalesce(max(cd_area_procedimento),0), 
	coalesce(max(cd_especialidade),0), 
	coalesce(max(cd_grupo_proc),0), 
	coalesce(max(substr(sus_obter_seq_estrut_proc(sus_obter_estrut_proc(cd_procedimento, ie_origem_proced, 'C', 'F'),'F'),1,10)),0), 
	coalesce(max(substr(sus_obter_seq_estrut_proc(sus_obter_estrut_proc(cd_procedimento, ie_origem_proced, 'C', 'G'),'G'),1,10)),0), 
	coalesce(max(substr(sus_obter_seq_estrut_proc(sus_obter_estrut_proc(cd_procedimento, ie_origem_proced, 'C', 'S'),'S'),1,10)),0) 
into STRICT	cd_area_proced_w, 
	cd_espec_proced_w, 
	cd_grupo_proced_w, 
	nr_seq_forma_org_w, 
	nr_seq_grupo_w, 
	nr_seq_subgrupo_w 
from	estrutura_procedimento_v 
where	cd_procedimento	= cd_procedimento_p 
and	ie_origem_proced	= ie_origem_proced_p;
	 
/* Verifica se possui regra conforme os dados da agenda */
 
open C01;
loop 
fetch C01 into	 
	nr_seq_regra_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	nr_seq_regra_w	:= nr_seq_regra_w;		
	end;
end loop;
close C01;
	 
/* Se possuir regra */
 
if (nr_seq_regra_w > 0) then 
	begin		 
	/* Verifica se a regra permite agendamento */
 
	select	coalesce(max(ie_permite),'S') 
	into STRICT	ie_perm_agenda_w 
	from	agenda_regra 
	where	nr_sequencia = nr_seq_regra_w;
		 
	/* Se permite agendamento */
 
	if (ie_perm_agenda_w = 'S') then 
		begin 
		/* Obtém a quantidade mensal da cota por municipio */
 
		select	coalesce(max(qt_regra),0) 
		into STRICT	qt_regra_w 
		from	agenda_regra 
		where	nr_sequencia = nr_seq_regra_w;
		 
		/* Se a quantidade mensal for maior que zero gera os dados da cota por município */
 
		if (qt_regra_w	> 0) then 
			begin 
			/* Verifica a quantidade de agendamentos com os dados da regra */
 
			select	count(*) 
			into STRICT	qt_agenda_w 
			from	agenda_paciente 
			where	cd_agenda			= cd_agenda_p 
			and	PKG_DATE_UTILS.start_of(dt_agenda, 'month', 0)	= dt_agenda_w 
			and	ie_status_agenda		<> 'C' 
			/* OS 116811 - Jerusa - Eraldo solicitou a não restrição pelo médico executor 
			and	cd_medico_exec		= cd_medico_exec_p*/
 
			and	cd_convenio			= cd_convenio_p 
			and	cd_procedimento			= cd_procedimento_p 
			and	ie_origem_proced		= ie_origem_proced_p 
			and	coalesce(nr_seq_proc_interno, 0)	= nr_seq_proc_interno_p 
			and	substr(obter_compl_pf(cd_pessoa_fisica, 1,'CDM'),1,6) = cd_municipio_ibge_w;
			 
			select	count(*) 
			into STRICT	qt_proc_adic_w 
			from	agenda_paciente_proc b, 
				agenda_paciente a 
			where	a.nr_sequencia			= b.nr_sequencia 
			and	a.cd_agenda			= cd_agenda_p 
			and	PKG_DATE_UTILS.start_of(a.dt_agenda, 'month', 0)	= dt_agenda_w 
			and	a.ie_status_agenda	<> 'C' 
			/* OS 116811 - Jerusa - Eraldo solicitou a não restrição pelo médico executor 
			and	a.cd_medico_exec	= cd_medico_exec_p*/
 
			and	a.cd_convenio			= cd_convenio_p 
			and	b.cd_procedimento		= cd_procedimento_p 
			and	b.ie_origem_proced		= ie_origem_proced_p 
			and	coalesce(b.nr_seq_proc_interno, 0)	= nr_seq_proc_interno_p 
			and	substr(obter_compl_pf(a.cd_pessoa_fisica, 1,'CDM'),1,6) = cd_municipio_ibge_w;		
		 
			if (ie_novo_w = 'S') then 
				qt_agenda_w		:= qt_agenda_w + 1;
			end if;
			 
			if (ie_novo_registro_p = 'S') then 
				qt_proc_adic_w	:= qt_proc_adic_w + 1;
			end if;
		 
			qt_agenda_w	:= qt_agenda_w + qt_proc_adic_w;
		 
			/* Se possui agendamentos conforme as restrições */
 
			if (qt_agenda_w > 0) then 
				begin 
				 
				select 	coalesce(max(qt_saldo_proximo),0) 
				into STRICT	qt_saldo_proximo_w 
				from	agenda_paciente_cota_munic 
				where 	dt_mes_referencia = dt_agenda_w 
				and	cd_convenio			= cd_convenio_p 
				and	cd_procedimento			= cd_procedimento_p 
				and	ie_origem_proced		= ie_origem_proced_p 
				and	coalesce(nr_seq_proc_interno, 0)	= nr_seq_proc_interno_p 
				and	cd_municipio_ibge 		= cd_municipio_ibge_w;
					 
				delete from agenda_paciente_cota_munic 
				where 	dt_mes_referencia = dt_agenda_w 
				and	cd_convenio			= cd_convenio_p 
				and	cd_procedimento			= cd_procedimento_p 
				and	ie_origem_proced		= ie_origem_proced_p 
				and	coalesce(nr_seq_proc_interno, 0)	= nr_seq_proc_interno_p 
				and	cd_municipio_ibge 		= cd_municipio_ibge_w;		
				 
				qt_saldo_w	:= qt_regra_w - qt_agenda_w;
				 
				select	coalesce(max(qt_saldo_proximo),0) 
				into STRICT	qt_saldo_ant_w 
				from	agenda_paciente_cota_munic 
				where	dt_mes_referencia		= PKG_DATE_UTILS.ADD_MONTH(dt_Agenda_w, -1,0) 
				and	cd_convenio			= cd_convenio_p 
				and	cd_procedimento			= cd_procedimento_p 
				and	ie_origem_proced		= ie_origem_proced_p 
				and	coalesce(nr_seq_proc_interno, 0)	= nr_seq_proc_interno_p;
				 
				qt_saldo_w	:= qt_saldo_w	- qt_saldo_ant_w;
				 
				/* Insere os dados conforme a regra */
 
				insert into agenda_paciente_cota_munic( 
					nr_sequencia, 
					dt_atualizacao, 
					nm_usuario, 
					dt_mes_referencia, 
					qt_agendada, 
					qt_saldo, 
					cd_convenio, 
					--cd_medico, 
					cd_municipio_ibge, 
					qt_mensal, 
					cd_procedimento, 
					ie_origem_proced, 
					nr_seq_proc_interno, 
					qt_saldo_proximo) 
				values (	nextval('agenda_paciente_cota_munic_seq'), 
					clock_timestamp(), 
					nm_usuario_p, 
					dt_agenda_w, 
					qt_agenda_w, 
					qt_saldo_w, 
					cd_convenio_p, 
					--cd_medico_exec_p, 
					cd_municipio_ibge_w, 
					qt_regra_w, 
					cd_procedimento_p, 
					ie_origem_proced_p, 
					nr_seq_proc_interno_p, 
					qt_saldo_proximo_w);
				end;
			end if;/* Final - Se possui agendamentos conforme as restrições */
			end;
		end if;/* Final - Se a quantidade mensal for maior que zero gera os dados da cota por município */
		end;
	end if;/* Final - Se permite agendamento */
	end;
end if;/* Final - Se possuir regra */
	
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cota_municipio_agepac ( nr_seq_agenda_p bigint, cd_agenda_p bigint, dt_agenda_p timestamp, cd_pessoa_fisica_p text, cd_convenio_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, cd_medico_exec_p text, ie_novo_registro_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

