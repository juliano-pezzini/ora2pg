-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE define_adicional_horario (cd_estabelecimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_setor_atendimento_p bigint, ie_tipo_atendimento_p bigint, ie_carater_inter_sus_p text, dt_procedimento_p timestamp, ie_carater_cirurgia_p text, ie_video_p text, dt_inicio_cirurgia_p timestamp, dt_final_cirurgia_p timestamp, cd_tipo_acomodacao_p bigint, cd_medico_executor_p text, cd_plano_p text, dt_entrada_p timestamp, tx_medico_p INOUT bigint, tx_anestesista_p INOUT bigint, tx_auxiliares_p INOUT bigint, tx_custo_operacional_p INOUT bigint, tx_materiais_p INOUT bigint, tx_procedimento_p INOUT bigint, vl_proc_adicional_p INOUT bigint, vl_med_adicional_p INOUT bigint, cd_proced_calculo_p INOUT bigint, ie_origem_proced_calculo_p INOUT bigint, nr_seq_regra_p INOUT bigint, ie_clinica_p bigint, cd_edicao_amb_p bigint default null, nr_seq_proc_interno_p bigint DEFAULT NULL) AS $body$
DECLARE


dt_atualizacao_w    			timestamp		:= clock_timestamp();
cd_edicao_w			integer	:= 0;
cd_area_w			bigint	:= 0;
cd_especialidade_w		bigint	:= 0;
cd_grupo_w			bigint	:= 0;
dia_semana_w			smallint	:= 0;
dia_feriado_w			varchar(1) := 'N';
ie_prioridade_w  			smallint;
cd_setor_exclusivo_w		integer;
ie_tipo_atendimento_w		smallint;
cd_convenio_w			integer;
tx_medico_w    			double precision	:= 1;
tx_anestesista_w 			double precision	:= 1;
tx_auxiliares_w 			double precision	:= 1;
tx_custo_operacional_w		double precision	:= 1;
tx_materiais_w 			double precision	:= 1;
tx_procedimento_w			double precision	:= 1;
cd_procedimento_calculo_w		bigint;
ie_origem_proced_calculo_w		bigint;
ie_carater_inter_sus_w		varchar(2);
ie_tipo_feriado_w			varchar(15);

vl_adic_proc_w			double precision		:= 0;
vl_adic_medico_w			double precision		:= 0;
nr_seq_adic_w			bigint;
dt_cirurgia_w			timestamp;
cd_tipo_acomodacao_w		bigint;
ie_credenciado_w			varchar(1);
dt_vigencia_w			timestamp:= PKG_DATE_UTILS.get_Time(dt_procedimento_p,0);
ie_tipo_convenio_w		smallint;

c01 CURSOR FOR
	SELECT 	ie_prioridade,
		cd_setor_exclusivo,
		ie_tipo_atendimento,
		cd_convenio,
		coalesce(tx_medico,1),
		coalesce(tx_anestesista,1),
		coalesce(tx_auxiliares,1),
		coalesce(tx_custo_operacional,1),
		coalesce(tx_materiais,1),
		coalesce(tx_procedimento,1),
		cd_procedimento_calculo,
		ie_origem_proced_calculo,
		coalesce(vl_adicional_proc,0),
		coalesce(vl_adicional_medico,0),
		nr_sequencia
	from	proc_criterio_horario
	where	cd_estabelecimento				= cd_estabelecimento_p
	and	coalesce(cd_procedimento,cd_procedimento_p) 		= cd_procedimento_p
	and	coalesce(nr_seq_proc_interno,coalesce(nr_seq_proc_interno_p,0)) = coalesce(nr_seq_proc_interno_p,0)
	and	coalesce(ie_origem_proced,ie_origem_proced_p)	= ie_origem_proced_p
	and	coalesce(cd_area_proced,cd_area_w)		= cd_area_w
	and	coalesce(cd_especial_proced,cd_especialidade_w)	= cd_especialidade_w
	and	coalesce(cd_grupo_proced,cd_grupo_w)		= cd_grupo_w
	and	coalesce(cd_edicao_amb, coalesce(cd_edicao_w,0))	= coalesce(cd_edicao_w,0)
	and	coalesce(cd_convenio, cd_convenio_p)		= cd_convenio_p
	and	coalesce(cd_categoria, coalesce(cd_categoria_p, '0')) 	= coalesce(cd_categoria_p, '0')
	and	coalesce(cd_plano, coalesce(cd_plano_p,'0')) = coalesce(cd_plano_p,'0')
      	and	coalesce(ie_tipo_atendimento,ie_tipo_atendimento_p) 	= ie_tipo_atendimento_p
	/*and		((ie_carater_inter_sus is null) or (ie_carater_inter_sus = nvl(ie_carater_inter_sus_p,ie_carater_inter_sus)))*/

	and	coalesce(ie_carater_inter_sus,ie_carater_inter_sus_w) 	=  ie_carater_inter_sus_w
	and	((coalesce(ie_carater_cirurgia::text, '') = '') or (ie_carater_cirurgia 	= coalesce(ie_carater_cirurgia_p, ie_carater_cirurgia)))
	and	coalesce(cd_setor_exclusivo, cd_setor_atendimento_p) 	= cd_setor_atendimento_p
	and	coalesce(cd_tipo_acomodacao,cd_tipo_acomodacao_w)	= cd_tipo_acomodacao_w
	and 	((coalesce(ie_credenciado,'T') = 'T') or (coalesce(ie_credenciado,'T') = coalesce(ie_credenciado_w,'N')))
	and	coalesce(cd_medico_executor, coalesce(cd_medico_executor_p,'X'))		= coalesce(cd_medico_executor_p,'X')
	and	dt_vigencia_w between coalesce(dt_inicio_vigencia,dt_vigencia_w) and fim_dia(coalesce(dt_final_vigencia,dt_vigencia_w))
	and	((coalesce(ie_feriado,'N')				= dia_feriado_w ) or (coalesce(ie_feriado,'N')	='A'))
	and	((ie_tipo_feriado = ie_tipo_feriado_w) or (coalesce(ie_tipo_feriado::text, '') = ''))
	and	((coalesce(dt_dia_semana, dia_semana_w) = dia_semana_w) or (dt_dia_semana = 9))
	and 	(((coalesce(ie_hora_final_cirurgia,'N') = 'N') and (dt_procedimento_p between

			pkg_date_utils.get_time(dt_procedimento_p,coalesce(TO_CHAR(hr_inicial,'hh24:mi:ss'), '00:00:01'))

						and

				pkg_date_utils.get_time(dt_procedimento_p,coalesce(TO_CHAR(hr_final,'hh24:mi:ss'), '23:59:59'))))

			or
			((ie_hora_final_cirurgia ='S') and (dt_final_cirurgia_p IS NOT NULL AND dt_final_cirurgia_p::text <> '') and (dt_final_cirurgia_p between

				pkg_date_utils.get_time(dt_final_cirurgia_p, coalesce(TO_CHAR(hr_inicial,'hh24:mi:ss'), '00:00:01'))

						and

				pkg_date_utils.get_time(dt_final_cirurgia_p, coalesce(TO_CHAR(hr_final,'hh24:mi:ss'), '23:59:59'))))

			or
			((ie_hora_final_cirurgia ='C') and (Obter_se_adic_periodo_cir(
							dt_inicio_cirurgia_p,
							dt_final_cirurgia_p,
							hr_inicial,
							hr_final,
							dt_procedimento_p) = 'S'))
			or
			((ie_hora_final_cirurgia = 'I') and (dt_inicio_cirurgia_p IS NOT NULL AND dt_inicio_cirurgia_p::text <> '') and (dt_inicio_cirurgia_p between

				pkg_date_utils.get_time(dt_inicio_cirurgia_p, coalesce(TO_CHAR(hr_inicial,'hh24:mi:ss'), '00:00:01'))

						and

				pkg_date_utils.get_time(dt_inicio_cirurgia_p, coalesce(TO_CHAR(hr_final,'hh24:mi:ss'), '23:59:59')))))

	and		((ie_video = 'A') or (ie_video = ie_video_p))
	and		((coalesce(hr_vig_regra_atend::text, '') = '') or ((dt_entrada_p IS NOT NULL AND dt_entrada_p::text <> '') and (hr_vig_regra_atend >= (coalesce(dt_procedimento_p,clock_timestamp()) - dt_entrada_p) * 24)))
	and		((coalesce(ie_tipo_convenio, coalesce(ie_tipo_convenio_w,0)) = coalesce(ie_tipo_convenio_w,0)) or (coalesce(ie_tipo_convenio_w,0) = 0))
	and		coalesce(ie_clinica, coalesce(ie_clinica_p,0))	= coalesce(ie_clinica_p,0)
	order by
			coalesce(nr_seq_proc_interno,0),
			coalesce(cd_procedimento,0),
			coalesce(cd_grupo_proced,0),
			coalesce(cd_especial_proced,0),
			coalesce(cd_area_proced,0),
			coalesce(cd_tipo_acomodacao,0),
			coalesce(cd_setor_exclusivo,0),
			coalesce(ie_tipo_atendimento,0),
			coalesce(ie_carater_inter_sus,0),
			coalesce(cd_convenio,0),
			coalesce(ie_prioridade,0),
			coalesce(cd_edicao_amb,0),
			coalesce(ie_tipo_convenio,0),
			coalesce(cd_medico_executor,'X'),
			coalesce(ie_clinica,0);

BEGIN
ie_credenciado_w := obter_se_medico_conveniado(cd_estabelecimento_p, cd_medico_executor_p, cd_convenio_p, null, null, null, null, null, null, ie_tipo_atendimento_p,
			null, ie_carater_inter_sus_p);
dia_semana_w 		:= pkg_date_utils.get_WeekDay(dt_procedimento_p);
ie_carater_inter_sus_w	:= coalesce(ie_carater_inter_sus_p,'0');
cd_tipo_acomodacao_w	:= coalesce(cd_tipo_acomodacao_p,0);

/* obter feriado */

begin
select	'S',
	ie_tipo_feriado
into STRICT 	dia_feriado_w,
	ie_tipo_feriado_w
from 	feriado
where 	cd_estabelecimento 		= cd_estabelecimento_p
and 	pkg_date_utils.get_time(dt_feriado,0,0,0)  	= pkg_date_utils.get_time(dt_procedimento_p,0,0,0);
exception
            when others then
		dia_feriado_w	:= 'N';
		ie_tipo_feriado_w	:= '';
end;

/* obter estrutura do procedimento */

begin
select 	cd_grupo_proc,
		cd_especialidade,
		cd_area_procedimento
into STRICT		cd_grupo_w,
		cd_especialidade_w,
		cd_area_w
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

/*      obter ediçao da amb  */

/* ricardo 07/11/2006 retirada a rotina abaixo para obter a edição, para buscarmos pela function obter_edicao

begin
select	cd_edicao_amb
into		cd_edicao_w
from		convenio_amb
where		cd_estabelecimento	= cd_estabelecimento_p
and		cd_convenio		= cd_convenio_p
and		cd_categoria		= cd_categoria_p
and 		nvl(ie_situacao,'A')	= 'A'
and		dt_inicio_vigencia	=
		(select max(dt_inicio_vigencia)
			from		convenio_amb a
			where		a.cd_estabelecimento	= cd_estabelecimento_p
			and		a.cd_convenio		= cd_convenio_p


			and		a.cd_categoria		= cd_categoria_p
		   	and 		nvl(ie_situacao,'A')		= 'A'
			and		a.dt_inicio_vigencia 	<= dt_procedimento_p);
exception
		when others then
     		cd_edicao_w 	:= 0;
end;

*/
select	coalesce(max(ie_tipo_convenio),0)
into STRICT	ie_tipo_convenio_w
from	convenio
where	cd_convenio = cd_convenio_p;

if (coalesce(cd_edicao_amb_p,0) = 0) then
	begin
	select	obter_edicao(cd_estabelecimento_p, cd_convenio_p, cd_categoria_p, dt_procedimento_p, cd_procedimento_p)
	into STRICT	cd_edicao_w
	;
	exception
			when others then
			cd_edicao_w 	:= 0;
	end;
else
	cd_edicao_w:= cd_edicao_amb_p;
end if;

tx_medico_p			:= 1;
tx_anestesista_p		:= 1;
tx_auxiliares_p		:= 1;
tx_custo_operacional_p	:= 1;
tx_materiais_p		:= 1;
tx_procedimento_p		:= 1;

open c01;
loop
fetch c01 into
	ie_prioridade_w,
	cd_setor_exclusivo_w,
	ie_tipo_atendimento_w,
	cd_convenio_w,
	tx_medico_w,
	tx_anestesista_w,
	tx_auxiliares_w,
	tx_custo_operacional_w,
	tx_materiais_w,
	tx_procedimento_w,
	cd_procedimento_calculo_w,
	ie_origem_proced_calculo_w,
	vl_adic_proc_w,
	vl_adic_medico_w,
	nr_seq_adic_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	tx_medico_p		:= tx_medico_w;
	tx_anestesista_p		:= tx_anestesista_w;
	tx_auxiliares_p		:= tx_auxiliares_w;
	tx_custo_operacional_p	:= tx_custo_operacional_w;
	tx_materiais_p		:= tx_materiais_w;
	tx_procedimento_p		:= tx_procedimento_w;
	cd_proced_calculo_p	:= cd_procedimento_calculo_w;
	ie_origem_proced_calculo_p	:= ie_origem_proced_calculo_w;
	vl_proc_adicional_p		:= vl_adic_proc_w;
	vl_med_adicional_p		:= vl_adic_medico_w;
	nr_seq_regra_p		:= nr_seq_adic_w;
	end;
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE define_adicional_horario (cd_estabelecimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_setor_atendimento_p bigint, ie_tipo_atendimento_p bigint, ie_carater_inter_sus_p text, dt_procedimento_p timestamp, ie_carater_cirurgia_p text, ie_video_p text, dt_inicio_cirurgia_p timestamp, dt_final_cirurgia_p timestamp, cd_tipo_acomodacao_p bigint, cd_medico_executor_p text, cd_plano_p text, dt_entrada_p timestamp, tx_medico_p INOUT bigint, tx_anestesista_p INOUT bigint, tx_auxiliares_p INOUT bigint, tx_custo_operacional_p INOUT bigint, tx_materiais_p INOUT bigint, tx_procedimento_p INOUT bigint, vl_proc_adicional_p INOUT bigint, vl_med_adicional_p INOUT bigint, cd_proced_calculo_p INOUT bigint, ie_origem_proced_calculo_p INOUT bigint, nr_seq_regra_p INOUT bigint, ie_clinica_p bigint, cd_edicao_amb_p bigint default null, nr_seq_proc_interno_p bigint DEFAULT NULL) FROM PUBLIC;

