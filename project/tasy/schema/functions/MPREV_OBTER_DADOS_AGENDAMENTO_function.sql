-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mprev_obter_dados_agendamento ( nr_seq_agendamento_p bigint, ie_opcao_p text, ie_restringe_tam_p text default 'N', nr_seq_eq_fil_p text default null) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Obter dados de um agendamento da agenda da Medicina Preventiva.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[X]  Objetos do dicionario [X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

IE_OPCAO_P
DT - data agenda
FA - forma de atendimento EQ - equipe, LA - Local Atendimento
TP - tipo: Se por equipe, codigo de equipe, se por local, se Individual ou coletivo
IN - interno 'S', externo 'N'
DR - duracao
NP - nome participante
NT - nome da turma
ST - status da agenda
SP - status paciente na agenda
DC - data da confirmacao
UC - usuario confirmacao
UR - usuario registro
NE - Nome exibicao
LA - Local Atendimento
MT - Motivo cancelamento
TA - Tipo de atendimento
TR - Descricao do Tipo de recurso
NR - Nome do recurso
DB - Descricao do patrimonio ou bem
AE - Nome da atividade extra
TE - Tema do encontro do grupo

IE_RESTRINGE_TAM_P
'S' - Limitar tamanho do retorno. OBS.: Parametro criado para utilizacao no detalhe do agendamento na funcao PrevMed - Agenda.

Alteracoes:
 -----------------------------------------------------------------------------------------------------------------

 jjung OS 708649 - 
 
 Alteracao:	Aumentei o  tamanho da variavel de retorno.
 
 Motivo:	Para poder retornar o campo observacao, de 4000 caracteres.
 -----------------------------------------------------------------------------------------------------------------


++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
			
ds_retorno_w		varchar(4000);
nr_seq_participante_w 	mprev_agendamento.nr_seq_participante%type;
nr_seq_turma_w		mprev_agendamento.nr_seq_turma%type;
nr_seq_captacao_w	mprev_agendamento.nr_seq_captacao%type;
dt_agenda_w		mprev_agendamento.dt_agenda%type;
cd_agenda_w		mprev_agendamento.cd_agenda%type;
nr_seq_local_atend_w	mprev_local_atend.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	mprev_obter_ds_tipo_recurso(ie_tipo_recurso) ds_tipo_recurso
	from	mprev_agendamento_recurso
	where	nr_seq_agendamento = nr_seq_agendamento_p
	order by 1;
	
C02 CURSOR FOR
	SELECT	a.nm_recurso
	from	mprev_recurso_agenda a,
		mprev_agendamento_recurso b
	where	a.nr_sequencia = b.nr_seq_recurso
	and	b.nr_seq_agendamento = nr_seq_agendamento_p
	order by 1;

C03 CURSOR FOR
	SELECT	ds_bem
	from	pat_bem a,
		mprev_recurso_agenda c,
		mprev_agendamento_recurso d
	where	a.nr_sequencia = c.nr_seq_pat_bem
	and	c.nr_sequencia = d.nr_seq_recurso
	and	d.nr_seq_agendamento = nr_seq_agendamento_p
	order by ds_bem;

BEGIN

if (nr_seq_agendamento_p IS NOT NULL AND nr_seq_agendamento_p::text <> '') then
	
	if (upper(ie_opcao_p) = 'DT') then
	
		select	to_char(max(dt_agenda),'dd/mm/yyyy hh24:mi')
		into STRICT	ds_retorno_w
		from	mprev_agendamento
		where	nr_sequencia = nr_seq_agendamento_p;

	elsif (upper(ie_opcao_p) = 'DR') then
	
		select	max(to_char(nr_minuto_duracao))
		into STRICT	ds_retorno_w
		from	mprev_agendamento
		where	nr_sequencia = nr_seq_agendamento_p;

	elsif (upper(ie_opcao_p) = 'NP') then
		
		select	max(mprev_obter_nm_participante(nr_seq_participante))
		into STRICT	ds_retorno_w
		from	mprev_agendamento
		where	nr_sequencia = nr_seq_agendamento_p;
			
	elsif (upper(ie_opcao_p) = 'NT') then
		
		select	max(mprev_obter_dados_grupo_turma(nr_seq_turma,'N'))
		into STRICT	ds_retorno_w
		from	mprev_agendamento
		where	nr_sequencia = nr_seq_agendamento_p;
	
	elsif (upper(ie_opcao_p) = 'ST') then
		
		select	max(substr(obter_valor_dominio(83, IE_STATUS_AGENDA),1,250))
		into STRICT	ds_retorno_w
		from	mprev_agendamento
		where	nr_sequencia = nr_seq_agendamento_p;

	elsif (upper(ie_opcao_p) = 'SP') then
		
		select	max(substr(obter_descricao_padrao('STATUS_PACIENTE_AGENDA','DS_STATUS_PACIENTE',NR_SEQ_STATUS_PAC),1,250))
		into STRICT	ds_retorno_w
		from	mprev_agendamento
		where	nr_sequencia = nr_seq_agendamento_p;		
		
	elsif (upper(ie_opcao_p) = 'DC') then
		
		select	DT_CONFIRMACAO ||
			CASE WHEN coalesce(dt_confirmacao::text, '') = '' THEN NULL  ELSE ' ' || wheb_mensagem_pck.get_texto(795553) || ' ' END  || 
			CASE WHEN coalesce(SUBSTR(ds_confirmacao,1,30)::text, '') = '' THEN NULL  ELSE ds_confirmacao || ' ' || wheb_mensagem_pck.get_texto(795554) || ' ' END  || 
			SUBSTR(obter_desc_forma_conf(a.nr_seq_forma_confirm),1,20)
		into STRICT	ds_retorno_w
		from	mprev_agendamento a
		where	nr_sequencia = nr_seq_agendamento_p;
			
		if (upper(ie_restringe_tam_p) = 'S' and (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '')) then
			if (length(ds_retorno_w) > 33) then
				ds_retorno_w := substr(ds_retorno_w,1,33) || '...';
			end if;
		end if;

	elsif (upper(ie_opcao_p) = 'UC') then
		
		select	nm_usuario_confirm
		into STRICT	ds_retorno_w
		from	mprev_agendamento a
		where	nr_sequencia = nr_seq_agendamento_p;
			
		if (upper(ie_restringe_tam_p) = 'S' and (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '')) then
			if (length(ds_retorno_w) > 10) then
				ds_retorno_w := substr(ds_retorno_w,1,10) ||'...';
			end if;
		end if;
		
	elsif (upper(ie_opcao_p) = 'UR') then
		
		select	nm_usuario
		into STRICT	ds_retorno_w
		from	mprev_agendamento a
		where	nr_sequencia = nr_seq_agendamento_p;
			
		if (upper(ie_restringe_tam_p) = 'S' and (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '')) then
			if (length(ds_retorno_w) > 10) then
				ds_retorno_w := substr(ds_retorno_w,1,10) ||'...';
			end if;
		end if;

	elsif (upper(ie_opcao_p) = 'OB') then
		
		select	max(ds_observacao)
		into STRICT	ds_retorno_w
		from	mprev_agendamento
		where	nr_sequencia = nr_seq_agendamento_p;	
		
		if (upper(ie_restringe_tam_p) = 'S' and (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '')) then
			if (length(ds_retorno_w) > 45) then
				ds_retorno_w := substr(ds_retorno_w,1,45) || '...';
			end if;
		end if;

	elsif (upper(ie_opcao_p) = 'FA') then
		
		select 	max(CASE WHEN coalesce(a.cd_pessoa_fisica::text, '') = '' THEN 'LA'  ELSE 'EQ' END )
		into STRICT	ds_retorno_w
		from 	agenda a,
			mprev_agendamento b
		where 	a.cd_agenda = b.cd_agenda
		and	b.nr_sequencia = nr_seq_agendamento_p;

	elsif (upper(ie_opcao_p) = 'TP') then
		select	to_char(max(NR_SEQ_EQUIPE))
		into STRICT	ds_retorno_w
		from 	agenda a,
				mprev_agendamento b,
				mprev_equipe_profissional c
		where 	a.cd_agenda = b.cd_agenda
		and 	c.cd_pessoa_fisica = a.cd_pessoa_fisica
		and		b.nr_sequencia = nr_seq_agendamento_p
		and		NR_SEQ_EQUIPE = nr_seq_eq_fil_p
		and		clock_timestamp() between pkg_date_utils.start_of(dt_inclusao, 'DAY') and pkg_date_utils.end_of(coalesce(dt_exclusao, clock_timestamp()), 'DAY');
		
		if (coalesce(ds_retorno_w::text, '') = '' or ds_retorno_w = '') then
			select	max(ds)
			into STRICT	ds_retorno_w
			from (
			SELECT	to_char(c.nr_seq_equipe) ds
			from 	agenda a,
					mprev_agendamento b,
					mprev_equipe_profissional c
			where 	a.cd_agenda = b.cd_agenda
			and 	c.cd_pessoa_fisica = a.cd_pessoa_fisica
			and	b.nr_sequencia = nr_seq_agendamento_p
			and clock_timestamp() between pkg_date_utils.start_of(c.dt_inclusao, 'DAY') and pkg_date_utils.end_of(coalesce(c.dt_exclusao, clock_timestamp()), 'DAY')
			
union

			SELECT	CASE WHEN coalesce(b.nr_seq_participante::text, '') = '' THEN 'C'  ELSE 'I' END  ds 
			from 	agenda a,
				mprev_agendamento b
			where 	a.cd_agenda = b.cd_agenda
			and	coalesce(a.cd_pessoa_fisica::text, '') = ''
			and	b.nr_sequencia = nr_seq_agendamento_p) alias11;
		end if;
		
		if (coalesce(ds_retorno_w::text, '') = '' or ds_retorno_w = '') then
			ds_retorno_w := nr_seq_eq_fil_p;
		end if;

	elsif (upper(ie_opcao_p) = 'IN') then

		select  max(CASE WHEN c.IE_INTERNO='S' THEN 'I'  ELSE 'E' END )
		into STRICT	ds_retorno_w
		from 	mprev_local_atend_agenda a,
			mprev_agendamento b,
			mprev_local_atend c
		where 	a.cd_agenda = b.cd_agenda
		and	c.nr_sequencia = a.nr_seq_local_atend
		and	a.ie_situacao = 'A'
		and	b.nr_sequencia = nr_seq_agendamento_p;

	elsif (upper(ie_opcao_p) = 'NE') then
		select	a.nr_seq_participante,
			a.nr_seq_turma,
			a.nr_seq_captacao,
			a.dt_agenda
		into STRICT	nr_seq_participante_w,
			nr_seq_turma_w,
			nr_seq_captacao_w,
			dt_agenda_w
		from	mprev_agendamento a
		where	a.nr_sequencia	= nr_seq_agendamento_p;

		if (nr_seq_participante_w IS NOT NULL AND nr_seq_participante_w::text <> '') then
			select	obter_nome_pessoa_fisica(x.cd_pessoa_fisica, null)
			into STRICT 	ds_retorno_w
			from	mprev_participante x
			where	x.nr_sequencia = nr_seq_participante_w;
		elsif (nr_seq_turma_w IS NOT NULL AND nr_seq_turma_w::text <> '') then
			select	max(nm_grupo||' - ' || nm_turma)
			into STRICT 	ds_retorno_w
			from 	mprev_grupo_col_turma  x,
				mprev_grupo_coletivo y 
			where 	x.nr_sequencia = nr_seq_turma_w
			and	y.nr_sequencia = x.NR_SEQ_GRUPO_COLETIVO;
		else
			if (nr_seq_captacao_w IS NOT NULL AND nr_seq_captacao_w::text <> '') then
				ds_retorno_w := obter_desc_expressao(300492,null) 
				|| ' - ' || mprev_obter_dados_captacao(nr_seq_captacao_w,dt_agenda_w,'PF');
			else
				ds_retorno_w := null;
			end if;
		end if;
		
	elsif (upper(ie_opcao_p) = 'LA') then
		select	max(nr_seq_local_atend)
		into STRICT	nr_seq_local_atend_w
		from	mprev_agendamento a
		where	a.nr_sequencia = nr_seq_agendamento_p;
		
		if (coalesce(nr_seq_local_atend_w,0) > 0) then
			select 	a.nm_local
			into STRICT	ds_retorno_w
			from 	mprev_local_atend a
			where	a.nr_sequencia	= nr_seq_local_atend_w;
		else
			select	max(x.cd_agenda)
			into STRICT	cd_agenda_w
			from	mprev_agendamento x
			where	x.nr_sequencia = nr_seq_agendamento_p;
		
			if (coalesce(cd_agenda_w,0) > 0) then
				select 	a.nm_local
				into STRICT	ds_retorno_w
				from 	mprev_local_atend a,
					mprev_local_atend_agenda b
				where	a.nr_sequencia	= b.nr_seq_local_atend
				and	b.ie_situacao 	= 'A'
				and	b.cd_agenda 	= cd_agenda_w;
			end if;
		end if;

	elsif (upper(ie_opcao_p) = 'MT') then
		select	a.ds_motivo
		into STRICT	ds_retorno_w
		from 	agenda_motivo_cancelamento a, mprev_agendamento b
		where 	b.nr_seq_motivo_canc =	a.nr_sequencia
		and	b.nr_sequencia	=	nr_seq_agendamento_p;
	elsif (upper(ie_opcao_p) = 'TA') then
		select	dt_agenda,
			nr_seq_participante
		into STRICT	dt_agenda_w,
			nr_seq_participante_w
		from	mprev_agendamento
		where	nr_sequencia	= nr_seq_agendamento_p;
		
		select	obter_valor_dominio(5987, coalesce(max(ie_tipo_atendimento), 'P'))
		into STRICT	ds_retorno_w
		from	mprev_partic_tipo_atend
		where	nr_seq_participante 	= nr_seq_participante_w
		and	dt_inicio <= to_date(dt_agenda_w)
		and (dt_fim >= to_date(dt_agenda_w) or coalesce(dt_fim::text, '') = '');
	
	elsif (upper(ie_opcao_p) = 'TR') then
		for	r_C01_w in C01 loop
			begin
			if (coalesce(ds_retorno_w::text, '') = '') then	
				ds_retorno_w := r_C01_w.ds_tipo_recurso;
			else
				ds_retorno_w := (ds_retorno_w||', '||r_C01_w.ds_tipo_recurso);
			end if;	
			end;
		end loop;
	elsif (upper(ie_opcao_p) = 'NR') then
		for	r_C02_w in C02 loop
			begin
			if (coalesce(ds_retorno_w::text, '') = '') then	
				ds_retorno_w := r_C02_w.nm_recurso;
			else
				ds_retorno_w := (ds_retorno_w||', '||r_C02_w.nm_recurso);
			end if;	
			end;
		end loop;
	elsif (upper(ie_opcao_p) = 'DB') then
		for	r_C03_w in C03 loop
			begin
			if (coalesce(ds_retorno_w::text, '') = '') then	
				ds_retorno_w := r_C03_w.ds_bem;
			else
				ds_retorno_w := (ds_retorno_w||', '||r_C03_w.ds_bem);
			end if;	
			end;
		end loop;
	elsif (upper(ie_opcao_p) = 'AE') then
		select 	a.ds_atividade
		into STRICT	ds_retorno_w
		from	mprev_ativ_extra_agenda a,
			mprev_agendamento b
		where	a.nr_sequencia = b.nr_seq_ativ_extra
		and	b.nr_sequencia = nr_seq_agendamento_p;
	elsif (upper(ie_opcao_p) = 'TE') then
		select	b.ds_tema
		into STRICT	ds_retorno_w
		from	mprev_agendamento a,
			mprev_grupo_tema_encontro b
		where	a.nr_seq_grupo_tema = b.nr_sequencia
		and	a.nr_sequencia = nr_seq_agendamento_p;
	end if;		
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mprev_obter_dados_agendamento ( nr_seq_agendamento_p bigint, ie_opcao_p text, ie_restringe_tam_p text default 'N', nr_seq_eq_fil_p text default null) FROM PUBLIC;
