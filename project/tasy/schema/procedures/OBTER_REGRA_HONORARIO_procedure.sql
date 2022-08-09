-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_regra_honorario ( cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, dt_procedimento_p timestamp, ie_tipo_atendimento_p bigint, cd_setor_atendimento_p bigint, ie_tipo_servico_sus_p bigint, ie_tipo_ato_sus_p bigint, cd_medico_executor_p text, cd_pessoa_juridica_p text, ie_pacote_p text, ie_carater_atendimento_p text, cd_plano_p text, cd_regra_p INOUT text, ie_entra_conta_p INOUT text, ie_calcula_valor_p INOUT text, cd_cgc_p INOUT text, cd_pessoa_fisica_p INOUT text, nr_seq_criterio_p INOUT bigint, cd_especialidade_p bigint, cd_regra_hon_proc_princ_p text, cd_funcao_medico_p text, ie_clinica_p bigint, cd_empresa_p bigint, nr_seq_classif_medico_p bigint, cd_procedencia_p bigint, ie_doc_executor_p bigint, cd_cbo_p text, nr_seq_proc_interno_p bigint, nr_seq_exame_p bigint, ie_drg_item_p text default 'N', ie_drg_procedure_p text default 'N', vl_price_drg_p text default 0) AS $body$
DECLARE


cd_edicao_amb_w			integer		:= 0;
cd_grupo_w			bigint		:= 0;
cd_especialidade_w		bigint		:= 0;
cd_area_w			bigint		:= 0;
ie_credenciado_w		varchar(1);
ie_funcionario_w		varchar(1);
ie_corpo_clinico_w		varchar(1);
cd_especial_medica_w		integer		:= 0;
cd_regra_w			varchar(5)		:= '';
cd_regra_valida_w		varchar(5)		:= '';
nr_sequencia_w         		smallint		:= 0;
ie_especialidade_w		smallint		:= 0;
ie_entra_conta_w		varchar(1)		:= 'S';
ie_calcula_valor_w		varchar(1)		:= 'S';
cd_cgc_w			varchar(14);
cd_pessoa_fisica_w		varchar(10);
cd_medico_executor_w		varchar(10);
cd_pessoa_juridica_w		varchar(14);
nr_seq_criterio_w		bigint;
nr_seq_criterio_valido_w	bigint;
ie_tipo_convenio_w		smallint;
ie_vinculo_medico_w		smallint;
dia_feriado_w			varchar(1) := 'N';
dia_semana_w			smallint	:= 0;
ie_prioridade_edicao_w		varchar(01);

nr_seq_forma_org_w		bigint := 0;
nr_seq_grupo_w			bigint := 0;
nr_seq_subgrupo_w		bigint := 0;

vl_ch_honorarios_w		double precision	:= 0;
vl_ch_custo_oper_w		double precision	:= 0;
vl_m2_filme_w			double precision	:= 0;
dt_inicio_vigencia_w		timestamp;
tx_ajuste_geral_w		double precision	:= 0;
ie_carater_atendimento_w	varchar(10);
cd_plano_w			varchar(10);
cd_regra_hon_proc_princ_w	varchar(10);
cd_funcao_medico_w		bigint;
nr_seq_cbhpm_edicao_w		bigint;
nr_seq_terceiro_w		bigint;
cd_tipo_procedimento_w		smallint;
qt_regra_terceiro_w		bigint;


c01 CURSOR FOR
	SELECT 	a.cd_especialidade_medica,
		a.cd_regra,
		b.ie_entra_conta,
		b.ie_calcula_valor,
		b.cd_cgc,
		b.cd_pessoa_fisica,
		a.nr_sequencia
	from 	regra_honorario_criterio a,
		regra_honorario b
	where	a.cd_regra					= b.cd_regra
	and	b.ie_situacao					= 'A'
	and 	a.cd_estabelecimento      			= cd_estabelecimento_p
	and	coalesce(a.cd_procedimento,cd_procedimento_p)	= cd_procedimento_p
	and	((coalesce(cd_procedimento::text, '') = '') or (coalesce(a.ie_origem_proced,ie_origem_proced_p)= ie_origem_proced_p))
	and	coalesce(a.cd_area_procedimento,cd_area_w)		= cd_area_w
	and	coalesce(a.cd_especialidade,cd_especialidade_w)	= cd_especialidade_w
	and	coalesce(a.cd_grupo_proc,cd_grupo_w)			= cd_grupo_w
	and	coalesce(a.nr_seq_grupo,nr_seq_grupo_w)		= nr_seq_grupo_w
	and	coalesce(a.nr_seq_subgrupo,nr_seq_subgrupo_w)	= nr_seq_subgrupo_w
	and	coalesce(a.nr_seq_forma_org,nr_seq_forma_org_w)	= nr_seq_forma_org_w
	and	coalesce(a.cd_edicao_amb,cd_edicao_amb_w)		= cd_edicao_amb_w
	and	coalesce(a.cd_convenio, cd_convenio_p)		= cd_convenio_p
	and	((coalesce(a.ie_drg,3) = 3) or (a.ie_drg = 1 and ie_drg_item_p = 'S') or (a.ie_drg = 2 and ie_drg_procedure_p = 'S'))
	and	((coalesce(a.ie_value_drg,3) = 3) or (a.ie_value_drg = 1 and coalesce(vl_price_drg_p,0) > 0) or (a.ie_value_drg = 2 and coalesce(vl_price_drg_p,0) <= 0))
	and	coalesce(a.ie_tipo_convenio, coalesce(ie_tipo_convenio_w, 0))	= coalesce(ie_tipo_convenio_w, 0)
	and	coalesce(a.cd_categoria, coalesce(cd_categoria_p, '0'))	= coalesce(cd_categoria_p, '0')
	and 	coalesce(a.ie_tipo_atendimento,ie_tipo_atendimento_p) = ie_tipo_atendimento_p
	and	coalesce(a.cd_setor_atendimento, cd_setor_atendimento_p) = cd_setor_atendimento_p
	and	coalesce(a.ie_carater_internacao, ie_carater_atendimento_w) = ie_carater_atendimento_w
	and	coalesce(a.cd_funcao_medico,cd_funcao_medico_w)	= cd_funcao_medico_w
	and 	coalesce(a.cd_especialidade_medica, coalesce(cd_especialidade_p,0)) = coalesce(cd_especialidade_p,0)
	and	coalesce(a.cd_plano, cd_plano_w) 			= cd_plano_w
	and	((coalesce(a.cd_empresa, coalesce(cd_empresa_p,0)) = coalesce(cd_empresa_p,0)) or (coalesce(cd_empresa_p,0) = 0))
	and 	coalesce(a.ie_situacao,'A') = 'A'
	and	coalesce(a.cd_medico, cd_medico_executor_w)		= cd_medico_executor_w
	and 	((coalesce(a.nr_seq_equipe::text, '') = '') or (obter_se_medico_equipe(a.nr_seq_equipe, cd_medico_executor_w) = 'S'))
	and	coalesce(a.cd_cgc, cd_pessoa_juridica_w)		= cd_pessoa_juridica_w
	and 	coalesce(a.ie_vinculo_medico, ie_vinculo_medico_w) 	= ie_vinculo_medico_w
	and	((a.ie_credenciado	= 'T') or (a.ie_credenciado 	= ie_credenciado_w))
	and	((a.ie_funcionario	= 'T') or (a.ie_funcionario 	= ie_funcionario_w))
	and	((a.ie_corpo_clinico	= 'T') or (a.ie_corpo_clinico	= ie_corpo_clinico_w))
	and	dt_procedimento_p between coalesce(dt_inicio_vigencia, dt_procedimento_p) and
		pkg_date_utils.get_time(coalesce(dt_final_vigencia,dt_procedimento_p),'23:59:59')
	and	coalesce(a.ie_tipo_servico_sus, coalesce(ie_tipo_servico_sus_p,0)) = coalesce(ie_tipo_servico_sus_p,0)
	and	coalesce(a.ie_tipo_ato_sus, coalesce(ie_tipo_ato_sus_p,0)) = coalesce(ie_tipo_ato_sus_p,0)
	and 	((coalesce(a.ie_pacote,'A') = 'A')  or (a.ie_pacote = ie_pacote_p))
	and	coalesce(a.cd_regra_hon_proc_princ,cd_regra_hon_proc_princ_w)= cd_regra_hon_proc_princ_w
	and	coalesce(a.ie_clinica, coalesce(ie_clinica_p, 0))	= coalesce(ie_clinica_p, 0)
	--and	((ie_feriado is null) or (nvl(ie_feriado,'N')				= dia_feriado_w))
	and	((coalesce(ie_feriado,'A')	='A') or (coalesce(ie_feriado,'A') 	= dia_feriado_w ))
	and	coalesce(a.nr_seq_terceiro, coalesce(nr_seq_terceiro_w, 0))	= coalesce(nr_seq_terceiro_w, 0)
	and	((coalesce(dt_dia_semana, dia_semana_w) = dia_semana_w) or (dt_dia_semana = 9))
	and (dt_procedimento_p between
		pkg_date_utils.get_DateTime(dt_procedimento_p, coalesce(hr_inicial,  pkg_date_utils.get_Time(00,00,00))) and
		pkg_date_utils.get_DateTime(dt_procedimento_p, coalesce(hr_final, pkg_date_utils.get_Time(23,59,59))))
	and	coalesce(nr_seq_classif_medico,coalesce(nr_seq_classif_medico_p,0)) = coalesce(nr_seq_classif_medico_p,0)
	and	coalesce(a.cd_procedencia,coalesce(cd_procedencia_p,0)) = coalesce(cd_procedencia_p,0)
	and	coalesce(a.ie_doc_executor,coalesce(ie_doc_executor_p,0)) = coalesce(ie_doc_executor_p,0)
	and	coalesce(a.cd_cbo,coalesce(cd_cbo_p,0)) = coalesce(cd_cbo_p,0)
	and	coalesce(a.cd_tipo_procedimento,coalesce(cd_tipo_procedimento_w,0)) = coalesce(cd_tipo_procedimento_w,0)
	and	coalesce(a.nr_seq_proc_interno, coalesce(nr_seq_proc_interno_p,0)) = coalesce(nr_seq_proc_interno_p,0)
	and	coalesce(a.nr_seq_exame, coalesce(nr_seq_exame_p,0)) = coalesce(nr_seq_exame_p,0)
	order by	coalesce(dt_dia_semana,9) desc,
		coalesce(a.cd_medico,0),
		coalesce(a.cd_cgc, 0),
		coalesce(a.cd_setor_atendimento,0),
		coalesce(a.nr_seq_proc_interno,0),
		coalesce(a.nr_seq_exame,0),
		coalesce(a.cd_procedimento,0),
		coalesce(a.nr_seq_forma_org,0),
		coalesce(a.nr_seq_subgrupo,0),
		coalesce(a.nr_seq_grupo,0),
		coalesce(a.cd_grupo_proc,0),
		coalesce(a.cd_especialidade,0),
		coalesce(a.cd_area_procedimento,0),
		coalesce(a.cd_convenio,0),
		coalesce(a.ie_tipo_atendimento,0),
		coalesce(a.cd_plano,' '),
		a.ie_credenciado desc,
		coalesce(a.cd_especialidade_medica,0),
		coalesce(a.cd_funcao_medico,0),
		coalesce(a.cd_edicao_amb,0),
		coalesce(a.ie_tipo_servico_sus, 0),
		coalesce(a.ie_tipo_ato_sus, 0),
		coalesce(nr_seq_classif_medico,0),
		coalesce(a.nr_seq_equipe,0),
		coalesce(a.ie_doc_executor,0),
		coalesce(a.cd_procedencia,0),
		coalesce(cd_tipo_procedimento,0),
		coalesce(a.ie_pacote,'A'),
		coalesce(a.cd_cbo,0);

BEGIN

select	coalesce(max(ie_prioridade_edicao_amb), 'N')
into STRICT	ie_prioridade_edicao_w
from	parametro_faturamento
where	cd_estabelecimento	= 1;

select 	count(*)
into STRICT	qt_regra_terceiro_w
from 	regra_honorario_criterio
where 	(nr_seq_terceiro IS NOT NULL AND nr_seq_terceiro::text <> '');

if (qt_regra_terceiro_w > 0) then
	begin
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_terceiro_w
	from 	terceiro a
	where 	a.cd_estabelecimento = cd_estabelecimento_p
	and 	a.ie_situacao = 'A'
	and	exists (SELECT 1
				from 	terceiro_pessoa_fisica	x
				where	x.cd_pessoa_fisica	= cd_medico_executor_p
				and		x.nr_seq_terceiro	= a.nr_sequencia
				and 	pkg_date_utils.start_of(dt_procedimento_p,'DD') between coalesce(dt_inicio_vigencia, pkg_date_utils.start_of(dt_procedimento_p,'DD')) and pkg_date_utils.end_of(coalesce(dt_fim_vigencia,dt_procedimento_p), 'DAY'));
	exception
		when others then
		nr_seq_terceiro_w	:= 0;
	end;
else
	nr_seq_terceiro_w	:= 0;
end if;

cd_regra_valida_w		:= '';
cd_medico_executor_w		:= coalesce(cd_medico_executor_p,'0');
cd_pessoa_juridica_w		:= coalesce(cd_pessoa_juridica_p,'0');
ie_carater_atendimento_w	:= coalesce(ie_carater_atendimento_p, '00');
cd_plano_w			:= coalesce(cd_plano_p, '0');
cd_regra_hon_proc_princ_w	:= coalesce(cd_regra_hon_proc_princ_p,'0');
cd_funcao_medico_w		:= somente_numero(cd_funcao_medico_p);

select	max(ie_tipo_convenio)
into STRICT	ie_tipo_convenio_w
from	convenio
where	cd_convenio	= cd_convenio_p;

dia_semana_w := pkg_date_utils.get_WeekDay(dt_procedimento_p);

/* obter feriado */

begin
select 	'S'
into STRICT 		dia_feriado_w
from 		feriado
where 	cd_estabelecimento 			= cd_estabelecimento_p
and 		pkg_date_utils.get_time(dt_feriado,0,0,0)  	= pkg_date_utils.get_time(dt_procedimento_p,0,0,0);
exception
            when others then
		dia_feriado_w	:= 'N';
end;

begin
/* Trocado pela function abaixo. OS 334552 - aaheckler
select	nvl(ie_vinculo_medico,0)
into	ie_vinculo_medico_w
from 	medico
where 	cd_pessoa_fisica = cd_medico_executor_w;*/
select	coalesce(max(obter_vinculo_medico(cd_medico_executor_w, cd_estabelecimento_p)),0)
into STRICT	ie_vinculo_medico_w
;
exception
	when others then
	ie_vinculo_medico_w:= 0;
end;


/* obter estrutura do procedimento */

begin
select 	cd_grupo_proc,
	cd_especialidade,
	cd_area_procedimento,
	cd_tipo_procedimento
into STRICT	cd_grupo_w,
	cd_especialidade_w,
	cd_area_w,
	cd_tipo_procedimento_w
from		estrutura_procedimento_v
where		cd_procedimento 	= cd_procedimento_p
and		ie_origem_proced	= ie_origem_proced_p;
exception
     		when others then
		begin
		cd_grupo_w		:= 0;
		cd_especialidade_w	:= 0;
		cd_area_w		:= 0;
		end;
end;

/* obter estrutura do procedimento sus unificado*/

select	coalesce(substr(sus_obter_seq_estrut_proc(sus_obter_estrut_proc(cd_procedimento_p, ie_origem_proced_p, 'C', 'F'),'F'),1,10),0),
	coalesce(substr(sus_obter_seq_estrut_proc(sus_obter_estrut_proc(cd_procedimento_p, ie_origem_proced_p, 'C', 'G'),'G'),1,10),0),
	coalesce(substr(sus_obter_seq_estrut_proc(sus_obter_estrut_proc(cd_procedimento_p, ie_origem_proced_p, 'C', 'S'),'S'),1,10),0)
into STRICT	nr_seq_forma_org_w,
	nr_seq_grupo_w,
	nr_seq_subgrupo_w
;

/*      obter ediçao da amb  */

if (ie_tipo_convenio_w = 3) then
	cd_edicao_amb_w 	:= 0;
elsif (ie_prioridade_edicao_w	= 'N' ) then
	begin
	select	cd_edicao_amb
	into STRICT	cd_edicao_amb_w
	from	convenio_amb
	where	cd_estabelecimento	= cd_estabelecimento_p
	and	cd_convenio			= cd_convenio_p
	and	cd_categoria		= cd_categoria_p
	and 	coalesce(ie_situacao,'A')	= 'A'
	and	dt_inicio_vigencia	=
		(SELECT max(dt_inicio_vigencia)
			from		convenio_amb a
			where		a.cd_estabelecimento	= cd_estabelecimento_p
			and		a.cd_convenio		= cd_convenio_p
			and		a.cd_categoria		= cd_categoria_p
		      and 		coalesce(ie_situacao,'A')	= 'A'
			and		a.dt_inicio_vigencia 	<= dt_procedimento_p);
	exception
		when others then
     			cd_edicao_amb_w 	:= 0;
	end;
else
	begin
	SELECT * FROM obter_edicao_proc_conv(cd_estabelecimento_p, cd_convenio_p, cd_categoria_p, dt_procedimento_p, cd_procedimento_p, cd_edicao_amb_w, vl_ch_honorarios_w, vl_ch_custo_oper_w, vl_m2_filme_w, dt_inicio_vigencia_w, tx_ajuste_geral_w, nr_seq_cbhpm_edicao_w) INTO STRICT cd_edicao_amb_w, vl_ch_honorarios_w, vl_ch_custo_oper_w, vl_m2_filme_w, dt_inicio_vigencia_w, tx_ajuste_geral_w, nr_seq_cbhpm_edicao_w;
	end;
end if;

/*      obter indicador de medico credenciado  */


/*select		nvl(max(ie_conveniado), 'X')
into		ie_credenciado_w
from		medico_convenio
where		cd_pessoa_fisica		= cd_medico_executor_p
and		cd_convenio			= cd_convenio_p
and		cd_prestador			= nvl(cd_pessoa_juridica_p, '0');

if	(ie_credenciado_w	= 'X') then
	begin
	select		nvl(ie_conveniado,'N')
	into		ie_credenciado_w
	from		medico_convenio
	where		cd_pessoa_fisica		= cd_medico_executor_p
	and		cd_convenio			= cd_convenio_p
	and		cd_prestador			is null;
	exception
		when others then
     		ie_credenciado_w 	:= 'N';
	end;
end if;*/


/* substituída a rotina acima por essa abaixo os 86907 11/06/2008 fabrício */

select 	obter_se_medico_credenciado(cd_estabelecimento_p, cd_medico_executor_p, cd_convenio_p, cd_pessoa_juridica_p, cd_especialidade_p, cd_categoria_p,
		cd_setor_atendimento_p, cd_plano_p, dt_procedimento_p, ie_tipo_atendimento_p, cd_funcao_medico_p, coalesce(ie_carater_atendimento_p,'0'))
into STRICT	ie_credenciado_w
;

/*      obter indicador de medico do corpo clínico */

select	coalesce(max(ie_corpo_clinico),'N'),
	CASE WHEN coalesce(max(ie_vinculo_medico),'99')='1' THEN 'S'  ELSE 'N' END
into STRICT	ie_corpo_clinico_w,
	ie_funcionario_w
from	medico
where	cd_pessoa_fisica	= cd_medico_executor_p;

cd_edicao_amb_w	:= coalesce(cd_edicao_amb_w,0);

open c01;
loop
fetch c01 into
		cd_especial_medica_w,
		cd_regra_w,
		ie_entra_conta_w,
		ie_calcula_valor_w,
		cd_cgc_w,
		cd_pessoa_fisica_w,
		nr_seq_criterio_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	if (coalesce(cd_especial_medica_w::text, '') = '') then
		cd_regra_valida_w		:= cd_regra_w;
		nr_seq_criterio_valido_w	:= nr_seq_criterio_w;	-- edgar 14/04/2006, os 30827, coloquei tratamento de nr_seq_criterio_valido_w
	else
		begin
		select 	cd_regra_w,
			nr_seq_criterio_w
		into STRICT	cd_regra_valida_w,
			nr_seq_criterio_valido_w
		from	medico_especialidade
		where	cd_pessoa_fisica	= cd_medico_executor_p
		and	cd_especialidade	= cd_especial_medica_w;
		exception
			when others then
    				cd_regra_valida_w		:= cd_regra_valida_w;
				nr_seq_criterio_valido_w	:= nr_seq_criterio_valido_w;
		end;
	end if;
	end;
end loop;
close c01;

cd_regra_p			:= cd_regra_valida_w;
nr_seq_criterio_p		:= nr_seq_criterio_valido_w;

begin
select 	coalesce(ie_entra_conta,'S'),
	coalesce(ie_calcula_valor,'S'),
	cd_cgc,
	cd_pessoa_fisica
into STRICT
	ie_entra_conta_w,
	ie_calcula_valor_w,
	cd_cgc_w,
	cd_pessoa_fisica_w
from	regra_honorario
where	cd_regra		= cd_regra_valida_w;
exception
	when others then
		begin
		ie_entra_conta_w	:= 'S';
		ie_calcula_valor_w	:= 'S';
		end;
end;

ie_entra_conta_p		:= ie_entra_conta_w;
ie_calcula_valor_p		:= ie_calcula_valor_w;
cd_cgc_p			:= cd_cgc_w;
cd_pessoa_fisica_p		:= cd_pessoa_fisica_w;
--nr_seq_criterio_p		:= nr_seq_criterio_w;	-- edgar 14/04/2006, os 30827, tirie pois coloquei tratamento de nr_seq_criterio_valido_w
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_regra_honorario ( cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, dt_procedimento_p timestamp, ie_tipo_atendimento_p bigint, cd_setor_atendimento_p bigint, ie_tipo_servico_sus_p bigint, ie_tipo_ato_sus_p bigint, cd_medico_executor_p text, cd_pessoa_juridica_p text, ie_pacote_p text, ie_carater_atendimento_p text, cd_plano_p text, cd_regra_p INOUT text, ie_entra_conta_p INOUT text, ie_calcula_valor_p INOUT text, cd_cgc_p INOUT text, cd_pessoa_fisica_p INOUT text, nr_seq_criterio_p INOUT bigint, cd_especialidade_p bigint, cd_regra_hon_proc_princ_p text, cd_funcao_medico_p text, ie_clinica_p bigint, cd_empresa_p bigint, nr_seq_classif_medico_p bigint, cd_procedencia_p bigint, ie_doc_executor_p bigint, cd_cbo_p text, nr_seq_proc_interno_p bigint, nr_seq_exame_p bigint, ie_drg_item_p text default 'N', ie_drg_procedure_p text default 'N', vl_price_drg_p text default 0) FROM PUBLIC;
