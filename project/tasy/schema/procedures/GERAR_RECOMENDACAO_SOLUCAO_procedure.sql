-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_recomendacao_solucao ( nr_prescricao_p bigint, cd_setor_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

					
cd_item_w		bigint;
ie_tipo_item_w		varchar(1);
cd_recomendacao_w	bigint;
cont_w			bigint;
nr_seq_topografia_w	bigint;
ie_faose_w		varchar(15);
ie_se_necessario_w	varchar(1);
ie_acm_w		varchar(1);
cd_intervalo_w		varchar(7);
cd_intervalo_ww		varchar(7);
ds_complemento_w	varchar(2000);	
nr_sequencia_w		bigint;
nr_ocorrencia_w		bigint := 0;
ds_horario1_w		varchar(255);
ds_horario2_w		varchar(255);
dt_inicio_prescr_w	timestamp;
dt_inicio_interv_w	timestamp;
nr_horas_validade_w	integer;
hr_prim_horario_w	varchar(5);
VarPrimHorarioRec_w	varchar(50);
dt_primeiro_horario_w	timestamp;
hr_prim_horario_rec_w	varchar(255);
ie_urgencia_w			varchar(1);
VarParam_968_w			varchar(10);
ie_agora_w				varchar(1);
ie_primeiro_dia_w		varchar(1);
nr_sequencia_anterior_w	bigint;
ie_via_aplicacao_w			via_aplicacao.ie_via_aplicacao%type;
cd_convenio_w               atend_categoria_convenio.cd_convenio%type;
nr_seq_agrupamento_w        setor_atendimento.nr_seq_agrupamento%type;
cd_perfil_ativo_w           prescr_material.cd_perfil_ativo%type;
nr_atendimento_w			prescr_medica.nr_atendimento%type;
dt_inicio_prescr_cpoe_w		prescr_medica.dt_inicio_prescr%type;
dt_liberacao_w				prescr_medica.dt_liberacao%type;


c01 CURSOR FOR
SELECT	cd_material	cd_item,
		'M'		ie_tipo_item,
		coalesce(nr_sequencia_anterior,0) nr_seq_anterior,
		ie_via_aplicacao,
		cd_perfil_ativo
from	prescr_material
where	nr_prescricao 	 	= nr_prescricao_p
and	ie_agrupador		in (1,8,12,4)

union all

select	cd_dieta	cd_item,
		'D'		ie_tipo_item,
		0 nr_seq_anterior,
		ie_via_aplicacao,
		cd_perfil_ativo
from	prescr_dieta
where	nr_prescricao		= nr_prescricao_p;

c02 CURSOR FOR
SELECT	cd_recomendacao,
	nr_seq_topografia,
	ie_faose,
	ie_se_necessario,
	ie_acm,
	cd_intervalo,
	coalesce(ie_primeiro_dia,'N')
from	rep_recomendacao_solucao
where	((cd_material			= cd_item_w AND ie_tipo_item_w 		= 'M') or
	 (cd_dieta			= cd_item_w AND ie_tipo_item_w		= 'D'))
and	cd_setor_atendimento 	= cd_setor_atendimento_p
and	coalesce(ie_via_aplicacao,ie_via_aplicacao_w)	= ie_via_aplicacao_w
and	coalesce(ie_forma_lancamento,'L')	= 'L';

c03 CURSOR FOR
SELECT
	cd_kit
from	kit_mat_recomendacao
where	cd_recomendacao = cd_recomendacao_w
and (coalesce(cd_perfil::text, '') = '' or cd_perfil = cd_perfil_ativo_w)
and (coalesce(cd_convenio::text, '') = '' or cd_convenio = cd_convenio_w)
and (coalesce(nr_seq_agrupamento::text, '') = '' or nr_seq_agrupamento = nr_seq_agrupamento_w)
and (coalesce(cd_setor_atendimento::text, '') = '' or cd_setor_atendimento = cd_setor_atendimento_p);

BEGIN

select	count(*)
into STRICT	cont_w
from	rep_recomendacao_solucao;

VarParam_968_w := obter_Param_Usuario(924, 968, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, VarParam_968_w);

if (cont_w	> 0) then
	open c01;
	loop
	fetch c01 into
		cd_item_w,
		ie_tipo_item_w,
		nr_sequencia_anterior_w,
		ie_via_aplicacao_w,
		cd_perfil_ativo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		
		open C02;
		loop
		fetch C02 into	
			cd_recomendacao_w,
			nr_seq_topografia_w,
			ie_faose_w,
			ie_se_necessario_w,
			ie_acm_w,
			cd_intervalo_w,
			ie_primeiro_dia_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			
			if (ie_primeiro_dia_w	= 'N') or (nr_sequencia_anterior_w = 0) then

				select	cd_intervalo,
					ds_complemento,
					coalesce(ie_urgencia,'N')
				into STRICT	cd_intervalo_ww,
					ds_complemento_w,
					ie_urgencia_w
				from	tipo_recomendacao
				where	cd_tipo_recomendacao = cd_recomendacao_w;
				
				
				if (ie_urgencia_w = 'S')  then
			
					ie_agora_w := obter_se_intervalo_agora(coalesce(cd_intervalo_w,cd_intervalo_ww));
			
					if (ie_agora_w 	= 'N') 	and (ie_urgencia_w 	= 'S')	then
						
						select	max(cd_intervalo)
						into STRICT	cd_intervalo_w
						from 	intervalo_prescricao
						where 	ie_agora = 'S'
						and 	((coalesce(cd_estabelecimento::text, '') = '') or (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento))
						and 	Obter_se_intervalo(cd_intervalo,'R') = 'S'
						and 	ie_situacao = 'A';
					end if;
				end if;
				

				select	max(to_char(coalesce(dt_primeiro_horario,dt_inicio_prescr),'hh24:mi')),
					max(dt_inicio_prescr),
					max(nr_horas_validade),
					max(dt_primeiro_horario),
					max(obter_convenio_atendimento(nr_atendimento))
				into STRICT	hr_prim_horario_w,
					dt_inicio_prescr_w,
					nr_horas_validade_w,
					dt_primeiro_horario_w,
					cd_convenio_w
				from	prescr_medica
				where	nr_prescricao	= nr_prescricao_p;

				select
					max(nr_seq_agrupamento)
				into STRICT	nr_seq_agrupamento_w
				from	setor_atendimento
				where	cd_setor_atendimento = cd_setor_atendimento_p;
				
				if (coalesce(dt_primeiro_horario_w::text, '') = '') then
					dt_primeiro_horario_w := dt_inicio_prescr_w;
				end if;

				dt_inicio_interv_w	:= trunc(ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_primeiro_horario_w, coalesce(hr_prim_horario_w, '00:00')), 'mi');
				nr_ocorrencia_w		:= 0;
				
				select	max(Obter_primeiro_horario(coalesce(cd_intervalo_w,cd_intervalo_ww), nr_prescricao_p, 0, null))
				into STRICT	hr_prim_horario_rec_w
				;
				
				begin
				VarPrimHorarioRec_w := obter_Param_Usuario(924, 208, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, VarPrimHorarioRec_w);
				exception when others then
					null;
				end;
				
				if (hr_prim_horario_rec_w IS NOT NULL AND hr_prim_horario_rec_w::text <> '') and (VarPrimHorarioRec_w = 'S') then
					hr_prim_horario_w   := hr_prim_horario_rec_w;

					dt_inicio_interv_w  := trunc(ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_primeiro_horario_w, coalesce(hr_prim_horario_rec_w, '00:00')), 'mi');
				end if;
				
				SELECT * FROM Calcular_Horario_Prescricao(nr_prescricao_p, coalesce(cd_intervalo_w,cd_intervalo_ww), dt_inicio_prescr_w, dt_inicio_interv_w, nr_horas_validade_w, null, null, null, nr_ocorrencia_w, ds_horario1_w, ds_horario2_w, 'N', null) INTO STRICT nr_ocorrencia_w, ds_horario1_w, ds_horario2_w;
						
				ds_horario1_w := ds_horario1_w || ds_horario2_w;

				select	reordenar_horarios(dt_inicio_interv_w, ds_horario1_w) || ' '
				into STRICT	ds_horario1_w
				;
											
				select	coalesce(max(nr_sequencia),0) + 1
				into STRICT	nr_sequencia_w
				from 	prescr_recomendacao
				where	nr_prescricao	= nr_prescricao_p;
				
				insert into prescr_recomendacao(
								cd_recomendacao,
								nr_prescricao,
								nr_sequencia,
								ie_destino_rec,
								dt_atualizacao,
								nm_usuario,
								ds_recomendacao,
								cd_intervalo,
								ds_horarios,
                                hr_prim_horario,
								nr_seq_topografia,
								ie_faose,
								ie_se_necessario,
								ie_acm,
								ie_urgencia)
					values (
								cd_recomendacao_w,
								nr_prescricao_p,
								nr_sequencia_w,
								'E',
								clock_timestamp(),
								nm_usuario_p,	
								ds_complemento_w,
								coalesce(cd_intervalo_w,cd_intervalo_ww),
								ds_horario1_w,
                                hr_prim_horario_w,
								nr_seq_topografia_w,
								ie_faose_w,
								ie_se_necessario_w,
								ie_acm_w,
								ie_urgencia_w);	
				if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
				
				if (VarParam_968_w = 'S') then
					for c03_w in c03
					loop
						CALL inserir_kit_recomendacao(nm_usuario_p, nr_prescricao_p, nr_sequencia_w, cd_recomendacao_w, c03_w.cd_kit);
					end loop;

					CALL Gerar_Kit_rec_Prescricao(wheb_usuario_pck.get_cd_estabelecimento, nr_prescricao_p, nr_sequencia_w, nm_usuario_p);
				end if;
				
			
			end if;	
		end loop;
		close C02;	

	end loop;
	close c01;
	if ((cd_recomendacao_w IS NOT NULL AND cd_recomendacao_w::text <> '') and obter_funcao_origem_prescr(nr_prescricao_p) = 2314) then
		
		select	nr_atendimento,
				dt_inicio_prescr,
				dt_liberacao_medico
		into STRICT	nr_atendimento_w,
				dt_inicio_prescr_cpoe_w,
				dt_liberacao_w
		from	prescr_medica
		where	nr_prescricao	= nr_prescricao_p;
		CALL CPOE_REP_Gerar_recomendacao(nr_prescricao_p,
				nr_atendimento_w,
				dt_inicio_prescr_cpoe_w,
				dt_inicio_prescr_cpoe_w + 1 - 1/1440,
				dt_liberacao_w,
				nm_usuario_p,
				wheb_usuario_pck.get_cd_funcao,
				cd_setor_atendimento_p);
		
	end if;
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_recomendacao_solucao ( nr_prescricao_p bigint, cd_setor_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

