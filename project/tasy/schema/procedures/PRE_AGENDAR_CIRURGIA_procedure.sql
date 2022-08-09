-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pre_agendar_cirurgia ( cd_agenda_p bigint, hr_inicio_p timestamp, cd_pessoa_fisica_p text, cd_medico_p text, nr_seq_proc_interno_p bigint, cd_convenio_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ds_orientacao_p text, ie_lado_p text, qt_tempo_proc_p bigint, ds_erro_p INOUT text, nr_seq_agenda_p INOUT bigint, nm_paciente_p text, ie_carater_p text, ds_erro_2_p INOUT text, nr_seq_atend_futuro_p bigint default null, nr_atendimento_p bigint default 0, nr_seq_motivo_prazo_p bigint default null, ds_motivo_prazo_p text default null, cd_categoria_p text default null, cd_plano_p text default null, dt_desejada_agend_p timestamp default null, dt_validity_mipres_p timestamp default null, nr_prescr_mipres_p bigint default null) AS $body$
DECLARE


nm_paciente_w			varchar(60);
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
nr_seq_agenda_w			    agenda_paciente.nr_sequencia%type;
qt_min_cirugia_w			bigint:= null;
qt_idade_paciente_w		smallint;
cd_tipo_anestesia_w		varchar(2);
ie_reserva_leito_w			varchar(3);
dt_ultima_consulta_w		timestamp;
cd_usuario_convenio_w		varchar(30);
qt_dias_atend_w			integer;	
qt_min_higienizacao_w		bigint;
nr_seq_classif_agenda_w		bigint;
nr_telefone_w			varchar(40);
nr_celular_w			varchar(40);
nm_pessoa_contato_w		varchar(50);
ie_autorizacao_w			varchar(3);
dt_nascimento_w			timestamp;
ds_erro_w			varchar(255);
ds_erro_2_w			varchar(255);
ie_gerar_servico_w			varchar(1);
qt_classif_agenda_w		smallint;
nr_seq_agenda_aux_w		agenda_paciente_auxiliar.nr_sequencia%type;



BEGIN
ie_gerar_servico_w := Obter_Param_Usuario(870, 59, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_gerar_servico_w);

select	obter_valor_param_usuario(870, 3, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p),
	obter_compl_pf(cd_pessoa_fisica_p, 1, 'T'),
	obter_dados_pf(cd_pessoa_fisica_p,'TC'),
	substr(obter_desc_usuario(nm_usuario_p),1,40),
	coalesce(max((obter_valor_param_usuario(870,2,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p))::numeric ) , 1)
into STRICT	nr_seq_classif_agenda_w,
	nr_telefone_w,
	nr_celular_w,
	nm_pessoa_contato_w,
	qt_dias_atend_w
;

if (nr_celular_w IS NOT NULL AND nr_celular_w::text <> '') then
	nr_telefone_w := nr_telefone_w || ' ' || nr_celular_w;
end if;

select	coalesce(max(nr_sequencia), 0)
into STRICT	nr_seq_agenda_w
from	agenda_paciente
where	cd_agenda	= cd_agenda_p
and	hr_inicio		= hr_inicio_p
and 	ie_status_agenda	= 'L';

nr_seq_agenda_p	:= nr_seq_agenda_w;

if (coalesce(qt_tempo_proc_p::text, '') = '') or (qt_tempo_proc_p = 0) then
	begin
	select	coalesce(max(qt_min_cirugia),0)
	into STRICT	qt_min_cirugia_w
	from	proc_interno_tempo
	where	nr_seq_proc_interno		= nr_seq_proc_interno_p
	and	coalesce(cd_medico,coalesce(cd_medico_p,'X')) = coalesce(cd_medico_p,'X')
	and	coalesce(cd_estabelecimento,cd_estabelecimento_p)	= cd_estabelecimento_p;

	if (qt_min_cirugia_w = 0) then
		select	coalesce(qt_min_cirurgia,0)
		into STRICT	qt_min_cirugia_w
		from	proc_interno
		where	nr_sequencia		= nr_seq_proc_interno_p;
	end if;
	end;
else
	qt_min_cirugia_w := coalesce(qt_tempo_proc_p,0);
end if;

select	coalesce(max(qt_min_higienizacao),0)
into STRICT	qt_min_higienizacao_w
from	proc_interno
where	nr_sequencia			= nr_seq_proc_interno_p;

select	ie_reserva_leito,
	cd_tipo_anestesia
into STRICT	ie_reserva_leito_w,
	cd_tipo_anestesia_w
from	proc_interno
where	nr_sequencia			= nr_seq_proc_interno_p;

ie_autorizacao_w := obter_param_usuario(870, 9, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_autorizacao_w);

begin						
select	dt_ultima_consulta,
	cd_usuario_convenio
into STRICT	dt_ultima_consulta_w,
	cd_usuario_convenio_w
from	Med_Cliente
where	cd_pessoa_fisica		= cd_pessoa_fisica_p
and	trunc(dt_ultima_consulta,'dd')	>= trunc(clock_timestamp()-qt_dias_atend_w,'dd')
and	cd_convenio			= cd_convenio_p;
exception
	when others then
	cd_usuario_convenio_w	:= null;
end;

if (coalesce(cd_usuario_convenio_w::text, '') = '') then
	begin
	select	max(cd_usuario_convenio)
	into STRICT	cd_usuario_convenio_w	
	from    atendimento_paciente a,
		atend_categoria_convenio b
	where   a.nr_atendimento	= b.nr_atendimento
	and     a.cd_pessoa_fisica	= cd_pessoa_fisica_p
	and     b.cd_convenio		= cd_convenio_p
	and     dt_entrada >=		clock_timestamp() - qt_dias_atend_w;
	exception
		when others then
		cd_usuario_convenio_w	:= null;
	end;
end if;

if (nr_seq_agenda_w <> 0) then
	begin

	select	max(substr(obter_nome_pf(cd_pessoa_fisica),1,60)),
		max(obter_idade(dt_nascimento, clock_timestamp(), 'A')),
		max(dt_nascimento)
	into STRICT	nm_paciente_w,
		qt_idade_paciente_w,
		dt_nascimento_w	
	from	pessoa_fisica
	where	cd_pessoa_fisica		=	cd_pessoa_fisica_p;

	SELECT * FROM Obter_Proc_Tab_Inter_Agenda(nr_seq_proc_interno_p, null, cd_convenio_p, null, null, cd_estabelecimento_p, clock_timestamp(), null, null, null, null, null, null, null, null, cd_procedimento_w, ie_origem_proced_w) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
	
	if (coalesce(nr_seq_classif_agenda_w,0) > 0) then
		select	count(*)
		into STRICT	qt_classif_agenda_w
		from	agenda_paciente_classif
		where	nr_sequencia in (nr_seq_classif_agenda_w);	
	end if;
	
	if (qt_classif_agenda_w = 0) then
		CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(241216);
	end if;
			
	update	agenda_paciente
	set	cd_pessoa_fisica	=	cd_pessoa_fisica_p,
		nm_paciente		=	coalesce(nm_paciente_w,nm_paciente_p),
		cd_medico		=	cd_medico_p,
		nr_seq_proc_interno	=	nr_seq_proc_interno_p,
		cd_procedimento		=	cd_procedimento_w,
		ie_origem_proced	=	ie_origem_proced_w,
		cd_convenio		=	cd_convenio_p,
		cd_agenda		=	cd_agenda_p,
		nm_usuario		=	nm_usuario_p,
		ie_status_agenda	=	'PA',
		nr_minuto_duracao	=	coalesce(qt_min_cirugia_w,0) + coalesce(qt_min_higienizacao_w,0),
		ie_reserva_leito	=	ie_reserva_leito_w,
		qt_idade_paciente	=	qt_idade_paciente_w,
		dt_agendamento		=	clock_timestamp(),
		nm_usuario_orig		=	nm_usuario_p,
		cd_tipo_anestesia	=	cd_tipo_anestesia_w,
		cd_usuario_convenio	=	cd_usuario_convenio_w,
		ie_autorizacao		=	ie_autorizacao_w,
		nr_seq_classif_agenda	=	nr_seq_classif_agenda_w,
		nr_telefone		=	nr_telefone_w,
		nm_pessoa_contato	=	nm_pessoa_contato_w,
		ie_lado			=	ie_lado_p,
		dt_nascimento_pac	=	dt_nascimento_w,
		ie_carater_cirurgia	=	ie_carater_p,
		nr_seq_atend_futuro	=	nr_seq_atend_futuro_p,
		cd_doenca_cid		=	CASE WHEN nr_atendimento_p=0 THEN cd_doenca_cid  ELSE Obter_Cid_Atendimento(nr_atendimento_p,'P') END ,
		nr_seq_motivo_prazo	=	nr_seq_motivo_prazo_p,
		ds_motivo_prazo		=	substr(ds_motivo_prazo_p,1,255),
      		cd_categoria   		= 	cd_categoria_p,
      		cd_plano        		= 	cd_plano_p
	where	nr_sequencia		=	nr_seq_agenda_w;
	
	select max(nr_sequencia)
	into STRICT nr_seq_agenda_aux_w
	from agenda_paciente_auxiliar
	where nr_seq_agenda = nr_seq_agenda_w;

	if (coalesce(nr_seq_agenda_aux_w::text, '') = '') then
		
		select 	nextval('agenda_paciente_auxiliar_seq')
		into STRICT 	nr_seq_agenda_aux_w
		;
		
		insert into agenda_paciente_auxiliar(nr_sequencia,
					nm_usuario,
					dt_atualizacao,
					dt_desejada_agendamento,
					nr_seq_agenda)
		values (	nr_seq_agenda_aux_w,
					nm_usuario_p,
					clock_timestamp(),
					dt_desejada_agend_p,
					nr_seq_agenda_w);
	else
		update agenda_paciente_auxiliar
		set nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp(),
			dt_desejada_agendamento = dt_desejada_agend_p
		where nr_sequencia = nr_seq_agenda_aux_w;
	end if;
	
	if (obtain_user_locale(wheb_usuario_pck.get_nm_usuario) = 'es_CO') then
		ds_erro_p := insert_pre_agenda_mipres(nr_seq_agenda_aux_w, dt_validity_mipres_p, nr_prescr_mipres_p, nm_usuario_p, cd_pessoa_fisica_p, ds_erro_p);
	end if;

	CALL gerar_autor_regra(null,null,null,null,null,null,'AP',nm_usuario_p,nr_seq_agenda_w,nr_seq_proc_interno_p,null,null,null,null,'','','');

	SELECT * FROM gerar_dados_pre_agenda(cd_procedimento_w, ie_origem_proced_w, nr_seq_agenda_w, nr_seq_proc_interno_p, cd_medico_p, cd_pessoa_fisica_p, nm_usuario_p, cd_convenio_p, null, ds_orientacao_p, cd_estabelecimento_p, 'S', 'S', 'S', ie_gerar_servico_w, 'S', ds_erro_w, ds_erro_2_w) INTO STRICT ds_erro_w, ds_erro_2_w;
	ds_erro_2_p 		:= ds_erro_2_w;
	end;
else
	ds_erro_p		:= wheb_mensagem_pck.get_texto(279147);
end if;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pre_agendar_cirurgia ( cd_agenda_p bigint, hr_inicio_p timestamp, cd_pessoa_fisica_p text, cd_medico_p text, nr_seq_proc_interno_p bigint, cd_convenio_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ds_orientacao_p text, ie_lado_p text, qt_tempo_proc_p bigint, ds_erro_p INOUT text, nr_seq_agenda_p INOUT bigint, nm_paciente_p text, ie_carater_p text, ds_erro_2_p INOUT text, nr_seq_atend_futuro_p bigint default null, nr_atendimento_p bigint default 0, nr_seq_motivo_prazo_p bigint default null, ds_motivo_prazo_p text default null, cd_categoria_p text default null, cd_plano_p text default null, dt_desejada_agend_p timestamp default null, dt_validity_mipres_p timestamp default null, nr_prescr_mipres_p bigint default null) FROM PUBLIC;
