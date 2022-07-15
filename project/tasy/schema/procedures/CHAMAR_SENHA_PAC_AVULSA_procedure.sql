-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE chamar_senha_pac_avulsa ( nr_seq_senha_p bigint, nm_maquina_atual_p text, nr_seq_fila_p bigint, cd_senha_p text, nm_usuario_p text, nr_seq_local_p bigint default 0, ie_consiste_usuario_p text default null, cd_agenda_p bigint default null) AS $body$
DECLARE


cd_estabelecimento_w			bigint;
nr_seq_local_senha_w			bigint;
qt_chamadas_atual_w			bigint;
qt_max_chamadas_w			bigint;
ie_utiliza_oracle_alert_w		varchar(2);
nm_usuario_chamada_w 			varchar(20);	
ie_consiste_usuario_w			varchar(2);
dt_ultima_chamada_w			timestamp;
ie_rechamada_w				varchar(1);
dt_rechamada_w				timestamp;
nm_usuario_w				varchar(15);
nr_seq_senha_ant_w			bigint;
ie_final_senha_ant_w			varchar(10);
cd_senha_ant_w				paciente_senha_fila.cd_senha_gerada%type;
nr_seq_maquina_w			bigint;
qt_reg_w				bigint;
ie_status_agenda_w			varchar(255);
cd_funcao_ativa_w			integer;
qt_agendas_w        			integer := 0;
cd_tipo_agenda_w			agenda.cd_tipo_agenda%type;


BEGIN
nm_usuario_w		:= wheb_usuario_pck.get_nm_usuario;
cd_estabelecimento_w	:= wheb_usuario_pck.get_cd_estabelecimento;

ie_consiste_usuario_w := Obter_Param_Usuario(10021, 61, Obter_perfil_Ativo, nm_usuario_w, cd_estabelecimento_w, ie_consiste_usuario_w);
ie_final_senha_ant_w := Obter_Param_Usuario(10021, 80, Obter_perfil_Ativo, nm_usuario_w, cd_estabelecimento_w, ie_final_senha_ant_w);

ie_status_agenda_w := Obter_Param_Usuario(10021, 144, Obter_perfil_Ativo, nm_usuario_w, cd_estabelecimento_w, ie_status_agenda_w);


select  max(a.nr_sequencia)
into STRICT	nr_seq_maquina_w
from    maquina_local_senha a,
	computador b 
where  a.nr_seq_computador	= b.nr_sequencia 
and      a.cd_estabelecimento = cd_estabelecimento_w
and	 nm_computador_pesquisa = padronizar_nome(upper(nm_maquina_atual_p))
and	 coalesce(a.ie_situacao, 'A') = 'A';

select	count(*)
into STRICT	qt_reg_w
from	regra_liberacao_fila a,
	fila_espera_senha b
where	b.nr_sequencia 				= a.nr_seq_fila_espera
and	b.nr_sequencia				= nr_seq_fila_p
and	a.cd_estabelecimento			= cd_estabelecimento_w
and	coalesce(b.ie_permite_chamada, 'S') 		= 'S';

select	max(Obter_Funcao_Ativa)
into STRICT	cd_funcao_ativa_w
;

if (ie_status_agenda_w IS NOT NULL AND ie_status_agenda_w::text <> '') and (cd_funcao_ativa_w = 281) then -- PEP
    
	select	coalesce(max(cd_tipo_agenda),3)
	into STRICT	cd_tipo_agenda_w
	from	agenda
	where	cd_agenda = cd_agenda_p;
	
	if (cd_tipo_agenda_w in (3,4,5)) then -- Consultas por medico, Consultas servico medico, Agenda de servicos
		select	count(*)
		into STRICT	qt_agendas_w
		from	agenda_consulta
		where	nr_seq_pac_senha_fila	= nr_seq_senha_p
		and     obter_se_contido_char(ie_status_agenda, ie_status_agenda_w) = 'S';
	elsif (cd_tipo_agenda_w in (2,1)) then -- Exames, Cirurgia
		select	count(*)
		into STRICT	qt_agendas_w
		from	agenda_paciente
		where	nr_seq_pac_senha_fila	= nr_seq_senha_p
		and     obter_se_contido_char(ie_status_agenda, ie_status_agenda_w) = 'S';
	end if;

	if (qt_agendas_w = 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(445585);
	end if;
end if;
	
if (qt_reg_w > 0) then

	select	count(*)
	into STRICT	qt_reg_w
	from	regra_liberacao_fila a,
		fila_espera_senha b
	where	b.nr_sequencia 					= a.nr_seq_fila_espera
	and	b.nr_sequencia					= nr_seq_fila_p
	and	coalesce(a.cd_perfil,obter_perfil_ativo)		= obter_perfil_ativo
	and 	coalesce(a.nr_seq_local_senha,nr_seq_maquina_w)	= nr_seq_maquina_w
	and	a.cd_estabelecimento				= cd_estabelecimento_w
	and	coalesce(b.ie_permite_chamada, 'S') 			= 'S';

	if (qt_reg_w = 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(332782);
	end if;

end if;

if (coalesce(ie_consiste_usuario_p,'S') = 'S') then
	select 	max(nm_usuario_chamada),
		max(ie_rechamada),
		max(dt_nova_chamada)
	into STRICT	nm_usuario_chamada_w,
		ie_rechamada_w,
		dt_rechamada_w
	from	paciente_senha_fila
	where	(dt_primeira_chamada IS NOT NULL AND dt_primeira_chamada::text <> '')
	and	nr_sequencia = nr_seq_senha_p;
	
	select	max(dt_atualizacao_nrec)
	into STRICT	dt_ultima_chamada_w
	from	paciente_senha_fila_hist
	where	nr_seq_senha = nr_seq_senha_p;
	
	if	((ie_consiste_usuario_w = 'S') or
		((ie_consiste_usuario_w = 'M') and (obter_se_usuario_medico(nm_usuario_chamada_w) = 'S') and (obter_se_usuario_medico(nm_usuario_w) = 'S'))) and
		((coalesce(dt_rechamada_w::text, '') = '') or (dt_ultima_chamada_w < dt_rechamada_w)) then
		if (nm_usuario_chamada_w IS NOT NULL AND nm_usuario_chamada_w::text <> '') and (nm_usuario_chamada_w <> nm_usuario_w) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(227548, 'NM_USUARIO_CHAMADA= ' || nm_usuario_chamada_w);
		end if;
	end if;
elsif (coalesce(ie_consiste_usuario_p,'S') = 'N') then
		
	delete  FROM ATENDIMENTOS_SENHA a
	WHERE   a.NR_SEQ_PAC_SENHA_FILA = nr_seq_senha_p
	and	a.nr_sequencia in (	SELECT	c.nr_sequencia
					FROM    ATENDIMENTOS_SENHA c,
						paciente_senha_fila b
					WHERE   c.NR_SEQ_PAC_SENHA_FILA = b.nr_sequencia
					AND     (b.dt_inicio_atendimento IS NOT NULL AND b.dt_inicio_atendimento::text <> '')
					AND     coalesce(b.dt_fim_atendimento::text, '') = ''
					AND     c.nm_usuario_inicio  <> nm_usuario_w
					AND     b.nr_sequencia = nr_seq_senha_p);
	
	Update 	paciente_senha_fila
	set 	dt_inicio_atendimento 	 = NULL
	where   nr_sequencia = nr_seq_senha_p;

  CALL bifrost_integracao_senhas(nr_seq_senha_p => nr_seq_senha_p);

end if;
	SELECT  Obter_Valor_Param_Usuario(10021,24,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_w),
		coalesce(Obter_Valor_Param_Usuario(10021,56,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_w),'N')
		
	into STRICT 	qt_max_chamadas_w,
		ie_utiliza_oracle_alert_w
	;
	
	If (coalesce(nr_seq_local_p, 0) > 0) then
		nr_seq_local_senha_w := nr_seq_local_p;
	else
		select	max(a.nr_sequencia)
		into STRICT	nr_seq_local_senha_w
		from	maquina_local_senha a,
			computador b
		where   a.nr_seq_computador	= b.nr_sequencia
		and	nm_computador_pesquisa 	= padronizar_nome(upper(nm_maquina_atual_p))
		and	coalesce(b.cd_estabelecimento, cd_estabelecimento_w) = cd_estabelecimento_w
		and	coalesce(a.ie_situacao, 'A') = 'A';	
	end if;
	
	select	max(nr_sequencia)
	into STRICT	nr_seq_senha_ant_w
	from	paciente_senha_fila
	where	nr_sequencia = coalesce(obter_senha_pac_maquina(nm_usuario_p,nm_maquina_atual_p),0)
	and		coalesce(ie_rechamada, '@') <> 'S';
	
	if (nr_seq_senha_p > 0) then
		
		if (coalesce(nr_seq_senha_ant_w,0) > 0) and (nr_seq_senha_ant_w <> nr_seq_senha_p) and
			((coalesce(ie_final_senha_ant_w,'X') = 'C') or (coalesce(ie_final_senha_ant_w,'X') = 'A')) then
			CALL iniciar_finalizar_atend_senha(nr_seq_senha_ant_w,'F',nm_usuario_p,cd_estabelecimento_w);
		end if;
		
		update	paciente_senha_fila
		set	dt_chamada		=	clock_timestamp(),
			ds_maquina_chamada	=	nm_maquina_atual_p,
			nr_seq_local_senha	=	nr_seq_local_senha_w,
			dt_primeira_chamada	=	CASE WHEN dt_primeira_chamada = NULL THEN clock_timestamp()  ELSE dt_primeira_chamada END ,
			qt_chamadas		=	coalesce(qt_chamadas,0) + 1,
			nm_usuario		=	nm_usuario_p,
			nm_usuario_chamada	=	nm_usuario_p,
			ie_forma_chamada        =       'C'
		where	nr_sequencia		=	nr_seq_senha_p;
    CALL bifrost_integracao_senhas(nr_seq_senha_p => nr_seq_senha_p);		
		if (ie_utiliza_oracle_alert_w	=	'S') then
			CALL verificar_senha_nova_signal(nm_usuario_p);
		end if;	
	elsif (nr_seq_senha_p = 0) then
		if (coalesce(nr_seq_senha_ant_w,0) > 0) and
			((coalesce(ie_final_senha_ant_w,'X') = 'C') or (coalesce(ie_final_senha_ant_w,'X') = 'A')) then
			
			select	cd_senha_gerada
			into STRICT	cd_senha_ant_w
			from	paciente_senha_fila
			where	nr_sequencia = nr_seq_senha_ant_w;
			
			if (cd_senha_ant_w IS NOT NULL AND cd_senha_ant_w::text <> '') and (cd_senha_ant_w <> cd_senha_p) then
				CALL iniciar_finalizar_atend_senha(nr_seq_senha_ant_w,'F',nm_usuario_p,cd_estabelecimento_w);
			end if;
		end if;
		
		update	paciente_senha_fila
		set	dt_chamada			=	clock_timestamp(),
			ds_maquina_chamada		=	nm_maquina_atual_p,
			nr_seq_local_senha		=	nr_seq_local_senha_w,
			nm_usuario			=	nm_usuario_p,
			dt_primeira_chamada		=	CASE WHEN dt_primeira_chamada = NULL THEN clock_timestamp()  ELSE dt_primeira_chamada END ,
			qt_chamadas			=	coalesce(qt_chamadas,0) + 1,
			nm_usuario_chamada		=	nm_usuario_p
		where	cd_senha_gerada			=	cd_senha_p
		and	coalesce(dt_inutilizacao::text, '') = ''
		and	coalesce(dt_vinculacao_senha::text, '') = ''
		and	coalesce(dt_utilizacao::text, '') = ''
		and	nr_seq_fila_senha_origem        =	nr_seq_fila_p
		and	cd_estabelecimento		=	cd_estabelecimento_w;
    CALL bifrost_integracao_senhas(nr_seq_senha_p => nr_seq_senha_p);
		
		if (ie_utiliza_oracle_alert_w	=	'S') then
			CALL verificar_senha_nova_signal(nm_usuario_p);
		end if;	
		
	end if;
	
	select 	coalesce(max(qt_chamadas),0)
	into STRICT	qt_chamadas_atual_w
	from 	paciente_senha_fila
	where 	nr_sequencia = nr_seq_senha_p;
		
	if (qt_chamadas_atual_w > qt_max_chamadas_w) and (qt_max_chamadas_w > 0) then
		
		update paciente_senha_fila
		set	dt_inutilizacao 	= 	clock_timestamp(),
			nm_usuario_inutilizacao	= 	wheb_usuario_pck.get_nm_usuario,
			ds_maquina_inutilizacao	= 	wheb_usuario_pck.get_nm_maquina
		where	nr_sequencia  = nr_seq_senha_p;
    CALL bifrost_integracao_senhas(nr_seq_senha_p => nr_seq_senha_p);
			
		update	atendimento_paciente
		set 	ie_chamado = 'X',
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p
		where	nr_seq_pac_senha_fila = nr_seq_senha_p;
			
	end if;

	commit;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE chamar_senha_pac_avulsa ( nr_seq_senha_p bigint, nm_maquina_atual_p text, nr_seq_fila_p bigint, cd_senha_p text, nm_usuario_p text, nr_seq_local_p bigint default 0, ie_consiste_usuario_p text default null, cd_agenda_p bigint default null) FROM PUBLIC;

