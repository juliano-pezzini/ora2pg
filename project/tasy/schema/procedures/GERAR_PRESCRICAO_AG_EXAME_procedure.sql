-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_prescricao_ag_exame ( nr_seq_agenda_p bigint, nm_usuario_p text, cd_setor_usuario_p bigint, nr_prescricao_p INOUT bigint, ie_gerar_cpoe_p text default 'N') AS $body$
DECLARE

					


qt_prescr_w			bigint;

nr_prescricao_w			bigint;
cd_setor_atendimento_w		integer 	:= 0;
cd_procedimento_w		bigint	:= 0;
ie_origem_proced_w		bigint	:= 0;
qt_passagem_setor_w		bigint;
ie_origem_inf_w			varchar(1);
dt_prescricao_w			timestamp;
cd_estabelecimento_w		smallint;
cd_setor_proced_w		integer;
cd_medico_agenda_w		varchar(10);
ie_medico_requisitante_w	varchar(01)	:= 'N';
ie_medico_prescr_w		varchar(15);
nr_seq_interno_w		bigint	:= 0;
qt_peso_agenda_w		real;
qt_altura_cm_w			real;
cd_paciente_w			varchar(10);


ie_agenda_nova_w		varchar(01);
ie_regra_prescr_w		varchar(15)	:= 'U';
nr_prescricao_ind_w		bigint;

/* Variaveis utilizada no cursor c02 */

cd_procedimento_ind_w		bigint;
ie_origem_proced_ind_w		bigint;
ie_autorizacao_w		varchar(03);
cd_medico_agenda_ind_w		varchar(10);
ie_lado_w			varchar(01);
nr_seq_proc_interno_w		bigint;
hr_inicio_w			timestamp;
cd_medico_exec_w		varchar(10);

ie_tipo_passagem_regra_w	varchar(1);
nr_seq_proc_interno_uni_w	bigint;
nr_seq_forma_laudo_w		bigint;
cd_setor_entrega_w		bigint;
cd_setor_padrao_w		bigint;
ie_atualizar_setor_agenda_w	varchar(3);
ie_atualiza_setor_entrega	varchar(1) := 'U';
cd_setor_entrega_270_w		varchar(10);
ie_adep_w			varchar(3);
ie_medico_w			varchar(5);
cd_pessoa_fisica_w		varchar(10);
ds_erro_w			varchar(4000);
ie_prescr_agenda_w		varchar(1)	:= 'N';
nr_doc_convenio_w		varchar(20);
ie_nr_doc_convenio_w		varchar(1);
cd_medico_agendamento_w		varchar(10);
nr_seq_prescr_w			bigint;
nr_seq_pepo_w			bigint;
ie_prescr_dt_agenda_w		varchar(1);

cd_procedimento_agend_w		bigint;
nr_seq_proc_interno_agend_w	bigint;
ie_origem_proced_agend_w	bigint;
cd_setor_atend_agend_w		integer;
ie_tipo_atend_agend_w		smallint;
cd_convenio_agend_w		bigint;
ie_medico_executor_w		varchar(1);
cd_cgc_w			varchar(14);
cd_pf_fisica_w			varchar(10);

cd_medico_anestesista_w	varchar(10);
nr_seq_fanep			bigint;
nr_seq_proc_interno_ww	bigint;
cd_procedimento_ww		bigint;
ie_origem_proced_ww		bigint;
nr_atendimento_w		bigint;
cd_pessoa_fisica_ww		varchar(10);
ie_chama_fanep_w		varchar(10);


ie_gera_opme_w			varchar(1);
nr_seq_apresentacao_w		bigint;
ds_materiais_w			varchar(255);
cd_kit_material_w		integer;
nr_seq_prescr_material_w	integer;
nr_agrupamento_w		double precision;
hr_prim_horario_w		varchar(05);
ie_duplica_prescr_w		varchar(1);
ie_registra_w			varchar(1);
cd_material_w			integer;
nr_seq_componente_w		integer;
ie_gerou_itens_w		varchar(1) := 'N';
nr_seq_lote_fornec_w		bigint;
ie_acumula_w			varchar(01);
cd_material_opcao_w		integer;
qt_material_w			double precision;
cd_unidade_medida_w		varchar(30);
ie_via_aplicacao_w		varchar(05);
ie_dispensavel_w		varchar(01);
cd_fornecedor_w			varchar(14);
ie_tipo_material_w		varchar(3);
cd_convenio_ww			integer;
ie_gerado_avulso_w		varchar(1) := 'N';
cd_intervalo_w			varchar(7);
ie_gerar_consistido_w		varchar(15) := 'N';
nr_doc_interno_w		numeric(20);
nr_seq_reg_kit_w		bigint;
nr_doc_interno_aux_w		numeric(20);
cd_categoria_w			varchar(10);
dt_inicio_prescr_w		timestamp;
dt_validade_prescr_w	timestamp;
dt_entrega_w			prescr_medica.dt_entrega %type;	

c01 CURSOR FOR
	SELECT	cd_setor_atendimento
	from	procedimento_setor_atend
	where	cd_procedimento		= cd_procedimento_w
	and	ie_origem_proced		= ie_origem_proced_w
	and	cd_estabelecimento		= cd_estabelecimento_w
	order	by ie_prioridade desc;

C02 CURSOR FOR
	SELECT	a.nr_sequencia
	from	prescr_procedimento a,
		agenda_paciente b
	where	b.cd_procedimento = a.cd_procedimento
	and	a.ie_origem_proced = b.ie_origem_proced
	and	b.nr_sequencia = nr_seq_agenda_p
	and	a.nr_prescricao = nr_prescricao_w;
	
	
c03 CURSOR FOR
	SELECT	9999 nr_seq_apresentacao,
		a.cd_material,
		a.qt_material,
		SUBSTR(obter_dados_material_estab(a.cd_material,cd_estabelecimento_w,'UMS'),1,30) cd_unidade_medida_consumo,
		b.ie_via_aplicacao,
		'N' ie_dispensavel,
		0 cd_kit_material,
		0 nr_seq_componente,
		'' cd_fornecedor,
		b.ie_tipo_material,
		0,
		NULL,
		'S',
		NULL,
		'N'
	FROM	material b,
		agenda_pac_opme a
	WHERE	a.cd_material			=	b.cd_material
	AND	a.ie_autorizado			=	'A'
	AND	a.nr_seq_agenda			=	nr_seq_agenda_p
	ORDER BY nr_seq_apresentacao;

c04 CURSOR FOR
	SELECT	cd_material
	FROM	componente_kit_opcao
	WHERE	cd_kit_material		= cd_kit_material_w
	AND	nr_seq_componente	= nr_seq_componente_w;


BEGIN





select	count(*)
into STRICT	qt_prescr_w
from	prescr_medica
where	nr_seq_agenda = nr_seq_agenda_p;





if (qt_prescr_w = 0) then


	/* Select utilizado na proc agenda prescricao */

	select	max(a.cd_medico_exec)
	into STRICT	cd_medico_exec_w
	from	agenda b,
		agenda_paciente a
	where 	a.nr_sequencia	= nr_seq_agenda_p
	and	a.cd_agenda	= b.cd_agenda;
	

	select	max(b.cd_estabelecimento),
		max(a.cd_pessoa_fisica),
		max(a.cd_procedimento),
		max(a.nr_seq_proc_interno),
		max(a.ie_origem_proced),
		coalesce(max(a.cd_setor_atendimento),0),
		coalesce(max(a.ie_tipo_atendimento),0),
		max(a.cd_convenio)
	into STRICT	cd_estabelecimento_w,
		cd_paciente_w,
		cd_procedimento_agend_w,
		nr_seq_proc_interno_agend_w,
		ie_origem_proced_agend_w,
		cd_setor_atend_agend_w,
		ie_tipo_atend_agend_w,
		cd_convenio_agend_w
	from	agenda_paciente a,
		agenda b
	where	a.cd_agenda = b.cd_agenda
	and	a.nr_sequencia = nr_seq_agenda_p;

	SELECT * FROM consiste_medico_executor(cd_estabelecimento_w, cd_convenio_agend_w, cd_setor_atend_agend_w, cd_procedimento_agend_w, ie_origem_proced_agend_w, ie_tipo_atend_agend_w, null, nr_seq_proc_interno_agend_w, ie_medico_executor_w, cd_cgc_w, cd_medico_agendamento_w, cd_pf_fisica_w, null, clock_timestamp(), null, 'N', null, null) INTO STRICT ie_medico_executor_w, cd_cgc_w, cd_medico_agendamento_w, cd_pf_fisica_w;

	if (coalesce(cd_medico_exec_w::text, '') = '') and (coalesce(cd_medico_agendamento_w::text, '') = '') then
		CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(184044);
	end if;


	if (coalesce(cd_paciente_w,0) = 0) then
		CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(268404);	
	end if;
	

	/* Obter os valores dos parametros na funcao Entrada Unica de Pacientes - EUP */

	ie_medico_prescr_w := Obter_Param_Usuario(916, 203, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_medico_prescr_w);
	cd_setor_entrega_w  := Obter_Param_Usuario(916, 457, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, cd_setor_entrega_w );
	ie_atualizar_setor_agenda_w := obter_param_usuario(916, 452, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_atualizar_setor_agenda_w);
	ie_prescr_agenda_w := Obter_param_usuario(916, 655, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_prescr_agenda_w);
	ie_adep_w := Obter_param_usuario(924, 246, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_adep_w);
	ie_nr_doc_convenio_w := Obter_param_usuario(916, 714, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_nr_doc_convenio_w);
	ie_chama_fanep_w := Obter_param_usuario(820, 342, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_chama_fanep_w);
	ie_prescr_dt_agenda_w := Obter_param_usuario(820, 330, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_prescr_dt_agenda_w);
	ie_gera_opme_w := Obter_param_usuario(820, 315, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_gera_opme_w);

	select	max(cd_pessoa_Fisica)
	into STRICT	cd_pessoa_fisica_w
	from	usuario
	where	nm_usuario = nm_usuario_p;

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_medico_w
	from	medico
	where	cd_pessoa_fisica = cd_pessoa_fisica_w
	and	ie_situacao	= 'A';


	if (ie_adep_w = 'DS') then
		select	coalesce(max(ie_adep),'S')
		into STRICT	ie_adep_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_w;
	elsif (ie_adep_w = 'NV') then
		ie_adep_w := 'N';
	elsif (ie_adep_w = 'PV') then
		ie_adep_w := 'S';
	elsif (ie_adep_w =  'PNV') then
		ie_adep_w := 'N';
	else
		ie_adep_w := 'S';
	end if;

	/* Rafael em 30/18/ OS81037 inclui este IF */

	if (coalesce(nr_seq_agenda_p,0) > 0) then
		select	coalesce(Obter_Valor_Param_Usuario(39, 88, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_w), 'N')
		into STRICT	ie_medico_requisitante_w
		;
		if (ie_medico_requisitante_w	= 'N') then
			select	coalesce(Obter_Valor_Param_Usuario(820, 136, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_w), 'N')
			into STRICT	ie_medico_requisitante_w
			;
		end if;
	else
		ie_medico_requisitante_w := 'N';
	end if;

	/* Obter as informacoes da agenda */

	select	coalesce(max(cd_procedimento),0),
		coalesce(max(ie_origem_proced),0),
		max(cd_medico),
		max(qt_peso),
		max(qt_altura_cm),
		max(nr_seq_proc_interno),
		max(hr_inicio)
	into STRICT	cd_procedimento_w,
		ie_origem_proced_w,
		cd_medico_agenda_w,
		qt_peso_agenda_w,
		qt_altura_cm_w,
		nr_seq_proc_interno_uni_w,
		hr_inicio_w
	from	agenda_paciente
	where	nr_sequencia	= nr_seq_agenda_p;

	if (cd_setor_atendimento_w = 0) then
		/*select	nvl(max(cd_setor_exclusivo),0) -- Rafael em 05/12/2007 OS73448 */

		select	coalesce(coalesce(max(a.cd_setor_atendimento),max(b.cd_setor_exclusivo)),0)
		into STRICT	cd_setor_atendimento_w
		from	Agenda b,
			agenda_paciente a
		where 	a.cd_agenda	= b.cd_agenda
		and	a.nr_sequencia	= nr_seq_agenda_p;
	end if;

	cd_setor_padrao_w	:= null;

	if ie_atualizar_setor_agenda_w = 'S' then
		select 	obter_dados_agendamento(nr_seq_agenda_p,'CSA')
		into STRICT	cd_setor_entrega_w
		;
	end if;

	if (coalesce(cd_setor_entrega_w,0) > 0) then
		cd_setor_padrao_w	:= cd_setor_entrega_w;
	end if;

	if (cd_setor_atendimento_w = 0) then
		select	coalesce(max(cd_setor_exclusivo),0)
		into STRICT	cd_setor_atendimento_w
		from	procedimento
		where	cd_procedimento	= cd_procedimento_w
		and	ie_origem_proced	= ie_origem_proced_w;
	end if;

	if (ie_prescr_agenda_w = 'S') then
		cd_setor_atendimento_w	:= 0;
	end if;

	if (cd_setor_atendimento_w = 0) then
		cd_setor_atendimento_w	:= coalesce(cd_setor_usuario_p,0);
	end if;

	if (cd_setor_atendimento_w = 0) then
		select	cd_setor_atendimento
		into STRICT	cd_setor_atendimento_w
		from	usuario
		where	nm_usuario	= nm_usuario_p;
	end if;

	if (cd_setor_atendimento_w	= 0) then
		cd_setor_atendimento_w	:= null;
	end if;

	/* Obter ie_origem_inf se e medico ou nao */

	select	coalesce(max('1'),'3')
	into STRICT	ie_origem_inf_w
	from	Medico b,
		Usuario a
	where 	a.nm_usuario	= nm_usuario_p
	and	a.cd_pessoa_fisica	= b.cd_pessoa_fisica;

	if (ie_prescr_dt_agenda_w = 'S') then
		dt_prescricao_w := hr_inicio_w;
	else
		dt_prescricao_w	:= clock_timestamp();
	end if;
		
	dt_entrega_w := clock_timestamp();
	
	if (dt_entrega_w < dt_prescricao_w) then
		dt_entrega_w := dt_prescricao_w;
	end if;

	/*define setor_atendimento conforme parametro[270]*/

	if (ie_atualiza_setor_entrega = 'U') then
		cd_setor_entrega_270_w:=  cd_setor_entrega_w;
	end if;
	if (cd_setor_entrega_270_w	= 0) then
		cd_setor_entrega_270_w		:= null;
	end if;
	/* Gera a prescricao medica, conforme o parametro [36] da funcao Agenda de Exames */


	/*Observacao: Ao alterar a procedure:  Gerar_Proc_Agenda_Prescricao deve ser analisada a procedure: Gerar_Proc_Agenda_Prescr_Ind, pois a mesma possui a mesma funcionalidade */

	if (ie_regra_prescr_w = 'U') then
		begin

		select	nextval('prescr_medica_seq')
		into STRICT	nr_prescricao_w
		;

		insert into prescr_medica(
			nr_prescricao,
			cd_pessoa_fisica,
			cd_medico,
			dt_prescricao,
			dt_atualizacao,
			nm_usuario,
			nm_usuario_original,
			nr_horas_validade,
			dt_liberacao,
			cd_setor_atendimento,
			cd_setor_entrega,
			dt_entrega,
			ie_recem_nato,
			ie_origem_inf,
			cd_estabelecimento,
			nr_seq_agenda,
			cd_prescritor,
			qt_peso,
			qt_altura_cm,
			nr_seq_forma_laudo,
			ie_adep,
			dt_primeiro_horario)
		values	(nr_prescricao_w,
			cd_paciente_w,
			coalesce(cd_medico_exec_w,cd_medico_agendamento_w),
			dt_prescricao_w,
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_p,
			24,
			null,
			coalesce(cd_setor_padrao_w,cd_setor_atendimento_w),
			coalesce(cd_setor_entrega_270_w,(coalesce(cd_setor_padrao_w,cd_setor_atendimento_w))),
			dt_entrega_w,
			'N',
			ie_origem_inf_w,
			cd_estabelecimento_w,
			CASE WHEN coalesce(nr_seq_agenda_p,0)=0 THEN  null  ELSE nr_seq_agenda_p END ,
			obter_dados_usuario_opcao(nm_usuario_p, 'C'),
			qt_peso_agenda_w,
			qt_altura_cm_w,
			nr_seq_forma_laudo_w,
			ie_adep_w,
			dt_prescricao_w);

		nr_prescricao_p	:= nr_prescricao_w;

		IF (ie_gera_opme_w = 'S') THEN
			-- gerar materiais
			OPEN c03;
			LOOP
			FETCH c03 INTO  nr_seq_apresentacao_w,
					cd_material_w,
					qt_material_w,
					cd_unidade_medida_w,
					ie_via_aplicacao_w,
					ie_dispensavel_w,
					cd_kit_material_w,
					nr_seq_componente_w,
					cd_fornecedor_w,
					ie_tipo_material_w,
					cd_convenio_ww,
					cd_categoria_w,
					ie_duplica_prescr_w,
					nr_seq_lote_fornec_w,
					ie_gerado_avulso_w;
			EXIT WHEN NOT FOUND; /* apply on c03 */
			BEGIN

			ds_materiais_w	:= ' ';

			IF (cd_kit_material_w <> 0) AND (nr_seq_componente_w <> 0) THEN
				BEGIN
				OPEN	c04;
				LOOP
				FETCH	c04 INTO
					cd_material_opcao_w;
				EXIT WHEN NOT FOUND; /* apply on c04 */
				BEGIN
					IF (ds_materiais_w	= ' ') THEN
						ds_materiais_w	:= wheb_mensagem_pck.get_texto(308445) || ': '; -- Materiais substitutos
					END IF;
					ds_materiais_w	:= ds_materiais_w || cd_material_opcao_w || ';';
				END;
				END LOOP;
				CLOSE c04;
				END;
			END IF;

			SELECT	coalesce(MAX(nr_sequencia),0) + 1
			INTO STRICT	nr_seq_prescr_material_w
			FROM	prescr_material
			WHERE	nr_prescricao = nr_prescricao_w;

			SELECT	coalesce(MAX(nr_agrupamento),0) + 1
			INTO STRICT	nr_agrupamento_w
			FROM	prescr_material
			WHERE	nr_prescricao = nr_prescricao_w;

			SELECT	TO_CHAR(dt_primeiro_horario,'HH24:MM')
			INTO STRICT	hr_prim_horario_w
			FROM	prescr_medica
			WHERE	nr_prescricao = nr_prescricao_w;

			SELECT	coalesce(MAX('N'),'S')
			INTO STRICT	ie_registra_w
			FROM	prescr_material
			WHERE	cd_material = cd_material_w
			AND	nr_prescricao = nr_prescricao_w
			AND	coalesce(ie_duplica_prescr_w,'S') = 'N';

			IF (ie_registra_w = 'S') THEN
				BEGIN
				ie_gerou_itens_w := 'S';

				UPDATE	prescr_material
				SET	qt_dose		= qt_dose + qt_material_w,
					qt_unitaria	= qt_unitaria + qt_material_w,
					qt_material	= qt_material + qt_material_w,
					qt_total_dispensar = qt_total_dispensar + qt_material_w
				WHERE	nr_prescricao	= nr_prescricao_w
				--and	ie_origem_inf	= ie_origem_inf_p
				AND	cd_material	= cd_material_w
				AND	cd_unidade_medida	= cd_unidade_medida_w
				AND	ie_status_cirurgia	= 'GI'
				AND	ie_acumula_w		= 'S'
				AND	cd_motivo_baixa = 0
				AND	coalesce(dt_baixa::text, '') = ''
				AND	coalesce(nr_seq_lote_fornec, 0) = coalesce(nr_seq_lote_fornec_w, 0);


				IF (NOT FOUND) OR (ie_acumula_w = 'N') THEN
					BEGIN
					


					INSERT INTO prescr_material(nr_prescricao,
						nr_sequencia,
						ie_origem_inf,
						cd_material,
						cd_unidade_medida,
						qt_dose,
						qt_unitaria,
						qt_material,
						dt_atualizacao,
						nm_usuario,
						cd_intervalo,
						ds_horarios,
						ds_observacao,
						ie_via_aplicacao,
						nr_agrupamento,
						cd_motivo_baixa,
						dt_baixa,
						ie_utiliza_kit,
						cd_unidade_medida_dose,
						qt_conversao_dose,
						ie_urgencia,
						nr_ocorrencia,
						qt_total_dispensar,
						cd_fornec_consignado,
						nr_sequencia_solucao,
						nr_sequencia_proc,
						qt_solucao,
						hr_dose_especial,
						qt_dose_especial,
						ds_dose_diferenciada,
						ie_medicacao_paciente,
						nr_sequencia_diluicao,
						hr_prim_horario,
						nr_dia_util,
						nr_sequencia_dieta,
						ie_agrupador,
						dt_emissao_setor_atend,
						ie_suspenso,
						ds_justificativa,
						qt_dias_solicitado,
						qt_dias_liberado,
						nm_usuario_liberacao,
						dt_liberacao,
						ie_se_necessario,
						qt_min_aplicacao,
						nr_seq_lote_fornec,
						ie_status_cirurgia,
						ie_bomba_infusao,
						ie_aplic_bolus,
						ie_aplic_lenta,
						ie_acm,
						--cd_kit_material,
						ie_recons_diluente_fixo,
						cd_convenio,
						cd_categoria,
						ie_sem_aprazamento,
						nr_doc_interno,
						cd_local_estoque,
						nr_seq_reg_kit,
						nr_doc_interno_aux)
					VALUES (  nr_prescricao_w,
						nr_seq_prescr_material_w,
						ie_origem_inf_w,
						cd_material_w,
						cd_unidade_medida_w,
						qt_material_w,
						qt_material_w,
						qt_material_w,
						clock_timestamp(),
						nm_usuario_p,
						cd_intervalo_w,
						NULL,
						ds_materiais_w,
						ie_via_aplicacao_w,
						nr_agrupamento_w,
						0,
						NULL,
						'N',
						NULL,
						NULL,
						'N',
						1,
						qt_material_w,
						cd_fornecedor_w,
						NULL,
						NULL,
						NULL,
						NULL,
						 NULL,
						NULL,
						'N',
						NULL,
						hr_prim_horario_w,
						NULL,
						NULL,
						CASE WHEN ie_tipo_material_w='1' THEN  2 WHEN ie_tipo_material_w='2' THEN  1 WHEN ie_tipo_material_w='3' THEN  1  ELSE 2 END ,
						NULL,
						'N',
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						ie_dispensavel_w,
						NULL,
						nr_seq_lote_fornec_w,
						CASE WHEN ie_gerar_consistido_w='S' THEN  'CB'  ELSE 'GI' END ,
						'N',
						'N',
						'N',
						'N',
						--decode(cd_kit_material_p, 0, decode(nvl(cd_kit_material_w,0),0,null,cd_kit_material_w), cd_kit_material_p),
						'N',
						CASE WHEN cd_convenio_ww=0 THEN NULL  ELSE cd_convenio_ww END ,
						cd_categoria_w,
						'N',
						nr_doc_interno_w,
						NULL,
						CASE WHEN nr_seq_reg_kit_w=0 THEN NULL  ELSE nr_seq_reg_kit_w END ,
						nr_doc_interno_aux_w);--,
					COMMIT;
					END;
				END IF;
				END;
			END IF;


			END;
			END LOOP;
			CLOSE c03;
		END IF;	
			

		if (ie_chama_fanep_w = 'FANEP') then
			select 	cd_anestesista,
					nr_atendimento,
					nr_seq_proc_interno,
					cd_procedimento,
					ie_origem_proced,
					cd_pessoa_fisica
			into STRICT	cd_medico_anestesista_w,
					nr_atendimento_w,
					nr_seq_proc_interno_ww,
					cd_procedimento_ww,
					ie_origem_proced_ww,
					cd_pessoa_fisica_ww
			from	agenda_paciente
			where	nr_sequencia = nr_seq_agenda_p;
			
			
			nr_seq_fanep := gerar_fanep_gestao_exames(cd_pessoa_fisica_ww, cd_medico_anestesista_w, nr_atendimento_w, nr_seq_agenda_p, nr_seq_fanep, nm_usuario_p, nr_seq_proc_interno_ww, cd_procedimento_ww, ie_origem_proced_ww);

		end if;	
		if (ie_nr_doc_convenio_w = 'S') then

			select	max(nr_doc_convenio)
			into STRICT	nr_doc_convenio_w
			from	agenda_paciente
			where	nr_sequencia	= nr_seq_agenda_p
			and	(cd_procedimento IS NOT NULL AND cd_procedimento::text <> '');

			update	prescr_medica
			set	nr_doc_conv = nr_doc_convenio_w
			where 	nr_prescricao	= nr_prescricao_w;
			commit;

		end if;
			
	
		

		if (cd_setor_atendimento_w <> 0) and (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') and (nr_prescricao_w > 0) then
			begin
			/* Gera os procediagenda na prescricao criada */

			
			
			CALL Gerar_Proc_Agenda_Prescricao(nr_seq_agenda_p, nr_prescricao_w, cd_setor_atendimento_w, nm_usuario_p);

			open C02;
			loop
			fetch C02 into
				nr_seq_prescr_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin
				CALL Gerar_Kit_Procedimento(cd_estabelecimento_w,nr_prescricao_w,nr_seq_prescr_w,nm_usuario_p);
				end;
			end loop;
			close C02;

			end;
		end if;

		if (coalesce(nr_seq_agenda_p,0) > 0) and (coalesce(nr_prescricao_w,0) > 0) then
			select	coalesce(max(nr_seq_pepo),0)
			into STRICT	nr_seq_pepo_w
			from	agenda_paciente
			where	nr_sequencia = nr_seq_agenda_p;
			if (nr_seq_pepo_w > 0) then
				update	pepo_cirurgia
				set	nr_prescricao	= nr_prescricao_w
				where	nr_sequencia 	= nr_seq_pepo_w
				and	coalesce(nr_prescricao::text, '') = '';
			end if;
		end if;

		end;
	end if;

	commit;	
	
	if (ie_gerar_cpoe_p = 'S' and ie_chama_fanep_w = 'REP') then
		select max(dt_inicio_prescr),
			   max(dt_validade_prescr),
			   max(cd_pessoa_fisica)
		into STRICT   dt_inicio_prescr_w,
			   dt_validade_prescr_w,
			   cd_pessoa_fisica_w
		from 	prescr_medica
		where 	nr_prescricao = nr_prescricao_w;		
		
		CALL cpoe_rep_gerar_itens( nr_prescricao_w, nr_atendimento_w, dt_inicio_prescr_w, dt_validade_prescr_w, NULL, nm_usuario_p, cd_pessoa_fisica_w);
		
		CALL cpoe_delete_prescription( nr_prescricao_w, ' Stack Gerar_Prescricao_Ag_Exame');
		
end if;
	
end if;



end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_prescricao_ag_exame ( nr_seq_agenda_p bigint, nm_usuario_p text, cd_setor_usuario_p bigint, nr_prescricao_p INOUT bigint, ie_gerar_cpoe_p text default 'N') FROM PUBLIC;

