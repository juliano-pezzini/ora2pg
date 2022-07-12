-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_qt_incid_estrutura ( nr_seq_estrutura_p pls_ocorrencia_estrutura.nr_sequencia%type, nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, nr_seq_execucao_p pls_execucao_requisicao.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proced_p procedimento.ie_origem_proced%type, nr_seq_material_p pls_material.nr_sequencia%type, qt_solicitada_p bigint, qt_liberada_p bigint, dt_ref_inicial_p timestamp, dt_ref_final_p timestamp, ie_tipo_incidencia_p text, ie_somar_estrutura_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:Validar a incidencia  de itens da estrutura na Validacao de estrutura de itens.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
				
ie_retorno_w			varchar(1) 	:= 'N';
qt_solicitado_w			pls_guia_plano_mat.qt_autorizada%type	:= 0;


BEGIN

if (coalesce(nr_seq_guia_p,0) > 0) then	
	if (ie_somar_estrutura_p = 'S') then
		if (ie_tipo_incidencia_p = 'G') then								
			select	sum(qt_itens)
			into STRICT	qt_solicitado_w
			from ( 	SELECT 	coalesce(sum(a.qt_solicitada),0) qt_itens
					from	pls_guia_plano		b,
						pls_guia_plano_proc	a
					where	a.nr_seq_guia		= b.nr_sequencia
					and	b.nr_seq_segurado	= nr_seq_segurado_p
					and	b.nr_sequencia		= nr_seq_guia_p			
					and	b.cd_estabelecimento	= cd_estabelecimento_p				
					and (pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_p, a.cd_procedimento, a.ie_origem_proced, null) = 'S')
					
union 	all
 
					PERFORM 	coalesce(sum(a.qt_solicitada),0) qt_itens
					from	pls_guia_plano		b,
						pls_guia_plano_mat	a
					where	a.nr_seq_guia		= b.nr_sequencia
					and	b.nr_seq_segurado	= nr_seq_segurado_p
					and	b.nr_sequencia		= nr_seq_guia_p
					and	b.cd_estabelecimento	= cd_estabelecimento_p
					and (pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_p, null, null, a.nr_seq_material) = 'S') ) alias13;					
		elsif (ie_tipo_incidencia_p = 'H') then
			select	sum(qt_itens)
			into STRICT	qt_solicitado_w
			from (	SELECT 	coalesce(sum(a.qt_autorizada),0) qt_itens
					from	pls_guia_plano		b,
						pls_guia_plano_proc	a
					where	a.nr_seq_guia		= b.nr_sequencia
					and	b.nr_seq_segurado	= nr_seq_segurado_p
					and	b.nr_sequencia		<> nr_seq_guia_p
					and	b.cd_estabelecimento	= cd_estabelecimento_p
					and	b.ie_status		<> '3'
					and (pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_p, a.cd_procedimento, a.ie_origem_proced, null) = 'S')
					and	a.dt_liberacao		between dt_ref_inicial_p and dt_ref_final_p
					
union 	all

					PERFORM	coalesce(sum(a.qt_autorizada),0) qt_itens
					from	pls_guia_plano		b,
						pls_guia_plano_mat	a
					where	a.nr_seq_guia		= b.nr_sequencia
					and	b.nr_seq_segurado	= nr_seq_segurado_p
					and	b.nr_sequencia		<> nr_seq_guia_p
					and	b.cd_estabelecimento	= cd_estabelecimento_p
					and	b.ie_status 		<> '3'
					and (pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_p, null, null, a.nr_seq_material) = 'S')
					and	a.dt_liberacao		between dt_ref_inicial_p and dt_ref_final_p ) alias10;
		else
			select	sum(qt_itens)
			into STRICT	qt_solicitado_w
			from (	SELECT 	coalesce(sum(a.qt_autorizada),0) qt_itens
					from	pls_guia_plano		b,
						pls_guia_plano_proc	a
					where	a.nr_seq_guia		= b.nr_sequencia
					and	b.nr_seq_segurado	= nr_seq_segurado_p
					and	b.nr_sequencia		<> nr_seq_guia_p
					and	b.cd_estabelecimento	= cd_estabelecimento_p
					and	b.ie_status		<> '3'
					and (pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_p, a.cd_procedimento, a.ie_origem_proced, null) = 'S')
					and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(a.dt_liberacao) 	between ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_ref_inicial_p) and 
                                                                                ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_ref_final_p)
					
union 	all

					PERFORM	coalesce(sum(a.qt_autorizada),0) qt_itens
					from	pls_guia_plano		b,
						pls_guia_plano_mat	a
					where	a.nr_seq_guia		= b.nr_sequencia
					and	b.nr_seq_segurado	= nr_seq_segurado_p
					and	b.nr_sequencia		<> nr_seq_guia_p
					and	b.cd_estabelecimento	= cd_estabelecimento_p
					and	b.ie_status 		<> '3'
					and (pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_p, null, null, a.nr_seq_material) = 'S')
					and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(a.dt_liberacao)	between ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_ref_inicial_p) and 
                                                                              ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_ref_final_p) ) alias15;
		end if;
	elsif (ie_somar_estrutura_p = 'N') then
		if (coalesce(cd_procedimento_p,0) > 0) then
			if (ie_tipo_incidencia_p = 'G') then
				select 	coalesce(sum(a.qt_solicitada),0)
				into STRICT	qt_solicitado_w
				from	pls_guia_plano		b,
					pls_guia_plano_proc	a
				where	a.nr_seq_guia		= b.nr_sequencia
				and	b.nr_seq_segurado	= nr_seq_segurado_p
				and	b.nr_sequencia		= nr_seq_guia_p			
				and	b.cd_estabelecimento	= cd_estabelecimento_p
				and	a.cd_procedimento	= cd_procedimento_p		
				and	a.ie_origem_proced	= ie_origem_proced_p;
			elsif (ie_tipo_incidencia_p = 'H') then
				select 	coalesce(sum(a.qt_autorizada),0)
				into STRICT	qt_solicitado_w
				from	pls_guia_plano		b,
					pls_guia_plano_proc	a
				where	a.nr_seq_guia		= b.nr_sequencia
				and	b.nr_seq_segurado	= nr_seq_segurado_p
				and	b.nr_sequencia		<> nr_seq_guia_p
				and	b.cd_estabelecimento	= cd_estabelecimento_p
				and	b.ie_status		<> '3'
				and	a.cd_procedimento	= cd_procedimento_p		
				and	a.ie_origem_proced	= ie_origem_proced_p
				and	a.dt_liberacao		between dt_ref_inicial_p and dt_ref_final_p;
			else
				select 	coalesce(sum(a.qt_autorizada),0)
				into STRICT	qt_solicitado_w
				from	pls_guia_plano		b,
					pls_guia_plano_proc	a
				where	a.nr_seq_guia		= b.nr_sequencia
				and	b.nr_seq_segurado	= nr_seq_segurado_p
				and	b.nr_sequencia		<> nr_seq_guia_p
				and	b.cd_estabelecimento	= cd_estabelecimento_p
				and	b.ie_status		<> '3'
				and	a.cd_procedimento	= cd_procedimento_p		
				and	a.ie_origem_proced	= ie_origem_proced_p
				and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(a.dt_liberacao) between ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_ref_inicial_p) and
                                                                            ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_ref_final_p);
			end if;
		elsif (coalesce(nr_seq_material_p,0) > 0) then		
			if (ie_tipo_incidencia_p = 'G') then
				select 	coalesce(sum(a.qt_solicitada),0)
				into STRICT	qt_solicitado_w
				from	pls_guia_plano		b,
					pls_guia_plano_mat	a
				where	a.nr_seq_guia		= b.nr_sequencia
				and	b.nr_seq_segurado	= nr_seq_segurado_p
				and	b.nr_sequencia		= nr_seq_guia_p
				and	b.cd_estabelecimento	= cd_estabelecimento_p
				and	a.nr_seq_material	= nr_seq_material_p;
			elsif (ie_tipo_incidencia_p = 'H') then
				select	coalesce(sum(a.qt_autorizada),0)
				into STRICT	qt_solicitado_w
				from	pls_guia_plano		b,
					pls_guia_plano_mat	a
				where	a.nr_seq_guia		= b.nr_sequencia
				and	b.nr_seq_segurado	= nr_seq_segurado_p
				and	b.nr_sequencia		<> nr_seq_guia_p
				and	b.cd_estabelecimento	= cd_estabelecimento_p
				and	b.ie_status 		<> '3'
				and	a.nr_seq_material	= nr_seq_material_p
				and	a.dt_liberacao		between dt_ref_inicial_p and dt_ref_final_p;
			else
				select	coalesce(sum(a.qt_autorizada),0)
				into STRICT	qt_solicitado_w
				from	pls_guia_plano		b,
					pls_guia_plano_mat	a
				where	a.nr_seq_guia		= b.nr_sequencia
				and	b.nr_seq_segurado	= nr_seq_segurado_p
				and	b.nr_sequencia		<> nr_seq_guia_p
				and	b.cd_estabelecimento	= cd_estabelecimento_p
				and	b.ie_status 		<> '3'
				and	a.nr_seq_material	= nr_seq_material_p
				and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(a.dt_liberacao) between dt_ref_inicial_p and dt_ref_final_p;
			end if;
		end if;
	end if;
elsif (coalesce(nr_seq_requisicao_p,0) > 0) then
	if (ie_somar_estrutura_p = 'S') then
		if (ie_tipo_incidencia_p = 'G') then
			select	sum(qt_itens)
			into STRICT	qt_solicitado_w
			from (	SELECT 	coalesce(sum(a.qt_solicitado),0) qt_itens
					from	pls_requisicao		b,
						pls_requisicao_proc	a
					where	a.nr_seq_requisicao	= b.nr_sequencia
					and	b.nr_seq_segurado	= nr_seq_segurado_p
					and	b.nr_sequencia		= nr_seq_requisicao_p
					and	b.cd_estabelecimento	= cd_estabelecimento_p
					and (pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_p, a.cd_procedimento, a.ie_origem_proced, null) = 'S')
					
union	all

					PERFORM 	coalesce(sum(a.qt_solicitado),0) qt_itens
					from	pls_requisicao		b,
						pls_requisicao_mat	a
					where	a.nr_seq_requisicao	= b.nr_sequencia
					and	b.nr_seq_segurado	= nr_seq_segurado_p
					and	b.nr_sequencia		= nr_seq_requisicao_p
					and	b.cd_estabelecimento	= cd_estabelecimento_p
					and (pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_p, null, null, a.nr_seq_material) = 'S') ) alias13;						
		elsif (ie_tipo_incidencia_p = 'H') then
			select	sum(qt_itens)
			into STRICT	qt_solicitado_w
			from (	SELECT 	coalesce(sum(a.qt_procedimento),0) qt_itens
					from	pls_requisicao		b,
						pls_requisicao_proc	a
					where	a.nr_seq_requisicao	= b.nr_sequencia
					and	b.nr_seq_segurado	= nr_seq_segurado_p
					and	b.nr_sequencia		<> nr_seq_requisicao_p
					and	b.cd_estabelecimento	= cd_estabelecimento_p
					and	b.ie_estagio		= 2
					and (pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_p, a.cd_procedimento, a.ie_origem_proced, null) = 'S')
					and	b.dt_requisicao		between dt_ref_inicial_p and dt_ref_final_p
					
union	all

					PERFORM 	coalesce(sum(a.qt_material),0) qt_itens
					from	pls_requisicao		b,
						pls_requisicao_mat	a
					where	a.nr_seq_requisicao	= b.nr_sequencia
					and	b.nr_seq_segurado	= nr_seq_segurado_p
					and	b.nr_sequencia		<> nr_seq_requisicao_p
					and	b.cd_estabelecimento	= cd_estabelecimento_p
					and	b.ie_estagio		= 2
					and (pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_p, null, null, a.nr_seq_material) = 'S')
					and	b.dt_requisicao		between dt_ref_inicial_p and dt_ref_final_p) alias10;
		else
			select	sum(qt_itens)
			into STRICT	qt_solicitado_w
			from (	SELECT 	coalesce(sum(a.qt_procedimento),0) qt_itens
					from	pls_requisicao		b,
						pls_requisicao_proc	a
					where	a.nr_seq_requisicao	= b.nr_sequencia
					and	b.nr_seq_segurado	= nr_seq_segurado_p
					and	b.nr_sequencia		<> nr_seq_requisicao_p
					and	b.cd_estabelecimento	= cd_estabelecimento_p
					and	b.ie_estagio		= 2
					and (pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_p, a.cd_procedimento, a.ie_origem_proced, null) = 'S')
					and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(b.dt_requisicao)	between dt_ref_inicial_p and dt_ref_final_p
					
union 	all

					PERFORM 	coalesce(sum(a.qt_material),0) qt_itens
					from	pls_requisicao		b,
						pls_requisicao_mat	a
					where	a.nr_seq_requisicao	= b.nr_sequencia
					and	b.nr_seq_segurado	= nr_seq_segurado_p
					and	b.nr_sequencia		<> nr_seq_requisicao_p
					and	b.cd_estabelecimento	= cd_estabelecimento_p
					and	b.ie_estagio		= 2
					and (pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_p, null, null, a.nr_seq_material) = 'S')
					and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(b.dt_requisicao) between dt_ref_inicial_p and dt_ref_final_p) alias11;
		end if;
	elsif (ie_somar_estrutura_p = 'N') then
		if (coalesce(cd_procedimento_p,0) > 0) then
			if (ie_tipo_incidencia_p = 'G') then
				select 	coalesce(sum(a.qt_solicitado),0)
				into STRICT	qt_solicitado_w
				from	pls_requisicao		b,
					pls_requisicao_proc	a
				where	a.nr_seq_requisicao	= b.nr_sequencia
				and	b.nr_seq_segurado	= nr_seq_segurado_p
				and	b.nr_sequencia		= nr_seq_requisicao_p
				and	b.cd_estabelecimento	= cd_estabelecimento_p
				and	a.cd_procedimento	= cd_procedimento_p		
				and	a.ie_origem_proced	= ie_origem_proced_p;			
			elsif (ie_tipo_incidencia_p = 'H') then
				select 	coalesce(sum(a.qt_procedimento),0)
				into STRICT	qt_solicitado_w
				from	pls_requisicao		b,
					pls_requisicao_proc	a
				where	a.nr_seq_requisicao	= b.nr_sequencia
				and	b.nr_seq_segurado	= nr_seq_segurado_p
				and	b.nr_sequencia		<> nr_seq_requisicao_p
				and	b.cd_estabelecimento	= cd_estabelecimento_p
				and	b.ie_estagio		= 2
				and	a.cd_procedimento	= cd_procedimento_p		
				and	a.ie_origem_proced	= ie_origem_proced_p
				and	b.dt_requisicao		between dt_ref_inicial_p and dt_ref_final_p;
			else
				select 	coalesce(sum(a.qt_procedimento),0)
				into STRICT	qt_solicitado_w
				from	pls_requisicao		b,
					pls_requisicao_proc	a
				where	a.nr_seq_requisicao	= b.nr_sequencia
				and	b.nr_seq_segurado	= nr_seq_segurado_p
				and	b.nr_sequencia		<> nr_seq_requisicao_p
				and	b.cd_estabelecimento	= cd_estabelecimento_p
				and	b.ie_estagio		= 2
				and	a.cd_procedimento	= cd_procedimento_p		
				and	a.ie_origem_proced	= ie_origem_proced_p
				and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(b.dt_requisicao)	between dt_ref_inicial_p and dt_ref_final_p;
			end if;			
		elsif (coalesce(nr_seq_material_p,0) > 0) then
			if (ie_tipo_incidencia_p = 'G') then
				select 	coalesce(sum(a.qt_solicitado),0)
				into STRICT	qt_solicitado_w
				from	pls_requisicao		b,
					pls_requisicao_mat	a
				where	a.nr_seq_requisicao	= b.nr_sequencia
				and	b.nr_seq_segurado	= nr_seq_segurado_p
				and	b.nr_sequencia		= nr_seq_requisicao_p
				and	b.cd_estabelecimento	= cd_estabelecimento_p
				and	a.nr_seq_material	= nr_seq_material_p;

			elsif (ie_tipo_incidencia_p = 'H') then
				select 	coalesce(sum(a.qt_material),0)
				into STRICT	qt_solicitado_w
				from	pls_requisicao		b,
					pls_requisicao_mat	a
				where	a.nr_seq_requisicao	= b.nr_sequencia
				and	b.nr_seq_segurado	= nr_seq_segurado_p
				and	b.nr_sequencia		<> nr_seq_requisicao_p
				and	b.cd_estabelecimento	= cd_estabelecimento_p
				and	b.ie_estagio		= 2
				and	a.nr_seq_material	= nr_seq_material_p
				and	b.dt_requisicao		between dt_ref_inicial_p and dt_ref_final_p;
			else
				select 	coalesce(sum(a.qt_material),0)
				into STRICT	qt_solicitado_w
				from	pls_requisicao		b,
					pls_requisicao_mat	a
				where	a.nr_seq_requisicao	= b.nr_sequencia
				and	b.nr_seq_segurado	= nr_seq_segurado_p
				and	b.nr_sequencia		<> nr_seq_requisicao_p
				and	b.cd_estabelecimento	= cd_estabelecimento_p
				and	b.ie_estagio		= 2
				and	a.nr_seq_material	= nr_seq_material_p
				and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(b.dt_requisicao) between dt_ref_inicial_p and dt_ref_final_p;
			end if;
		end if;
	end if;
elsif (coalesce(nr_seq_execucao_p,0) > 0) then	
	if (ie_somar_estrutura_p = 'S') then
		if (ie_tipo_incidencia_p = 'G') then
			select	sum(qt_itens)
			into STRICT	qt_solicitado_w
			from (	SELECT 	coalesce(sum(a.qt_item),0) qt_itens
					from	pls_requisicao 		c,
						pls_execucao_requisicao	b,
						pls_execucao_req_item	a
					where	a.nr_seq_execucao	= b.nr_sequencia
					and	b.nr_seq_requisicao	= c.nr_sequencia
					and	a.nr_seq_segurado	= nr_seq_segurado_p
					and	a.ie_situacao		not in ('C','G','N','U')
					and (pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_p, a.cd_procedimento, a.ie_origem_proced, null) = 'S')
					and	b.dt_execucao		between dt_ref_inicial_p and dt_ref_final_p
					
union	all

					PERFORM 	coalesce(sum(a.qt_item),0) qt_itens
					from	pls_requisicao 		c,
						pls_execucao_requisicao	b,
						pls_execucao_req_item	a
					where	a.nr_seq_execucao	= b.nr_sequencia
					and	b.nr_seq_requisicao	= c.nr_sequencia
					and	a.nr_seq_segurado	= nr_seq_segurado_p
					and	a.ie_situacao		not in ('C','G','N','U')
					and (pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_p, null, null, a.nr_seq_material) = 'S')
					and	b.dt_execucao		between dt_ref_inicial_p and dt_ref_final_p) alias15;
		elsif (ie_tipo_incidencia_p = 'H') then
			select	sum(qt_itens)
			into STRICT	qt_solicitado_w
			from (	SELECT 	coalesce(sum(a.qt_item),0) qt_itens
					from	pls_requisicao 		c,
						pls_execucao_requisicao	b,
						pls_execucao_req_item	a
					where	a.nr_seq_execucao	= b.nr_sequencia
					and	b.nr_seq_requisicao	= c.nr_sequencia
					and	a.nr_seq_segurado	= nr_seq_segurado_p
					and	b.nr_sequencia		<> nr_seq_execucao_p
					and	a.ie_situacao		not in ('C','G','N','U')
					and (pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_p, a.cd_procedimento, a.ie_origem_proced, null) = 'S')
					and	b.dt_execucao		between dt_ref_inicial_p and dt_ref_final_p
					
union	all

					PERFORM 	coalesce(sum(a.qt_item),0) qt_itens
					from	pls_requisicao 		c,
						pls_execucao_requisicao	b,
						pls_execucao_req_item	a
					where	a.nr_seq_execucao	= b.nr_sequencia
					and	b.nr_seq_requisicao	= c.nr_sequencia
					and	a.nr_seq_segurado	= nr_seq_segurado_p
					and	b.nr_sequencia		<> nr_seq_execucao_p
					and	a.ie_situacao		not in ('C','G','N','U')
					and (pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_p, null, null, a.nr_seq_material) = 'S')
					and	b.dt_execucao		between dt_ref_inicial_p and dt_ref_final_p) alias12;
		else
			select	sum(qt_itens)
			into STRICT	qt_solicitado_w
			from ( 	SELECT 	coalesce(sum(a.qt_item),0) qt_itens
					from	pls_requisicao 		c,
						pls_execucao_requisicao	b,
						pls_execucao_req_item	a
					where	a.nr_seq_execucao	= b.nr_sequencia
					and	b.nr_seq_requisicao	= c.nr_sequencia
					and	a.nr_seq_segurado	= nr_seq_segurado_p
					and	b.nr_sequencia		<> nr_seq_execucao_p
					and	a.ie_situacao		not in ('C','G','N','U')
					and (pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_p, a.cd_procedimento, a.ie_origem_proced, null) = 'S')
					and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(b.dt_execucao) between dt_ref_inicial_p and dt_ref_final_p
					
union	all

					PERFORM 	coalesce(sum(a.qt_item),0) qt_itens
					from	pls_requisicao 		c,
						pls_execucao_requisicao	b,
						pls_execucao_req_item	a
					where	a.nr_seq_execucao	= b.nr_sequencia
					and	b.nr_seq_requisicao	= c.nr_sequencia
					and	a.nr_seq_segurado	= nr_seq_segurado_p
					and	b.nr_sequencia		<> nr_seq_execucao_p
					and	a.ie_situacao		not in ('C','G','N','U')
					and (pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_p, null, null, a.nr_seq_material) = 'S')
					and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(b.dt_execucao) between dt_ref_inicial_p and dt_ref_final_p) alias13;
		end if;	
	elsif (ie_somar_estrutura_p = 'N') then
		if (coalesce(cd_procedimento_p,0) > 0) then
			if (ie_tipo_incidencia_p = 'G') then
				select 	coalesce(sum(a.qt_item),0)
				into STRICT	qt_solicitado_w
				from	pls_requisicao 		c,
					pls_execucao_requisicao	b,
					pls_execucao_req_item	a
				where	a.nr_seq_execucao	= b.nr_sequencia
				and	b.nr_seq_requisicao	= c.nr_sequencia
				and	a.nr_seq_segurado	= nr_seq_segurado_p
				and	a.ie_situacao		not in ('C','G','N','U')
				and	a.cd_procedimento	= cd_procedimento_p		
				and	a.ie_origem_proced	= ie_origem_proced_p
				and	b.dt_execucao		between dt_ref_inicial_p and coalesce(dt_ref_final_p,clock_timestamp());
			elsif (ie_tipo_incidencia_p = 'H') then
				select 	coalesce(sum(a.qt_item),0)
				into STRICT	qt_solicitado_w
				from	pls_requisicao 		c,
					pls_execucao_requisicao	b,
					pls_execucao_req_item	a
				where	a.nr_seq_execucao	= b.nr_sequencia
				and	b.nr_seq_requisicao	= c.nr_sequencia
				and	a.nr_seq_segurado	= nr_seq_segurado_p
				and	b.nr_sequencia		<> nr_seq_execucao_p
				and	a.ie_situacao		not in ('C','G','N','U')
				and	a.cd_procedimento	= cd_procedimento_p		
				and	a.ie_origem_proced	= ie_origem_proced_p
				and	b.dt_execucao		between dt_ref_inicial_p and dt_ref_final_p;
			else
				select 	coalesce(sum(a.qt_item),0)
				into STRICT	qt_solicitado_w
				from	pls_requisicao 		c,
					pls_execucao_requisicao	b,
					pls_execucao_req_item	a
				where	a.nr_seq_execucao	= b.nr_sequencia
				and	b.nr_seq_requisicao	= c.nr_sequencia
				and	a.nr_seq_segurado	= nr_seq_segurado_p
				and	b.nr_sequencia		<> nr_seq_execucao_p
				and	a.ie_situacao		not in ('C','G','N','U')
				and	a.cd_procedimento	= cd_procedimento_p		
				and	a.ie_origem_proced	= ie_origem_proced_p
				and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(b.dt_execucao) between dt_ref_inicial_p and dt_ref_final_p;
			end if;
		elsif (coalesce(nr_seq_material_p,0) > 0) then
			if (ie_tipo_incidencia_p = 'G') then
				select 	coalesce(sum(a.qt_item),0)
				into STRICT	qt_solicitado_w
				from	pls_requisicao 		c,
					pls_execucao_requisicao	b,
					pls_execucao_req_item	a
				where	a.nr_seq_execucao	= b.nr_sequencia
				and	b.nr_seq_requisicao	= c.nr_sequencia
				and	a.nr_seq_segurado	= nr_seq_segurado_p
				and	a.ie_situacao		not in ('C','G','N','U')
				and	a.nr_seq_material	= nr_seq_material_p
				and	b.dt_execucao		between dt_ref_inicial_p and coalesce(dt_ref_final_p,clock_timestamp());
			elsif (ie_tipo_incidencia_p = 'H') then
				select 	coalesce(sum(a.qt_item),0)
				into STRICT	qt_solicitado_w
				from	pls_requisicao 		c,
					pls_execucao_requisicao	b,
					pls_execucao_req_item	a
				where	a.nr_seq_execucao	= b.nr_sequencia
				and	b.nr_seq_requisicao	= c.nr_sequencia
				and	a.nr_seq_segurado	= nr_seq_segurado_p
				and	b.nr_sequencia		<> nr_seq_execucao_p
				and	a.ie_situacao		not in ('C','G','N','U')
				and	a.nr_seq_material	= nr_seq_material_p
				and	b.dt_execucao		between dt_ref_inicial_p and dt_ref_final_p;
			else
				select 	coalesce(sum(a.qt_item),0)
				into STRICT	qt_solicitado_w
				from	pls_requisicao 		c,
					pls_execucao_requisicao	b,
					pls_execucao_req_item	a
				where	a.nr_seq_execucao	= b.nr_sequencia
				and	b.nr_seq_requisicao	= c.nr_sequencia
				and	a.nr_seq_segurado	= nr_seq_segurado_p
				and	b.nr_sequencia		<> nr_seq_execucao_p
				and	a.ie_situacao		not in ('C','G','N','U')
				and	a.nr_seq_material	= nr_seq_material_p
				and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(b.dt_execucao) between dt_ref_inicial_p and dt_ref_final_p;
			end if;
		end if;
	end if;
end if;	

if (ie_tipo_incidencia_p <> 'G' or coalesce(ie_tipo_incidencia_p::text, '') = '') then	
	qt_solicitado_w := qt_solicitado_w + qt_solicitada_p;
end if;

if (qt_solicitado_w	>= qt_liberada_p) then
	ie_retorno_w	:= 'S';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_qt_incid_estrutura ( nr_seq_estrutura_p pls_ocorrencia_estrutura.nr_sequencia%type, nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, nr_seq_execucao_p pls_execucao_requisicao.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proced_p procedimento.ie_origem_proced%type, nr_seq_material_p pls_material.nr_sequencia%type, qt_solicitada_p bigint, qt_liberada_p bigint, dt_ref_inicial_p timestamp, dt_ref_final_p timestamp, ie_tipo_incidencia_p text, ie_somar_estrutura_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

