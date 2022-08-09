-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_gerar_prescr_agendas ( nr_atendimento_p bigint, ie_setor_p text, cd_setor_usuario_p bigint, dt_entrega_p timestamp, ds_lista_agendas_p text, nm_usuario_p text) AS $body$
DECLARE


ds_lista_agendas_w			varchar(6000);
qt_controle_w				bigint;
nr_pos_separador_w			bigint;
ds_possib_aux_w				varchar(6000);
nr_seq_agenda_w				agenda_paciente.nr_sequencia%type;
ds_ultimo_caracter_w		varchar(1);
ie_origem_inf_w				varchar(1);

nr_prescricao_w				bigint;
cd_setor_atendimento_w		integer 	:= 0;
cd_setor_entrega_w			integer 	:= 0;
ie_data_w					varchar(1);
dt_prescricao_w				timestamp;
cd_estabelecimento_w		smallint;
nr_controle_w				bigint;
ie_medico_prescr_w			varchar(15);
ie_medico_requisitante_w	varchar(1) := 'N';
cd_setor_entrega_270_w		varchar(10);
cd_setor_entrega_def_270_w	varchar(10);
ie_atualiza_setor_entrega	varchar(1);
cd_tipo_agenda_w			bigint;
nr_pos_sep_itens_w			bigint;
qt_passagem_setor_w			bigint;
ie_tipo_passagem_regra_w	varchar(1);
nr_seq_interno_w			bigint;
ds_aux_w					varchar(255);
cd_senha_w					varchar(20);
cd_procedimento_w			bigint		:= 0;
ie_origem_proced_w			bigint	:= 0;
nr_seq_proc_interno_uni_w	bigint;
cd_convenio_w				integer;
cd_categoria_w				varchar(10);
cd_setor_proced_w			integer;
ie_tipo_atendimento_w		smallint;
nr_seq_forma_laudo_w		bigint;	
cd_medico_agenda_w			varchar(10);
ie_atualizar_setor_agenda_w	varchar(3);
qt_prescr_gerada_w			bigint;
ie_agendamento_pac_prescr_w	varchar(1);
ie_gerou_agend_pac_prescr_w	varchar(1) := 'N';
ie_exames_lab_w			varchar(1);
ie_restringe_estab_w		varchar(3);
ie_tipo_data_w			varchar(3);
cd_pessoa_fisica_w		atendimento_paciente.cd_pessoa_fisica%type;
dt_entrada_w			atendimento_paciente.dt_entrada%type;
nr_seq_ageint_w			bigint;
nr_seq_ageint_lab_w	bigint;
ie_gerar_ageint_exames_lab_w	varchar(1);
ie_gerou_prescr_w 		varchar(1) := 'N';
ie_gerar_senha_aut_w	varchar(1) := 'S';
dt_agendamento_w timestamp;
dt_agendamento_ww timestamp;
qt_peso_agenda_w bigint;
qt_peso_agenda_ww bigint;
qt_altura_cm_w bigint;
qt_altura_cm_ww bigint;

c01 CURSOR FOR
	SELECT	cd_setor_atendimento
	FROM	procedimento_setor_atend
	WHERE	cd_procedimento			= cd_procedimento_w
	AND		ie_origem_proced		= ie_origem_proced_w
	AND		cd_estabelecimento		= cd_estabelecimento_w
	ORDER	BY ie_prioridade DESC;	
	
C02 CURSOR FOR
	SELECT 	b.nr_seq_ageint,
		b.nr_sequencia
	FROM	agenda_integrada a,
		ageint_exame_lab b
	WHERE 	a.nr_sequencia = b.nr_seq_ageint
	AND	a.cd_pessoa_fisica = cd_pessoa_fisica_w
	AND	b.dt_prevista BETWEEN CASE WHEN ie_tipo_data_w='DE' THEN trunc(dt_entrada_w)  ELSE TRUNC(clock_timestamp()) END  AND CASE WHEN ie_tipo_data_w='DE' THEN pkg_date_utils.end_of(dt_entrada_w, 'DAY')  ELSE pkg_date_utils.end_of(clock_timestamp(), 'DAY') END
	and	((ie_restringe_estab_w = 'N') or (a.cd_estabelecimento = cd_estabelecimento_w))
	and	coalesce(b.dt_cancelamento::text, '') = ''
	and	coalesce(b.nr_prescricao::text, '') = '';
	

BEGIN
select	cd_estabelecimento,
	ie_tipo_atendimento,
	cd_pessoa_fisica,
	dt_entrada
into STRICT	cd_estabelecimento_w,
	ie_tipo_atendimento_w,
	cd_pessoa_fisica_w,
	dt_entrada_w
from	atendimento_paciente
where	nr_atendimento = nr_atendimento_p;

--AGENDA DE EXAMES
ie_medico_requisitante_w := Obter_Param_Usuario(820, 136, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_medico_requisitante_w);
--EUP
ie_data_w := Obter_Param_Usuario(916, 45, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_data_w);
ie_medico_prescr_w := Obter_Param_Usuario(916, 203, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_medico_prescr_w);
ie_atualiza_setor_entrega := Obter_param_usuario(916, 270, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_atualiza_setor_entrega);
ie_atualizar_setor_agenda_w := obter_param_usuario(916, 452, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_atualizar_setor_agenda_w);
cd_setor_entrega_w := Obter_Param_Usuario(916, 457, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, cd_setor_entrega_w);
ie_agendamento_pac_prescr_w := Obter_Param_Usuario(916, 518, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_agendamento_pac_prescr_w);	
cd_setor_entrega_def_270_w := Obter_param_usuario(916, 646, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, cd_setor_entrega_def_270_w);
ie_restringe_estab_w := Obter_param_usuario(916, 757, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_restringe_estab_w);
ie_tipo_data_w := Obter_param_usuario(916, 1164, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_tipo_data_w);
ie_gerar_ageint_exames_lab_w := Obter_param_usuario(916, 1185, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_gerar_ageint_exames_lab_w);

SELECT	coalesce(MAX(cd_convenio),0),
		coalesce(MAX(cd_categoria),0)
INTO STRICT	cd_convenio_w,
		cd_categoria_w
FROM 	atend_categoria_convenio
WHERE	nr_atendimento = nr_atendimento_p;

dt_prescricao_w	:= clock_timestamp();

if (ie_data_w = 'E') then
	select	dt_entrada
	into STRICT	dt_prescricao_w
	from	atendimento_paciente
	where	nr_atendimento	= nr_atendimento_p;
end if;

/*if	(cd_setor_atendimento_w = 0) then
	select	nvl(max(cd_setor_exclusivo),0)
	into	cd_setor_atendimento_w
	from	procedimento
	where	cd_procedimento	= cd_procedimento_w
	and	ie_origem_proced	= ie_origem_proced_w;
end if;*/
if (cd_setor_atendimento_w = 0) then
	if (REMOVER_ACENTUACAO(ie_setor_p) = 'Usuario') then
		cd_setor_atendimento_w	:= coalesce(cd_setor_usuario_p,0);
	elsif (ie_setor_p = 'Paciente') then
		select coalesce(max(cd_setor_atendimento),coalesce(cd_setor_usuario_p,0))
		into STRICT cd_setor_atendimento_w
		from atend_paciente_unidade
		where nr_seq_interno	= obter_atepacu_paciente(nr_atendimento_p, 'A');
	elsif (ie_setor_p = 'Procedimento') then
		begin
		/*open	c01;
		loop
		fetch	c01 into cd_setor_proced_w;
		exit 	when c01%notfound;
			begin
			cd_setor_atendimento_w	:= cd_setor_proced_w;
			end;
		end loop;
		close c01;*/
		if (cd_setor_atendimento_w = 0) then
			cd_setor_atendimento_w	:= coalesce(cd_setor_usuario_p,0);
		end if;
		end;
	end if;
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

if (ie_atualiza_setor_entrega = 'P') then
	select 	coalesce(max(cd_setor_atendimento),cd_setor_usuario_p)
	into STRICT	cd_setor_entrega_270_w
	from 	atend_paciente_unidade
	where 	nr_seq_interno = obter_atepacu_paciente(nr_atendimento_p, 'A');
elsif (ie_atualiza_setor_entrega = 'U') then
	cd_setor_entrega_270_w	:= cd_setor_entrega_w;
elsif (ie_atualiza_setor_entrega = 'A') then
	cd_setor_entrega_270_w	:= cd_setor_entrega_def_270_w;
end if;
if (cd_setor_entrega_270_w	= 0) then
	cd_setor_entrega_270_w	:= null;
end if;

select	coalesce(max('1'),'3')
into STRICT	ie_origem_inf_w
from	Medico b,
	Usuario a
where 	a.nm_usuario		= nm_usuario_p
and	a.cd_pessoa_fisica	= b.cd_pessoa_fisica;

begin
	select	max(vl_default)
	into STRICT	nr_seq_forma_laudo_w
	from	tabela_atrib_regra
	where	nm_tabela					= 'PRESCR_MEDICA'
	and	nm_atributo					= 'NR_SEQ_FORMA_LAUDO'
	and	coalesce(cd_estabelecimento,cd_estabelecimento_w)    = cd_estabelecimento_w
	and	coalesce(cd_perfil, obter_perfil_ativo)		= obter_perfil_ativo
	and	coalesce(nm_usuario_param, nm_usuario_p) 		= nm_usuario_p;
exception
when others then
	nr_seq_forma_laudo_w := null;
end;

ds_lista_agendas_w	:= ds_lista_agendas_p;

if (position('(' in ds_lista_agendas_w) > 0 ) and (position(')' in ds_lista_agendas_w) > 0 ) then
	ds_lista_agendas_w	:= substr(ds_lista_agendas_p,(position('(' in ds_lista_agendas_p)+1),(position(')' in ds_lista_agendas_p)-2));
end if;

select	substr(ds_lista_agendas_w, length(ds_lista_agendas_w), length(ds_lista_agendas_w))
into STRICT	ds_ultimo_caracter_w
;

if (ds_ultimo_caracter_w	<> ',') then
	ds_lista_agendas_w	:= ds_lista_agendas_w || ',';
end if;

qt_controle_w 		:= 0;
nr_pos_separador_w	:= position(',' in ds_lista_agendas_w);
nr_pos_sep_itens_w	:= position('-' in ds_lista_agendas_w);

select	nextval('prescr_medica_seq')
into STRICT	nr_prescricao_w
;

while(nr_pos_separador_w > 0) and (qt_controle_w < 1000 ) loop
	nr_seq_agenda_w		:= substr(ds_lista_agendas_w,1,nr_pos_sep_itens_w - 1);
	cd_tipo_agenda_w	:= substr(ds_lista_agendas_w,nr_pos_sep_itens_w + 1,1);
	
	if (cd_tipo_agenda_w = 0) then
		ie_exames_lab_w := 'S';
		if (ie_gerou_prescr_w = 'S') then
			goto proximo;
		end if;
	end if;
	
	/* Obter as informacoes da agenda */

	if (cd_tipo_agenda_w = 2)then
		SELECT	coalesce(MAX(cd_procedimento),0),
				coalesce(MAX(ie_origem_proced),0),	
				MAX(cd_medico),
				MAX(nr_seq_proc_interno),
				MAX(dt_agendamento),
				coalesce(max(QT_PESO),0),
	 			coalesce(max(qt_altura_cm),0)
		INTO STRICT	cd_procedimento_w,
				ie_origem_proced_w,	
				cd_medico_agenda_w,
				nr_seq_proc_interno_uni_w,
				dt_agendamento_w,
				qt_peso_agenda_w,
				qt_altura_cm_w
		FROM	agenda_paciente
		WHERE	nr_sequencia	= nr_seq_agenda_w;
		
		
	elsif (cd_tipo_agenda_w in (3,4,5))then
		SELECT	coalesce(MAX(cd_procedimento),0),
				coalesce(MAX(ie_origem_proced),0),	
				MAX(nr_seq_proc_interno),
				coalesce(max(QT_PESO),0),
	 			coalesce(max(qt_altura_cm),0)
		INTO STRICT	cd_procedimento_w,
				ie_origem_proced_w,	
				nr_seq_proc_interno_uni_w,
				qt_peso_agenda_w,
				qt_altura_cm_w
		FROM	agenda_consulta
		WHERE	nr_sequencia	= nr_seq_agenda_w;
		
	elsif (cd_tipo_agenda_w = 0) then	
		SELECT	coalesce(MAX(cd_procedimento),0),
			coalesce(MAX(ie_origem_proced),0),	
			MAX(nr_seq_proc_interno)
		INTO STRICT	cd_procedimento_w,
			ie_origem_proced_w,	
			nr_seq_proc_interno_uni_w
		FROM	ageint_exame_lab
		WHERE	nr_sequencia	= nr_seq_agenda_w;
	end if;

	--Validar param [47] da EUP
	IF (REMOVER_ACENTUACAO(ie_setor_p) = 'Usuario') THEN
		cd_setor_atendimento_w	:= coalesce(cd_setor_usuario_p,cd_setor_atendimento_w);
	ELSIF (ie_setor_p = 'Paciente') THEN
		SELECT coalesce(MAX(cd_setor_atendimento),coalesce(cd_setor_usuario_p,cd_setor_atendimento_w))
		INTO STRICT cd_setor_atendimento_w
		FROM atend_paciente_unidade
		WHERE nr_seq_interno	= obter_atepacu_paciente(nr_atendimento_p, 'A');
	ELSIF (ie_setor_p = 'Procedimento') THEN
		BEGIN
		OPEN	c01;
		LOOP
		FETCH	c01 INTO cd_setor_proced_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			BEGIN
			cd_setor_atendimento_w	:= cd_setor_proced_w;
			END;
		END LOOP;
		CLOSE c01;
		IF (cd_setor_atendimento_w = 0) THEN
			cd_setor_atendimento_w	:= coalesce(cd_setor_usuario_p,cd_setor_atendimento_w);
		END IF;
		END;
	ELSIF (ie_setor_p = 'Proc Interno') THEN
		BEGIN

		SELECT	coalesce(MAX(Obter_Setor_exec_proc_interno(nr_seq_proc_interno_uni_w,NULL,ie_tipo_atendimento_w,cd_convenio_w,cd_categoria_w)),cd_setor_atendimento_w)
		INTO STRICT	cd_setor_atendimento_w
		;

		END;
	END IF;		
	
	IF (ie_atualizar_setor_agenda_w = 'S') and (nr_seq_agenda_w IS NOT NULL AND nr_seq_agenda_w::text <> '') and (cd_tipo_agenda_w > 0) THEN
		SELECT 	coalesce(max(obter_dados_agendamento(nr_seq_agenda_w,'CSA')),0)
		INTO STRICT	cd_setor_entrega_w
		;
	END IF;	

	IF (DT_AGENDAMENTO_W > coalesce(DT_AGENDAMENTO_WW,DT_AGENDAMENTO_W-1)) THEN
		
		DT_AGENDAMENTO_WW := DT_AGENDAMENTO_W;
		
		if (qt_peso_agenda_w > 0)then
			qt_peso_agenda_ww := qt_peso_agenda_w;
		end if;
		
		if (qt_altura_cm_w > 0)then
			qt_altura_cm_ww := qt_altura_cm_w;
		end if;
	END IF;
	
	/*
	INICIO - CRIA PRESCRICAO
	*/

	
	--Gerar prescricao unica com todos os itens
	select	count(*)
	into STRICT	qt_prescr_gerada_w
	from	prescr_medica
	where	nr_atendimento = nr_atendimento_p
	and	coalesce(dt_liberacao::text, '') = '';
	
	if	((qt_prescr_gerada_w = 0) or (ie_agendamento_pac_prescr_w = 'P')) then
		
		if (ie_gerou_agend_pac_prescr_w = 'N') then
		
			if (ie_agendamento_pac_prescr_w = 'P') then
				ie_gerou_agend_pac_prescr_w := 'S';
			end if;
			if (coalesce(qt_prescr_gerada_w,0) <> 0) then
				select	nextval('prescr_medica_seq')
				into STRICT	nr_prescricao_w
				;
			end if;
			ie_gerou_prescr_w := 'S';
			insert into prescr_medica(
				nr_prescricao,
				cd_pessoa_fisica,
				nr_atendimento,
				cd_medico,
				dt_prescricao,
				dt_atualizacao,
				nm_usuario,
				nm_usuario_original,
				nr_horas_validade,
				dt_primeiro_horario,
				dt_liberacao,
				cd_setor_atendimento,
				cd_setor_entrega,
				dt_entrega,
				ie_recem_nato,
				ie_origem_inf,
				cd_estabelecimento,
				nr_seq_agenda,
				cd_prescritor,
				nr_controle,
				ie_modo_integracao,
				--,	qt_peso,

				--qt_altura_cm
				nr_seq_forma_laudo)
			SELECT 	nr_prescricao_w,
				a.cd_pessoa_fisica,
				nr_atendimento_p,
				CASE WHEN ie_medico_requisitante_w='N' THEN  CASE WHEN ie_medico_prescr_w='MR' THEN a.cd_medico_resp WHEN ie_medico_prescr_w='RE' THEN a.cd_medico_referido  ELSE null END   ELSE cd_medico_agenda_w END ,
				dt_prescricao_w,
				clock_timestamp(),
				nm_usuario_p,
				nm_usuario_p,
				24,
				b.hr_inicio_prescricao,
				null,
				cd_setor_atendimento_w,
				CASE WHEN ie_atualizar_setor_agenda_w='S' THEN  CASE WHEN cd_setor_entrega_w=0 THEN null  ELSE cd_setor_entrega_w END    ELSE coalesce(cd_setor_entrega_270_w,cd_setor_atendimento_w) END ,
				dt_prescricao_w,
				'N',
				ie_origem_inf_w,
				cd_estabelecimento_w,
				CASE WHEN coalesce(cd_tipo_agenda_w,0)=2 THEN  nr_seq_agenda_w  ELSE null END ,
				obter_dados_usuario_opcao(nm_usuario_p, 'C'),
				nr_controle_w,
				'A',
				--,	qt_peso_agenda_w,

				--qt_altura_cm_w
				nr_seq_forma_laudo_w
			from	setor_atendimento b,
				atendimento_paciente a
			where	a.nr_atendimento	= nr_atendimento_p
			and	b.cd_setor_atendimento	= cd_setor_atendimento_w;
		end if;
	else
		
		select	coalesce(max(nr_prescricao),0)
		into STRICT	nr_prescricao_w
		from	prescr_medica
		where	nr_atendimento = nr_atendimento_p
		and	coalesce(dt_liberacao::text, '') = '';	

	end if;
	/*
	FIM - CRIA PRESCRICAO
	*/
	
	/*
	INICIO - INSERE OS EXAMES NA PRESCRICAO
	*/
	if (cd_tipo_agenda_w > 0) and (cd_setor_atendimento_w <> 0) and (nr_seq_agenda_w IS NOT NULL AND nr_seq_agenda_w::text <> '') and (nr_prescricao_w > 0) then
		begin
		/* Gera os procedimentos da agenda na prescricao criada */
		
		CALL Ageint_Gerar_Proc_Prescr(nr_seq_agenda_w, nr_prescricao_w, cd_setor_atendimento_w, cd_tipo_agenda_w, nr_atendimento_p, nm_usuario_p);
			
		if (cd_tipo_agenda_w	= 2) then
			update	agenda_paciente
			set	nr_atendimento	= nr_atendimento_p
			where	nr_sequencia	= nr_seq_agenda_w;
		elsif (cd_tipo_agenda_w	in (3,4,5)) then
			update	agenda_consulta
			set	nr_atendimento	= nr_atendimento_p
			where	nr_sequencia	= nr_seq_agenda_w;
		end if;
		end;
		
		CALL executar_evento_age_eup_js('GA', cd_tipo_agenda_w, nr_seq_agenda_w, cd_estabelecimento_w, nm_usuario_p);
	end if;
	/*
	FIM - INSERE OS EXAMES NA PRESCRICAO
	*/
	<<proximo>>
	ds_lista_agendas_w	:= substr(ds_lista_agendas_w,nr_pos_separador_w+1,length(ds_lista_agendas_w));
	nr_pos_separador_w 	:= position(',' in ds_lista_agendas_w);
	nr_pos_sep_itens_w	:= position('-' in ds_lista_agendas_w);
	qt_controle_w		:= qt_controle_w + 1;
end loop;

update prescr_medica
set QT_PESO = qt_peso_agenda_ww,
	qt_altura_cm = qt_altura_cm_ww
where nr_prescricao = nr_prescricao_w;

select  max(cd_senha)
into STRICT    cd_senha_w
from    prescr_procedimento
where   nr_prescricao   = nr_prescricao_w;

begin
    select coalesce(ie_atual_senha_conv,'S')
    into STRICT ie_gerar_senha_aut_w
    from parametro_agenda_integrada
    where cd_estabelecimento = cd_estabelecimento_w  LIMIT 1;
	exception when others then
	begin
		select coalesce(ie_atual_senha_conv,'S')
		into STRICT ie_gerar_senha_aut_w
		from parametro_agenda_integrada
		where coalesce(cd_estabelecimento::text, '') = ''  LIMIT 1;
		exception when others then
			begin
				ie_gerar_senha_aut_w := 'S';
			end;
		end;
end;

if (cd_senha_w IS NOT NULL AND cd_senha_w::text <> '') and (ie_gerar_senha_aut_w = 'S') then
	update  atend_categoria_convenio
	set     cd_senha        = cd_senha_w
	where   nr_atendimento  = nr_atendimento_p;
end if;

if (cd_setor_atendimento_w <> 0) then
	--(nr_seq_agenda_p is not null) then
	begin
	select	count(*)
	into STRICT	qt_passagem_setor_w
	from	atend_paciente_unidade
	where	nr_atendimento	= nr_atendimento_p;	

	if (qt_passagem_setor_w = 0) then
		begin

		select 	obter_tipo_passagem_regra(cd_setor_atendimento_w)
		into STRICT	ie_tipo_passagem_regra_w
		;


		if (ie_tipo_passagem_regra_w = 'T') then

			CALL gerar_entrada_setor_prescr(nr_atendimento_p, cd_setor_atendimento_w, dt_prescricao_w,nm_usuario_p);

		else

			CALL gerar_passagem_setor_atend(nr_atendimento_p, cd_setor_atendimento_w, dt_prescricao_w, 'S', nm_usuario_p);

			select	coalesce(max(nr_seq_interno),0)
			into STRICT	nr_seq_interno_w
			from 	atend_paciente_unidade
			where 	nr_atendimento	= nr_atendimento_p;

			CALL ATEND_PACIENTE_UNID_AFTERPOST(nr_seq_interno_w,'I',nm_usuario_p);

		end if;

		end;
	end if;
	end;
end if;

if (ie_gerar_ageint_exames_lab_w = 'S') and (ie_exames_lab_w = 'S') then
	open C02;
	loop
	fetch C02 into	
		nr_seq_ageint_w,
		nr_seq_ageint_lab_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		CALL AGEINT_INSERIR_LAB_PRESCR(nr_prescricao_w, nr_seq_ageint_w, cd_setor_atendimento_w, nr_seq_ageint_lab_w, cd_estabelecimento_w, nm_usuario_p);
		end;
	end loop;
	close C02;	
end if;


commit;

consistir_prescricao(nr_prescricao_w, obter_perfil_Ativo, nm_usuario_p, ds_aux_w, ds_aux_w, ds_aux_w, ds_aux_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_gerar_prescr_agendas ( nr_atendimento_p bigint, ie_setor_p text, cd_setor_usuario_p bigint, dt_entrega_p timestamp, ds_lista_agendas_p text, nm_usuario_p text) FROM PUBLIC;
