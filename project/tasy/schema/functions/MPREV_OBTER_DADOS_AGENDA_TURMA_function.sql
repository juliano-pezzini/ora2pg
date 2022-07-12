-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mprev_obter_dados_agenda_turma (nr_seq_turma_p bigint, nr_seq_agendamento_p bigint, ie_opcao_p text, ie_restringe_tam_p text default 'N') RETURNS varchar AS $body$
DECLARE

/* 
A) Data de início 
B) Data de término 
C) Dias semana 
D) Qtd atual de participantes 
E) Qtd prevista para o dia 
F) Qtd faltas no dia 
G) Profissionais responsáveis 
Q) Quantidade participantes confirmados 
 
IE_RESTRINGE_TAM_P 
'S' - Limitar tamanho do retorno. OBS.: Parametro criado para utilização no detalhe do agendamento na função PrevMed - Agenda. 
*/
					 
 		  	 
ds_retorno_w		varchar(255);			
dt_agendamento_w	mprev_agendamento.dt_agendamento%type;
ie_status_agenda_w	mprev_agendamento.ie_status_agenda%type;
qt_partic_w		bigint;

C01 CURSOR FOR 
	SELECT	distinct(pkg_date_utils.get_weekday(dt_agenda)||'ª') dt_semana 
	from	mprev_agendamento 
	where	ie_status_agenda <> 'C' 
	and	nr_seq_horario_turma = (SELECT	max(nr_seq_horario_turma) 
				from	mprev_agendamento 
				where	nr_sequencia = nr_seq_agendamento_p) 
	order by 1;

C02 CURSOR FOR 
	SELECT	substr(obter_nome_pf(b.cd_pessoa_fisica),1,250) nm_responsavel   
	from	mprev_agendamento a, 
		mprev_grupo_turma_hor_prof b 
	where	a.nr_seq_horario_turma = b.nr_seq_horario						 
	and	a.nr_sequencia = nr_seq_agendamento_p 
	order by 1;
			
BEGIN 
 
if (upper(ie_opcao_p) = 'A') then 
	--data de inicio A	 
	select	min(dt_agenda) 
	into STRICT	ds_retorno_w 
	from	mprev_agendamento 
	where	ie_status_agenda <> 'C'	 
	and	nr_seq_turma = nr_seq_turma_p;
 
elsif (upper(ie_opcao_p) = 'B') then 
	--data de término B 
	select	max(dt_agenda) 
	into STRICT	ds_retorno_w 
	from	mprev_agendamento 
	where	ie_status_agenda <> 'C' 
	and	nr_seq_turma = nr_seq_turma_p;
 
elsif (upper(ie_opcao_p) = 'C') then 
 
	for	r_C01_w in C01 loop 
		begin 
		if (coalesce(ds_retorno_w::text, '') = '') then	 
			ds_retorno_w := r_C01_w.dt_semana;
		else 
			ds_retorno_w := (ds_retorno_w||', '||r_C01_w.dt_semana);
		end if;	
		end;
	end loop;			
	 
elsif (upper(ie_opcao_p) = 'D') then 
	--qtd atual D 
	select	count(1) 
	into STRICT	ds_retorno_w	 
	from	MPREV_GRUPO_TURMA_PARTIC 
	where	clock_timestamp() >= dt_entrada 
	and (coalesce(dt_saida::text, '') = '' or clock_timestamp() <= dt_saida) 
	and	nr_seq_turma = nr_seq_turma_p;
 
elsif (upper(ie_opcao_p) = 'E') then 
 
	select 	dt_agendamento, 
		ie_status_agenda 
	into STRICT	dt_agendamento_w, 
		ie_status_agenda_w 
	from	mprev_agendamento 
	where	nr_sequencia	= nr_seq_agendamento_p;
	 
	select	count(1) 
	into STRICT	qt_partic_w		 
	from	mprev_sel_partic_agenda 
	where	nr_seq_agendamento = nr_seq_agendamento_p;
	 
	if (qt_partic_w > 0) then 
		ds_retorno_w	:= qt_partic_w;
	else 
		--qtd prevista para o agendamento NR_SEQ_AGENDAMENTO E 
		select	count(1) 
		into STRICT	ds_retorno_w	 
		from	mprev_grupo_turma_partic 
		where	dt_agendamento_w >= dt_entrada 
		and (coalesce(dt_saida::text, '') = '' or dt_agendamento_w <= dt_saida) 
		and	nr_seq_turma = nr_seq_turma_p;
	end if;
 
elsif (upper(ie_opcao_p) = 'F') then 
	--qtd faltas no dia F 
	select	count(1) 
	into STRICT	ds_retorno_w			 
	from	MPREV_SEL_PARTIC_AGENDA 
	where (ie_selecionado = 'N' or coalesce(ie_selecionado::text, '') = '') 
	and	nr_seq_agendamento = nr_seq_agendamento_p;
	 
elsif (upper(ie_opcao_p) = 'G') then 
	for	r_C02_w in C02 loop 
		begin 
		if (coalesce(ds_retorno_w::text, '') = '') then	 
			ds_retorno_w := r_C02_w.nm_responsavel;
		else 
			ds_retorno_w := (ds_retorno_w||', '||r_C02_w.nm_responsavel );
		end if;	
		end;
		 
		if (upper(ie_restringe_tam_p) = 'S' and (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '')) then 
			if (length(ds_retorno_w) > 45) then 
				ds_retorno_w := substr(ds_retorno_w,1,45) ||'...';
			end if;
		end if;
		 
	end loop;
elsif (upper(ie_opcao_p) = 'Q') then 
	select 	count(1) 
	into STRICT	ds_retorno_w 
	from	mprev_sel_partic_agenda a 
	where 	a.nr_seq_agendamento = nr_seq_agendamento_p 
	and	coalesce(a.ie_confirmado,'N') = 'S';	
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mprev_obter_dados_agenda_turma (nr_seq_turma_p bigint, nr_seq_agendamento_p bigint, ie_opcao_p text, ie_restringe_tam_p text default 'N') FROM PUBLIC;

