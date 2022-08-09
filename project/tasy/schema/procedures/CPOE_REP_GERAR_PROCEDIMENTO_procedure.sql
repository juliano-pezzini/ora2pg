-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_rep_gerar_procedimento ( nr_prescricao_p prescr_medica.nr_prescricao%type, nr_atendimento_p atendimento_paciente.nr_atendimento%type, dt_inicio_prescr_p timestamp, dt_validade_prescr_p timestamp, dt_liberacao_p timestamp, nm_usuario_p usuario.nm_usuario%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, cd_funcao_origem_p funcao.cd_funcao%type, cd_setor_atendimento_p prescr_medica.cd_setor_atendimento%type default null, ie_origem_inf_p prescr_procedimento.ie_origem_inf%type default null, nr_seq_procedimento_p prescr_procedimento.nr_sequencia%type default null, nr_seq_agenda_p prescr_medica.nr_seq_agenda%type default null) AS $body$
DECLARE

					
nr_seq_procedimento_w			prescr_procedimento.nr_sequencia%type;
cd_intervalo_w					prescr_procedimento.cd_intervalo%type;
cd_material_exame_w				prescr_procedimento.cd_material_exame%type;
ds_horarios_w					prescr_procedimento.ds_horarios%type;
ds_justificativa_w				prescr_procedimento.ds_justificativa%type;
ds_material_especial_w			prescr_procedimento.ds_material_especial%type;
ds_observacao_w					prescr_procedimento.ds_observacao%type;
dt_prev_execucao_w				prescr_procedimento.dt_prev_execucao%type;
ie_acm_w						prescr_procedimento.ie_acm%type;
ie_lado_w						prescr_procedimento.ie_lado%type;
ie_se_necessario_w				prescr_procedimento.ie_se_necessario%type;
ie_urgencia_w					prescr_procedimento.ie_urgencia%type;
nr_ocorrencia_w					prescr_procedimento.nr_ocorrencia%type;
nr_seq_proc_interno_w			prescr_procedimento.nr_seq_proc_interno%type;
nr_seq_prot_glic_w				prescr_procedimento.nr_seq_prot_glic%type;
nr_seq_topografia_w				prescr_procedimento.nr_seq_topografia%type;
qt_procedimento_w				prescr_procedimento.qt_procedimento%type;
cd_perfil_ativo_w				prescr_procedimento.cd_perfil_ativo%type;

nr_seq_proc_int_cirur_w			prescr_procedimento.nr_seq_proc_int_cirur%type;
cd_pessoa_coleta_w				prescr_procedimento.cd_pessoa_coleta%type;
dt_coleta_w						prescr_procedimento.dt_coleta%type;
qt_peca_ap_w					prescr_procedimento.qt_peca_ap%type;
nr_seq_amostra_princ_w			prescr_procedimento.nr_seq_amostra_princ%type;
ds_qualidade_peca_ap_w			prescr_procedimento.ds_qualidade_peca_ap%type;
ie_forma_exame_w				prescr_procedimento.ie_forma_exame%type;
ds_diag_provavel_ap_w			prescr_procedimento.ds_diag_provavel_ap%type;
ds_exame_anterior_ap_w			prescr_procedimento.ds_exame_anterior_ap%type;
ds_localizacao_lesao_w			prescr_procedimento.ds_localizacao_lesao%type;
ds_tempo_doenca_w				prescr_procedimento.ds_tempo_doenca%type;
cd_setor_atendimento_w			prescr_procedimento.cd_setor_atendimento%type;
qt_frasco_env_w					prescr_procedimento.qt_frasco_env%type;
ie_amostra_w					prescr_procedimento.ie_amostra%type;
ie_suspenso_w					prescr_procedimento.ie_suspenso%type;
cd_cgc_laboratorio_w			prescr_procedimento.cd_cgc_laboratorio%type;
ie_anestesia_w			prescr_procedimento.ie_anestesia%type;
nr_seq_contraste_w			prescr_procedimento.nr_seq_contraste%type;
ie_executar_leito_w			prescr_procedimento.ie_executar_leito%type;
cd_setor_entrega_w			prescr_procedimento.cd_setor_entrega%type;
cd_medico_exec_w				prescr_procedimento.cd_medico_exec%type;
cd_protocolo_w					prescr_procedimento.cd_protocolo%type;
nr_seq_protocolo_w				prescr_procedimento.nr_seq_protocolo%type;

nr_sequencia_w					cpoe_procedimento.nr_sequencia%type;
ie_administracao_w				cpoe_procedimento.ie_administracao%type;
hr_prim_horario_w				cpoe_procedimento.hr_prim_horario%type;
ie_urgencia_ww					cpoe_procedimento.ie_urgencia%type;
nr_seq_condicao_w				cpoe_procedimento.nr_seq_condicao%type;
ds_dado_clinico_w				cpoe_procedimento.ds_dado_clinico%type;
ie_evento_unico_w         		cpoe_procedimento.ie_evento_unico%type;
dt_fim_w		         		cpoe_procedimento.dt_fim%type;
nr_seq_cpoe_peca_w				bigint;
nr_seq_histopatol_w				cpoe_prescr_histopatol.nr_sequencia%type;
nr_seq_citopatol_w				cpoe_prescr_citopatologico.nr_sequencia%type;

ie_retrogrado_w				prescr_medica.ie_prescr_emergencia%type;
nr_seq_atend_w				prescr_medica.nr_seq_atend%type;
dt_liberacao_enf_w			timestamp;
nm_usuario_lib_enf_w		prescr_medica.nm_usuario_lib_enf%type;
cd_medico_w					prescr_medica.cd_medico%type;


c01 CURSOR FOR
SELECT	nr_sequencia,
		cd_intervalo,
		cd_material_exame,
		ds_horarios,
		ds_justificativa,
		ds_material_especial,
		ds_observacao,
		dt_prev_execucao,
		coalesce(ie_acm,'N'),
		ie_lado,
		coalesce(ie_se_necessario,'N'),
		coalesce(ie_urgencia,'N'),
		nr_ocorrencia,
		nr_seq_proc_interno,
		nr_seq_prot_glic,
		nr_seq_topografia,
		qt_procedimento,
		cd_perfil_ativo,
		nr_seq_condicao,
		ds_dado_clinico,
		ie_anestesia,
		nr_seq_contraste,
		ie_executar_leito,
		cd_setor_entrega,
		cd_medico_exec,
		cd_setor_atendimento,
		cd_protocolo,
		nr_seq_protocolo
from	prescr_procedimento
where	nr_prescricao = nr_prescricao_p
and		((nr_seq_superior = nr_seq_procedimento_p) or (coalesce(nr_seq_procedimento_p::text, '') = ''))
and	coalesce(nr_seq_origem::text, '') = ''
and	(nr_seq_proc_interno IS NOT NULL AND nr_seq_proc_interno::text <> '')
and	ie_origem_inf = coalesce(ie_origem_inf_p, ie_origem_inf)
and 	((Obter_se_exibe_proced(nr_prescricao,nr_sequencia,ie_tipo_proced,'O') = 'S') 
or (Obter_se_exibe_proced(nr_prescricao,nr_sequencia,ie_tipo_proced,'IVC') = 'S'));

c02 CURSOR FOR
SELECT	nr_sequencia,		
		cd_perfil_ativo,	
		nr_seq_proc_interno,
		nr_seq_proc_int_cirur,
		cd_pessoa_coleta,
		dt_coleta,
		qt_peca_ap,
		nr_seq_amostra_princ,
		ds_qualidade_peca_ap,
		ds_dado_clinico,
		ie_forma_exame,
		ds_diag_provavel_ap,
		ds_exame_anterior_ap,
		ds_localizacao_lesao,
		ds_tempo_doenca,
		ds_observacao,
		cd_setor_atendimento,
		qt_frasco_env,
		cd_material_exame,
		cd_cgc_laboratorio,
		qt_procedimento,
		coalesce(ie_amostra,'N'),
		coalesce(ie_suspenso,'N'),	
		coalesce(ie_acm,'N'),
		coalesce(ie_se_necessario,'N'),
		coalesce(ie_urgencia,'N')		
from	prescr_procedimento
where	nr_prescricao = nr_prescricao_p
and		((nr_seq_superior = nr_seq_procedimento_p) or (coalesce(nr_seq_procedimento_p::text, '') = ''))
and	coalesce(nr_seq_origem::text, '') = ''
and	(nr_seq_proc_int_cirur IS NOT NULL AND nr_seq_proc_int_cirur::text <> '')
and ((Obter_se_exibe_proced(nr_prescricao,nr_sequencia,ie_tipo_proced,'AP') = 'S') or (Obter_se_exibe_proced(nr_prescricao,nr_sequencia,ie_tipo_proced,'APH') = 'S') or (Obter_se_exibe_proced(nr_prescricao,nr_sequencia,ie_tipo_proced,'APC') = 'S'));

c03 CURSOR FOR
SELECT	nr_sequencia                   ,
		cd_topografia                  ,
		cd_morfologia                  ,
		dt_atualizacao                 ,
		nm_usuario                     ,
		dt_atualizacao_nrec            ,
		nm_usuario_nrec                ,
		nr_seq_laudo                   ,
		cd_doenca_cid                  ,
		nr_seq_peca                    ,
		nr_seq_pato_exame              ,
		ie_status                      ,
		nr_seq_tipo                    ,
		nr_seq_apresent                ,
		nr_controle                    ,
		ds_amostra_principal           ,
		nr_seq_exame_complementar,
		nr_seq_caso_congelacao    ,
		nr_seq_amostra_princ       ,    
		nr_sequencia_princ          ,   
		nr_revisao                   ,  
		nr_fragmentos                 , 
		ds_designacao                  ,
		ds_observacao                  ,
		ie_tipo_designacao             ,
		ie_exame_compl                 ,
		nr_seq_designacao              ,
		ie_situacao                    ,
		ie_peca_principal              ,
		ie_lado     ,
    NR_SEQ_MORF_DESC_ADIC
from	prescr_proc_peca
where	nr_prescricao	= nr_prescricao_p
and		nr_seq_prescr	= nr_seq_procedimento_w;

c03_w c03%rowtype;
	
c04 CURSOR FOR
SELECT	dt_atualizacao,
		dt_atualizacao_nrec,
		dt_ultima_menstruacao,
		dt_ultimo_exame,
		ie_dst,
		ie_exame_preventivo,
		ie_gravida,
		ie_hormonio,
		ie_inspecao_colo,
		ie_pilula,
		ie_radioterapia,
		ie_sangramento,
		ie_sangr_apos_menop,
		ie_ultima_menstruacao,
		ie_usa_diu,
		nm_usuario,
		nm_usuario_nrec
from	prescr_citopatologico
where	nr_prescricao	= nr_prescricao_p;

c04_w c04%rowtype;	
	
c05 CURSOR FOR
SELECT	ds_inf_adic,
		ds_result_exame_outro,
		dt_atualizacao,
		dt_atualizacao_nrec,
		ie_caf,
		ie_colposcopia,
		ie_colposcopia_anormal,
		ie_procedimento,
		ie_result_aden_in_sito,
		ie_result_aden_invasivo,
		ie_result_ascus,
		ie_result_car_esc_inv,
		ie_result_hpv,
		ie_result_nao_fornec,
		ie_result_nici,
		ie_result_nicii,
		ie_result_niciii,
		ie_result_outros,
		nm_usuario,
		nm_usuario_nrec
from	prescr_histopatologico
where	nr_prescricao = nr_prescricao_p;

c05_w	c05%rowtype;
	

BEGIN

select	max(coalesce(ie_prescr_emergencia,'N')),
		max(nr_seq_atend),
		max(dt_liberacao),
		max(nm_usuario_lib_enf),
		max(cd_medico)
into STRICT	ie_retrogrado_w,
		nr_seq_atend_w,
		dt_liberacao_enf_w,
		nm_usuario_lib_enf_w,
		cd_medico_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;	

open c01;
loop
fetch c01 into	nr_seq_procedimento_w,
				cd_intervalo_w,
				cd_material_exame_w,
				ds_horarios_w,
				ds_justificativa_w,
				ds_material_especial_w,
				ds_observacao_w,
				dt_prev_execucao_w,
				ie_acm_w,
				ie_lado_w,
				ie_se_necessario_w,
				ie_urgencia_w,
				nr_ocorrencia_w,
				nr_seq_proc_interno_w,
				nr_seq_prot_glic_w,
				nr_seq_topografia_w,
				qt_procedimento_w,
				cd_perfil_ativo_w,
				nr_seq_condicao_w,
				ds_dado_clinico_w,
				ie_anestesia_w,
				nr_seq_contraste_w,
				ie_executar_leito_w,
				cd_setor_entrega_w,
				cd_medico_exec_w,
				cd_setor_atendimento_w,
				cd_protocolo_w,
				nr_seq_protocolo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	ie_administracao_w := 'P';
	ie_urgencia_ww := '';	
	dt_prev_execucao_w := coalesce(dt_prev_execucao_w, dt_inicio_prescr_p);
	hr_prim_horario_w := to_char(dt_prev_execucao_w,'hh24:mi');
	
	if (ie_urgencia_w = 'S') then
		ie_urgencia_ww := '0';
	elsif (ie_acm_w = 'S') then
		ie_administracao_w := 'C';
		ds_horarios_w := '';
		hr_prim_horario_w := '';
	elsif (ie_se_necessario_w = 'S') then
		ie_administracao_w := 'N';
		ds_horarios_w := '';
		hr_prim_horario_w := '';
	end if;
		
	select	nextval('cpoe_procedimento_seq')
	into STRICT	nr_sequencia_w
	;
	
	if (cd_funcao_origem_p = 2314) then
		if (position('A' in padroniza_horario_prescr(ds_horarios_w, dt_prev_execucao_w)) > 0) then
			dt_fim_w := fim_dia(dt_prev_execucao_w + 1);
		else
			dt_fim_w := fim_dia(dt_prev_execucao_w);
		end if;
	else
		dt_fim_w := dt_validade_prescr_p;
	end if;

	insert into cpoe_procedimento(
					nr_sequencia,
					nr_atendimento,
					ie_administracao,
					ie_duracao,
					dt_liberacao,
					dt_inicio,
					dt_fim,
					dt_prox_geracao,
					hr_prim_horario,
					cd_intervalo,
					cd_material_exame,
					ds_horarios,
					ds_justificativa,
					ds_material_especial,
					ds_observacao,
					dt_prev_execucao,
					ie_acm,
					ie_lado,
					ie_se_necessario,
					ie_urgencia,
					nr_ocorrencia,
					nr_seq_proc_interno,
					nr_seq_prot_glic,
					nr_seq_topografia,
					qt_procedimento,
					nm_usuario,
					nm_usuario_nrec,
					dt_atualizacao,
					dt_atualizacao_nrec,
					cd_perfil_ativo,
					cd_pessoa_fisica,
					nr_seq_condicao,
					ds_dado_clinico,
					ie_evento_unico,
					cd_funcao_origem,
					cd_setor_atendimento,
					ie_retrogrado,
					ie_oncologia,
					dt_liberacao_enf,
					nm_usuario_lib_enf,
					ie_anestesia,
					nr_seq_contraste,
					nr_seq_agenda,
					ie_executar_leito,
					cd_setor_entrega,
					cd_medico_exec,
					cd_medico,
					cd_protocolo,
					nr_seq_protocolo)
				values (
					nr_sequencia_w,
					nr_atendimento_p,
					ie_administracao_w,
					'P',
					dt_liberacao_p,
					dt_prev_execucao_w,
					dt_fim_w,
					dt_prev_execucao_w + 12/24,
					hr_prim_horario_w,
					cd_intervalo_w,
					cd_material_exame_w,
					ds_horarios_w,
					ds_justificativa_w,
					ds_material_especial_w,
					ds_observacao_w,
					dt_prev_execucao_w,
					ie_acm_w,
					ie_lado_w,
					ie_se_necessario_w,
					ie_urgencia_ww,
					nr_ocorrencia_w,
					nr_seq_proc_interno_w,
					nr_seq_prot_glic_w,
					nr_seq_topografia_w,
					qt_procedimento_w,
					nm_usuario_p,
					nm_usuario_p,
					clock_timestamp(),
					clock_timestamp(),
					cd_perfil_ativo_w,
					cd_pessoa_fisica_p,
					nr_seq_condicao_w, 
					ds_dado_clinico_w,
					ie_evento_unico_w,
					cd_funcao_origem_p,
					coalesce(cd_setor_atendimento_w,cd_setor_atendimento_p),
					ie_retrogrado_w,
					CASE WHEN coalesce(nr_seq_atend_w::text, '') = '' THEN 'N'  ELSE 'S' END ,
					dt_liberacao_enf_w,
					nm_usuario_lib_enf_w,
					coalesce(ie_anestesia_w,'N'),
					nr_seq_contraste_w,
					nr_seq_agenda_p,
					coalesce(ie_executar_leito_w,'N'),
					cd_setor_entrega_w,
					cd_medico_exec_w,
					cd_medico_w,
					cd_protocolo_w,
					nr_seq_protocolo_w);
					
	CALL cpoe_rep_gerar_mat_assoc_proc( nr_seq_procedimento_w, nr_sequencia_w, nr_prescricao_p, nr_atendimento_p, dt_inicio_prescr_p, nm_usuario_p, cd_perfil_ativo_w, cd_pessoa_fisica_p, dt_liberacao_p, cd_funcao_origem_p);
	CALL cpoe_rep_gerar_proc_glic(nr_prescricao_p, nr_seq_procedimento_w, nr_atendimento_p, nr_sequencia_w,nm_usuario_p,cd_pessoa_fisica_p);
					
	update	prescr_procedimento
	set		nr_seq_proc_cpoe = nr_sequencia_w
	where	nr_sequencia = nr_seq_procedimento_w
	and		nr_prescricao = nr_prescricao_p;
	
	end;
end loop;
close c01;

open C02;
loop
fetch C02 into	
		nr_seq_procedimento_w,
		cd_perfil_ativo_w,
		nr_seq_proc_interno_w,
		nr_seq_proc_int_cirur_w,
		cd_pessoa_coleta_w,
		dt_coleta_w,
		qt_peca_ap_w, 
		nr_seq_amostra_princ_w, 
		ds_qualidade_peca_ap_w, 
		ds_dado_clinico_w,
		ie_forma_exame_w,
		ds_diag_provavel_ap_w, 
		ds_exame_anterior_ap_w, 
		ds_localizacao_lesao_w, 
		ds_tempo_doenca_w,
		ds_observacao_w,
		cd_setor_atendimento_w, 
		qt_frasco_env_w, 
		cd_material_exame_w,
		cd_cgc_laboratorio_w,
		qt_procedimento_w,
		ie_amostra_w,
		ie_suspenso_w, 
		ie_acm_w,
		ie_se_necessario_w,
		ie_urgencia_w;		
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	
	ie_administracao_w := 'P';
	ie_urgencia_ww := '';
	hr_prim_horario_w := to_char(dt_coleta_w,'hh24:mi');
	if (ie_urgencia_w = 'S') then
		ie_urgencia_ww := '0';
	elsif (ie_acm_w = 'S') then
		ie_administracao_w := 'C';
		hr_prim_horario_w := '';
	elsif (ie_se_necessario_w = 'S') then
		ie_administracao_w := 'N';
		hr_prim_horario_w := '';
	end if;
	
	select	nextval('cpoe_procedimento_seq')
	into STRICT	nr_sequencia_w
	;

	insert into cpoe_anatomia_patologica(
					nr_sequencia,
					nr_atendimento,
					ie_administracao,
					ie_duracao,
					dt_liberacao,
					dt_inicio,
					dt_coleta,
					dt_fim,
					hr_prim_horario,
					cd_material_exame,
					ds_observacao,
					ie_urgencia,
					nr_seq_proc_interno,
					nr_seq_proc_int_cirur,
					nm_usuario,
					nm_usuario_nrec,
					dt_atualizacao,
					dt_atualizacao_nrec,
					cd_perfil_ativo,
					cd_pessoa_fisica,
					cd_funcao_origem,
					cd_setor_exec,
					cd_pessoa_coleta,
					qt_peca_ap,
					nr_seq_amostra_princ,
					ds_qualidade_peca_ap,
					ds_dado_clinico,
					ie_forma_exame,
					ds_diag_provavel_ap,
					ds_exame_anterior_ap, 
					ds_localizacao_lesao, 
					ds_tempo_doenca,
					qt_frasco_env,
					ie_amostra,
					ie_suspenso,
					cd_cgc_laboratorio,
					qt_procedimento,
					cd_setor_atendimento,
					ie_retrogrado
					)
				values (
					nr_sequencia_w,
					nr_atendimento_p,
					ie_administracao_w,
					'P',
					dt_liberacao_p,
					dt_coleta_w,
					dt_coleta_w,
					dt_validade_prescr_p,
					hr_prim_horario_w,
					cd_material_exame_w,
					ds_observacao_w,
					ie_urgencia_ww,
					nr_seq_proc_interno_w,
					nr_seq_proc_int_cirur_w,
					nm_usuario_p,
					nm_usuario_p,
					clock_timestamp(),
					clock_timestamp(),
					cd_perfil_ativo_w,
					cd_pessoa_fisica_p,
					cd_funcao_origem_p,
					cd_setor_atendimento_w,
					cd_pessoa_coleta_w,
					qt_peca_ap_w,
					nr_seq_amostra_princ_w,
					ds_qualidade_peca_ap_w,
					ds_dado_clinico_w,
					ie_forma_exame_w,
					ds_diag_provavel_ap_w, 
					ds_exame_anterior_ap_w, 
					ds_localizacao_lesao_w, 
					ds_tempo_doenca_w,
					qt_frasco_env_w,
					ie_amostra_w,
					ie_suspenso_w,
					cd_cgc_laboratorio_w,
					qt_procedimento_w,
					cd_setor_atendimento_p,
					ie_retrogrado_w
					);
	
		open C03;
		loop
		fetch C03 into	
			C03_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
			
			select	nextval('cpoe_prescr_proc_peca_seq')
			into STRICT	nr_seq_cpoe_peca_w
			;

			insert into cpoe_prescr_proc_peca(	
						nr_sequencia                   ,
						cd_topografia                  ,
						cd_morfologia                  ,
						dt_atualizacao                 ,
						nm_usuario                     ,
						dt_atualizacao_nrec            ,
						nm_usuario_nrec                ,
						nr_seq_laudo                   ,
						cd_doenca_cid                  ,
						nr_seq_peca                    ,
						nr_seq_pato_exame              ,
						ie_status                      ,
						nr_seq_tipo                    ,
						nr_seq_apresent                ,
						nr_controle                    ,
						ds_amostra_principal           ,
						nr_seq_exame_complementar,
						nr_seq_caso_congelacao    ,
						nr_seq_amostra_princ       ,    
						nr_sequencia_princ          ,   
						nr_revisao                   ,  
						nr_fragmentos                 , 
						ds_designacao                  ,
						ds_observacao                  ,
						ie_tipo_designacao             ,
						ie_exame_compl                 ,
						nr_seq_designacao              ,
						ie_situacao                    ,
						ie_peca_principal              ,
						dt_inativacao                  ,
						nr_seq_cpoe_proc               ,
						ie_lado ,
            NR_SEQ_MORF_DESC_ADIC)
			values (		nr_seq_cpoe_peca_w,
						c03_w.cd_topografia                  ,
						c03_w.cd_morfologia                  ,
						c03_w.dt_atualizacao                 ,
						c03_w.nm_usuario                     ,
						c03_w.dt_atualizacao_nrec            ,
						c03_w.nm_usuario_nrec                ,
						c03_w.nr_seq_laudo                   ,
						c03_w.cd_doenca_cid                  ,
						c03_w.nr_seq_peca                    ,
						c03_w.nr_seq_pato_exame              ,
						c03_w.ie_status                      ,
						c03_w.nr_seq_tipo                    ,
						c03_w.nr_seq_apresent                ,
						c03_w.nr_controle                    ,
						c03_w.ds_amostra_principal           ,
						c03_w.nr_seq_exame_complementar,
						c03_w.nr_seq_caso_congelacao    ,     
						c03_w.nr_seq_amostra_princ       ,    
						c03_w.nr_sequencia_princ          ,   
						c03_w.nr_revisao                   ,  
						c03_w.nr_fragmentos                 , 
						c03_w.ds_designacao                  ,
						c03_w.ds_observacao                  ,
						c03_w.ie_tipo_designacao             ,
						c03_w.ie_exame_compl                 ,
						c03_w.nr_seq_designacao              ,
						c03_w.ie_situacao                    ,
						c03_w.ie_peca_principal              ,
						null                  ,
						nr_sequencia_w             ,
						c03_w.ie_lado,
            c03_w.NR_SEQ_MORF_DESC_ADIC);
			end;
		end loop;
		close C03;
	
		open C04;
		loop
		fetch C04 into	
			C04_w;
		EXIT WHEN NOT FOUND; /* apply on C04 */
			begin
			
			select	nextval('cpoe_prescr_citopatologico_seq')
			into STRICT	nr_seq_citopatol_w
			;
			
			insert into cpoe_prescr_citopatologico(	
						nr_sequencia,
						ie_exame_preventivo,
						dt_ultimo_exame,
						ie_usa_diu,
						ie_gravida,
						ie_pilula,
						ie_hormonio,
						ie_radioterapia,
						ie_ultima_menstruacao,
						dt_ultima_menstruacao,
						ie_sangramento,
						ie_sangr_apos_menop,
						ie_inspecao_colo,
						ie_dst,
						nr_seq_proc_anatomia)
			values (		nr_seq_citopatol_w,
						C04_w.ie_exame_preventivo,
						C04_w.dt_ultimo_exame,
						C04_w.ie_usa_diu,
						C04_w.ie_gravida,
						C04_w.ie_pilula,
						C04_w.ie_hormonio,
						C04_w.ie_radioterapia,
						C04_w.ie_ultima_menstruacao,
						C04_w.dt_ultima_menstruacao,
						C04_w.ie_sangramento,
						C04_w.ie_sangr_apos_menop,
						C04_w.ie_inspecao_colo,
						C04_w.ie_dst,
						nr_sequencia_w);
			end;
		end loop;
		close C04;
	
		open C05;
		loop
		fetch C05 into	
			C05_w;
		EXIT WHEN NOT FOUND; /* apply on C05 */
			begin
			
			select	nextval('cpoe_prescr_histopatol_seq')
			into STRICT	nr_seq_histopatol_w
			;

			insert into cpoe_prescr_histopatol(	
						nr_sequencia,
						ie_result_hpv,
						ie_result_car_esc_inv,
						ie_result_ascus,
						ie_result_aden_in_sito,
						ie_result_nici,
						ie_result_aden_invasivo,
						ie_result_nicii,
						ie_result_nao_fornec,
						ie_result_niciii,
						ie_result_outros,
						ds_result_exame_outro,
						ie_colposcopia,
						ie_colposcopia_anormal,
						ie_procedimento,
						ds_inf_adic,
						ie_caf,
						nr_seq_proc_anatomia)
			values (		nr_seq_histopatol_w,
						C05_w.ie_result_hpv,
						C05_w.ie_result_car_esc_inv,
						C05_w.ie_result_ascus,
						C05_w.ie_result_aden_in_sito,
						C05_w.ie_result_nici,
						C05_w.ie_result_aden_invasivo,
						C05_w.ie_result_nicii,
						C05_w.ie_result_nao_fornec,
						C05_w.ie_result_niciii,
						C05_w.ie_result_outros,
						C05_w.ds_result_exame_outro,
						C05_w.ie_colposcopia,
						C05_w.ie_colposcopia_anormal,
						C05_w.ie_procedimento,
						C05_w.ds_inf_adic,
						C05_w.ie_caf,
						nr_sequencia_w);
			end;
		end loop;
		close C05;
	
	end;
end loop;
close C02;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_rep_gerar_procedimento ( nr_prescricao_p prescr_medica.nr_prescricao%type, nr_atendimento_p atendimento_paciente.nr_atendimento%type, dt_inicio_prescr_p timestamp, dt_validade_prescr_p timestamp, dt_liberacao_p timestamp, nm_usuario_p usuario.nm_usuario%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, cd_funcao_origem_p funcao.cd_funcao%type, cd_setor_atendimento_p prescr_medica.cd_setor_atendimento%type default null, ie_origem_inf_p prescr_procedimento.ie_origem_inf%type default null, nr_seq_procedimento_p prescr_procedimento.nr_sequencia%type default null, nr_seq_agenda_p prescr_medica.nr_seq_agenda%type default null) FROM PUBLIC;
