-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_encaixe_agenda_exame ( cd_estabelecimento_p bigint, cd_agenda_p bigint, dt_agenda_p timestamp, hr_encaixe_p timestamp, qt_duracao_p bigint, cd_pessoa_fisica_p text, nm_pessoa_fisica_p text, cd_convenio_p bigint, cd_categoria_p text, cd_medico_p text, cd_medico_exec_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, ie_lado_p text, ds_observacao_p text, nm_usuario_p text, cd_setor_atendimento_p bigint, ie_forma_agendamento_p text, cd_plano_p text, nm_usuario_confirm_encaixe_p text, nr_seq_classif_p bigint, nr_seq_encaixe_p INOUT bigint, nr_seq_segurado_p bigint default null, dt_val_carteira_p timestamp default null, cd_usuario_convenio_p text default null, cd_empresa_ref_p bigint default null) AS $body$
DECLARE


dt_encaixe_w			timestamp;
ds_consistencia_w		varchar(4000);
ds_validacao_w			varchar(255);
cd_turno_w				varchar(1);
nr_seq_classif_w		bigint;
ie_forma_convenio_w		varchar(2);
cd_convenio_w			integer;
cd_categoria_w			varchar(10);
cd_usuario_convenio_w	varchar(30);
cd_plano_w				varchar(10);
dt_validade_w			timestamp;
nr_doc_convenio_w		varchar(20);
cd_tipo_acomodacao_w	smallint;
nr_seq_agenda_w			agenda_paciente.nr_sequencia%type;
ie_proc_agenda_w		varchar(1);
ds_observacao_aux		varchar(4000);
cd_retorno_w			bigint;
ie_consist_js_w			varchar(255) := '';
ie_atualiza_sala_turno_w varchar(1);
nr_seq_sala_w			bigint;
nr_seq_turno_w			bigint;
qt_agendamentos_w		bigint;
qt_regra_w				bigint;
ds_mensagem_w			varchar(255);
ie_cons_sobrep_hor_enc_w	varchar(1);
qt_encaixe_turno_w		bigint := 0;
qt_perm_enc_turno_w		bigint := 0;
nr_seq_turno_val_marc_w	bigint;
hr_inicial_turno_w		timestamp;
hr_final_turno_w		timestamp;
ds_erro_w				varchar(255);
ie_cons_regra_aut_w		varchar(2) := '';
ie_regra_w			smallint;
nr_seq_regra_w			bigint;
ds_cons_erro_w			varchar(255);
ds_procedimento_w		varchar(255);
ds_convenio_w			varchar(255);
qt_peso_w			pessoa_fisica.qt_peso%type;
qt_altura_cm_w			pessoa_fisica.qt_altura_cm%type;
ie_glosa_w			regra_ajuste_proc.ie_glosa%type;
nr_seq_regra_preco_w		regra_ajuste_proc.nr_sequencia%type;
ie_regra_encaixe_turno_w 	varchar(1);
nr_seq_bloq_geral_w		agenda_bloqueio_geral.nr_sequencia%type;


BEGIN
select	coalesce(max(obter_valor_param_usuario(820,417, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)), 'S'),
		coalesce(max(obter_valor_param_usuario(820,440, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)), 'S')
into STRICT	ie_cons_sobrep_hor_enc_w,
		ie_regra_encaixe_turno_w
;

select	coalesce(max(obter_valor_param_usuario(820, 201, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)), 'S')
into STRICT	ie_cons_regra_aut_w
;


if (ie_cons_regra_aut_w = 'S') then
	SELECT * FROM consiste_plano_convenio(null, cd_convenio_p, cd_procedimento_p, ie_origem_proced_p, clock_timestamp(), 1, null, cd_plano_p, '', ds_cons_erro_w, cd_setor_atendimento_p, null, ie_regra_w, null, nr_seq_regra_w, nr_seq_proc_interno_p, cd_categoria_p, cd_estabelecimento_p, 0, cd_medico_exec_p, cd_pessoa_fisica_p, ie_glosa_w, nr_seq_regra_preco_w) INTO STRICT ds_cons_erro_w, ie_regra_w, nr_seq_regra_w, ie_glosa_w, nr_seq_regra_preco_w;
	if (ie_regra_w in (1,2)) then
		ds_convenio_w		:= obter_nome_convenio(cd_convenio_p);
		ds_procedimento_w	:= obter_desc_procedimento(cd_procedimento_p,ie_origem_proced_p);
		CALL wheb_mensagem_pck.exibir_mensagem_abort(290431, 'DS_PROCEDIMENTO='||ds_procedimento_w||';DS_CONVENIO='||ds_convenio_w);
	end if;
end if;

if (cd_agenda_p IS NOT NULL AND cd_agenda_p::text <> '') and (dt_agenda_p IS NOT NULL AND dt_agenda_p::text <> '') and (hr_encaixe_p IS NOT NULL AND hr_encaixe_p::text <> '') and (qt_duracao_p IS NOT NULL AND qt_duracao_p::text <> '') and
	((cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') or (nm_pessoa_fisica_p IS NOT NULL AND nm_pessoa_fisica_p::text <> '')) and
	--(cd_convenio_p is not null) and

	--(cd_medico_p is not null) and

	--(cd_medico_exec_p is not null)
	(nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	/* obter horario agenda x encaixe */

	dt_encaixe_w := pkg_date_utils.get_DateTime(dt_agenda_p, hr_encaixe_p);

	if (ie_cons_sobrep_hor_enc_w = 'S')then
		ds_validacao_w := consistir_horario_agenda_exame(cd_agenda_p, dt_encaixe_w, qt_duracao_p, 'E', ds_validacao_w);
		
		if (ds_validacao_w IS NOT NULL AND ds_validacao_w::text <> '') then
			CALL Wheb_mensagem_pck.exibir_mensagem_abort( 262328 , 'DS_MENSAGEM='||ds_validacao_w);
		end if;
	end if;


	/* consistir regras procedimento x convenio */

	if (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') and (ie_origem_proced_p IS NOT NULL AND ie_origem_proced_p::text <> '') then
		SELECT * FROM consistir_proc_conv_agenda(cd_estabelecimento_p, cd_pessoa_fisica_p, dt_encaixe_w, cd_agenda_p, cd_convenio_p, cd_categoria_p, cd_procedimento_p, ie_origem_proced_p, nr_seq_proc_interno_p, cd_medico_exec_p, 'E', cd_plano_p, null, null, null, null, null, null, null) INTO STRICT ds_consistencia_w, ie_proc_agenda_w, cd_retorno_w, ie_consist_js_w;
		if	((ie_proc_agenda_w = 'N') or (ie_proc_agenda_w = 'H') or (ie_proc_agenda_w = 'Q')) then
			CALL Wheb_mensagem_pck.exibir_mensagem_abort( 262328 , 'DS_MENSAGEM='||ds_consistencia_w);
		end if;
	end if;


	if (nr_seq_proc_interno_p IS NOT NULL AND nr_seq_proc_interno_p::text <> '') then
		CALL Consistir_Regra_Agenda_Grupo(cd_agenda_p, dt_agenda_p, nr_seq_proc_interno_p, 0, nm_usuario_p, cd_estabelecimento_p, 0);
	end if;

	if (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') and (ie_origem_proced_p IS NOT NULL AND ie_origem_proced_p::text <> '') then
		SELECT * FROM consistir_proc_conv_agenda(cd_estabelecimento_p, cd_pessoa_fisica_p, dt_encaixe_w, cd_agenda_p, cd_convenio_p, cd_categoria_p, cd_procedimento_p, ie_origem_proced_p, nr_seq_proc_interno_p, cd_medico_p, 'R', cd_plano_p, null, null, null, null, null, null, null) INTO STRICT ds_consistencia_w, ie_proc_agenda_w, cd_retorno_w, ie_consist_js_w;

		if	((ie_proc_agenda_w = 'N') or (ie_proc_agenda_w = 'H') or (ie_proc_agenda_w = 'Q')) then
			CALL Wheb_mensagem_pck.exibir_mensagem_abort( 262328 , 'DS_MENSAGEM='||ds_consistencia_w);
		end if;
	end if;

	/* obter parametros */

	select	coalesce(max(obter_valor_param_usuario(820, 6, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)), 'N')
	into STRICT	ie_forma_convenio_w
	;

	select	coalesce(max(obter_valor_param_usuario(820, 375, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)), 'N')
	into STRICT	ie_atualiza_sala_turno_w
	;

	/* obter turno */

	select	obter_turno_horario_agenda(cd_agenda_p, dt_encaixe_w)
	into STRICT	cd_turno_w
	;

	/*obter sequencia do turno*/

	select	obter_turno_encaixe_ageexame(cd_agenda_p, dt_encaixe_w)
	into STRICT	nr_seq_turno_w
	;


	if (ie_atualiza_sala_turno_w = 'S') then
		select	max(nr_seq_sala)
		into STRICT	nr_seq_sala_w
		from	agenda_horario
		where	nr_sequencia = nr_seq_turno_w;
	end if;

	if ((ie_regra_encaixe_turno_w = 'N') and (coalesce(nr_seq_turno_w::text, '') = '')) then
		--Nao e permitido gerar um encaixe fora do horario do turno cadastrado. Parametro [440].
		CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(326563);
	end if;

	/* obter classificacao */


	--obter_classif_encaixe_agenda(nr_seq_classif_w);
	nr_seq_classif_w	:= nr_seq_classif_p;

	/* obter sequencia */

	select	nextval('agenda_paciente_seq')
	into STRICT	nr_seq_agenda_w
	;

	SELECT * FROM Consistir_qtd_conv_regra(nr_seq_agenda_w, cd_convenio_p, dt_encaixe_w, cd_agenda_p, cd_pessoa_fisica_p, cd_categoria_w, cd_plano_w, cd_estabelecimento_p, nm_usuario_p, null, null, nr_seq_proc_interno_p, qt_agendamentos_w, qt_regra_w, ds_mensagem_w) INTO STRICT qt_agendamentos_w, qt_regra_w, ds_mensagem_w;

	select	max(nr_sequencia)
	into STRICT	nr_seq_turno_val_marc_w
	from	agenda_horario
	where	to_char(dt_encaixe_w, 'hh24:mi:ss') between to_char(hr_inicial,'hh24:mi:ss') and to_char(hr_final,'hh24:mi:ss')
	and		coalesce(dt_inicio_vigencia, to_date(to_char(dt_agenda_p, 'dd/mm/yyyy') || ' ' || to_char(dt_encaixe_w,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')) <=
			to_date(to_char(dt_agenda_p, 'dd/mm/yyyy') || ' ' || to_char(dt_encaixe_w,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
	and		coalesce(dt_final_vigencia, to_date(to_char(dt_agenda_p, 'dd/mm/yyyy') || ' ' || to_char(dt_encaixe_w,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')) >=
			to_date(to_char(dt_agenda_p, 'dd/mm/yyyy') || ' ' || to_char(dt_encaixe_w,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
	and		nr_minuto_intervalo > 0
	and		((dt_dia_semana = obter_cod_dia_semana(dt_agenda_p)) or ((dt_dia_semana = 9) and (obter_cod_dia_semana(dt_agenda_p) not in (7,1))))
	and		cd_agenda 		= cd_agenda_p
	and		(qt_encaixe IS NOT NULL AND qt_encaixe::text <> '');

	if (nr_seq_turno_val_marc_w IS NOT NULL AND nr_seq_turno_val_marc_w::text <> '')then
		begin

		select	max(hr_inicial),
				max(hr_final),
				max(qt_encaixe)
		into STRICT	hr_inicial_turno_w,
				hr_final_turno_w,
				qt_perm_enc_turno_w
		from	agenda_horario
		where	nr_sequencia = nr_seq_turno_val_marc_w;

		if (hr_inicial_turno_w IS NOT NULL AND hr_inicial_turno_w::text <> '') and (hr_final_turno_w IS NOT NULL AND hr_final_turno_w::text <> '')then
			select	count(*) + 1
			into STRICT	qt_encaixe_turno_w
			from	agenda_paciente
			where	coalesce(ie_encaixe,'N')	= 'S'
			and		hr_inicio 		between to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' || to_char(hr_inicial_turno_w,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
			and		to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' || to_char(hr_final_turno_w,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
			and		ie_status_agenda	not in ('C', 'F', 'I', 'II', 'B', 'R')
			and		cd_agenda			= cd_agenda_p
			and		(dt_geracao_encaixe IS NOT NULL AND dt_geracao_encaixe::text <> '');
			--and		nr_seq_horario		= nr_seq_turno_val_marc_w;
		end if;

		exception
		when others then
			ds_erro_w := substr(sqlerrm,1,255);
		end;
	end if;

	if (qt_perm_enc_turno_w IS NOT NULL AND qt_perm_enc_turno_w::text <> '') and (coalesce(qt_encaixe_turno_w,0) > coalesce(qt_perm_enc_turno_w,0))then
		/*A quantidade limite de encaixes para este turno foi atingida! Verifique a qtd. permitida no cadastro dos horarios da agenda.*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(260557);
	end if;

	nr_seq_bloq_geral_w := obter_se_bloq_geral_agenda(cd_estabelecimento_p,
							cd_agenda_p,
							null, --ie_classif_agenda_p
							nr_seq_classif_w,
							null, --cd_espec_agendamento_p
							cd_setor_atendimento_p,
							nr_seq_proc_interno_p,
							cd_procedimento_p,
							ie_origem_proced_p,
							cd_medico_p,
							dt_encaixe_w,
							'N',
							'N');
	if (nr_seq_bloq_geral_w > 0) then
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(obter_mensagem_bloq_geral_age(nr_seq_bloq_geral_w));
	end if;

	select	max(qt_peso),
		max(qt_altura_cm)
	into STRICT	qt_peso_w,
		qt_altura_cm_w
	from	pessoa_fisica
	where	cd_pessoa_fisica = cd_pessoa_fisica_p;

	/* gerar encaixe */

	insert into agenda_paciente(
					nr_sequencia,
					cd_agenda,
					dt_agenda,
					hr_inicio,
					nr_minuto_duracao,
					ie_status_agenda,
					cd_pessoa_fisica,
					nm_paciente,
					dt_nascimento_pac,
					qt_idade_paciente,
					nr_telefone,
					cd_convenio,
					cd_medico,
					cd_procedimento,
					ie_origem_proced,
					nr_seq_proc_interno,
					ie_lado,
					ds_observacao,
					nr_seq_classif_agenda,
					cd_turno,
					ie_equipamento,
					dt_agendamento,
					nm_usuario_orig,
					cd_medico_exec,
					nm_usuario,
					dt_atualizacao,
					ie_encaixe,
					cd_setor_atendimento,
					ie_forma_agendamento,
					cd_categoria,
					nm_usuario_confirm_encaixe,
					dt_confirm_encaixe,
					qt_idade_meses,
					cd_perfil_ger_encaixe,
					nr_seq_sala,
					ds_email,
					qt_peso,
					qt_altura_cm,
					cd_plano,
					nr_seq_segurado,
					cd_usuario_convenio,
					cd_empresa_ref,
					dt_validade_carteira
					)
				values (
					nr_seq_agenda_w,
					cd_agenda_p,
					trunc(dt_encaixe_w,'dd'),
					dt_encaixe_w,
					qt_duracao_p,
					'N',
					cd_pessoa_fisica_p,
					substr(coalesce(obter_nome_pf(cd_pessoa_fisica_p), nm_pessoa_fisica_p),1,60),
					to_date(substr(obter_dados_pf(cd_pessoa_fisica_p,'DN'),1,10),'dd/mm/yyyy'),
					substr(obter_dados_pf(cd_pessoa_fisica_p,'I'),1,3),
					substr(obter_fone_pac_agenda(cd_pessoa_fisica_p),1,255),
					cd_convenio_p,
					cd_medico_p,
					cd_procedimento_p,
					ie_origem_proced_p,
					nr_seq_proc_interno_p,
					ie_lado_p,
					ds_observacao_p,
					nr_seq_classif_w,
					cd_turno_w,
					'N',
					clock_timestamp(),
					nm_usuario_p,
					cd_medico_exec_p,
					nm_usuario_p,
					clock_timestamp(),
					'S',
					cd_setor_atendimento_p,
					ie_forma_agendamento_p,
					cd_categoria_p,
					nm_usuario_confirm_encaixe_p,
					clock_timestamp(),
					obter_idade(to_date(obter_dados_pf(cd_pessoa_fisica_p,'DN'),'dd/mm/yyyy'),clock_timestamp(),'MM'),
					CASE WHEN coalesce(obter_perfil_ativo,0)=0 THEN null  ELSE obter_perfil_ativo END ,
					nr_seq_sala_w,
					substr(obter_compl_pf(cd_pessoa_fisica_p, 1, 'M'),1,255),
					qt_peso_w,
					qt_altura_cm_w,
					cd_plano_p,
					nr_seq_segurado_p,
					cd_usuario_convenio_p,
					cd_empresa_ref_p,
					dt_val_carteira_p);

	/* obter dados convenio, caso usuario nao informar (Esta rotina devera permanecer aqui, antes do insert gera erro) */

	if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (coalesce(cd_convenio_p::text, '') = '') and (ie_forma_convenio_w <> 'N') then
		SELECT * FROM gerar_convenio_agendamento(cd_pessoa_fisica_p, 2, nr_seq_agenda_w, ie_forma_convenio_w, cd_convenio_w, cd_categoria_w, cd_usuario_convenio_w, dt_validade_w, nr_doc_convenio_w, cd_tipo_acomodacao_w, cd_plano_w, nm_usuario_p, ds_observacao_aux) INTO STRICT cd_convenio_w, cd_categoria_w, cd_usuario_convenio_w, dt_validade_w, nr_doc_convenio_w, cd_tipo_acomodacao_w, cd_plano_w, ds_observacao_aux;

		if (cd_convenio_w = '0') then
			cd_convenio_w := null;
		end if;

		if (cd_plano_w = '0') then
			cd_plano_w := null;
		end if;

		if (cd_categoria_w = '0') then
			cd_categoria_w := null;
		end if;



		if (cd_convenio_w IS NOT NULL AND cd_convenio_w::text <> '') then

			update	agenda_paciente
			set	cd_convenio		= cd_convenio_w,
				cd_categoria		= cd_categoria_w,
				cd_usuario_convenio	= cd_usuario_convenio_w,
				dt_validade_carteira	= dt_validade_w,
				nr_doc_convenio	= nr_doc_convenio_w,
				cd_tipo_acomodacao	= cd_tipo_acomodacao_w,
				cd_plano		= cd_plano_w
			where	nr_sequencia		= nr_seq_agenda_w;
		end if;
	end if;
/*
else
	20011, 'Voce deve informar todos os dados para a geracao do encaixe');*/
end if;

delete 	FROM agenda_controle_horario
where 	cd_agenda = cd_agenda_p
and 	dt_agenda = trunc(dt_agenda_p);

commit;

nr_seq_encaixe_p := nr_seq_agenda_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_encaixe_agenda_exame ( cd_estabelecimento_p bigint, cd_agenda_p bigint, dt_agenda_p timestamp, hr_encaixe_p timestamp, qt_duracao_p bigint, cd_pessoa_fisica_p text, nm_pessoa_fisica_p text, cd_convenio_p bigint, cd_categoria_p text, cd_medico_p text, cd_medico_exec_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, ie_lado_p text, ds_observacao_p text, nm_usuario_p text, cd_setor_atendimento_p bigint, ie_forma_agendamento_p text, cd_plano_p text, nm_usuario_confirm_encaixe_p text, nr_seq_classif_p bigint, nr_seq_encaixe_p INOUT bigint, nr_seq_segurado_p bigint default null, dt_val_carteira_p timestamp default null, cd_usuario_convenio_p text default null, cd_empresa_ref_p bigint default null) FROM PUBLIC;

