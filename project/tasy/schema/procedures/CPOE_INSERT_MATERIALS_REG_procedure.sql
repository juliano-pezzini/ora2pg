-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_insert_materials_reg ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, nr_prescricao_p prescr_medica.nr_prescricao%type, nr_sequencia_p cpoe_material.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_perfil_p perfil.cd_perfil%type, nm_usuario_p usuario.nm_usuario%type, dt_inicio_prescr_p timestamp, dt_inicio_ret_p INOUT timestamp, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type default null, ie_copia_diaria_p char default 'N', nr_seq_procedimento_p bigint default null) AS $body$
DECLARE


nr_seq_material_w		prescr_material.nr_sequencia%type;
nr_agrupamento_w		prescr_material.nr_agrupamento%type;
qt_unitaria_w			prescr_material.qt_unitaria%type;
qt_total_dispensar_w	prescr_material.qt_total_dispensar%type;
ie_regra_disp_w			prescr_material.ie_regra_disp%type;
qt_conversao_dose_w		prescr_material.qt_conversao_dose%type;
qt_material_w			prescr_material.qt_material%type;
ie_se_necessario_w  prescr_material.ie_se_necessario%type;

cd_material_w			cpoe_material.cd_material%type;
qt_dose_w				cpoe_material.qt_dose%type;
nr_ocorrencia_w			cpoe_material.nr_ocorrencia%type;
cd_intervalo_w			cpoe_material.cd_intervalo%type;
ie_urgencia_w			cpoe_material.ie_urgencia%type;
ds_horarios_w			cpoe_material.ds_horarios%type;
hr_prim_horario_w		cpoe_material.hr_prim_horario%type;
ds_observacao_w			cpoe_material.ds_observacao%type;
ds_justificativa_w		cpoe_material.ds_justificativa%type;
ie_administracao_w		cpoe_material.ie_administracao%type;
ie_retrogrado_w			cpoe_material.ie_retrogrado%type;
cd_protocolo_w			cpoe_material.cd_protocolo%type;
nr_seq_protocolo_w			cpoe_material.nr_seq_protocolo%type;

cd_unidade_medida_dose_w		unidade_medida.cd_unidade_medida%type;
cd_unidade_medida_w		unidade_medida.cd_unidade_medida%type;

--ds_erro_w				varchar2(2000);
ds_erro_ww				varchar(2000);
dt_inicio_w 			timestamp;
dt_inicio_base_w		timestamp;
dt_inicio_orig_w		timestamp;
dt_fim_w				timestamp;
nr_horas_prox_geracao_w	bigint;
--ie_copia_w				number(1);
nr_seq_mat_protocolo_w	cpoe_material.nr_seq_mat_protocolo%type;

sql_w                   varchar(300);
dt_prox_geracao_w       timestamp;
ie_copia_material_w     varchar(1);

c01 CURSOR FOR
	SELECT	cd_material,
			qt_dose,
			cd_unidade_medida,
			nr_ocorrencia,
			cd_intervalo,
			ie_urgencia,
			ds_horarios,
			hr_prim_horario,
			ds_observacao,
			ds_justificativa,
			dt_inicio,
			dt_fim,
			coalesce(ie_retrogrado,'N'),
			cd_protocolo,
			nr_seq_protocolo,
			nr_seq_mat_protocolo,
			coalesce(ie_administracao,'P')
	from	cpoe_material
	where	nr_sequencia = nr_sequencia_p
	and		((CASE WHEN coalesce(dt_lib_suspensao::text, '') = '' THEN  coalesce(dt_fim_cih,dt_fim)  ELSE coalesce(dt_suspensao,dt_fim) END  >= clock_timestamp()) or (CASE WHEN coalesce(dt_lib_suspensao::text, '') = '' THEN  coalesce(dt_fim_cih,dt_fim)  ELSE coalesce(dt_suspensao,dt_fim) coalesce(END::text, '') = '') or (coalesce(ie_retrogrado,'N') = 'S' AND dt_inicio >= dt_inicio_prescr_p)) -- retrograde/backward item
	and		coalesce(ie_material,'N') = 'S';


BEGIN
dt_inicio_base_w		:= trunc(dt_inicio_prescr_p,'mi');
nr_horas_prox_geracao_w	:= get_qt_hours_after_copy_cpoe(cd_perfil_p, nm_usuario_p, cd_estabelecimento_p);

select	coalesce(max(nr_sequencia),0) + 1,
		coalesce(max(nr_agrupamento),0) + 1
into STRICT	nr_seq_material_w,
		nr_agrupamento_w
from	prescr_material
where	nr_prescricao = nr_prescricao_p;

open C01;
loop
fetch C01 into
	cd_material_w,
	qt_dose_w,
	cd_unidade_medida_dose_w,
	nr_ocorrencia_w,
	cd_intervalo_w,
	ie_urgencia_w,
	ds_horarios_w,
	hr_prim_horario_w,
	ds_observacao_w,
	ds_justificativa_w,
	dt_inicio_orig_w,
	dt_fim_w,
	ie_retrogrado_w,
	cd_protocolo_w,
	nr_seq_protocolo_w,
	nr_seq_mat_protocolo_w,
	ie_administracao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
		dt_inicio_w	:= dt_inicio_orig_w;

		-- Itens ACM e SN nao possuem 1 horario, definir inicio do item para execucao da geracao.
		if (ie_administracao_w <> 'P') then
			begin
				if (trunc(dt_inicio_w) > trunc(dt_inicio_base_w)) then
					hr_prim_horario_w	:= '00:00';
				else
					hr_prim_horario_w		:= to_char(dt_inicio_base_w,'hh24:mi');
				end if;
			end;
		end if;

		-- Atualiza a data inicio com dia e horario.
		dt_inicio_w		:= to_date(to_char(dt_inicio_w,'dd/mm/yyyy ') || hr_prim_horario_w,'dd/mm/yyyy hh24:mi');

		/*select	max(1)
		into	ie_copia_w
		from	prescr_medica
		where	nr_prescricao = nr_prescricao_p
		and 	nr_prescricoes is null;*/


		-- Atualizar data de inicio com a data atual, para itens que a data de inicio ja tenha sido ultrapassada.

		-- E se for nao for a primeira prescricao de um item retrogrado
		if (ie_copia_diaria_p = 'S') then
			-- Assumir data da prescricao para o item
			dt_inicio_w		:= to_date(to_char(dt_inicio_base_w,'dd/mm/yyyy ') || hr_prim_horario_w, 'dd/mm/yyyy hh24:mi');
			--- Inicio MD1

			-- Adicionar um dia, caso o inicio do item, nao caia na data de hoje
					
			begin
			  sql_w := 'call calcular_data_inicio_mat_md(:1, :2) into :dt_inicio_w';
			  EXECUTE sql_w using in dt_inicio_w, in dt_inicio_base_w, out dt_inicio_w;
			exception
			  when others then
			    dt_inicio_w := null;
			end;
			--- Fim MD1
		end if;

		-- Caso a data de inicio do item seja maior que a data base de inicio, reprogramar a geracao para o futuro
		if (dt_inicio_w > dt_inicio_base_w + 1 - 1/86400) then
		
			begin
			  sql_w := 'call obter_dt_prox_geracao_cpoe_md(:1, :2) into :dt_prox_geracao_w';
			  EXECUTE sql_w using in dt_inicio_w, in nr_horas_prox_geracao_w, out dt_prox_geracao_w;
			exception
			  when others then
			    dt_prox_geracao_w := null;
			end;
			
			update	cpoe_material
			set		dt_prox_geracao = dt_prox_geracao_w --- Inicio MD2 utilizar ou criar o objeto obter_dt_prox_geracao_cpoe_md.
			where	nr_sequencia = nr_sequencia_p;

			CALL gravar_log_cpoe(substr('CPOE_INSERT_MATERIALS_REG LOG DT_INICIO_W > DT_INICIO_BASE_W:'
				||' dt_inicio_base_w : ' || to_char(dt_inicio_base_w,'dd/mm/yyyy hh24:mi:ss')
				||' dt_inicio_w : ' || to_char(dt_inicio_w,'dd/mm/yyyy hh24:mi:ss')
				||' dt_prox_geracao : ' || to_char(dt_prox_geracao_w,'dd/mm/yyyy hh24:mi:ss')
				||' nr_prescricao_p : ' || nr_prescricao_p
				||' nr_seq_mat_cpoe_w :' || nr_sequencia_p
				||' cd_perfil_p: ' || cd_perfil_p,1,2000),
				nr_atendimento_p, 'M', nr_sequencia_p);

			goto proximo_item;
		end if;

		-- Se o inicio do item for apos a data de fim, definida para o mesmo, este item nao deve ser mais copiado.
		
		begin
		  sql_w := 'call obter_se_copia_material_md(:1, :2) into :ie_copia_material_w';
		  EXECUTE sql_w using in dt_inicio_w, in dt_fim_w, out ie_copia_material_w;
		exception
		  when others then
		    ie_copia_material_w := 'N';
		end;
		
		if ie_copia_material_w = 'S' then --- Inicio MD3 Criar uma function para fazer esta validacao do IF. obter_se_copia_material_md
			CALL gravar_log_cpoe(substr('CPOE_INSERT_MATERIALS_REG LOG DT_FIM_W <= DT_INICIO_W:'
				||'//dt_inicio_base_w : ' || to_char(dt_inicio_base_w,'dd/mm/yyyy hh24:mi:ss')
				||' dt_inicio_w : ' || to_char(dt_inicio_w,'dd/mm/yyyy hh24:mi:ss')
				||' dt_fim_w : ' || to_char(dt_fim_w,'dd/mm/yyyy hh24:mi:ss')
				||' nr_prescricao_p : ' || nr_prescricao_p
				||' nr_seq_mat_cpoe_w :' || nr_sequencia_p
				||' cd_perfil_p: ' || cd_perfil_p,1,2000),
				nr_atendimento_p, 'M', nr_sequencia_p);

			goto proximo_item;
		end if;

		if	((coalesce(dt_inicio_ret_p::text, '') = '') or (dt_inicio_w > dt_inicio_ret_p)) then
			dt_inicio_ret_p	:= dt_inicio_w;
		end if;

		cd_unidade_medida_w	:= substr(obter_dados_material_estab(cd_material_w, cd_estabelecimento_p ,'UMS'),1,30);
		qt_conversao_dose_w	:= coalesce(obter_conversao_unid_med(cd_material_w, cd_unidade_medida_dose_w),0);

		if (qt_conversao_dose_w <= 0) then
			qt_conversao_dose_w	:= 1;
		end if;
		--- Inicio MD4
		
		begin
		  sql_w := 'call calcular_qtd_unitaria_md(:1, :2) into :qt_unitaria_w';
		  EXECUTE sql_w using in qt_dose_w, in qt_conversao_dose_w, out qt_unitaria_w;
		exception
		  when others then
		    qt_unitaria_w := null;
		end;
		
		--- Fim MD4
		
		qt_material_w	:= 0;

		SELECT * FROM obter_quant_dispensar(	cd_estabelecimento_p, cd_material_w, nr_prescricao_p, nr_seq_material_w, cd_intervalo_w, null, qt_unitaria_w, 0, nr_ocorrencia_w, null, 'S', cd_unidade_medida_dose_w, 0, qt_material_w, qt_total_dispensar_w, ie_regra_disp_w, ds_erro_ww, 'N', 'N' ) INTO STRICT qt_material_w, qt_total_dispensar_w, ie_regra_disp_w, ds_erro_ww;

    if (ie_administracao_w = 'N') then
      ie_se_necessario_w := 'S';
    else
      ie_se_necessario_w := 'N';
    end if;

		insert into prescr_material(	nr_prescricao,
					nr_sequencia,
					ie_origem_inf,
					cd_material,
					cd_unidade_medida_dose,
					cd_unidade_medida,
					qt_dose,
					qt_unitaria,
					qt_material,
					qt_total_dispensar,
					nr_ocorrencia,
					dt_atualizacao,
					dt_atualizacao_nrec,
					nm_usuario,
					nm_usuario_nrec,
					cd_intervalo,
					nr_agrupamento,
					ie_acm,
					ie_se_necessario,
					ie_urgencia,
					ie_suspenso,
					ie_medicacao_paciente,
					cd_motivo_baixa,
					ie_agrupador,
					ie_bomba_infusao,
					ie_aplic_bolus,
					ie_aplic_lenta,
					ds_horarios,
					ie_recons_diluente_fixo,
					ie_sem_aprazamento,
					qt_dose_especial,
					hr_dose_especial,
					ie_cobra_paciente,
					ie_via_aplicacao,
					hr_prim_horario,
					ds_observacao,
					ds_justificativa,
					qt_conversao_dose,
					ie_checar_adep,
					ie_horario_susp,
					ie_erro,
					ie_regra_disp,
					dt_inicio_medic,
					nr_seq_mat_cpoe,
					nr_sequencia_proc,
					cd_protocolo,
					nr_seq_protocolo,
					nr_seq_mat_protocolo)
				values (
					nr_prescricao_p,
					nr_seq_material_w,
					'S',
					cd_material_w,
					cd_unidade_medida_dose_w,
					cd_unidade_medida_w,
					qt_dose_w,
					qt_unitaria_w,
					qt_material_w,
					qt_total_dispensar_w,
					nr_ocorrencia_w,
					clock_timestamp(),
					clock_timestamp(),
			    nm_usuario_p,
          nm_usuario_p,
          cd_intervalo_w,
          nr_agrupamento_w,
          CASE WHEN ie_administracao_w='C' THEN 'S'  ELSE 'N' END ,
          ie_se_necessario_w,
          CASE WHEN coalesce(ie_urgencia_w::text, '') = '' THEN 'N'  ELSE 'S' END ,
          'N',
          'N',
          0,
          CASE WHEN coalesce(nr_seq_procedimento_p::text, '') = '' THEN  2  ELSE 5 END ,
          'N',
          'N',
          'N',
          ds_horarios_w,
          'N',
          'N',
          null,
          null,
          'S',
          null,
          hr_prim_horario_w,
          ds_observacao_w,
          ds_justificativa_w,
          qt_conversao_dose_w,
          'N',
          'N',
          0,
          ie_regra_disp_w,
          dt_inicio_w,
          nr_sequencia_p,
          nr_seq_procedimento_p,
          cd_protocolo_w,
          nr_seq_protocolo_w,
          nr_seq_mat_protocolo_w);


  <<proximo_item>>
  commit;
  end;
end loop;
close C01;

exception when others then
  CALL gravar_log_cpoe(substr('CPOE_INSERT_MATERIALS_REG EXCEPTION:'|| substr(to_char(sqlerrm),1,2000)
    ||'//nr_atendimento_p:'||nr_atendimento_p
    ||'nr_prescricao_p:'||nr_prescricao_p
    ||'nr_sequencia_p:'||nr_sequencia_p
    ||'cd_estabelecimento_p'||cd_estabelecimento_p
    ||'cd_perfil_p:'||cd_perfil_p
    ||'nm_usuario_p : '||nm_usuario_p
    ||'cd_pessoa_fisica_p: ' || cd_pessoa_fisica_p
    ||'ie_copia_diaria_p: ' || ie_copia_diaria_p
    ||'dt_inicio_prescr_p :'||to_char(dt_inicio_prescr_p,'dd/mm/yyyy hh24:mi:ss')
    ||'dt_inicio_ret_p :'||to_char(dt_inicio_ret_p,'dd/mm/yyyy hh24:mi:ss'),1,2000),
    nr_atendimento_p, 'M', nr_sequencia_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_insert_materials_reg ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, nr_prescricao_p prescr_medica.nr_prescricao%type, nr_sequencia_p cpoe_material.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_perfil_p perfil.cd_perfil%type, nm_usuario_p usuario.nm_usuario%type, dt_inicio_prescr_p timestamp, dt_inicio_ret_p INOUT timestamp, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type default null, ie_copia_diaria_p char default 'N', nr_seq_procedimento_p bigint default null) FROM PUBLIC;
