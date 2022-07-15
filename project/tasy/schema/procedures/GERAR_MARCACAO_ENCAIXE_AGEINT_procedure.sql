-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_marcacao_encaixe_ageint (cd_estabelecimento_p bigint, cd_agenda_p bigint, dt_agenda_p timestamp, hr_encaixe_p text, qt_duracao_p bigint, cd_pessoa_fisica_p text, cd_convenio_p bigint, cd_categoria_p text, nr_seq_proc_interno_p bigint, nm_usuario_p text, cd_setor_atendimento_p bigint, nr_seq_ageint_item_p bigint, nr_Seq_ageint_p bigint, nr_seq_ageint_lib_p bigint, cd_medico_p text, nm_usuario_confirm_encaixe_p text default null, ie_classif_agenda_p text DEFAULT NULL, ds_observacao_p text DEFAULT NULL) AS $body$
DECLARE

						--nr_seq_encaixe_p out	number) is
dt_encaixe_w		timestamp;
ds_consistencia_w	varchar(255);
cd_turno_w		varchar(1);
nr_seq_classif_w	bigint;
ie_forma_convenio_w	varchar(2);
cd_convenio_w		integer;
cd_categoria_w		varchar(10);
cd_usuario_convenio_w	varchar(30);
cd_plano_w		varchar(10);
dt_validade_w		timestamp;
nr_doc_convenio_w	varchar(20);
cd_tipo_acomodacao_w	smallint;
nr_seq_agenda_w		bigint;
ie_proc_agenda_w	varchar(1);
cd_tipo_Agenda_w	bigint;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
ie_reservado_w		varchar(1);
ie_principal_w		varchar(1);
ie_sobreposicao_w	varchar(1);
qt_horarios_bloq_w	bigint;
ie_dia_semana_w		integer;
ie_bloqueio_w		varchar(1);
ie_consiste_encaixe_w	varchar(1);
ds_erro_w		varchar(255);
qt_encaixe_w		bigint;
qt_encaixe_existe_w	bigint;
qt_encaixe_turno_w	bigint := 0;
qt_perm_enc_turno_w	bigint := 0;
nr_seq_turno_val_marc_w	bigint;
hr_inicial_turno_w	timestamp;
hr_final_turno_w	timestamp;
nr_seq_turno_w		bigint;
ie_regra_horario_turno_w	varchar(1);
qt_idade_min_enc_w			bigint;
qt_idade_max_enc_w			bigint;
qt_idade_pac_w				bigint;
dt_nascimento_w				timestamp;
ds_consist_encaixe_turno_w	varchar(255);
ie_permite_classif_w		varchar(1) := 'S';
ie_consiste_classif_lib_w		varchar(1);
ie_conv_cancelado_w		varchar(1);
cd_medico_agenda_w		pessoa_fisica.cd_pessoa_fisica%type;
cd_especialidade_w		especialidade_proc.cd_especialidade%type;
cd_setor_agenda_w		setor_atendimento.cd_setor_atendimento%type;
cd_setor_exclusivo_w		setor_atendimento.cd_setor_atendimento%type;
cd_especialidade_item_w		especialidade_medica.cd_especialidade%type;
nr_seq_regra_bloq_w		bigint;
CD_SETOR_ATENDIMENTO_W		setor_atendimento.cd_setor_atendimento%type;
ie_regra_turno_exames_w varchar(1);
qt_dias_fut_w		bigint;


BEGIN

select 	SUBSTR(Obter_se_Convenio_Cancelado(cd_convenio_p, dt_agenda_p),1,2)				
into STRICT 	ie_conv_cancelado_w
;

if (ie_conv_cancelado_w = 'S') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(857353);
end if;

if (hr_encaixe_p = '  :  ') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(184601);
end if;

dt_encaixe_w := TO_DATE(TO_CHAR(dt_agenda_p,'dd/mm/yyyy') || ' ' || hr_encaixe_p || ':00','dd/mm/yyyy hh24:mi:ss');

ie_sobreposicao_w := Obter_Param_Usuario(869, 162, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_sobreposicao_w);
ie_consiste_encaixe_w := Obter_Param_Usuario(869, 219, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_consiste_encaixe_w);
ie_consiste_classif_lib_w := Obter_Param_Usuario(869, 403, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_consiste_classif_lib_w);
ie_regra_horario_turno_w := Obter_Param_Usuario(821, 219, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_regra_horario_turno_w);
ie_regra_turno_exames_w := Obter_Param_Usuario(820, 440, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_regra_turno_exames_w);

select	max(dt_nascimento)
into STRICT	dt_nascimento_w
from	pessoa_fisica
where	cd_pessoa_fisica = cd_pessoa_fisica_p;

select  max(cd_tipo_agenda),
		coalesce(max(qt_idade_min_encaixe),0),
		coalesce(max(qt_idade_max_encaixe),0),
		max(cd_pessoa_fisica),
		max(cd_especialidade),
		max(cd_setor_agenda),
		max(cd_setor_exclusivo),
    max(nr_dias_fut_agendamento)
into STRICT    cd_tipo_agenda_w,
		qt_idade_min_enc_w,
		qt_idade_max_enc_w,
		cd_medico_agenda_w,
		cd_especialidade_w,
		cd_setor_agenda_w,
		cd_setor_exclusivo_w,
    qt_dias_fut_w
from    agenda
where   cd_agenda = cd_agenda_p;

select 	obter_cod_dia_semana(dt_agenda_p),
		obter_idade(dt_nascimento_w, trunc(dt_encaixe_w), 'A')
into STRICT	ie_dia_semana_w,
		qt_idade_pac_w
;

if (qt_dias_fut_w > 0) and (dt_encaixe_w > trunc(clock_timestamp() + qt_dias_fut_w)) then
  CALL wheb_mensagem_pck.exibir_mensagem_abort(1134591);
end if;

if (ie_sobreposicao_w = 'S') then
	if (cd_tipo_agenda_w = 3) then
		ds_consistencia_w := consistir_horario_agecons(cd_agenda_p, dt_encaixe_w, qt_duracao_p, 'E', ds_consistencia_w);
		if (ds_consistencia_w IS NOT NULL AND ds_consistencia_w::text <> '') then
			CALL Wheb_mensagem_pck.exibir_mensagem_abort( 262328 , 'DS_MENSAGEM='||ds_consistencia_w);
		end if;
	elsif (cd_tipo_agenda_w = 2) then
		ds_consistencia_w := consistir_horario_agenda_exame(cd_agenda_p, dt_encaixe_w, qt_duracao_p, 'E', ds_consistencia_w);
		if (ds_consistencia_w IS NOT NULL AND ds_consistencia_w::text <> '') then
			CALL Wheb_mensagem_pck.exibir_mensagem_abort( 262328 , 'DS_MENSAGEM='||ds_consistencia_w);
		end if;
	end if;
end if;

/*Validar caso exista algum bloqueio para determinado exame na pasta Cadastros > Exames > Regras exames > Bloqueios*/

if (ie_consiste_encaixe_w	= 'S') then
	ie_bloqueio_w := ageint_consistir_bloq_agenda(cd_Agenda_p, dt_encaixe_w, ie_dia_semana_w, nr_seq_proc_interno_p, ie_bloqueio_w, cd_pessoa_fisica_p);
	if (ie_bloqueio_w	= 'S') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(184602);
	end if;
end if;

--Exames
if (cd_tipo_agenda_w = 2) then
	select	coalesce(max(qt_encaixe),0)
	into STRICT	qt_encaixe_w
	from	agenda
	where	cd_agenda = cd_agenda_p;
	
	if (qt_encaixe_w > 0) then
		select	count(*)
		into STRICT	qt_encaixe_existe_w
		from	agenda_paciente
		where	coalesce(ie_encaixe,'N') = 'S'
		and	cd_agenda = cd_agenda_p
		and	ie_status_agenda not in ('C','F','I')
		and	dt_agenda between trunc(dt_agenda_p) and trunc(dt_agenda_p) + 83699/86400;
	
		if (qt_encaixe_existe_w >= qt_encaixe_w) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(238107);
		end if;
	end if;
--Consultas
elsif (cd_tipo_agenda_w = 3) then
	select	coalesce(max(qt_encaixe),0)
	into STRICT	qt_encaixe_w
	from	agenda
	where	cd_agenda = cd_agenda_p;
	
	if (qt_encaixe_w > 0) then
		select	count(*)
		into STRICT	qt_encaixe_existe_w
		from	agenda_consulta
		where	coalesce(ie_encaixe,'N') = 'S'
		and		cd_agenda = cd_agenda_p
		and		ie_status_agenda not in ('C','F','I')
		and		dt_agenda between trunc(dt_agenda_p) and trunc(dt_agenda_p) + 83699/86400;
	
		if (qt_encaixe_existe_w >= qt_encaixe_w) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(238107);
		end if;
	end if;
	
	
end if;

/*Regra de quantidade de encaixe por convenio*/

if (cd_tipo_agenda_w = 3) then
	nr_seq_turno_w := obter_turno_encaixe_agecons(cd_agenda_p,dt_encaixe_w);
	
	ds_consist_encaixe_turno_w := ageint_consistir_turno_conv(null, cd_agenda_p, dt_agenda_p, nr_seq_turno_w, cd_convenio_p, ie_classif_agenda_p, ds_consist_encaixe_turno_w, nm_usuario_p, cd_estabelecimento_p, 'S');
	if (ds_consist_encaixe_turno_w IS NOT NULL AND ds_consist_encaixe_turno_w::text <> '') then
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(ds_consist_encaixe_turno_w);
	end if;	
end if;

--Consistir idade do paciente
if (qt_idade_max_enc_w > 0) and (cd_tipo_agenda_w = 3) then	
	if (qt_idade_pac_w < qt_idade_min_enc_w) then
		--A idade do paciente e menor que a idade definida na configuracao da agenda para a realizacao de encaixes!
		CALL wheb_mensagem_pck.exibir_mensagem_abort(324140);
	elsif (qt_idade_pac_w > qt_idade_max_enc_w) then
		--A idade do paciente e maior que a idade definida na configuracao da agenda para a realizacao de encaixes!
		CALL wheb_mensagem_pck.exibir_mensagem_abort(324141);
	end if;
	
end if;	

if (cd_tipo_agenda_w = 3) then	
	if (ie_regra_horario_turno_w = 'T') then
		select	obter_turno_encaixe_d_agecons(cd_agenda_p,dt_encaixe_w,'N')
		into STRICT	nr_seq_turno_w
		;	
	else
		select	obter_turno_encaixe_agecons(cd_agenda_p,dt_encaixe_w)
		into STRICT	nr_seq_turno_w
		;	
	end if;
	
	if (ie_regra_horario_turno_w <> 'S') and (coalesce(nr_seq_turno_w::text, '') = '') then
		CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(288472);
	end if;
	
end if;

--bloqueio parametro 440 agenda de exames
if (cd_tipo_agenda_w = 2 and ie_regra_turno_exames_w = 'N') then
    if coalesce(obter_turno_encaixe_ageexame(cd_agenda_p,dt_encaixe_w)::text, '') = '' then
        CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(1069380);
    end if;
end if;

-- Consistencia de classificacoes liberadas
if (cd_tipo_agenda_w = 3) then
	if (coalesce(ie_consiste_classif_lib_w,'N') = 'S') -- Novo parametro na AGI
	and (ie_classif_agenda_p IS NOT NULL AND ie_classif_agenda_p::text <> '') then
		ie_permite_classif_w	:= obter_agecons_agenda_classif(cd_agenda_p,ie_classif_agenda_p);
		if (ie_permite_classif_w = 'N') then
			CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(262323);
		end if;
	end if;
end if;	
	
	
/* insert ageint_horarios_usuario */

SELECT	obter_turno_horario_agenda(cd_agenda_p, dt_encaixe_w)
INTO STRICT	cd_turno_w
;

/*Consistir a tabela ageint_regra_convenio*/

ds_erro_w := ageint_consistir_regra_conv(cd_convenio_p, nr_seq_ageint_item_p, dt_encaixe_w, cd_estabelecimento_p, nm_usuario_p, ds_erro_w);

if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort( 262328 , 'DS_MENSAGEM='||ds_erro_w);
end if;

ds_erro_w := ageint_consistir_dias_autor(dt_encaixe_w, nr_seq_ageint_item_p, nm_usuario_p, cd_estabelecimento_p, ds_erro_w);

if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort( 262328 , 'DS_MENSAGEM='||ds_erro_w);
end if;

if (cd_tipo_agenda_w = 2) then
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
			and		cd_agenda			= cd_agenda_p;
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
	
elsif (cd_tipo_agenda_w = 3) then
	CALL CONSISTE_ENCAIXE_TURNO_AGECONS( dt_agenda_p, dt_encaixe_w, cd_agenda_p );
end if;

if (nr_seq_proc_interno_p IS NOT NULL AND nr_seq_proc_interno_p::text <> '') then
	SELECT * FROM obter_proc_tab_interno_conv(
		nr_seq_proc_interno_p, cd_estabelecimento_p, cd_convenio_p, cd_categoria_p, null, null, cd_procedimento_w, ie_origem_proced_w, null, dt_encaixe_w, null, null, null, null, null, null, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
end if;

select 	max(cd_especialidade)
into STRICT	cd_especialidade_item_w
from 	agenda_integrada_item
where 	nr_sequencia = nr_seq_ageint_item_p;

nr_seq_regra_bloq_w := obter_se_bloq_geral_agenda(cd_estabelecimento_p,
					cd_agenda_p,
					ie_classif_agenda_p, -- no caso de exames, ou ie_classif_item_w para consultas/servicos
					null, -- no caso de exames, ou null para consultas
					null, -- nao considerado pois nao esta indo para agenda_consulta
					obter_setor_regras_ageint(cd_tipo_agenda_w,cd_agenda_p,cd_procedimento_w,'S',nm_usuario_p,cd_estabelecimento_p),
					nr_seq_proc_interno_p,
					cd_procedimento_w,
					ie_origem_proced_w,
					cd_medico_p, -- verificar no insert o campo a ser utilizado
					dt_encaixe_w, -- verificar no insert o campo a ser utilizado
					'N',
					'N');

if (nr_seq_regra_bloq_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(obter_mensagem_bloq_geral_age(nr_seq_regra_bloq_w));
end if;

INSERT INTO ageint_encaixe_usuario(nr_sequencia,
	cd_agenda,
	--hr_agenda,

	--ie_status_agenda,
	nm_usuario,
	nr_Seq_Ageint,
	nr_minuto_duracao,
	--ie_encaixe,

	--nr_seq_ageint_lib,
	cd_turno,
	nr_Seq_ageint_item,
	dt_encaixe,
	dt_atualizacao,
	cd_pessoa_fisica,
	ie_classif_agenda,
	ds_observacao)
VALUES (nextval('ageint_encaixe_usuario_seq'),
	cd_agenda_p,
	--dt_encaixe_w,

	--'N',
	nm_usuario_p,
	nr_Seq_Ageint_p,
	qt_duracao_p,
	--'S',

	--nr_seq_ageint_lib_p,
	cd_turno_w,
	nr_Seq_ageint_item_p,
	dt_encaixe_w,
	clock_timestamp(),
	cd_medico_p,
	ie_classif_agenda_p,
	ds_observacao_p);

SELECT * FROM Atualiza_Dados_Marcacao(cd_agenda_p, dt_encaixe_w, nr_Seq_ageint_p, 'I', qt_duracao_p, nm_usuario_p, nr_seq_ageint_item_p, nr_seq_ageint_lib_p, 'S', cd_medico_p, ie_reservado_w, nm_usuario_confirm_encaixe_p, ie_principal_w) INTO STRICT ie_reservado_w, ie_principal_w;

COMMIT;

--nr_seq_encaixe_p := nr_seq_agenda_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_marcacao_encaixe_ageint (cd_estabelecimento_p bigint, cd_agenda_p bigint, dt_agenda_p timestamp, hr_encaixe_p text, qt_duracao_p bigint, cd_pessoa_fisica_p text, cd_convenio_p bigint, cd_categoria_p text, nr_seq_proc_interno_p bigint, nm_usuario_p text, cd_setor_atendimento_p bigint, nr_seq_ageint_item_p bigint, nr_Seq_ageint_p bigint, nr_seq_ageint_lib_p bigint, cd_medico_p text, nm_usuario_confirm_encaixe_p text default null, ie_classif_agenda_p text DEFAULT NULL, ds_observacao_p text DEFAULT NULL) FROM PUBLIC;

