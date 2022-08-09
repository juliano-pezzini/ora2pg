-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_gerar_med_mat_assoc ( nr_atendimento_p bigint, nr_seq_procedimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_paciente_p text, qt_idade_dia_p bigint, qt_idade_mes_p bigint, qt_idade_ano_p bigint, cd_setor_atendimento_p bigint, ie_tipo_atendimento_p bigint, cd_convenio_p bigint, cd_medico_p text, dt_prev_execucao_p timestamp, cd_intervalo_p text, ie_urgencia_p text, qt_hora_intervalo_p bigint, qt_min_intervalo_p bigint, ds_horarios_p text, nr_ocorrencia_p bigint, ds_mat_adic_proc_p INOUT text, nr_seq_contraste_p bigint default null, nr_seq_cpoe_order_unit_p cpoe_order_unit.nr_sequencia%type default null) AS $body$
DECLARE

									
cd_mat_proc_w				material.cd_material%type;

qt_peso_w					prescr_medica.qt_peso%type;

qt_dose_mat_w				prescr_material.qt_dose%type;
ds_observacao_w				prescr_material.ds_observacao%type;

cd_unid_medida_dose_mat_w	unidade_medida.cd_unidade_medida%type;

cd_interv_proc_w			intervalo_prescricao.cd_intervalo%type;

ie_via_mat_proc_w			via_aplicacao.ie_via_aplicacao%type;

nr_sequencia_w				cpoe_material.nr_sequencia%type;

qt_unitaria_w				cpoe_material.qt_unitaria%type;

i							char(1);
nr_ocorrencia_w				double precision;
ie_sexo_w					char(1);
ie_gerar_associado_w		char(1);
ie_intervalo_fixo_w			char(1);
ie_duplicar_w				char(1);
ie_urgencia_mat_w			char(1);
ie_urgencia_w   			char(1);
ie_adm_mat_w				char(1);
ie_se_necessario_w			char(1);
ie_acm_w					char(1);
hr_prim_hor_proc_w			char(5);
ie_checar_adep_w			char(1);
ie_tipo_material_w			varchar(15);
ds_horarios_w				varchar(4000);
ds_horarios_aux_w			varchar(2000);
ds_erro_w					varchar(4000);
cd_setor_atend_w			proc_int_mat_prescr.cd_setor_atendimento%type;
nr_seq_rotina_w				proc_int_mat_prescr.nr_sequencia%type;
param_650_w				    varchar(1);
param_809_w	        	    varchar(1);

dt_inicio_mat_w 	        varchar(200);
dt_inicio_w                 cpoe_procedimento.dt_inicio%type;
dt_fim_w			        cpoe_procedimento.dt_fim%type;
nr_ocorrencia_cpoe_w	    cpoe_procedimento.nr_ocorrencia%type;
ie_via_aplicacao_w			via_aplicacao.ie_via_aplicacao%type;
ie_segunda_w				cpoe_material.ie_segunda%type;
ie_terca_w					cpoe_material.ie_terca%type;
ie_quarta_w					cpoe_material.ie_quarta%type;
ie_quinta_w					cpoe_material.ie_quinta%type;
ie_sexta_w					cpoe_material.ie_sexta%type;
ie_sabado_w					cpoe_material.ie_sabado%type;
ie_domingo_w				cpoe_material.ie_domingo%type;

C02 CURSOR FOR
SELECT	a.cd_material,
		a.cd_unidade_medida,
		a.qt_dose,
		coalesce(a.cd_intervalo,cd_intervalo_p),
		a.ds_observacao,
		a.ds_horarios,
		a.ie_via_aplicacao,
		coalesce(a.ie_intervalo_fixo,'N'),
		coalesce(a.ie_duplicar,'S'),
		coalesce(a.ie_checar_adep,'N'),
		obter_tipo_material(a.cd_material, 'C') ie_tipo_material,
		coalesce(a.cd_setor_atendimento,999),
		a.nr_sequencia,
		null,
		null,
		null,
		null,
		null,
		null,
		null
FROM	proc_int_mat_prescr a
where	coalesce(a.ie_situacao,'A')	= 'A'
and		((coalesce(a.cd_convenio_exc::text, '') = '') or (a.cd_convenio_exc <> cd_convenio_p))
and		((coalesce(a.cd_medico::text, '') = '') or (a.cd_medico = cd_medico_p))
and		((coalesce(a.ie_sexo::text, '') = '') or (a.ie_sexo = ie_sexo_w))
and		Obter_se_mat_setor(a.nr_sequencia, cd_setor_atendimento_p, cd_convenio_p, ie_tipo_atendimento_p) = 'S'
and		((coalesce(a.ie_tipo_atendimento::text, '') = '') or (a.ie_tipo_atendimento = ie_tipo_atendimento_p))
and		((coalesce(a.cd_convenio::text, '') = '') or (a.cd_convenio = cd_convenio_p))
and		((coalesce(a.cd_setor_atendimento::text, '') = '') or (a.cd_setor_atendimento = cd_setor_atendimento_p))
and		((coalesce(a.cd_estabelecimento::text, '') = '') or (a.cd_estabelecimento = cd_estabelecimento_p))
and		coalesce(qt_idade_dia_p,1) between coalesce(obter_idade_mat_int_prescr(a.nr_sequencia,'MIN'),0) and coalesce(obter_idade_mat_int_prescr(a.nr_sequencia,'MAX'),9999999)
and		cpoe_obter_se_medic_lib_med(nr_atendimento_p, a.cd_material, 'S', a.ie_via_aplicacao, ie_tipo_atendimento_p, cd_setor_atendimento_p, cd_perfil_p, cd_convenio_p, nm_usuario_p, cd_estabelecimento_p, cd_paciente_p, clock_timestamp()) = 'S'
and		a.nr_seq_proc_interno = nr_seq_proc_interno_p
and		coalesce(qt_peso_w,0) between coalesce(a.qt_peso_min,0) and coalesce(a.qt_peso_max,999)

union all

select	a.cd_material,
		coalesce(a.cd_unidade_medida,m.cd_unidade_medida_consumo),
		coalesce(a.qt_dose,0),
		coalesce(a.cd_intervalo,coalesce(p.cd_intervalo,cd_intervalo_p)) cd_intervalo,
		null ds_observacao,
		a.ds_horarios ds_horarios,
		null ie_via_aplicacao,
		coalesce(a.ie_intervalo_fixo,'N'),
		'N',
		coalesce(a.ie_checar_adep,'N'),
		obter_tipo_material(a.cd_material, 'C'),
		null,
		null,
		ie_segunda,
		ie_terca,
		ie_quarta,
		ie_quinta,
		ie_sexta,
		ie_sabado,
		ie_domingo
FROM	proc_int_mat_contraste a,
		proc_interno_contraste c,
		cpoe_procedimento p,
		material m
where	(nr_seq_contraste_p IS NOT NULL AND nr_seq_contraste_p::text <> '')
and		c.nr_seq_proc_interno	= nr_seq_proc_interno_p
and		a.nr_seq_contraste	= c.nr_sequencia
and 	p.nr_sequencia = nr_seq_procedimento_p
and 	m.cd_material = a.cd_material
and 	coalesce(c.ie_itens_associados,'N') = 'S'
and		a.nr_seq_contraste	= nr_seq_contraste_p
order by 11,12,13;


	procedure inserir_mat_associados_proc is
	nr_proximo_w	bigint;
	
BEGIN
		
		ie_via_aplicacao_w := cpoe_obter_padrao_param_prescr(nr_atendimento_p, cd_mat_proc_w, null, 'N', 'V', null, cd_estabelecimento_p, obter_perfil_ativo, nm_usuario_p,  Obter_Pf_Usuario(nm_usuario_p, 'C'));
		
		if (cd_intervalo_p = cd_interv_proc_w) then
			nr_ocorrencia_w	:= nr_ocorrencia_p;
			ds_horarios_w	:= ds_horarios_p;
		else
			nr_ocorrencia_w	:= 0;
			if (coalesce(ds_horarios_w::text, '') = '') then					
				SELECT * FROM cpoe_calcular_horario_prescr(	nr_atendimento_p, cd_interv_proc_w, cd_mat_proc_w, dt_prev_execucao_p, qt_hora_intervalo_p, qt_min_intervalo_p, nr_ocorrencia_w, ds_horarios_w, ds_horarios_aux_w, nm_usuario_p, cd_estabelecimento_p, cd_perfil_p, null) INTO STRICT nr_ocorrencia_w, ds_horarios_w, ds_horarios_aux_w;
				ds_horarios_w	:= ds_horarios_w || ds_horarios_aux_w;
			end if;
			
			if (ie_intervalo_fixo_w = 'N') then
				hr_prim_hor_proc_w	:= to_char(dt_prev_execucao_p,'hh24:mi');
			else
				hr_prim_hor_proc_w	:= to_char(clock_timestamp(),'hh24:mi');
			end if;
			
            dt_inicio_mat_w := to_char(dt_prev_execucao_p,pkg_date_formaters.localize_mask('timestamp', pkg_date_formaters.getUserLanguageTag(wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario)));
			
			if (ie_acm_w = 'S') or (ie_se_necessario_w = 'S') then
				ds_horarios_w		:= null;
				hr_prim_hor_proc_w	:= null;
				dt_inicio_mat_w := to_char(dt_prev_execucao_p, 'dd/mm/yyyy');
			end if;
		end if;

		if (ie_tipo_material_w <> '1') then
		
			nr_proximo_w	:= position(',' in ds_mat_adic_proc_p);
			i := substr(ds_mat_adic_proc_p,1,nr_proximo_w-1);
			ds_mat_adic_proc_p	:= substr(ds_mat_adic_proc_p,nr_proximo_w+1,length(ds_mat_adic_proc_p));
			
			CALL exec_sql_dinamico_bv(
				'CPOE',
					' update	cpoe_procedimento ' ||
					' set		cd_mat_proc'||i||' = :cd_mat_proc_w, ' ||
					' 			ie_via_mat_proc'||i||' = :ie_via_mat_proc_w, ' ||
					' 			qt_dose_mat'||i||' = :qt_dose_mat_w, ' ||
					' 			cd_unid_medida_dose_mat'||i||' = :cd_unid_medida_dose_mat_w, ' ||
					' 			cd_interv_proc'||i||' = :cd_interv_proc_w, ' ||
					' 			ds_hor_proc'||i||' = :ds_hor_proc_w, ' ||
					' 			dt_inicio_proc'||i||' = :dt_inicio_proc_w, ' ||
					' 			hr_prim_hor_proc'||i||' = :hr_prim_hor_proc_w, ' ||
					' 			ds_obser_proc'||i||' = :ds_obser_proc_w, ' ||
					' 			ie_urgencia_mat'||i||' = :ie_urgencia_mat_w, ' ||
					' 			ie_adm_mat'||i||' = :ie_adm_mat_w, ' ||
					' 			ie_assoc_adep'||i||' = :ie_assoc_adep_w ' ||
					' where		nr_atendimento = :nr_atendimento_p ' ||
					' and		nr_sequencia = :nr_seq_procedimento_p ',
				'cd_mat_proc_w='||cd_mat_proc_w||
				'#@#@ie_via_mat_proc_w='||coalesce(ie_via_mat_proc_w, ie_via_aplicacao_w)||
				'#@#@qt_dose_mat_w='||qt_dose_mat_w||
				'#@#@cd_unid_medida_dose_mat_w='||cd_unid_medida_dose_mat_w||
				'#@#@cd_interv_proc_w='||cd_interv_proc_w||
				'#@#@ds_hor_proc_w='||ds_horarios_w||
				'#@#@dt_inicio_proc_w='||dt_inicio_mat_w||
				'#@#@hr_prim_hor_proc_w='||hr_prim_hor_proc_w||
				'#@#@ds_obser_proc_w='||ds_observacao_w||
				'#@#@ie_urgencia_mat_w='||ie_urgencia_mat_w||
				'#@#@ie_adm_mat_w='||ie_adm_mat_w||
				'#@#@ie_assoc_adep_w='||ie_checar_adep_w||
				'#@#@nr_atendimento_p='||nr_atendimento_p||
				'#@#@nr_seq_procedimento_p='||nr_seq_procedimento_p||
				'#@#@');

		else
			
			if (ie_checar_adep_w = 'N' and coalesce(cd_intervalo_p::text, '') = '') then
				dt_inicio_w := null;
				dt_fim_w := null;
				ds_horarios_w := null;
				hr_prim_hor_proc_w := null;
				cd_interv_proc_w := null;
				nr_ocorrencia_cpoe_w := null;			
			else
				dt_inicio_w	:= dt_prev_execucao_p;
				dt_fim_w := trunc(dt_prev_execucao_p + 1/24,'hh24') - 1/1440;
				nr_ocorrencia_cpoe_w := obter_ocorrencias_horarios_rep(ds_horarios_w);
			end if;			
		
			select	nextval('cpoe_material_seq')
			into STRICT	nr_sequencia_w
			;
						
			insert into cpoe_material(
							nr_sequencia,
							nr_atendimento,
							cd_material,
							qt_dose,
							cd_unidade_medida,
							ie_via_aplicacao,
							cd_intervalo,
							hr_prim_horario,
							ds_horarios,
							dt_inicio,
							ie_urgencia,
							ie_duracao,
							ie_administracao,
							dt_fim,
							ie_material,
							nm_usuario,
							nm_usuario_nrec,
							dt_atualizacao,
							dt_atualizacao_nrec,
							cd_perfil_ativo,
							cd_pessoa_fisica,
							nr_seq_procedimento,
							nr_seq_proc_edit,
							cd_funcao_origem,
							qt_unitaria,
							nr_ocorrencia,
							ie_tipo_assoc,
							nr_seq_cpoe_order_unit,
							ie_segunda,
							ie_terca,
							ie_quarta,
							ie_quinta,
							ie_sexta,
							ie_sabado,
							ie_domingo)
						values (
							nr_sequencia_w,
							nr_atendimento_p,
							cd_mat_proc_w,
							qt_dose_mat_w,
							cd_unid_medida_dose_mat_w,
							coalesce(ie_via_mat_proc_w, ie_via_aplicacao_w),
							cd_interv_proc_w,
							hr_prim_hor_proc_w,
							ds_horarios_w,
							dt_inicio_w,
							ie_urgencia_mat_w,
							'P',
							ie_adm_mat_w,
							dt_fim_w,
							'S',
							nm_usuario_p,
							nm_usuario_p,
							clock_timestamp(),
							clock_timestamp(),
							cd_perfil_p,
							cd_paciente_p,
							nr_seq_procedimento_p,
							nr_seq_procedimento_p,
							2314,
							obter_conversao_unid_med_cons(cd_mat_proc_w, cd_unid_medida_dose_mat_w, qt_dose_mat_w),
							nr_ocorrencia_cpoe_w,
							'P',
							nr_seq_cpoe_order_unit_p,
							ie_segunda_w,
							ie_terca_w,
							ie_quarta_w,
							ie_quinta_w,
							ie_sexta_w,
							ie_sabado_w,
							ie_domingo_w);
						
		end if;	
		
		commit;

	end;

begin

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_seq_procedimento_p IS NOT NULL AND nr_seq_procedimento_p::text <> '') then
	begin

    param_650_w := Obter_Param_Usuario(924, 650, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, param_650_w);
	param_809_w := Obter_Param_Usuario(924, 809, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, param_809_w);

	if (ds_mat_adic_proc_p = 'X') then
		ds_mat_adic_proc_p	:= '1,2,3,4,5,6,7';
	else
		if (coalesce(ds_mat_adic_proc_p::text, '') = '') then
			return;
		end if;
		
		ds_mat_adic_proc_p	:= ds_mat_adic_proc_p;
	end if;
	
	select 	obter_sinal_vital(nr_atendimento_p,'PESO')
	into STRICT	qt_peso_w
	;
		
	open C02;
	loop
	fetch C02 into	
		cd_mat_proc_w,
		cd_unid_medida_dose_mat_w,
		qt_dose_mat_w,
		cd_interv_proc_w,
		ds_observacao_w,
		ds_horarios_w,
		ie_via_mat_proc_w,
		ie_intervalo_fixo_w,
		ie_duplicar_w,
		ie_checar_adep_w,
		ie_tipo_material_w,
		cd_setor_atend_w,
		nr_seq_rotina_w,
		ie_segunda_w,
		ie_terca_w,
		ie_quarta_w,
		ie_quinta_w,
		ie_sexta_w,
		ie_sabado_w,
		ie_domingo_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */	
	
        ie_adm_mat_w := 'P';

        if (coalesce(ie_checar_adep_w, 'N') = 'S') then
            select	coalesce(coalesce(max(ie_agora),ie_urgencia_p),'N'),
                    coalesce(coalesce(max(ie_se_necessario), ie_se_necessario_w),'N'),
                    coalesce(coalesce(max(ie_acm), ie_acm_w),'N')
            into STRICT	ie_urgencia_w,
                    ie_se_necessario_w,
                    ie_acm_w
            from	intervalo_prescricao
            where	cd_intervalo = cd_interv_proc_w;

            if (param_809_w = 'S' and ie_acm_w = 'S') then
                ie_adm_mat_w	:= 'C';
            elsif ((param_809_w = 'S' or param_650_w = 'S') and ie_se_necessario_w = 'S') then
                ie_adm_mat_w	:= 'N';
            end if;

            if (param_809_w = 'S' and ie_urgencia_w = 'S') then
                ie_urgencia_mat_w	:= 0;
            end if;
        else
            if (ie_urgencia_p IS NOT NULL AND ie_urgencia_p::text <> '') then
                ie_urgencia_mat_w	:= 0;
            end if;
        end if;
		if (ie_duplicar_w = 'N') then
			select	coalesce(max('N'),'S')
			into STRICT	ie_duplicar_w
			from	cpoe_material_proced_v where		cd_material = cd_mat_proc_w
			and		nr_atendimento = nr_atendimento_p
			and		nr_seq_proced = nr_seq_procedimento_p LIMIT 1;
		end if;
		
		if (ie_duplicar_w = 'S') then		
			begin	
				inserir_mat_associados_proc;
			exception when others then
				CALL gravar_log_tasy(10007,' CPOE_Gerar_med_mat_assoc - ERRO ' ||  to_char(sqlerrm),
								nm_usuario_p);	
			end;					
		end if;

		if (coalesce(ds_mat_adic_proc_p::text, '') = '') then
			exit;
		end if;
	end loop;
	close C02;

	commit;			
	exception when others then
		ds_erro_w	:= substr(sqlerrm(SQLSTATE),1,255);	
	end;
end if;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_gerar_med_mat_assoc ( nr_atendimento_p bigint, nr_seq_procedimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_paciente_p text, qt_idade_dia_p bigint, qt_idade_mes_p bigint, qt_idade_ano_p bigint, cd_setor_atendimento_p bigint, ie_tipo_atendimento_p bigint, cd_convenio_p bigint, cd_medico_p text, dt_prev_execucao_p timestamp, cd_intervalo_p text, ie_urgencia_p text, qt_hora_intervalo_p bigint, qt_min_intervalo_p bigint, ds_horarios_p text, nr_ocorrencia_p bigint, ds_mat_adic_proc_p INOUT text, nr_seq_contraste_p bigint default null, nr_seq_cpoe_order_unit_p cpoe_order_unit.nr_sequencia%type default null) FROM PUBLIC;
