-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_regra_excecao_aut ( nr_seq_ocorrencia_p bigint, nr_seq_requisicao_p bigint, nr_seq_guia_plano_p bigint, nr_seq_proc_p bigint, nr_seq_mat_p bigint, dt_solicitacao_p timestamp, ie_tipo_item_p bigint, nr_seq_prestador_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_material_p bigint, nr_seq_segurado_p bigint, ie_tipo_guia_p text, nr_seq_plano_p bigint, nm_usuario_p text, qt_dias_vencido_p bigint, nr_seq_uni_exec_p bigint, ie_tipo_repasse_p text, ie_carater_internacao_p text) RETURNS varchar AS $body$
DECLARE

/* 
ie_tipo_item_w 
1 - Procedimento da guia 
2 - Material da guia 
3 - Procedimento da conta 
4 - Material da conta 
5 - Procedimento da requisição 
6 - Material da requisição 
7 - Guia 
8 - Contas Médica 
9 - Requisições para Autorização 
*/
 
qt_ocorrencia_w			bigint;
qt_dias_w			bigint;
nr_seq_estrutura_w		bigint;
cd_procedimento_w		bigint;
ie_origem_proced_w		integer;
nr_seq_proc_espec_w		bigint;
cd_espec_medica_w		bigint;
cd_especialidade_w		bigint;
nr_contrato_w			bigint;
nr_seq_contrato_w		bigint;
nr_seq_intercambio_w		bigint;
nr_seq_grupo_prestador_w	bigint;
nr_seq_prestador_w		bigint;
nr_seq_tipo_prestador_w		bigint;
nr_seq_classificacao_w		bigint;
nr_seq_classificacao_regra_w	bigint;
nr_seq_tipo_prestador_regra_w	bigint;
qt_idade_w			integer;
qt_idade_min_w			smallint;
qt_idade_max_w			smallint;
qt_idade_meses_w		integer;
nr_seq_grupo_contrato_w		bigint;
qt_existe_grupo_w		integer;
nr_seq_material_w		bigint;
qt_consulta_urg_w		bigint;
qt_gat_w			bigint;
qt_cobranca_previa_w		bigint;
nr_seq_local_atend_w		bigint 	:= 0;
cd_estabelecimento_w		smallint;
nr_seq_tipo_acomodacao_w	bigint;
nr_seq_grupo_produto_w		bigint;
ie_porte_anestesico_w		varchar(1);
ds_retorno_w			varchar(1) := 'N';
ie_estrutura_w			varchar(1);
ie_porte_w			varchar(1);
cd_medico_executor_regra_w	varchar(10);
ie_medico_exec_solic_w		varchar(1);
ie_oc_medico_exec_w		varchar(1);
ie_espec_solic_proc_w		varchar(1);
ie_tipo_processo_w		varchar(1);
ie_tipo_atend_tiss_w		varchar(2);
ie_preco_w			varchar(10);
ie_regulamentacao_w		varchar(1);
ie_tipo_contrato_inter_w	varchar(2);
ie_grupo_prest_w		varchar(1);
ie_beneficiario_tratamento_w	varchar(1);
ie_tratamento_w			varchar(1)	:= 'N';
cd_doenca_cid_w			varchar(10);
ie_cid_regra_w			varchar(1);
ie_tipo_segurado_w		varchar(3);
ie_sexo_w			varchar(2);
ie_unid_tempo_idade_w		varchar(2);
ie_possui_liminar_w		varchar(2);
ie_liminar_benef_w		varchar(1);
cd_ocorrencia_w			varchar(10);
cd_pessoa_fisica_w		varchar(255);
ie_consulta_urgencia_w		varchar(2);
ie_tipo_gat_regra_w		varchar(2);
ie_cobranca_previa_w		varchar(2);
nm_usuario_solic_w		varchar(255);
ie_tipo_solicitacao_int_w	varchar(2)	:= 'X';
ie_espec_prestador_w		varchar(1);
ie_grupo_produto_w		varchar(1);
ie_recem_nasc_regra_w		varchar(1);
ie_recem_nascido_w		varchar(1);
nr_seq_grupo_servico_regra_w	bigint;
nr_seq_grupo_material_regra_w	bigint;
ie_grupo_servico_w		varchar(2)	:= 'X';
ie_grupo_material_w		varchar(2)	:= 'X';
nr_seq_excecao_ocor_w		bigint;
ie_pcmso_w			varchar(1);
ie_pcmso_regra_w		varchar(1);
nr_seq_grupo_doenca_regra_w	bigint;
cd_doenca_cid_aut_w		varchar(50);
ie_grupo_doenca_w		varchar(1);
ie_carater_internacao_con_w	varchar(1);
ie_carater_internacao_w		varchar(1);

C01 CURSOR FOR 
	SELECT	nr_sequencia, 
		qt_dias, 
		ie_porte_anestesico, 
		nr_seq_estrutura, 
		cd_procedimento, 
		ie_origem_proced, 
		cd_medico_executor, 
		ie_medico, 
		nr_seq_proc_espec, 
		cd_especialidade_medica, 
		nr_seq_grupo_prestador, 
		nr_seq_classificacao, 
		nr_seq_tipo_prestador, 
		ie_beneficiario_tratamento, 
		cd_doenca_cid, 
		qt_idade_min, 
		qt_idade_max, 
		ie_unid_tempo_idade, 
		ie_possui_liminar, 
		nr_seq_grupo_contrato, 
		nr_seq_material, 
		ie_consulta_urgencia, 
		ie_tipo_gat, 
		ie_cobranca_previa, 
		nr_seq_grupo_produto, 
		ie_recem_nascido, 
		nr_seq_grupo_servico, 
		nr_seq_grupo_material, 
		ie_pcmso, 
		nr_seq_grupo_doenca, 
		ie_carater_internacao 
	from	pls_excecao_ocorrencia 
	where	nr_seq_ocorrencia = nr_seq_ocorrencia_p 
	and	ie_autorizacao	= 'S' 
	and	ie_situacao	= 'A' 
	and	((coalesce(cd_procedimento::text, '') = '') or (cd_procedimento	= cd_procedimento_p and ie_origem_proced = ie_origem_proced_p)) 
	and	((coalesce(ie_tipo_guia::text, '') = '') or (ie_tipo_guia = ie_tipo_guia_p)) 
	and	((coalesce(ie_tipo_processo_autor::text, '') = '') or (ie_tipo_processo_autor = ie_tipo_processo_w AND ie_tipo_processo_autor IS NOT NULL AND ie_tipo_processo_autor::text <> '')) 
	and	((coalesce(ie_tipo_atend_tiss::text, '') = '') or (ie_tipo_atend_tiss = ie_tipo_atend_tiss_w)) 
	and	((coalesce(ie_preco::text, '') = '') or (ie_preco = ie_preco_w)) 
	and	((coalesce(ie_regulamentacao::text, '') = '') or (ie_regulamentacao = ie_regulamentacao_w)) 
	and	((coalesce(nr_seq_prestador::text, '') = '') or (nr_seq_prestador = nr_seq_prestador_p)) 
	and	((coalesce(nr_contrato::text, '') = '') or (nr_contrato = nr_contrato_w)) 
	and	((coalesce(nr_seq_intercambio::text, '') = '') or (nr_seq_intercambio = nr_seq_intercambio_w)) 
	and	((coalesce(ie_tipo_segurado::text, '') = '') or (ie_tipo_segurado = ie_tipo_segurado_w)) 
	and	((coalesce(ie_sexo::text, '') = '') or (ie_sexo = ie_sexo_w)) 
	and	((coalesce(ie_tipo_contrato_intercambio::text, '') = '') or (ie_tipo_contrato_intercambio = ie_tipo_contrato_inter_w)) 
	and	trunc(dt_solicitacao_p) between trunc(dt_inicio_vigencia)	and fim_dia(coalesce(dt_fim_vigencia,dt_solicitacao_p)) 
	and	((coalesce(qt_dias_mensal_vencido,0) = 0) or (coalesce(qt_dias_vencido_p,0) >= qt_dias_mensal_vencido)) 
	and	((coalesce(nr_seq_uni_exec::text, '') = '') or (nr_seq_uni_exec = nr_seq_uni_exec_p)) 
	and	((coalesce(nr_seq_local_atend::text, '') = '') or (nr_seq_local_atend = nr_seq_local_atend_w)) 
	and	((coalesce(ie_tipo_solicitacao_int::text, '') = '')	or (ie_tipo_solicitacao_int	= ie_tipo_solicitacao_int_w)) 
	and	((coalesce(nr_seq_tipo_acomodacao::text, '') = '') or (nr_seq_tipo_acomodacao = nr_seq_tipo_acomodacao_w)) 
	and	((coalesce(nr_seq_plano::text, '') = '') or (nr_seq_plano = nr_seq_plano_p)) 
	and	((coalesce(ie_tipo_repasse::text, '') = '') or (ie_tipo_repasse = ie_tipo_repasse_p)) 
	order by 
		coalesce(ie_tipo_guia,'0'), 
		coalesce(cd_procedimento,999999999999999);


BEGIN 
 
ie_carater_internacao_con_w	:= ie_carater_internacao_p;
 
if (ie_tipo_item_p	in (1,2,7)) then 
	begin 
		 
		select	coalesce(ie_tipo_processo,'X'), 
			ie_tipo_atend_tiss, 
			nr_seq_prestador, 
			ie_tipo_intercambio, 
			nr_seq_tipo_acomodacao 
		into STRICT	ie_tipo_processo_w, 
			ie_tipo_atend_tiss_w, 
			nr_seq_prestador_w, 
			ie_tipo_solicitacao_int_w, 
			nr_seq_tipo_acomodacao_w 
		from	pls_guia_plano 
		where	nr_sequencia	= nr_seq_guia_plano_p;
		 
		select max(cd_doenca) 
		into STRICT	cd_doenca_cid_aut_w 
		from	pls_diagnostico 
		where	nr_seq_guia	= nr_seq_guia_plano_p 
		and	ie_classificacao= 'P';
		 
	exception 
	when others then 
		ie_tipo_processo_w := 'X';
	end;
elsif (ie_tipo_item_p in (5,6,9)) then 
	begin 
		select	coalesce(ie_tipo_processo,'X'), 
			nm_usuario_solic, 
			cd_estabelecimento, 
			ie_tipo_intercambio, 
			nr_seq_tipo_acomodacao, 
			ie_tipo_atendimento 
		into STRICT	ie_tipo_processo_w, 
			nm_usuario_solic_w, 
			cd_estabelecimento_w, 
			ie_tipo_solicitacao_int_w, 
			nr_seq_tipo_acomodacao_w, 
			ie_tipo_atend_tiss_w 
		from	pls_requisicao 
		where	nr_sequencia	= nr_seq_requisicao_p;
		 
		select max(cd_doenca) 
		into STRICT	cd_doenca_cid_aut_w 
		from	pls_requisicao_diagnostico 
		where	nr_seq_requisicao	= nr_seq_requisicao_p 
		and	ie_classificacao= 'P';		
	exception 
	when others then 
		ie_tipo_processo_w := 'X';
	end;
 
	/* Obter local de atendimento */
 
	if (coalesce(nm_usuario_solic_w,'X') <> 'X') and (ie_tipo_processo_w = 'P') then 
		nr_seq_local_atend_w := pls_obter_local_atend_usuario(nm_usuario_solic_w,cd_estabelecimento_w);
	end if;
end if;
 
/* Obter dados do segurado */
 
begin 
select	nr_seq_contrato, 
	ie_tipo_segurado, 
	cd_pessoa_fisica, 
	ie_pcmso 
into STRICT	nr_seq_contrato_w, 
	ie_tipo_segurado_w, 
	cd_pessoa_fisica_w, 
	ie_pcmso_w 
from	pls_segurado 
where	nr_sequencia		= nr_seq_segurado_p;
exception 
when others then 
	nr_seq_contrato_w 	:= 0;
	ie_tipo_segurado_w	:= '0';
	cd_pessoa_fisica_w	:= '0';
end;
 
begin 
select	a.ie_sexo, 
	substr(obter_idade_pf(a.cd_pessoa_fisica, clock_timestamp(), 'A'),1,10), 
	substr(obter_idade_pf(a.cd_pessoa_fisica, clock_timestamp(), 'M'),1,10) 
into STRICT	ie_sexo_w, 
	qt_idade_w, 
	qt_idade_meses_w 
from	pessoa_fisica	a 
where	cd_pessoa_fisica	= cd_pessoa_fisica_w;
exception 
when others then 
	ie_sexo_w		:= '';
	qt_idade_w		:= '';
	qt_idade_meses_w	:= '';
end;
 
/* Obter dados do contrato */
 
begin 
select	nr_contrato 
into STRICT	nr_contrato_w 
from	pls_contrato 
where	nr_sequencia	= nr_seq_contrato_w;
exception 
when others then 
	nr_contrato_w	:= 0;
end;
 
/*Se o beneficiário não tiver um contrato verificamos se este é um beneficiário de intercâmbio*/
 
begin 
select	coalesce(nr_seq_intercambio,0) 
into STRICT	nr_seq_intercambio_w 
from	pls_segurado 
where	nr_sequencia = nr_seq_segurado_p;
 
select	coalesce(ie_tipo_contrato,'0') 
into STRICT	ie_tipo_contrato_inter_w 
from	pls_intercambio 
where	nr_sequencia = nr_seq_intercambio_w;
exception 
when others then 
	nr_seq_intercambio_w	:= 0;
	ie_tipo_contrato_inter_w := '0';
end;
 
/* Obter dados do produto */
 
begin 
select	ie_preco, 
	ie_regulamentacao 
into STRICT	ie_preco_w, 
	ie_regulamentacao_w 
from	pls_plano 
where	nr_sequencia	= nr_seq_plano_p;
exception 
when others then 
	ie_preco_w	:= '0';
end;
 
/* Obter dados do prestador */
 
begin 
select	nr_seq_tipo_prestador, 
	nr_seq_classificacao 
into STRICT	nr_seq_tipo_prestador_w, 
	nr_seq_classificacao_w 
from	pls_prestador 
where	nr_sequencia	= nr_seq_prestador_p;
exception 
when others then 
	nr_seq_tipo_prestador_w	:= 0;
end;
 
open C01;
loop 
fetch C01 into 
	nr_seq_excecao_ocor_w, 
	qt_dias_w, 
	ie_porte_anestesico_w, 
	nr_seq_estrutura_w, 
	cd_procedimento_w, 
	ie_origem_proced_w, 
	cd_medico_executor_regra_w, 
	ie_medico_exec_solic_w, 
	nr_seq_proc_espec_w, 
	cd_espec_medica_w, 
	nr_seq_grupo_prestador_w, 
	nr_seq_classificacao_regra_w, 
	nr_seq_tipo_prestador_regra_w, 
	ie_beneficiario_tratamento_w, 
	cd_doenca_cid_w, 
	qt_idade_min_w, 
	qt_idade_max_w, 
	ie_unid_tempo_idade_w, 
	ie_possui_liminar_w, 
	nr_seq_grupo_contrato_w, 
	nr_seq_material_w, 
	ie_consulta_urgencia_w, 
	ie_tipo_gat_regra_w, 
	ie_cobranca_previa_w, 
	nr_seq_grupo_produto_w, 
	ie_recem_nasc_regra_w, 
	nr_seq_grupo_servico_regra_w, 
	nr_seq_grupo_material_regra_w, 
	ie_pcmso_regra_w, 
	nr_seq_grupo_doenca_regra_w, 
	ie_carater_internacao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
 
	if (coalesce( cd_procedimento_w,0)	> 0) or (coalesce(nr_seq_estrutura_w,0)	> 0) or (coalesce(nr_seq_material_w,0)	> 0) then 
 
		if (ie_tipo_item_p in (1,2,5,6)) then 
			/*Se for uma regra de procedimento*/
 
			 
			 
			if (cd_procedimento_w > 0) and (coalesce(nr_seq_estrutura_w,0) = 0) then 
 
				/*Verifica se o procedimento da regra consiste com o do procedimento da conta / guia*/
 
				if (cd_procedimento_w <> coalesce(cd_procedimento_p,0)) or (ie_origem_proced_w <> coalesce(ie_origem_proced_p,0)) or (coalesce(nr_seq_material_w,0) > 0) then 
					goto final;
				end if;
			/*Se for uma regra de material*/
 
			elsif (coalesce(nr_seq_material_w,0) > 0) and (coalesce(nr_seq_estrutura_w,0) = 0) then 
				if (nr_seq_material_w <> coalesce(nr_seq_material_p,0)) or (coalesce(cd_procedimento_w,0) > 0) then 
					goto final;
				end if;
			/*Se for regra de estrutura*/
 
			elsif (nr_seq_estrutura_w > 0) and 
				((coalesce(cd_procedimento_w,0) = 0) and (coalesce(nr_seq_material_w,0) = 0)) then 
				/*Verifica-se se algum dos procedimentos daestrutura existe na conta / guia*/
 
				ie_estrutura_w	:= pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_w, cd_procedimento_p, ie_origem_proced_p, nr_seq_material_p);
				if (ie_estrutura_w = 'N') then 
					/*Se não existe */
 
					goto final;
				end if;
			/*Se for regra de estrutura e procedimento verifica-se os dois*/
 
			elsif (cd_procedimento_w > 0) and (nr_seq_estrutura_w > 0) then 
				/*Se na regra já coincidiu o procedimento com o da conta já é gerado ocorrencia sem necessidadse de verificar a estrutura.	*/
 
				if	(((cd_procedimento_w <> cd_procedimento_p) or (ie_origem_proced_w <> ie_origem_proced_p)) or (coalesce(cd_procedimento_p,0) = 0)) then 
					/*Se for regar de material ou o procedimento não consistir com a regra é verificado a estrutura.*/
 
					if (pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_w, cd_procedimento_p, ie_origem_proced_p, nr_seq_material_p) = 'N') then 
						goto final;
					end if;
				end if;
			/*Se for regra de estrutura e material verifica-se os dois */
 
			elsif (coalesce( nr_seq_material_w,0) > 0)and (coalesce(nr_seq_estrutura_w,0) > 0) then 
				/* Se a regra já coincidiu com o material, já é gerado a ocorrência */
 
				if	((nr_seq_material_w <> nr_seq_material_p) or (coalesce(nr_seq_material_p,0) = 0)) then 
					if (pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_w, cd_procedimento_p, ie_origem_proced_p, nr_seq_material_p) = 'N') then 
						goto final;
					end if;
				end if;
			end if;
 
			/*Grupo serviço*/
	 
			if (coalesce(nr_seq_grupo_servico_regra_w,0) > 0) then	 
				ie_grupo_servico_w	:= pls_se_grupo_preco_servico(nr_seq_grupo_servico_regra_w, cd_procedimento_p, ie_origem_proced_p);
				if (ie_grupo_servico_w	= 'N') then 
					goto final;
				end if;
			end if;	
 
			/* Grupo de material */
 
			if (coalesce(nr_seq_grupo_material_regra_w,0) > 0) and (coalesce(nr_seq_material_p,0) > 0) then 
				ie_grupo_material_w	:= pls_se_grupo_preco_material(nr_seq_grupo_material_regra_w, nr_seq_material_p);
				if (ie_grupo_material_w	= 'N') then 
					goto final;
				end if;	
			end if;
		else 
			goto final;
		end if;
	end if;
 
	/* Verificar regra de porte anestesico */
 
	if (ie_porte_anestesico_w = 'S') then 
		ie_porte_w := pls_obter_se_porte_anestesico(	nr_seq_requisicao_p, nr_seq_guia_plano_p, null, 
								nr_seq_proc_p, nr_seq_mat_p, ie_tipo_item_p, 
								cd_procedimento_p, ie_origem_proced_p, nr_seq_segurado_p, 
								qt_dias_w, dt_solicitacao_p);
		if (ie_porte_w = 'N') then 
			goto final;
		end if;
	end if;
 
	/* Verificar a regra de expecialidade médica para a requisicão*/
 
	if (cd_espec_medica_w IS NOT NULL AND cd_espec_medica_w::text <> '') then	 
		if (ie_tipo_item_p	in (5,6,9)) then 
			select	coalesce(cd_especialidade,0) 
			into STRICT	cd_especialidade_w 
			from	pls_requisicao 
			where	nr_sequencia	= nr_seq_requisicao_p;
 
			if (cd_espec_medica_w	<> cd_especialidade_w) then 
				goto final;
			end if;
		elsif (ie_tipo_item_p in (1,2,7)) then 
			ie_espec_prestador_w := pls_obter_se_espec_prestador(nr_seq_prestador_p,cd_espec_medica_w);
			if (ie_espec_prestador_w = 'N') then 
				goto final;
			end if;
		end if;
	end if;
 
	/*Verificar se o prestador pertence ao grupo dos prestador*/
 
	if (coalesce(nr_seq_grupo_prestador_w,0) > 0) then 
		ie_grupo_prest_w	:= pls_se_grupo_preco_prestador(nr_seq_grupo_prestador_w, nr_seq_prestador_w, nr_seq_classificacao_w);
		if (ie_grupo_prest_w = 'N') then 
			goto final;
		end if;
	end if;
 
	/*Obter se a regra é para uma classificacao do prestador*/
 
	if (coalesce(nr_seq_classificacao_regra_w,0) > 0) then 
		if (nr_seq_classificacao_regra_w <> nr_seq_classificacao_w) then 
			goto final;
		end if;
	end if;
 
	/*Se for uma regra para o tipo do prestador*/
 
	if (coalesce(nr_seq_tipo_prestador_regra_w,0) > 0) then 
		/*Se for é verificado se o prestador é do tipo do prestador da regra*/
 
		if (nr_seq_tipo_prestador_regra_w <> nr_seq_tipo_prestador_w) then 
			goto final;
		end if;
	end if;
 
	/* Verificar se for regra de quantidade de idade minima ou maxima da regra, sendo "A" por ano e "M" por meses*/
 
	if (coalesce(ie_unid_tempo_idade_w,'A') = 'A') then 
		if	(qt_idade_min_w IS NOT NULL AND qt_idade_min_w::text <> '' AND qt_idade_min_w > qt_idade_w) or 
			(qt_idade_max_w IS NOT NULL AND qt_idade_max_w::text <> '' AND qt_idade_max_w < qt_idade_w) then 
			goto final;
		end if;
	elsif (coalesce(ie_unid_tempo_idade_w,'A') = 'M') then 
		if	(qt_idade_min_w IS NOT NULL AND qt_idade_min_w::text <> '' AND qt_idade_min_w > qt_idade_meses_w) or 
			(qt_idade_max_w IS NOT NULL AND qt_idade_max_w::text <> '' AND qt_idade_max_w < qt_idade_meses_w) then 
			goto final;
		end if;
	end if;
 
	/* Verificar se existe liminares para o beneficiário da requisição */
 
	if (coalesce(ie_possui_liminar_w,'N') = 'S') then 
		ie_liminar_benef_w := pls_obter_se_liminar_benef(nr_seq_segurado_p,dt_solicitacao_p);
		if (ie_liminar_benef_w = 'N') then 
			goto final;
		end if;
	end if;
 
	/* Verificar se o beneficiário está em tratamento. Valido somente para a requisição e execução da requisição */
 
	if (coalesce(ie_beneficiario_tratamento_w,'N') = 'S') then 
		if (ie_tipo_item_p in (5,6,9,10,11)) then 
			ie_tratamento_w := pls_obter_se_tratamento_benef(dt_solicitacao_p,nr_seq_segurado_p);
			if (ie_tratamento_w = 'N') then 
				goto final;
			end if;
		else 
			goto final;
		end if;
	end if;
 
	if (coalesce(cd_doenca_cid_w,'X') <> 'X') then 
		ie_cid_regra_w	:= pls_obter_se_cid_guia_req(nr_seq_guia_plano_p,nr_seq_requisicao_p,cd_doenca_cid_w,ie_tipo_item_p);
		if (ie_cid_regra_w = 'N') then 
			goto final;
		end if;
	end if;
 
	/* Verificar se o contrato do beneficiário pertence ao grupo de contrato cadastrado na regra */
 
	if (coalesce(nr_seq_grupo_contrato_w,0) <> 0) then 
		select	count(1) 
		into STRICT	qt_existe_grupo_w 
		from	pls_preco_contrato	a 
		where	a.nr_seq_grupo	= nr_seq_grupo_contrato_w 
		and (nr_seq_contrato	= nr_seq_contrato_w 
		or	nr_seq_intercambio	= nr_seq_intercambio_w);
		if (qt_existe_grupo_w = 0) then 
			goto final;
		end if;
	end if;
 
	/* Se for uma regra de exceção para as consultas de urgências*/
 
	if (coalesce(ie_consulta_urgencia_w,'N')	= 'S') then 
		if (ie_tipo_item_p in (5,6,9)) then 
			select	count(1) 
			into STRICT	qt_consulta_urg_w 
			from	pls_requisicao 
			where	nr_sequencia		= nr_seq_requisicao_p 
			and	ie_consulta_urgencia	= 'S';
 
			if (qt_consulta_urg_w = 0) then 
				goto final;
			end if;
		else 
			goto final;
		end if;
	end if;
 
	/* Se for uma excessão para as requisições GAT */
 
	if (coalesce(ie_tipo_gat_regra_w,'N')	= 'S') then 
		if (ie_tipo_item_p in (5,6,9)) then 
			select	count(1) 
			into STRICT	qt_gat_w 
			from	pls_requisicao 
			where	nr_sequencia	= nr_seq_requisicao_p 
			and	ie_tipo_gat	= 'S';
 
			if (qt_gat_w = 0) then 
				goto final;
			end if;
		else 
			goto final;
		end if;
	end if;
	 
	/* Se for uma regra de gripo de produtos */
 
	if (nr_seq_grupo_produto_w IS NOT NULL AND nr_seq_grupo_produto_w::text <> '')	then 
		ie_grupo_produto_w	:= pls_se_grupo_preco_produto(nr_seq_grupo_produto_w, nr_seq_plano_p);
		if (ie_grupo_produto_w = 'N')	then 
			goto final;
		end if;
	end if;
 
	/* Se for uma regra de exceção para itens já pagos em cobrança prévia*/
 
	if (coalesce(ie_cobranca_previa_w,'N')	= 'S') then 
		if (ie_tipo_item_p = 5) then 
			select	count(1) 
			into STRICT	qt_cobranca_previa_w 
			from	pls_requisicao_proc 
			where	nr_sequencia			= nr_seq_proc_p 
			and	ie_cobranca_previa_servico	= 'S';
 
			if (qt_cobranca_previa_w = 0) then 
				goto final;
			end if;
		elsif (ie_tipo_item_p = 6) then 
			select	count(1) 
			into STRICT	qt_cobranca_previa_w 
			from	pls_requisicao_mat 
			where	nr_sequencia			= nr_seq_mat_p 
			and	ie_cobranca_previa_servico	= 'S';
 
			if (qt_cobranca_previa_w = 0) then 
				goto final;
			end if;
		else 
			goto final;
		end if;
	end if;
	 
	/* Regra de exceção para recém nascidos */
 
	if (coalesce(ie_recem_nasc_regra_w,'N')	= 'S') then 
		if (ie_tipo_item_p	in (1,2,7)) then 
			begin 
				select	ie_recem_nascido 
				into STRICT	ie_recem_nascido_w 
				from	pls_guia_plano 
				where	nr_sequencia	= nr_seq_guia_plano_p;
			exception 
			when others then 
				ie_recem_nascido_w		:= 'N';
			end;
		elsif (ie_tipo_item_p	in (5,6,9)) then 
			begin 
				select	ie_recem_nascido 
				into STRICT	ie_recem_nascido_w 
				from	pls_requisicao 
				where	nr_sequencia	= nr_seq_requisicao_p;
			exception 
			when others then 
				ie_recem_nascido_w		:= 'N';
			end;
		end if;
		 
		if (coalesce(ie_recem_nascido_w,'N')	= 'N') then 
			goto final;
		end if;
	end if;
	/* */
 
	 
	/* Regra de exceção para PCMSO */
 
	if (coalesce(ie_pcmso_regra_w,'N') = 'S') then 
		if (ie_pcmso_w = 'N') then 
			goto final;
		end if;
	end if;
 
	/*Grupos de Doencas*/
	 
	 
	if (coalesce(nr_seq_grupo_doenca_regra_w,0) > 0) then 
		if (coalesce(cd_doenca_cid_aut_w,'X') <> 'X') then 
			ie_grupo_doenca_w	:= pls_se_grupo_preco_doenca(nr_seq_grupo_doenca_regra_w, cd_doenca_cid_aut_w);	
			if (coalesce(ie_grupo_doenca_w,'N')	= 'N') then 
				goto final;	
			end if;
		else 
			goto final;
		end if;
		 
	end if;
	/* */
 
	 
	/* Verifica se o carater de internação é igual ao cadastrado em uma regra de exceção de Autorização*/
 
	if (ie_carater_internacao_w IS NOT NULL AND ie_carater_internacao_w::text <> '')	then 
		if (ie_carater_internacao_w <> ie_carater_internacao_con_w)	then 
			goto final;
		end if;
	end if;
	 
	ds_retorno_w := 'S';
	if (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then 
		CALL pls_inserir_regra_excecao_req(nr_seq_ocorrencia_p, nr_seq_excecao_ocor_w, nr_seq_requisicao_p, nm_usuario_p);
	end if;
	 
	<<final>> 
	qt_ocorrencia_w	:= 0;
	end;
	 
 
	 
end loop;
close C01;
 
if (ie_tratamento_w = 'S') and (ds_retorno_w = 'S') and (ie_tipo_item_p = 5) then 
	update	pls_requisicao_proc 
	set	nr_seq_tratamento	= pls_obter_tratamento_benef(dt_solicitacao_p,nr_seq_segurado_p) 
	where	nr_sequencia		= nr_seq_proc_p;
 
	select	pls_obter_codigo_ocorrencia(nr_seq_ocorrencia_p) 
	into STRICT	cd_ocorrencia_w 
	;
 
	CALL pls_requisicao_gravar_hist(nr_seq_requisicao_p,'L', 
				'A ocorrência '||cd_ocorrencia_w||' não foi gerada pois o beneficiário está em tratamento conforme regra de exceção.', 
				'',nm_usuario_p);
end if;
 
if (ie_liminar_benef_w = 'S') and (ds_retorno_w = 'S') then 
 
	CALL pls_inserir_liminar_excecao(nr_seq_segurado_p,dt_solicitacao_p,nr_seq_requisicao_p,nr_seq_guia_plano_p,ie_tipo_item_p,nm_usuario_p);
end if;
 
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_obter_se_regra_excecao_aut ( nr_seq_ocorrencia_p bigint, nr_seq_requisicao_p bigint, nr_seq_guia_plano_p bigint, nr_seq_proc_p bigint, nr_seq_mat_p bigint, dt_solicitacao_p timestamp, ie_tipo_item_p bigint, nr_seq_prestador_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_material_p bigint, nr_seq_segurado_p bigint, ie_tipo_guia_p text, nr_seq_plano_p bigint, nm_usuario_p text, qt_dias_vencido_p bigint, nr_seq_uni_exec_p bigint, ie_tipo_repasse_p text, ie_carater_internacao_p text) FROM PUBLIC;
