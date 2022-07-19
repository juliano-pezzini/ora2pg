-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE verifica_dose_minima_onc ( nr_seq_atendimento_p bigint, nr_sequencia_p bigint, ie_utiliza_horarios_p text, ds_erro_p INOUT text, ds_erro2_p INOUT text, ie_forma_consistencia_p INOUT text) AS $body$
DECLARE


qt_max_prescricao_w		double precision;
cd_unidade_medida_consumo_w	varchar(30);
cd_unid_med_limite_w		varchar(30);
qt_limite_pessoa_w		double precision;
qt_dose_min_w			double precision;
qt_conversao_dose_w		double precision;
qt_conversao_dose_limite_w	double precision;
qt_dose_w			double precision;
qt_dose_ww			double precision;
qt_dose_limite_w		double precision;
cd_unidade_medida_dose_w	varchar(30);
cd_pessoa_fisica_w		varchar(30);
cd_material_w			integer;
ie_dose_limite_w		varchar(15);
nr_ocorrencia_w			double precision;
ie_via_aplicacao_w		varchar(5);
ie_justificativa_w		varchar(5);
ds_justificativa_w		varchar(2000);
cd_prescritor_w			varchar(50);
cd_setor_atendimento_w		integer;
qt_regra_w			bigint;
qt_idade_w			bigint;
qt_peso_w			real;
qt_limite_peso_w		double precision;
nr_seq_paciente_w		bigint;
qt_sc_w				double precision := 0;
qt_altura_w			double precision;
nr_ciclos_w			bigint;
cd_protocolo_w			bigint;
nr_seq_medicacao_w		integer;
ie_forma_consistencia_w	varchar(10);

c01 CURSOR FOR
	SELECT	coalesce(qt_dose_min,0),
		coalesce(ie_dose_limite,'DOSE'),
		cd_unid_med_limite,
		coalesce(ie_justificativa,'S'),
		ie_forma_consistencia
	from	material_prescr
	where	cd_material							= cd_material_w
	and	coalesce(cd_setor_atendimento, coalesce(cd_setor_atendimento_w,0))	= coalesce(cd_setor_atendimento_w,0)
	and	coalesce(ie_via_aplicacao, coalesce(ie_via_aplicacao_w,0))		= coalesce(ie_via_aplicacao_w,0)
	and	(qt_limite_pessoa IS NOT NULL AND qt_limite_pessoa::text <> '')
	and	coalesce(qt_idade_w,1) between coalesce(Obter_idade_param_prescr(nr_sequencia,'MIN'),0) and coalesce(Obter_idade_param_prescr(nr_sequencia,'MAX'),9999999)
	and	qt_peso_w between coalesce(qt_peso_min,0) and coalesce(qt_peso_max,999)
	and	coalesce(cd_protocolo,coalesce(cd_protocolo_w,0))	= coalesce(cd_protocolo_w,0)
	and	coalesce(nr_seq_medicacao,coalesce(nr_seq_medicacao_w,0)) = coalesce(nr_seq_medicacao_w,0)
	and	ie_tipo								= '2'
	and	((coalesce(cd_especialidade::text, '') = '') or (obter_se_especialidade_medico(cd_prescritor_w, cd_especialidade) = 'S'))
	and (coalesce(ie_tipo_item,'TOD') in ('OUT','TOD'))
	and	((cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento) OR (coalesce(cd_estabelecimento::text, '') = ''))
	order by nr_sequencia;


BEGIN
ds_erro_p	:= '';
ds_erro2_p	:= '';

select	cd_material,
	cd_unid_med_prescr,
	qt_dose_prescricao,
	null,
	ie_via_aplicacao,
	ds_observacao
into STRICT	cd_material_w,
	cd_unidade_medida_dose_w,
	qt_dose_ww,
	nr_ocorrencia_w,
	ie_via_aplicacao_w,
	ds_justificativa_w
from	paciente_atend_medic
where	nr_seq_atendimento = nr_seq_atendimento_p
and	nr_seq_material	= nr_sequencia_p;

select	nr_seq_paciente,
	coalesce(qt_peso,0),
	coalesce(qt_altura,0)
into STRICT	nr_seq_paciente_w,
	qt_peso_w,
	qt_altura_w
from	paciente_atendimento
where	nr_seq_atendimento = nr_seq_atendimento_p;

select	cd_medico_resp,
	cd_setor_atendimento,
	cd_pessoa_fisica,
	cd_protocolo,
	nr_seq_medicacao
into STRICT	cd_prescritor_w,
	cd_setor_atendimento_w,
	cd_pessoa_fisica_w,
	cd_protocolo_w,
	nr_seq_medicacao_w
from	paciente_setor
where	nr_seq_paciente = nr_seq_paciente_w;

select	max(obter_idade(dt_nascimento,coalesce(dt_obito,clock_timestamp()),'DIA'))
into STRICT	qt_idade_w
from	pessoa_fisica
where	cd_pessoa_fisica	= cd_pessoa_fisica_w;

select	count(distinct nr_ciclo)
into STRICT	nr_ciclos_w
from	paciente_atendimento
where	nr_seq_paciente = nr_seq_paciente_w;

if (coalesce(cd_material_w,0) > 0) and (cd_unidade_medida_dose_w IS NOT NULL AND cd_unidade_medida_dose_w::text <> '') and (coalesce(qt_dose_ww,0) > 0) then
	begin

	/* Verifica se tem alguma regra para os dados informados */

	select	count(*)
	into STRICT	qt_regra_w
	from	material_prescr
	where	cd_material							= cd_material_w
	and	coalesce(cd_setor_atendimento, coalesce(cd_setor_atendimento_w,0))	= coalesce(cd_setor_atendimento_w,0)
	and	coalesce(ie_via_aplicacao, coalesce(ie_via_aplicacao_w,0))		= coalesce(ie_via_aplicacao_w,0)
	and	coalesce(qt_idade_w,1) between coalesce(Obter_idade_param_prescr(nr_sequencia,'MIN'),0) and coalesce(Obter_idade_param_prescr(nr_sequencia,'MAX'),9999999)
	and	qt_peso_w between coalesce(qt_peso_min,0) and coalesce(qt_peso_max,999)
	and	(qt_limite_pessoa IS NOT NULL AND qt_limite_pessoa::text <> '')
	and	((coalesce(cd_especialidade::text, '') = '') or (obter_se_especialidade_medico(cd_prescritor_w, cd_especialidade) = 'S'))
	and (coalesce(ie_tipo_item,'TOD') in ('OUT','TOD'))
	and	ie_tipo								= '2';
	
	/* Caso haja alguma regra, faz as consistências */

	if (qt_regra_w > 0) then
		open c01;
		loop
		fetch c01 into
			qt_dose_min_w,
			ie_dose_limite_w,
			cd_unid_med_limite_w,
			ie_justificativa_w,
			ie_forma_consistencia_w;		
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
			
			select	coalesce(qt_max_prescricao,0),
				cd_unidade_medida_consumo
			into STRICT	qt_max_prescricao_w,
				cd_unidade_medida_consumo_w
			from	material
			where	cd_material	= cd_material_w;

			if (cd_unidade_medida_consumo_w = cd_unidade_medida_dose_w) then
				qt_conversao_dose_w	:= 1;
			else
				begin
				select	coalesce(max(qt_conversao),1)
				into STRICT	qt_conversao_dose_w
				from	material_conversao_unidade
				where	cd_material		= cd_material_w
				and	cd_unidade_medida	= cd_unidade_medida_dose_w;
				exception	
					when others then
						qt_conversao_dose_w	:= 1;
				end;
			end if;

			qt_dose_w	:= (trunc(qt_dose_ww * 1000 / qt_conversao_dose_w)/ 1000);

			if (cd_unidade_medida_consumo_w = cd_unid_med_limite_w) then
				qt_conversao_dose_limite_w	:= 1;
			else
				begin
				select	coalesce(max(qt_conversao),1)
				into STRICT	qt_conversao_dose_limite_w
				from	material_conversao_unidade
				where	cd_material		= cd_material_w
				and	cd_unidade_medida	= cd_unid_med_limite_w;
				exception
					when others then
						qt_conversao_dose_limite_w	:= 1;
				end;
			end if;

			qt_dose_w		:= (trunc(qt_dose_ww * 1000 / qt_conversao_dose_w)/ 1000);
			qt_dose_limite_w	:= (trunc(qt_dose_min_w * 1000 / qt_conversao_dose_limite_w)/ 1000);
							
			if (ie_dose_limite_w = 'DIA') then
				/*if	(nr_horas_validade_w	> 24) then
					nr_ocorrencia_w	:= trunc(((nr_ocorrencia_w * 24) / nr_horas_validade_w));
				end if;*/
				qt_dose_w	:= qt_dose_w * coalesce(nr_ocorrencia_w,1);
				--qt_dose_w	:= qt_dose_w + obter_dose_medic_dia(nr_prescricao_p,nr_sequencia_p,ie_utiliza_horarios_p);
			elsif (qt_peso_w > 0) and (ie_dose_limite_w = 'KG') then
				qt_dose_w	:= qt_dose_w / coalesce(qt_peso_w,1);
			elsif (ie_dose_limite_w = 'AT') then
				begin
				qt_dose_w	:= qt_dose_w * coalesce(nr_ocorrencia_w,1);
				--qt_dose_w	:= qt_dose_w + obter_dose_medic_atend_dia(nr_prescricao_p,nr_sequencia_p,qt_dose_w,ie_utiliza_horarios_p);
				end;
			elsif (qt_peso_w > 0) and (qt_altura_w > 0) and (ie_dose_limite_w = 'SC') then
				begin
				qt_sc_w		:= (qt_peso_w / ((qt_altura_w / 100) * (qt_altura_w / 100 )));	
				qt_dose_w	:= qt_dose_w / coalesce(qt_sc_w,1);	/*por SC*/
				

				qt_dose_w	:= qt_dose_w * coalesce(nr_ocorrencia_w,1);
				end;
			elsif (qt_peso_w > 0) and (ie_dose_limite_w = 'CI') then
				begin
				qt_dose_w	:= qt_dose_w / coalesce(nr_ciclos_w,1);	/*por Ciclo*/
				

				qt_dose_w	:= qt_dose_w * coalesce(nr_ocorrencia_w,1);
				end;
			elsif (ie_dose_limite_w = 'PF') then
				begin						
				qt_dose_w	:= qt_dose_w * coalesce(nr_ocorrencia_w,1); /* Pessoa Física*/
				qt_dose_w	:= qt_dose_w + obter_dose_medic_pessoa_dia(nr_seq_atendimento_p,nr_sequencia_p,cd_material_w,qt_dose_w);
				--qt_dose_w	:= qt_dose_w + obter_dose_medic_atend_dia(nr_prescricao_p,nr_sequencia_p,qt_dose_w,ie_utiliza_horarios_p);
				end;								
			elsif (qt_peso_w > 0) and (ie_dose_limite_w = 'KG/DIA') then
				begin
				/*por KG*/

				qt_dose_w	:= qt_dose_w / coalesce(qt_peso_w,1);					
				/*por dia*/


				/*if	(nr_horas_validade_w	> 24) then
					nr_ocorrencia_w	:= trunc(((nr_ocorrencia_w * 24) / nr_horas_validade_w));
				end if;*/
				qt_dose_w	:= qt_dose_w * coalesce(nr_ocorrencia_w,1);
				--qt_dose_w	:= qt_dose_w + obter_dose_medic_dia(nr_prescricao_p,nr_sequencia_p,ie_utiliza_horarios_p);
				end;
			end if;		

			if (qt_dose_limite_w > 0) and (qt_dose_limite_w > coalesce(qt_dose_w,0)) and
				((ie_justificativa_w = 'S') or (coalesce(ds_justificativa_w::text, '') = '')) then
				ds_erro2_p	:= ' ';
			end if;

			end;
		end loop;
		close c01;
	end if;
	end;	
end if;

ie_forma_consistencia_P	:= ie_forma_consistencia_W;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE verifica_dose_minima_onc ( nr_seq_atendimento_p bigint, nr_sequencia_p bigint, ie_utiliza_horarios_p text, ds_erro_p INOUT text, ds_erro2_p INOUT text, ie_forma_consistencia_p INOUT text) FROM PUBLIC;

