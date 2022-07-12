-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_regra_bloq_in ( nr_seq_prestador_p pls_regra_cta_bloq_integ.nr_seq_prestador%type, ie_evento_p text, ie_opcao_p text, ie_conta_recurso_p pls_regra_cta_bloq_integ.ie_conta_recurso%type, nr_seq_lote_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, ie_nova_imp_xml_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type default null, ie_webservice_p text default 'N') RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Busca os dados da regra de bloqueio de integracao do portal, caso tenha alguma
valida, conforme parametros

Alteracoes
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/*	ie_opcao_p:
	DS = Mensagem da regra quando bloqueada

	ie_evento_p: dominio 3470:
	C - Complemento de Guia
	E - Importacao XML / TISS e webservice(mantido mesmo valor de parametro para as regras atuais contemplarem a mudanca para validacao webservice)
	P - Digitacao de contas pelo portal
	
	ie_conta_recurso_p:
	C = Conta medica
	R = Recurso de glosa
	A = Ambos
*/
/*
	ie_webservice_p - parametro passado com valor S quando estiver sendo chamado via webservice, nos demais casos sera passado valor N ou nao sera passado valor algum(nulo)
*/
ds_regra		pls_regra_cta_bloq_integ.ds_mensagem%type;
ie_cad_conta_medica_w	pls_controle_estab.ie_cad_conta_medica%type;
day_of_month_w		integer;
achou_regra_w		varchar(1) := 'N';
ie_conta_recurso_w	pls_regra_cta_bloq_integ.ie_conta_recurso%type;
nr_seq_regra_w		pls_regra_cta_bloq_integ.nr_sequencia%type;
nr_seq_regra_excecao_w	pls_excecao_cta_bloq_integ.nr_sequencia%type;
ie_nova_imp_xml_w	varchar(1);
ie_webservice_w		varchar(1);
nr_seq_prestador_w	pls_protocolo_conta.nr_seq_prestador%type;

-- Cursor de busca por prestador e evento
C01 CURSOR FOR
	-- O primeiro union e quando nao controla o estabelecimento
	SELECT	a.nr_sequencia,
		a.ds_mensagem,
		coalesce(a.nr_dia_bloqueio, 0) nr_dia_bloqueio,
		coalesce(ie_webservice, 'N')  ie_webservice
	from	pls_regra_cta_bloq_integ	a
	where	trunc(coalesce(a.dt_fim_vigencia,clock_timestamp()))	>= trunc(clock_timestamp())
	and	trunc(a.dt_inicio_vigencia) 		<= trunc(clock_timestamp())
	and	a.nr_seq_prestador			= nr_seq_prestador_w
	and	a.ie_evento 				= ie_evento_p
	and	ie_cad_conta_medica_w			= 'N'
	and	a.ie_conta_recurso			in (ie_conta_recurso_w, 'A')
	
union all

	-- O segundo union e quando controla o estabelecimento
	SELECT	a.nr_sequencia,
		a.ds_mensagem,
		coalesce(a.nr_dia_bloqueio, 0) nr_dia_bloqueio,
		coalesce(ie_webservice, 'N') ie_webservice
	from	pls_regra_cta_bloq_integ	a
	where	trunc(coalesce(a.dt_fim_vigencia,clock_timestamp()))	>= trunc(clock_timestamp())
	and	trunc(a.dt_inicio_vigencia) 		<= trunc(clock_timestamp())
	and	a.nr_seq_prestador			= nr_seq_prestador_w
	and	a.ie_evento 				= ie_evento_p
	and	a.ie_conta_recurso			in (ie_conta_recurso_w, 'A')
	and	ie_cad_conta_medica_w			= 'S'
	and	a.cd_estabelecimento			= cd_estabelecimento_p;

--Cursor de busca por prestador
C02 CURSOR FOR	
	SELECT	a.nr_sequencia,
		a.ds_mensagem,
		coalesce(a.nr_dia_bloqueio, 0) nr_dia_bloqueio,
		coalesce(ie_webservice, 'N') ie_webservice
	from	pls_regra_cta_bloq_integ	a
	where	trunc(coalesce(a.dt_fim_vigencia,clock_timestamp()))	>= trunc(clock_timestamp())
	and	trunc(a.dt_inicio_vigencia) 		<= trunc(clock_timestamp())
	and	a.nr_seq_prestador 			= nr_seq_prestador_w
	and	coalesce(a.ie_evento::text, '') = ''
	and	ie_cad_conta_medica_w			= 'N'
	and	a.ie_conta_recurso			in (ie_conta_recurso_w, 'A')
	
union all

	SELECT	a.nr_sequencia,
		a.ds_mensagem,
		coalesce(a.nr_dia_bloqueio, 0) nr_dia_bloqueio,
		coalesce(ie_webservice, 'N') ie_webservice
	from	pls_regra_cta_bloq_integ	a
	where	trunc(coalesce(a.dt_fim_vigencia,clock_timestamp()))	>= trunc(clock_timestamp())
	and	trunc(a.dt_inicio_vigencia) 		<= trunc(clock_timestamp())
	and	a.nr_seq_prestador 			= nr_seq_prestador_w
	and	coalesce(a.ie_evento::text, '') = ''
	and	a.ie_conta_recurso			in (ie_conta_recurso_w, 'A')
	and	ie_cad_conta_medica_w			= 'S'
	and	a.cd_estabelecimento			= cd_estabelecimento_p;

--Cursor de busca por tipo de prestador e evento
C03 CURSOR FOR	
	SELECT	a.nr_sequencia,
		a.ds_mensagem,
		coalesce(a.nr_dia_bloqueio, 0) nr_dia_bloqueio,
		coalesce(ie_webservice, 'N') ie_webservice
	from	pls_regra_cta_bloq_integ	a
	where	((a.nr_dia_bloqueio < extract(day from clock_timestamp())) and (coalesce(a.nr_dia_bloqueio,0) > 0))
	and	trunc(coalesce(a.dt_fim_vigencia,clock_timestamp()))	>= trunc(clock_timestamp())
	and	trunc(a.dt_inicio_vigencia) 		<= trunc(clock_timestamp())
	and	a.nr_seq_tipo_prestador = (SELECT x.nr_seq_tipo_prestador from pls_prestador x where x.nr_sequencia = nr_seq_prestador_w)
	and	a.ie_evento = ie_evento_p
	and	ie_cad_conta_medica_w			= 'N'
	and	a.ie_conta_recurso			in (ie_conta_recurso_w, 'A')
	
union all

	select	a.nr_sequencia,
		a.ds_mensagem,
		coalesce(a.nr_dia_bloqueio, 0) nr_dia_bloqueio,
		coalesce(ie_webservice, 'N') ie_webservice
	from	pls_regra_cta_bloq_integ	a
	where	((a.nr_dia_bloqueio < extract(day from clock_timestamp())) and (coalesce(a.nr_dia_bloqueio,0) > 0))
	and	trunc(coalesce(a.dt_fim_vigencia,clock_timestamp()))	>= trunc(clock_timestamp())
	and	trunc(a.dt_inicio_vigencia) 		<= trunc(clock_timestamp())
	and	a.nr_seq_tipo_prestador = (select x.nr_seq_tipo_prestador from pls_prestador x where x.nr_sequencia = nr_seq_prestador_w)
	and	a.ie_evento = ie_evento_p
	and	a.ie_conta_recurso			in (ie_conta_recurso_w, 'A')
	and	ie_cad_conta_medica_w			= 'S'
	and	a.cd_estabelecimento			= cd_estabelecimento_p;

--Cursor por tipo de prestador
C04 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.ds_mensagem,
		coalesce(a.nr_dia_bloqueio, 0) nr_dia_bloqueio,
		coalesce(ie_webservice, 'N') ie_webservice
	from	pls_regra_cta_bloq_integ	a
	where	((a.nr_dia_bloqueio < extract(day from clock_timestamp())) and (coalesce(a.nr_dia_bloqueio,0) > 0))
	and	trunc(coalesce(a.dt_fim_vigencia,clock_timestamp()))	>= trunc(clock_timestamp())
	and	trunc(a.dt_inicio_vigencia) 		<= trunc(clock_timestamp())
	and	a.nr_seq_tipo_prestador = (SELECT x.nr_seq_tipo_prestador from pls_prestador x where x.nr_sequencia = nr_seq_prestador_w)
	and	coalesce(a.ie_evento::text, '') = ''
	and	ie_cad_conta_medica_w			= 'N'
	and	a.ie_conta_recurso			in (ie_conta_recurso_w, 'A')
	
union all

	select	a.nr_sequencia,
		a.ds_mensagem,
		coalesce(a.nr_dia_bloqueio, 0) nr_dia_bloqueio,
		coalesce(ie_webservice, 'N') ie_webservice
	from	pls_regra_cta_bloq_integ	a
	where	((a.nr_dia_bloqueio < extract(day from clock_timestamp())) and (coalesce(a.nr_dia_bloqueio,0) > 0))
	and	trunc(coalesce(a.dt_fim_vigencia,clock_timestamp()))	>= trunc(clock_timestamp())
	and	trunc(a.dt_inicio_vigencia) 		<= trunc(clock_timestamp())
	and	a.nr_seq_tipo_prestador = (select x.nr_seq_tipo_prestador from pls_prestador x where x.nr_sequencia = nr_seq_prestador_w)
	and	coalesce(a.ie_evento::text, '') = ''
	and	a.ie_conta_recurso			in (ie_conta_recurso_w, 'A')
	and	ie_cad_conta_medica_w			= 'S'
	and	a.cd_estabelecimento			= cd_estabelecimento_p;

--Cursor por evento
C05 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.ds_mensagem,
		coalesce(a.nr_dia_bloqueio, 0) nr_dia_bloqueio,
		coalesce(ie_webservice, 'N') ie_webservice
	from	pls_regra_cta_bloq_integ	a
	where	((a.nr_dia_bloqueio < extract(day from clock_timestamp())) and (coalesce(a.nr_dia_bloqueio,0) > 0))
	and	trunc(coalesce(a.dt_fim_vigencia,clock_timestamp()))	>= trunc(clock_timestamp())
	and	trunc(a.dt_inicio_vigencia) 		<= trunc(clock_timestamp())
	and	a.ie_evento = ie_evento_p
	and	coalesce(a.nr_seq_tipo_prestador::text, '') = ''
	and	coalesce(a.nr_seq_prestador::text, '') = ''
	and	ie_cad_conta_medica_w			= 'N'
	and	a.ie_conta_recurso			in (ie_conta_recurso_w, 'A')
	
union all

	SELECT	a.nr_sequencia,
		a.ds_mensagem,
		coalesce(a.nr_dia_bloqueio, 0) nr_dia_bloqueio,
		coalesce(ie_webservice, 'N') ie_webservice
	from	pls_regra_cta_bloq_integ	a
	where	((a.nr_dia_bloqueio < extract(day from clock_timestamp())) and (coalesce(a.nr_dia_bloqueio,0) > 0))
	and	trunc(coalesce(a.dt_fim_vigencia,clock_timestamp()))	>= trunc(clock_timestamp())
	and	trunc(a.dt_inicio_vigencia) 		<= trunc(clock_timestamp())
	and	a.ie_evento = ie_evento_p
	and	coalesce(a.nr_seq_tipo_prestador::text, '') = ''
	and	coalesce(a.nr_seq_prestador::text, '') = ''
	and	a.ie_conta_recurso			in (ie_conta_recurso_w, 'A')
	and	ie_cad_conta_medica_w			= 'S'
	and	a.cd_estabelecimento			= cd_estabelecimento_p;

--Cursor geral
C06 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.ds_mensagem,
		coalesce(a.nr_dia_bloqueio, 0) nr_dia_bloqueio,
		coalesce(ie_webservice, 'N') ie_webservice
	from	pls_regra_cta_bloq_integ	a
	where	((a.nr_dia_bloqueio < extract(day from clock_timestamp())) and (coalesce(a.nr_dia_bloqueio,0) > 0))
	and	trunc(coalesce(a.dt_fim_vigencia,clock_timestamp()))	>= trunc(clock_timestamp())
	and	trunc(a.dt_inicio_vigencia) 		<= trunc(clock_timestamp())
	and	coalesce(a.ie_evento::text, '') = ''
	and	coalesce(a.nr_seq_prestador::text, '') = ''
	and	coalesce(a.nr_seq_tipo_prestador::text, '') = ''
	and	ie_cad_conta_medica_w			= 'N'
	and	a.ie_conta_recurso			in (ie_conta_recurso_w, 'A')
	
union all

	SELECT	a.nr_sequencia,
		a.ds_mensagem,
		coalesce(a.nr_dia_bloqueio, 0) nr_dia_bloqueio,
		coalesce(ie_webservice, 'N') ie_webservice
	from	pls_regra_cta_bloq_integ	a
	where	((a.nr_dia_bloqueio < extract(day from clock_timestamp())) and (coalesce(a.nr_dia_bloqueio,0) > 0))
	and	trunc(coalesce(a.dt_fim_vigencia,clock_timestamp()))	>= trunc(clock_timestamp())
	and	trunc(a.dt_inicio_vigencia) 		<= trunc(clock_timestamp())
	and	coalesce(a.ie_evento::text, '') = ''
	and	coalesce(a.nr_seq_prestador::text, '') = ''
	and	coalesce(a.nr_seq_tipo_prestador::text, '') = ''
	and	a.ie_conta_recurso			in (ie_conta_recurso_w, 'A')
	and	ie_cad_conta_medica_w			= 'S'
	and	a.cd_estabelecimento			= cd_estabelecimento_p;
BEGIN
--tratado com variavel pois mesmo que o parametro seja default N, se for EXPLICITAMENTE passado valor nulo, ele nao sobrescreve com N
if (ie_webservice_p IS NOT NULL AND ie_webservice_p::text <> '') then
	ie_webservice_w := ie_webservice_p;
else
	ie_webservice_w := 'N';
end if;

if (ie_webservice_w = 'S') Then
	select nr_seq_prestador_imp_ref
	into STRICT nr_seq_prestador_w
	from pls_protocolo_conta
	where nr_sequencia = nr_seq_protocolo_p;
else
  nr_seq_prestador_w := nr_seq_prestador_p;
end if;

select 	extract(day from clock_timestamp())
into STRICT	day_of_month_w
;

ie_conta_recurso_w := coalesce(ie_conta_recurso_p, 'C');
ie_nova_imp_xml_w := substr(coalesce(ie_nova_imp_xml_p, 'N'),1,1);

-- DS Mensagem da Regra
if (ie_opcao_p = 'DS') then
	ds_regra := null;

	if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then
		ie_cad_conta_medica_w := pls_obter_se_controle_estab('CM');
	else

		ie_cad_conta_medica_w := 'N';
	end if;

	-- Busca por prestador e evento
	for r_c01_w in C01 loop

		if ( ie_webservice_w = 'N' or (ie_webservice_w = 'S' and  r_c01_w.ie_webservice = 'S')) then
			--Se entrar aqui, quer dizer que a regra ja e valida, porem verificara ainda se o dia de inicio da mesma e valido
			achou_regra_w := 'S';
			if (r_c01_w.nr_dia_bloqueio < day_of_month_w and r_c01_w.nr_dia_bloqueio > 0 ) then
				ds_regra := r_c01_w.ds_mensagem;
			end if;
									
			-- se possui mensagem, entao a regra e valida, guarda a regra selecionada para usar na excecao
			if (ds_regra IS NOT NULL AND ds_regra::text <> '') then
			
				nr_seq_regra_w := r_c01_w.nr_sequencia;
			end if;
		end if;
					
	end loop;

	-- Busca por prestador
	if (coalesce(ds_regra::text, '') = '' and achou_regra_w = 'N') then
		for r_c02_w in C02 loop
			
			if ( ie_webservice_w = 'N' or (ie_webservice_w = 'S' and  r_c02_w.ie_webservice = 'S')) then
				--Se entrar aqui, quer dizer que a regra ja e valida, porem verificara ainda se o dia de inicio da mesma e valido
				achou_regra_w := 'S';
				if (r_c02_w.nr_dia_bloqueio < day_of_month_w and r_c02_w.nr_dia_bloqueio > 0 ) then
					ds_regra := r_c02_w.ds_mensagem;
				end if;
				
				-- se possui mensagem, entao a regra e valida, guarda a regra selecionada para usar na excecao
				if (ds_regra IS NOT NULL AND ds_regra::text <> '') then
				
					nr_seq_regra_w := r_c02_w.nr_sequencia;
				end if;
			end if;

		end loop;
	end if;

	-- Busca por tipo de prestador e evento
	if (coalesce(ds_regra::text, '') = '' and achou_regra_w = 'N') then
		for r_c03_w in C03 loop

			if ( ie_webservice_w = 'N' or (ie_webservice_w = 'S' and  r_c03_w.ie_webservice = 'S'))then
				--Se entrar aqui, quer dizer que a regra ja e valida, porem verificara ainda se o dia de inicio da mesma e valido
				achou_regra_w := 'S';
				if (r_c03_w.nr_dia_bloqueio < day_of_month_w and r_c03_w.nr_dia_bloqueio > 0 ) then
					ds_regra := r_c03_w.ds_mensagem;

					end if;
				-- se possui mensagem, entao a regra e valida, guarda a regra selecionada para usar na excecao
				if (ds_regra IS NOT NULL AND ds_regra::text <> '') then
				
					nr_seq_regra_w := r_c03_w.nr_sequencia;
				end if;
			end if;

		end loop;
	end if;

	-- Busca por tipo de prestador
	if (coalesce(ds_regra::text, '') = '' and achou_regra_w = 'N') then
		for r_c04_w in C04 loop

			if ( ie_webservice_w = 'N' or (ie_webservice_w = 'S' and  r_c04_w.ie_webservice = 'S')) then
				--Se entrar aqui, quer dizer que a regra ja e valida, porem verificara ainda se o dia de inicio da mesma e valido
				achou_regra_w := 'S';
				if (r_c04_w.nr_dia_bloqueio < day_of_month_w and r_c04_w.nr_dia_bloqueio > 0 ) then
					ds_regra := r_c04_w.ds_mensagem;
				end if;
				
				-- se possui mensagem, entao a regra e valida, guarda a regra selecionada para usar na excecao
				if (ds_regra IS NOT NULL AND ds_regra::text <> '') then
				
					nr_seq_regra_w := r_c04_w.nr_sequencia;
				end if;
			end if;

		end loop;
	end if;

	-- Busca por evento
	if (coalesce(ds_regra::text, '') = '' and achou_regra_w = 'N') then
		for r_c05_w in C05 loop

			if ( ie_webservice_w = 'N' or (ie_webservice_w = 'S' and  r_c05_w.ie_webservice = 'S')) then
				--Se entrar aqui, quer dizer que a regra ja e valida, porem verificara ainda se o dia de inicio da mesma e valido
				achou_regra_w := 'S';
				if (r_c05_w.nr_dia_bloqueio < day_of_month_w and r_c05_w.nr_dia_bloqueio > 0 ) then
					ds_regra := r_c05_w.ds_mensagem;
				end if;
				
				-- se possui mensagem, entao a regra e valida, guarda a regra selecionada para usar na excecao
				if (ds_regra IS NOT NULL AND ds_regra::text <> '') then
				
					nr_seq_regra_w := r_c05_w.nr_sequencia;
				end if;
			end if;

		end loop;
	end if;

	-- Busca "geral"
	if (coalesce(ds_regra::text, '') = '' and achou_regra_w = 'N') then
		for r_c06_w in C06 loop

			if ( ie_webservice_w = 'N' or (ie_webservice_w = 'S' and  r_c06_w.ie_webservice = 'S')) then
				--Se entrar aqui, quer dizer que a regra ja e valida, porem verificara ainda se o dia de inicio da mesma e valido
				achou_regra_w := 'S';
				if (r_c06_w.nr_dia_bloqueio < day_of_month_w and r_c06_w.nr_dia_bloqueio > 0 ) then
					ds_regra := r_c06_w.ds_mensagem;
				end if;
				
				-- se possui mensagem, entao a regra e valida, guarda a regra selecionada para usar na excecao
				if (ds_regra IS NOT NULL AND ds_regra::text <> '') then
				
					nr_seq_regra_w := r_c06_w.nr_sequencia;
				end if;
			end if;

		end loop;
	end if;
	
	
	-- se teve regra, valida a excecao
	if (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') then
	
		nr_seq_regra_excecao_w := pls_possui_exce_regra_bloq_in(nr_seq_regra_w,
									nr_seq_lote_p,
									nr_seq_protocolo_p,
									nr_seq_prestador_w,
									ie_conta_recurso_p,
									ie_nova_imp_xml_w);
	else
	
		nr_seq_regra_excecao_w := null;
	end if;
	
	-- se teve uma excecao valida, entao deve retornar null na rotina
	if (nr_seq_regra_excecao_w IS NOT NULL AND nr_seq_regra_excecao_w::text <> '') then
	
		ds_regra := null;
	end if;

	return ds_regra;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_regra_bloq_in ( nr_seq_prestador_p pls_regra_cta_bloq_integ.nr_seq_prestador%type, ie_evento_p text, ie_opcao_p text, ie_conta_recurso_p pls_regra_cta_bloq_integ.ie_conta_recurso%type, nr_seq_lote_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, ie_nova_imp_xml_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type default null, ie_webservice_p text default 'N') FROM PUBLIC;
