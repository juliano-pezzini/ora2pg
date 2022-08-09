-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE iniciar_cirurgia ( nr_atendimento_p bigint, nr_cirurgia_p bigint, dt_entrada_unidade_p timestamp, dt_inicio_real_p timestamp, cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, cd_tipo_acomodacao_p bigint, nm_usuario_p text, cd_funcao_p bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE

				
qt_atendimento_w		bigint;
nr_sequencia_w			bigint;
nr_seq_interno_w		bigint;
nr_seq_interno_ww		bigint;
qt_passagem_w			bigint;
ie_atualizar_setor_w		varchar(01)	:= 'N';
ie_atualiza_hora_w		varchar(01)	:= 'N';
ie_regra_lanc_automatico_w	varchar(1)		:= 'N';
ie_gerar_partic_w		varchar(1);
cd_medico_anestesista_w		varchar(10);
cd_medico_cirurgiao_w		varchar(10);
cd_profissional_w		varchar(10);
cd_funcao_prof_w		smallint;
ie_gera_prof_agenda_w		varchar(01) 	:= 'N';
cd_funcao_w			smallint;
nr_seq_agenda_w			    agenda_paciente.nr_sequencia%type;
cd_status_cirurgia_w		varchar(10)	:= '';
ie_grava_log_w			varchar(1);
ie_atualizar_convenio_w		varchar(1);
qt_cirurgias_sus_w		varchar(10);
ie_tipo_convenio_w		smallint;
cd_convenio_w			integer;
qt_cirurgias_w			bigint;
ie_consistir_dia_w		varchar(1);
ie_vincular_atend_w		varchar(1);
ie_estrutura_pepo_w		varchar(1);
ie_data_cirurgia_w		varchar(1);
ie_consiste_atend_agenda_w	varchar(1);
nr_atendimento_w		bigint;
ie_informacao_w			varchar(15);	
nr_prescricao_w			bigint;
ie_gera_prev_aut_iniciar_w	varchar(1);
ie_conta_fechada_w		varchar(01) 	:= 'N';
dt_termino_w			timestamp;
dt_inicio_w			timestamp;
ie_altera_clinica_atend_w	varchar(1);
nr_seq_inicia_cir_w		bigint;
nr_seq_evento_cirurgia_w	bigint;
nr_sequencia_evento_w		bigint := 0;
ie_atualizar_tempos_auto_w	varchar(01) 	:= 'N';
ds_mensagem_w			varchar(500);
ds_setores_finaliza_mov_w	varchar(255);
ie_excecao_w			varchar(1);
cd_especialidade_w		integer;
ie_atualizar_setor_prescr_w	varchar(1);
cd_setor_atendimento_w		integer;
OSUSER_w			varchar(100);
nr_seq_equipe_w			bigint;
cd_profissional_ww     		varchar(10);
cd_funcao_prof_ww      		smallint;
nr_seq_equipe_ww	   	bigint;
ie_momento_integracao_w		varchar(15);

ds_param_integ_hl7_w	varchar(4000);
ds_sep_bv_w				varchar(100);
qt_existe_regra_setor_w		bigint;
ie_pyxis_cirurgia_w		parametros_farmacia.ie_pyxis_cirurgia%type;
ie_inicio_cirurgia_w	ajuste_ap_lote_evento.ie_inicio_cirurgia%type;
cd_departamento_w     atend_paciente_unidade.cd_departamento%type;
ie_gerar_evolucao_cirurgia_w varchar(1);
cd_evolucao_w bigint;

expressao1_w	varchar(255) := obter_desc_expressao_idioma(320593, null, wheb_usuario_pck.get_nr_seq_idioma);--Iniciar cirurgia
C01 CURSOR FOR
	SELECT	cd_profissional,
		cd_funcao,
		nr_seq_equipe,
		cd_especialidade
	from	profissional_agenda
	where	nr_seq_agenda	= nr_seq_agenda_w
	order by 1;
	
C02 CURSOR FOR
	SELECT	a.nr_sequencia,
			c.cd_pessoa_fisica,
			c.nr_atendimento,
			substr(obter_atepacu_paciente( c.nr_atendimento ,'A'),1,30) nr_seq_interno
	from	prescr_procedimento a,
			proc_interno_integracao b,
			prescr_medica c
	where	b.nr_seq_proc_interno = a.nr_seq_proc_interno
	and		a.nr_prescricao = c.nr_prescricao
	and		a.nr_prescricao	= nr_prescricao_w
	and		coalesce(b.cd_estabelecimento,coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0)
	and		coalesce(a.nr_seq_exame::text, '') = ''
	and		b.nr_seq_sistema_integ in (11,66,91)
	
union
 
	SELECT	nr_sequencia,
			c.cd_pessoa_fisica,
			c.nr_atendimento,
			substr(obter_atepacu_paciente( c.nr_atendimento ,'A'),1,30) nr_seq_interno
	from	prescr_procedimento a,
			prescR_medica c
	where	a.nr_prescricao = c.nr_prescricao
	and		a.nr_prescricao	= nr_prescricao_w
	and		Obter_Se_Integr_Proc_Interno(a.nr_seq_proc_interno,2,null,a.ie_lado,c.cd_estabelecimento) = 'S'		 
	and		coalesce(a.nr_seq_exame::text, '') = '';
c02_w	c02%rowtype;
	
C03 CURSOR FOR
	SELECT	b.cd_pessoa_fisica,
		b.ie_funcao,
		b.nr_seq_equipe
	from	pf_equipe a,
		pf_equipe_partic b
	where	a.nr_sequencia = nr_seq_equipe_w
	and 	a.nr_sequencia = b.nr_seq_equipe	
	order by 1;
	
	
c06 CURSOR FOR
	SELECT	a.nr_sequencia,
		e.cd_pessoa_fisica,
		e.nr_atendimento,
		e.nr_prescricao,
		f.nr_sequencia nr_seq_procedimento
	from	prescr_procedimento a,
		proc_interno_integracao b,
		proc_interno c,
		procedimento d,
		prescr_medica e,
		prescr_proc_hor f
	where	a.nr_prescricao	= nr_prescricao_w
	and	e.nr_prescricao = a.nr_prescricao
	and     c.nr_sequencia = a.nr_seq_proc_interno
	and	coalesce(b.nr_seq_proc_interno,a.nr_seq_proc_interno) = a.nr_seq_proc_interno
	and     c.cd_procedimento = d.cd_procedimento
	and	f.nr_prescricao = a.nr_prescricao 
	and 	f.nr_seq_procedimento = a.nr_sequencia
	and     c.ie_origem_proced = d.ie_origem_proced
	and	coalesce(b.cd_estabelecimento,coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0)
	and	coalesce(b.CD_TIPO_PROCEDIMENTO,coalesce( d.cd_tipo_procedimento,0)) = coalesce(d.cd_tipo_procedimento,0)
	and	coalesce(a.nr_seq_exame::text, '') = '';

BEGIN
begin

ie_atualizar_setor_w := obter_param_usuario(900, 94, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_atualizar_setor_w);
ie_grava_log_w := obter_param_usuario(900, 202, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_grava_log_w); --OS 
ie_estrutura_pepo_w := obter_param_usuario(872, 158, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_estrutura_pepo_w);
ie_atualizar_tempos_auto_w := obter_param_usuario(872, 400, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_atualizar_tempos_auto_w);

/* Surgery Management */

if (cd_funcao_p = 900) then
	ie_atualiza_hora_w := obter_param_usuario(900, 82, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_atualiza_hora_w);
	ie_regra_lanc_automatico_w := obter_param_usuario(900, 85, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_regra_lanc_automatico_w);
	qt_cirurgias_sus_w := obter_param_usuario(900, 222, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, qt_cirurgias_sus_w);
	ie_consistir_dia_w := obter_param_usuario(900, 225, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_consistir_dia_w);
end if;

ie_gera_prof_agenda_w := obter_param_usuario(900, 70, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_gera_prof_agenda_w);
ie_consiste_atend_agenda_w := obter_param_usuario(900, 325, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_consiste_atend_agenda_w);
ie_altera_clinica_atend_w := obter_param_usuario(900, 379, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_altera_clinica_atend_w);
cd_status_cirurgia_w := obter_param_usuario(900, 198, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, cd_status_cirurgia_w);
ie_conta_fechada_w := obter_param_usuario(900, 364, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_conta_fechada_w);
ie_atualizar_convenio_w := obter_param_usuario(900, 219, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_atualizar_convenio_w);
ie_vincular_atend_w := obter_param_usuario(900, 263, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_vincular_atend_w);
ie_gerar_partic_w := obter_param_usuario(900, 20, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_gerar_partic_w);
ie_gera_prev_aut_iniciar_w := obter_param_usuario(900, 354, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_gera_prev_aut_iniciar_w);
ds_setores_finaliza_mov_w := obter_param_usuario(900, 406, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ds_setores_finaliza_mov_w);
ie_atualizar_setor_prescr_w := obter_param_usuario(900, 479, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_atualizar_setor_prescr_w);
ie_data_cirurgia_w := obter_param_usuario(872, 305, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_data_cirurgia_w);
ie_informacao_w := obter_param_usuario(900, 328, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_informacao_w);
ie_gerar_evolucao_cirurgia_w := obter_param_usuario(281, 1627, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_gerar_evolucao_cirurgia_w);

select	coalesce(max(ie_momento_integracao),'IF')
into STRICT	ie_momento_integracao_w
from	parametros_pepo
where	cd_estabelecimento = cd_estabelecimento_p;

/* PEPO */

if (cd_funcao_p = 872) then
	ie_atualiza_hora_w := obter_param_usuario(872, 81, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_atualiza_hora_w);	
	ie_regra_lanc_automatico_w := obter_param_usuario(872, 102, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_regra_lanc_automatico_w);		
end if;

if (ie_consistir_dia_w = 'S') and (dt_inicio_real_p > clock_timestamp()) then
	--The actual start date must not be greater than the current date
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(191580);
end if;

if (ie_consiste_atend_agenda_w = 'S') then
	select 	coalesce(max(nr_atendimento),0)
	into STRICT	nr_atendimento_w
	from 	agenda_paciente
	where 	nr_cirurgia = nr_cirurgia_p;
	if (nr_atendimento_w > 0) and (nr_atendimento_w <> nr_atendimento_p) then
		--The surgery attendance must be the same as the patient's appointment! Parameter [325].
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(191581);
	end if;
end if;	
		

select	count(*)
into STRICT	qt_atendimento_w
from	atendimento_paciente
where	(dt_fim_conta IS NOT NULL AND dt_fim_conta::text <> '')
and		nr_atendimento		= nr_atendimento_p;

select	max(nr_sequencia)
into STRICT	nr_seq_agenda_w
from	agenda_paciente
where 	nr_cirurgia = nr_cirurgia_p;

if (ie_conta_fechada_w = 'N')
	and (qt_atendimento_w > 0) then
	--Esse atendimento possui conta fechada!
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(191582);
end if;


if (qt_cirurgias_sus_w <> '999') then
	select	obter_convenio_atendimento(nr_atendimento_p)
	into STRICT	cd_convenio_w
	;
	
	select	max(ie_tipo_convenio)
	into STRICT	ie_tipo_convenio_w
	from	convenio
	where	cd_convenio = cd_convenio_w;

	if (ie_tipo_convenio_w = 3) then
		select	count(*)
		into STRICT	qt_cirurgias_w
		from	cirurgia
		where	nr_atendimento = nr_atendimento_p
		and	nr_cirurgia <> nr_cirurgia_p;
		
		select 	max(obter_se_excecao_proc_sus(nr_atendimento_p))
		into STRICT	ie_excecao_w
		from	cirurgia
		where 	nr_cirurgia = nr_cirurgia_p;
		
		if (ie_excecao_w = 'N') and (qt_cirurgias_w >= campo_numerico(qt_cirurgias_sus_w)) then
			--It is no longer possible to start surgery for this SUS service
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(191583);
		end if;	
	end if;
end if;

select	count(*)
into STRICT	qt_passagem_w
from	atend_paciente_unidade
where	nr_atendimento = nr_atendimento_p
and	dt_entrada_unidade = dt_entrada_unidade_p;

if (qt_passagem_w > 0) then
        --A sector ticket already exists with this entry date. Please check the Patient Movement or inform another date
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(191584);
end if;

select	coalesce(max(nr_sequencia),0) + 1
into STRICT	nr_sequencia_w
from	atend_paciente_unidade
where	nr_atendimento		= nr_atendimento_p;

select	nextval('atend_paciente_unidade_seq')
into STRICT	nr_seq_interno_w
;

select	max(atpa.cd_departamento)
into STRICT	cd_departamento_w
from	atend_paciente_unidade atpa
where	atpa.nr_atendimento = nr_atendimento_p
and          atpa.nr_seq_interno = (SELECT   max(a.nr_seq_interno)
                                from    atend_paciente_unidade a
                                where   a.nr_atendimento = atpa.nr_atendimento
                                and     (a.cd_departamento IS NOT NULL AND a.cd_departamento::text <> '')
                                and     coalesce(a.dt_saida_unidade::text, '') = '');

insert	into atend_paciente_unidade(nr_atendimento,
	nr_sequencia,
	cd_setor_atendimento,
	cd_unidade_basica,
	cd_unidade_compl,
	dt_entrada_unidade,
	dt_atualizacao,
	nm_usuario,
	cd_tipo_acomodacao,
	dt_saida_unidade,
	nr_atend_dia,
	ds_observacao,
	nm_usuario_original,
	dt_saida_interno,
	ie_passagem_setor,
	nr_acompanhante,
	nr_seq_interno,
	IE_CALCULAR_DIF_DIARIA,
	nr_seq_motivo_transf,
	cd_departamento)
values (nr_atendimento_p,
	nr_sequencia_w,
	cd_setor_atendimento_p,
	cd_unidade_basica_p,
	cd_unidade_compl_p,
	dt_entrada_unidade_p,
	clock_timestamp(),
	nm_usuario_p,
	cd_tipo_acomodacao_p,
	null,
	null,
	null,
	nm_usuario_p,
	null,
	'S',
	null,
	nr_seq_interno_w,
	'S',
	null,
	cd_departamento_w);


if (trim(both ds_setores_finaliza_mov_w) <> ' ') then

	select	max(a.nr_seq_interno)
	into STRICT	nr_seq_interno_ww
	from	atend_paciente_unidade a
	where	a.nr_atendimento	= nr_atendimento_p
	and	a.dt_entrada_unidade 	= (	SELECT	max(b.dt_entrada_unidade)
						from	atend_paciente_unidade b
						where	a.nr_atendimento     = b.nr_atendimento
						and	b.dt_entrada_unidade <> dt_entrada_unidade_p
						and	coalesce(b.dt_saida_unidade::text, '') = ''
						and	obter_se_contido(b.cd_setor_atendimento,ds_setores_finaliza_mov_w) = 'S');
	
	if (nr_seq_interno_ww IS NOT NULL AND nr_seq_interno_ww::text <> '') then
		update	atend_paciente_unidade
		set	dt_saida_unidade	= dt_entrada_unidade_p,
			nm_usuario              = nm_usuario_p
		where	nr_seq_interno		= nr_seq_interno_ww
		and	coalesce(dt_saida_unidade::text, '') = '';
	end if;
end if;

commit;
	
if (ie_atualizar_convenio_w = 'S') then
	begin
	update	cirurgia
	set	cd_convenio	= obter_convenio_atendimento(nr_atendimento_p),
		cd_categoria	= obter_categoria_atendimento(nr_atendimento_p)
	where	nr_cirurgia	= nr_cirurgia_p;
	exception
		when others then
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(260029);
	end;	
end if;

update	cirurgia
set	nr_atendimento		= nr_atendimento_p,
	dt_entrada_unidade	= dt_entrada_unidade_p,
	dt_inicio_real		= dt_inicio_real_p,
	ie_status_cirurgia	= 2,
	nm_usuario		= nm_usuario_p
where	nr_cirurgia		= nr_cirurgia_p;

if (ie_data_cirurgia_w = 'S') then
	update 	prescr_procedimento 
	set 	dt_inicio = trunc(clock_timestamp())
	where 	nr_prescricao = (SELECT max(nr_prescricao) from cirurgia where nr_cirurgia = nr_cirurgia_p);
	commit;
elsif (ie_data_cirurgia_w = 'H') then
	select 	max(dt_inicio_real) 
	into STRICT	dt_inicio_w
	from	cirurgia 
	where 	nr_cirurgia = nr_cirurgia_p;

	update 	prescr_procedimento
	set 	dt_inicio = dt_inicio_w
	where 	nr_prescricao = (SELECT max(nr_prescricao) from cirurgia where nr_cirurgia = nr_cirurgia_p);
	commit;
end if;

if (ie_estrutura_pepo_w = 'S') then
	update  pepo_cirurgia 
	set 	nr_atendimento = nr_atendimento_p
	where 	nr_sequencia = (SELECT max(nr_seq_pepo) from cirurgia where nr_cirurgia = nr_cirurgia_p);
	commit;
end if;

if (ie_atualizar_setor_w = 'S') then
	update	cirurgia
	set	cd_setor_atendimento	= cd_setor_atendimento_p
	where	nr_cirurgia		= nr_cirurgia_p;
end if;

if (ie_atualiza_hora_w = 'S') then
	update	agenda_paciente
	set	hr_revisada		= dt_inicio_real_p
	where	nr_cirurgia		= nr_cirurgia_p;
end if;

if (cd_status_cirurgia_w IS NOT NULL AND cd_status_cirurgia_w::text <> '') then
	update	agenda_paciente
	set		ie_status_agenda = cd_status_cirurgia_w
	where	nr_sequencia = nr_seq_agenda_w;
end if;

if (ie_atualizar_tempos_auto_w = 'S') then
	select  max(nr_sequencia)
	into STRICT 	nr_seq_inicia_cir_w
	from  	evento_cirurgia
	where 	ie_inicia_cirurgia = 'S'
	and	coalesce(ie_situacao,'A') = 'A';

	if (nr_seq_inicia_cir_w IS NOT NULL AND nr_seq_inicia_cir_w::text <> '') then
		select max(nr_sequencia)
		into STRICT nr_seq_evento_cirurgia_w
		from evento_cirurgia_paciente
		where nr_cirurgia =  nr_cirurgia_p
		and  nr_seq_evento = nr_seq_inicia_cir_w
		and	coalesce(ie_situacao,'A') = 'A';
	end if;

	if (nr_seq_evento_cirurgia_w > 0) then
		update  EVENTO_CIRURGIA_PACIENTE
		set 	DT_REGISTRO  =   dt_inicio_real_p
		where   nr_cirurgia  =   nr_cirurgia_p
		and     nr_sequencia = nr_seq_evento_cirurgia_w;
	else
		select	nextval('evento_cirurgia_paciente_seq')
		into STRICT	nr_sequencia_evento_w
		;
	
	insert into evento_cirurgia_paciente(
		nr_sequencia,
		nr_seq_evento,
		nr_cirurgia,                      
		dt_registro,                  
		dt_atualizacao,         
		nm_usuario,
		ie_situacao,
		cd_profissional)
		values (
		nr_sequencia_evento_w,
		nr_seq_inicia_cir_w,
		CASE WHEN nr_cirurgia_p=0 THEN null  ELSE nr_cirurgia_p END ,
		dt_inicio_real_p,
		clock_timestamp(),
		nm_usuario_p,
		'A',
		Obter_Pessoa_Fisica_Usuario(nm_usuario_p,'C'));
	end if;
end if;
/*OS 896434 Change made to treat cases where the event generates the beginning of surgery and the beginning of integration. Integration starts when you insert / change the event and it has movement. As the moment when the surgery starts and generates the movement already generated the event, we put the update below.*/

select max(nr_sequencia)
into STRICT nr_seq_evento_cirurgia_w
from evento_cirurgia_paciente
where nr_cirurgia =  nr_cirurgia_p
and  nr_seq_evento in (SELECT	nr_sequencia
						from  	evento_cirurgia
						where 	coalesce(ie_inicia_cirurgia,'N') = 'S'
						and		coalesce(ie_inicia_integracao,'N') = 'S'
						and		coalesce(ie_situacao,'A') = 'A')
and	coalesce(ie_situacao,'A') = 'A';

if (nr_seq_evento_cirurgia_w > 0) then
	update  EVENTO_CIRURGIA_PACIENTE
	set 	nr_seq_aten_pac_unid = nr_seq_interno_w
	where   nr_cirurgia  =   nr_cirurgia_p 
	and     nr_sequencia = nr_seq_evento_cirurgia_w;
	commit;
end if;
--OS 896434
if (ie_gerar_partic_w = 'I') then
	select	cd_medico_anestesista,
			cd_medico_cirurgiao
	into STRICT	cd_medico_anestesista_w,   
			cd_medico_cirurgiao_w
	from	cirurgia
	where	nr_cirurgia	=	nr_cirurgia_p;
	
	if (cd_medico_anestesista_w IS NOT NULL AND cd_medico_anestesista_w::text <> '') then
		select	min(cd_funcao)
		into STRICT	cd_funcao_w
		from	funcao_medico
		where	ie_anestesista	=	'S';
		
		if (cd_funcao_w > 0) then
			CALL gerar_participante_cirurgia(cd_medico_anestesista_w, nr_cirurgia_p,cd_funcao_w,'A',nm_usuario_p);
		end if;
	end if;
	
	if (cd_medico_cirurgiao_w IS NOT NULL AND cd_medico_cirurgiao_w::text <> '') then
		select	min(cd_funcao)
		into STRICT	cd_funcao_w
		from	funcao_medico
		where	ie_cirurgiao	=	'S';
		
		if (cd_funcao_w > 0) then
			CALL gerar_participante_cirurgia(cd_medico_cirurgiao_w, nr_cirurgia_p,cd_funcao_w,'C',nm_usuario_p);
		end if;
	end if;
	
	if (ie_gera_prof_agenda_w = 'S') then
		open C01;
		loop
		fetch C01 into	
			cd_profissional_w,
			cd_funcao_prof_w,
			nr_seq_equipe_w,
			cd_especialidade_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			if (cd_funcao_prof_w IS NOT NULL AND cd_funcao_prof_w::text <> '') then
				CALL gerar_partic_cir_prof(cd_profissional_w,
						nr_cirurgia_p,
						cd_funcao_prof_w,
						'',
						cd_especialidade_w,
						nm_usuario_p);
			end if;

			if (nr_seq_equipe_w IS NOT NULL AND nr_seq_equipe_w::text <> '') and (coalesce(cd_funcao_prof_w::text, '') = '') then
				open C03;
				loop
				fetch C03 into	
					cd_profissional_ww,
					cd_funcao_prof_ww,
					nr_seq_equipe_ww;
				EXIT WHEN NOT FOUND; /* apply on C03 */
					begin
					CALL gerar_partic_cir_prof(cd_profissional_ww,
								nr_cirurgia_p,
								cd_funcao_prof_ww,
								'',
								null,
								nm_usuario_p);
					end;
				end loop;
				close C03;
			end if;	
					
			end;
		end loop;
		close C01;
	end if;	
end if;
commit;

if (ie_informacao_w IS NOT NULL AND ie_informacao_w::text <> '') then
	CALL gerar_dados_painel_cir_ini_fim(ie_informacao_w,nr_seq_agenda_w,'A',nm_usuario_p);
	
end if;


CALL Atend_Paciente_Unid_AfterPost(nr_seq_interno_w, 'I', nm_usuario_p);



if (ie_regra_lanc_automatico_w		= 'S') then
	CALL gerar_lancamento_automatico(	nr_atendimento_p,
									null,
									28,
									nm_usuario_p,
									nr_cirurgia_p,
									null,
									null,
									null,
									null,
									null);
					
end if;

if (ie_vincular_atend_w = 'S') and (nr_atendimento_p > 0) and (nr_cirurgia_p > 0) then
	update	prescr_medica
	set	nr_atendimento	=	nr_atendimento_p
	where	nr_cirurgia	=	nr_cirurgia_p
	and	coalesce(ie_tipo_prescr_cirur,0) <> 2;
	commit;
end if;


if (ie_gera_prev_aut_iniciar_w = 'S') then
	select	max(nr_prescricao)
	into STRICT	nr_prescricao_w
	from	cirurgia
	where	nr_cirurgia = nr_cirurgia_p;
	CALL gerar_proc_agenda_cirurgia(nr_seq_agenda_w,nr_prescricao_w,nm_usuario_p);
end if;	

if (ie_atualizar_setor_prescr_w = 'S') then
	select	coalesce(max(nr_prescricao),0),
		coalesce(max(cd_setor_atendimento),0)
	into STRICT	nr_prescricao_w,
		cd_setor_atendimento_w
	from	cirurgia
	where	nr_cirurgia = nr_cirurgia_p;
	if (nr_prescricao_w > 0) and (cd_setor_atendimento_w > 0) then
		update	prescr_medica
		set	cd_setor_atendimento	= cd_setor_atendimento_w
		where	nr_prescricao		= nr_prescricao_w;
	end if;	
end if;


if (ie_altera_clinica_atend_w = 'S') and (nr_atendimento_p > 0) then
	update	atendimento_paciente
	set	ie_clinica = 2
	where	nr_atendimento = nr_atendimento_p;
end if;

commit;

if (ie_momento_integracao_w = 'IF') then
	CALL gerar_cirurgia_hl7(nr_atendimento_p,nr_seq_interno_w,cd_setor_atendimento_p,'I');
end if;

if (nr_seq_agenda_w > 0) then
	CALL executar_evento_agenda('INC','CI',nr_seq_agenda_w,cd_estabelecimento_p,nm_usuario_p,null,null);
end if;

if ((ie_grava_log_w = 'S') and (obter_se_possui_motivo_alt_cir('I','') = 'N')) then
	CALL gerar_cirurgia_hist(nr_cirurgia_p,'IC',nm_usuario_p,expressao1_w);
end if;



if (wheb_usuario_pck.is_evento_ativo(23) = 'S') then

	select	coalesce(max(nr_prescricao),0)
	into STRICT	nr_prescricao_w
	from	cirurgia
	where	nr_cirurgia = nr_cirurgia_p;
	
	ds_sep_bv_w := obter_separador_bv;	
	
	open c02;
	loop
	fetch c02 into c02_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
		begin		
		
		ds_param_integ_hl7_w :=	
					'cd_pessoa_fisica=' || c02_w.cd_pessoa_fisica 	|| ds_sep_bv_w ||
					'nr_atendimento='   || c02_w.nr_atendimento   	|| ds_sep_bv_w ||
					'nr_seq_interno='   || c02_w.nr_seq_interno		|| ds_sep_bv_w ||
					'nr_prescricao='    || nr_prescricao_w	    	|| ds_sep_bv_w ||
					'nr_seq_presc='	    || c02_w.nr_sequencia     	|| ds_sep_bv_w ||
					'order_control='    || 'NW'    		     		|| ds_sep_bv_w ||
					'order_status='     || 'SC'    		     		|| ds_sep_bv_w;
		
		CALL gravar_agend_integracao(23, ds_param_integ_hl7_w);
		
		end;
	end loop;
	close c02;

end if;

select	max(nr_prescricao)
into STRICT	nr_prescricao_w
from	cirurgia
where	nr_cirurgia = nr_cirurgia_p;

if (OBTAIN_USER_LOCALE(nm_usuario_p) = 'en_AU') and (nr_prescricao_w IS NOT NULL AND nr_prescricao_w::text <> '') then --Forcar a geracao da prescr_proc_hor devido necessidade na integracao com a Siemens.
	CALL gerar_prescr_proc_hor(nr_prescricao_w,obter_perfil_ativo,nm_usuario_p);
end if;


for r_c06 in c06 loop
	begin
	CALL call_bifrost_content('surgery.image.order.request','prescription_json_pck.get_ris_message_clob('||r_c06.nr_seq_procedimento||')', nm_usuario_p);
	end;
end loop;



CALL atualizar_mov_iniciar_cir(nr_atendimento_p, nr_cirurgia_p, cd_estabelecimento_p, nr_seq_interno_w);	

select	coalesce(max(ie_pyxis_cirurgia), 'N')
into STRICT	ie_pyxis_cirurgia_w
from	parametros_farmacia
where	cd_estabelecimento = cd_estabelecimento_p;

if (ie_pyxis_cirurgia_w = 'S') then

	begin
	select	1
	into STRICT	qt_existe_regra_setor_w
	from	dis_regra_setor
	where	cd_setor_atendimento = cd_setor_atendimento_p  LIMIT 1;
	exception
	when others then
		qt_existe_regra_setor_w := 0;
	end;

	if (qt_existe_regra_setor_w > 0) then
		/*OS 2875891 passando setor para nao limpar a unidade basica*/

		CALL intdisp_gerar_movimento(nr_atendimento_p, 'EPA', cd_setor_atendimento_p, nr_cirurgia_p);
	end if;	
end if;

select	coalesce(max(ie_inicio_cirurgia), 'N')
into STRICT	ie_inicio_cirurgia_w
from	ajuste_ap_lote_evento
where	ie_evento = 'M'
and	((coalesce(cd_estabelecimento::text, '') = '') or (cd_estabelecimento = cd_estabelecimento_p));

if (ie_inicio_cirurgia_w = 'S') then
	CALL gerar_ajustes_ap_lote('M', nr_atendimento_p, nm_usuario_p);
end if;

if ( ie_gerar_evolucao_cirurgia_w = 'S' ) then

	cd_evolucao_w := clinical_notes_pck.gerar_soap(nr_atendimento_p, nr_cirurgia_p, 'SURGERY', null, 'P', 1, cd_evolucao_w);

	update cirurgia
	set cd_evolucao = cd_evolucao_w
	where nr_cirurgia = nr_cirurgia_p;
	
end if;
exception
when others then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(191586,'DS_ERRO='||substr(SQLERRM(SQLSTATE),1,1800));
end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE iniciar_cirurgia ( nr_atendimento_p bigint, nr_cirurgia_p bigint, dt_entrada_unidade_p timestamp, dt_inicio_real_p timestamp, cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, cd_tipo_acomodacao_p bigint, nm_usuario_p text, cd_funcao_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
