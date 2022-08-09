-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_processa_consulta_benef ( nr_seq_cons_benef_p ptu_consulta_beneficiario.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p ptu_consulta_beneficiario.nm_usuario%type, nr_seq_resp_cons_p INOUT ptu_resp_consulta_benef.nr_sequencia%type) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Validar a importação da consulta de dados do beneficiário. 
 
Rotina utilizada nas transações ptu via WebService. 
quando for alterar, favor verificar com o análista responsável para a realização de testes. 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ X ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
dt_nasc_benef_w			ptu_consulta_beneficiario.dt_nascimento%type;
cd_unimed_beneficiario_w	ptu_resp_consulta_benef.cd_unimed_beneficiario%type;
cd_unimed_w 			ptu_resp_nomes_benef.cd_unimed%type;
cd_unimed_executora_w 	 	ptu_resp_consulta_benef.cd_unimed_executora%type;
cd_carteirinha_w		pls_segurado_carteira.cd_usuario_plano%type := '';
nr_seq_plano_w			pls_plano.nr_sequencia%type;
cd_usuario_plano_ww		ptu_consulta_beneficiario.cd_usuario_plano%type := null;
nm_empresa_w			ptu_resp_nomes_benef.nm_empresa_abrev%type;
ie_abrangencia_w		pls_plano.ie_abrangencia%type;
ie_tipo_cliente_w		ptu_resp_consulta_benef.ie_tipo_cliente%type;
nr_seq_execucao_w		ptu_resp_consulta_benef.nr_seq_execucao%type;
nm_benef_consulta_w		pessoa_fisica.nm_pessoa_fisica%type;
nr_versao_w			ptu_resp_consulta_benef.nr_versao%type;
ie_regulamentacao_w   	ptu_resp_nomes_benef.ie_tipo_plano%type;
ie_inseriu_w			varchar(1)	:= 'N';
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
nr_seq_tipo_acomodacao_w	pls_plano_acomodacao.nr_seq_tipo_acomodacao%type;
ie_tipo_acomodacao_ptu_w	pls_tipo_acomodacao.ie_tipo_acomodacao_ptu%type;
nr_cpf_w			pessoa_fisica.nr_cpf%type;
nr_cns_w			pessoa_fisica.nr_cartao_nac_sus%type;
nr_seq_categoria_w		pls_plano_acomodacao.nr_seq_categoria%type;

-- Buscar informações dos beneficiários quando informada a carteirinha 
C01 CURSOR(	cd_carteirinha_wc		pls_segurado_carteira.cd_usuario_plano%type) FOR 
	SELECT	distinct(a.cd_pessoa_fisica) cd_pessoa_fisica, 
		a.nm_pessoa_fisica, 
		a.ie_sexo, 
		pls_obter_nome_sobrenome(a.cd_pessoa_fisica,'P') nm_beneficiario, 
		coalesce(b.nr_via_solicitacao,1) nr_via_solicitacao, 
		b.dt_validade_carteira, 
		substr(b.cd_usuario_plano,5,17) cd_usuario_plano, 
		substr(b.cd_usuario_plano,1,4) cd_unimed, 
		c.nr_sequencia, 
		c.nr_seq_plano, 
		to_date(pls_obter_dados_segurado(c.nr_sequencia, 'I'),'dd/mm/rrrr') dt_inclusao_operadora, 
		to_date(pls_obter_dados_segurado(c.nr_sequencia, 'DR'),'dd/mm/rrrr') dt_rescisao, 
		to_date(pls_obter_dados_segurado(c.nr_sequencia, 'NAS'),'dd/mm/rrrr') dt_nascimento		 
	from	pls_segurado			c, 
		pls_segurado_carteira		b, 
		pessoa_fisica			a 
	where	b.nr_seq_segurado	= c.nr_sequencia 
	and	c.cd_pessoa_fisica	= a.cd_pessoa_fisica 
	and	b.cd_usuario_plano	= cd_carteirinha_wc		 
	and	c.ie_tipo_segurado	in ('A','B','P');
	
-- Buscar informações dos beneficiários quando não informada a carteirinha	 
C02 CURSOR(	nm_benef_consulta_wc		pessoa_fisica.nm_pessoa_fisica%type, 
		dt_nasc_benef_wc	 	pessoa_fisica.dt_nascimento%type) FOR 
	SELECT	distinct(a.cd_pessoa_fisica) cd_pessoa_fisica, 
		a.nm_pessoa_fisica, 
		a.ie_sexo, 
		pls_obter_nome_sobrenome(a.cd_pessoa_fisica,'P') nm_beneficiario, 
		coalesce(b.nr_via_solicitacao,1) nr_via_solicitacao, 
		b.dt_validade_carteira, 
		substr(b.cd_usuario_plano,5,17) cd_usuario_plano, 
		substr(b.cd_usuario_plano,1,4) cd_unimed, 
		c.nr_sequencia, 
		c.nr_seq_plano, 
		to_date(pls_obter_dados_segurado(c.nr_sequencia, 'I'),'dd/mm/rrrr') dt_inclusao_operadora, 
		to_date(pls_obter_dados_segurado(c.nr_sequencia, 'DR'),'dd/mm/rrrr') dt_rescisao, 
		to_date(pls_obter_dados_segurado(c.nr_sequencia, 'NAS'),'dd/mm/rrrr') dt_nascimento		 
	from	pls_segurado			c, 
		pls_segurado_carteira		b, 
		pessoa_fisica			a 
	where	b.nr_seq_segurado	= c.nr_sequencia 
	and	c.cd_pessoa_fisica	= a.cd_pessoa_fisica 
	and	a.dt_nascimento		= dt_nasc_benef_wc 
	and	upper(a.nm_pessoa_fisica) like nm_benef_consulta_wc 
	and	c.ie_tipo_segurado	in ('A','B','P') 
	
union
 
	SELECT	distinct(a.cd_pessoa_fisica) cd_pessoa_fisica, 
		a.nm_pessoa_fisica, 
		a.ie_sexo, 
		pls_obter_nome_sobrenome(a.cd_pessoa_fisica,'P') nm_beneficiario, 
		coalesce(b.nr_via_solicitacao,1) nr_via_solicitacao, 
		b.dt_validade_carteira, 
		substr(b.cd_usuario_plano,5,17) cd_usuario_plano, 
		substr(b.cd_usuario_plano,1,4) cd_unimed, 
		c.nr_sequencia, 
		c.nr_seq_plano, 
		to_date(pls_obter_dados_segurado(c.nr_sequencia, 'I'),'dd/mm/rrrr') dt_inclusao_operadora, 
		to_date(pls_obter_dados_segurado(c.nr_sequencia, 'DR'),'dd/mm/rrrr') dt_rescisao, 
		to_date(pls_obter_dados_segurado(c.nr_sequencia, 'NAS'),'dd/mm/rrrr') dt_nascimento		 
	from	pls_segurado			c, 
		pls_segurado_carteira		b, 
		pessoa_fisica			a 
	where	b.nr_seq_segurado	= c.nr_sequencia 
	and	c.cd_pessoa_fisica	= a.cd_pessoa_fisica 
	and	a.dt_nascimento		= dt_nasc_benef_wc 
	and	upper(a.nm_pessoa_fisica_sem_acento) like nm_benef_consulta_wc 
	and	c.ie_tipo_segurado	in ('A','B','P');
	
C03 CURSOR(nr_seq_plano_wc		pls_plano.nr_sequencia%type) FOR 
	SELECT	substr(pls_obter_dados_produto(nr_seq_plano_wc,'N'),1,20) nm_plano, 
		pls_obter_dados_produto(nr_seq_plano_wc,'APD') ds_tipo_acomod, 
		ie_abrangencia, 
		ie_regulamentacao, 
		substr(cd_rede_refer_ptu,1,4) cd_rede_atendimento 
	from  pls_plano 
	where  nr_sequencia	= nr_seq_plano_wc;
	
C04 CURSOR( nr_cpf_pc		pessoa_fisica.nr_cpf%type) FOR 
	SELECT	distinct(a.cd_pessoa_fisica) cd_pessoa_fisica, 
		a.nm_pessoa_fisica, 
		a.ie_sexo, 
		pls_obter_nome_sobrenome(a.cd_pessoa_fisica,'P') nm_beneficiario, 
		coalesce(b.nr_via_solicitacao,1) nr_via_solicitacao, 
		b.dt_validade_carteira, 
		substr(b.cd_usuario_plano,5,17) cd_usuario_plano, 
		substr(b.cd_usuario_plano,1,4) cd_unimed, 
		c.nr_sequencia, 
		c.nr_seq_plano, 
		to_date(pls_obter_dados_segurado(c.nr_sequencia, 'I'),'dd/mm/rrrr') dt_inclusao_operadora, 
		to_date(pls_obter_dados_segurado(c.nr_sequencia, 'DR'),'dd/mm/rrrr') dt_rescisao, 
		to_date(pls_obter_dados_segurado(c.nr_sequencia, 'NAS'),'dd/mm/rrrr') dt_nascimento		 
	from	pls_segurado			c, 
		pls_segurado_carteira		b, 
		pessoa_fisica			a 
	where	b.nr_seq_segurado	= c.nr_sequencia 
	and	c.cd_pessoa_fisica	= a.cd_pessoa_fisica 
	and	lpad(a.nr_cpf,11,'0')		= nr_cpf_pc 
	and	c.ie_tipo_segurado	in ('A','B','P');
	
C05 CURSOR( nr_cns_pc		pessoa_fisica.nr_cartao_nac_sus%type) FOR 
	SELECT	distinct(a.cd_pessoa_fisica) cd_pessoa_fisica, 
		a.nm_pessoa_fisica, 
		a.ie_sexo, 
		pls_obter_nome_sobrenome(a.cd_pessoa_fisica,'P') nm_beneficiario, 
		coalesce(b.nr_via_solicitacao,1) nr_via_solicitacao, 
		b.dt_validade_carteira, 
		substr(b.cd_usuario_plano,5,17) cd_usuario_plano, 
		substr(b.cd_usuario_plano,1,4) cd_unimed, 
		c.nr_sequencia, 
		c.nr_seq_plano, 
		to_date(pls_obter_dados_segurado(c.nr_sequencia, 'I'),'dd/mm/rrrr') dt_inclusao_operadora, 
		to_date(pls_obter_dados_segurado(c.nr_sequencia, 'DR'),'dd/mm/rrrr') dt_rescisao, 
		to_date(pls_obter_dados_segurado(c.nr_sequencia, 'NAS'),'dd/mm/rrrr') dt_nascimento		 
	from	pls_segurado			c, 
		pls_segurado_carteira		b, 
		pessoa_fisica			a 
	where	b.nr_seq_segurado	= c.nr_sequencia 
	and	c.cd_pessoa_fisica	= a.cd_pessoa_fisica 
	and	lpad(a.nr_cartao_nac_sus,15,'0')	= nr_cns_pc 
	and	c.ie_tipo_segurado	in ('A','B','P');

BEGIN 
cd_estabelecimento_w := cd_estabelecimento_p;
 
--Quando as transações são geradas pelo WebService, não existe estabelecimento definido, então é verificado o estabeleicmento do parâmetro 
if ( coalesce(cd_estabelecimento_w,0) = 0 ) then 
	cd_estabelecimento_w := ptu_obter_estab_padrao;
end if;
 
select	to_date(dt_nascimento), 
	ie_tipo_cliente, 
	cd_unimed, 
	cd_unimed_executora, 
	cd_unimed_beneficiario, 
	cd_usuario_plano, 
	nr_seq_execucao, 
	nr_versao, 
	nextval('ptu_resp_consulta_benef_seq'), 
	upper(elimina_acentos(nm_beneficiario||'%'||sobrenome_beneficiario||'%')), 
	substr(pls_obter_nome_operadora(cd_unimed_beneficiario),1,18), 
	lpad(nr_cpf,11,'0'), 
	lpad(nr_cns,15,'0') 
into STRICT	dt_nasc_benef_w, 
	ie_tipo_cliente_w, 
	cd_unimed_w, 
	cd_unimed_executora_w, 
	cd_unimed_beneficiario_w, 
	cd_usuario_plano_ww, 
	nr_seq_execucao_w, 
	nr_versao_w, 
	nr_seq_resp_cons_p, 
	nm_benef_consulta_w, 
	nm_empresa_w, 
	nr_cpf_w, 
	nr_cns_w 
from	ptu_consulta_beneficiario 
where	nr_sequencia = nr_seq_cons_benef_p;
 
if (cd_usuario_plano_ww <> '0000000000000') then 
	cd_carteirinha_w	:= adiciona_zeros_esquerda(cd_unimed_w, 4)||lpad(cd_usuario_plano_ww,13,'0');
end if;
 
insert	into ptu_resp_consulta_benef(nr_sequencia, cd_transacao, ie_tipo_cliente, 
	 cd_unimed_executora, cd_unimed_beneficiario, nr_seq_execucao, 
	 nr_seq_origem, ie_confirmacao, dt_atualizacao, 
	 nm_usuario, nr_seq_requisicao, nr_seq_guia, 
	 nm_usuario_nrec, dt_atualizacao_nrec, nr_versao) 
values (nr_seq_resp_cons_p, '00413', ie_tipo_cliente_w, 
	 cd_unimed_executora_w, cd_unimed_beneficiario_w, nr_seq_execucao_w, 
	 nr_seq_resp_cons_p, 'S', clock_timestamp(), 
	 nm_usuario_p, null, nr_seq_resp_cons_p, 
	 nm_usuario_p, clock_timestamp(), nr_versao_w);
 
 
begin 
if (cd_carteirinha_w IS NOT NULL AND cd_carteirinha_w::text <> '') 	then	 
	for c01_w in C01( cd_carteirinha_w ) loop 
		for c03_w in C03( c01_w.nr_seq_plano ) loop 
			--tipo de acomodação SCS 6.0 
			begin 
				select	nr_seq_categoria 
				into STRICT	nr_seq_categoria_w 
				from	pls_plano_acomodacao 
				where	nr_seq_plano		= c01_w.nr_seq_plano;
			exception 
			when others then 
				nr_seq_categoria_w := null;
			end;
			 
			if (nr_seq_categoria_w IS NOT NULL AND nr_seq_categoria_w::text <> '') then 
				select	max(nr_seq_tipo_acomodacao) 
				into STRICT	nr_seq_tipo_acomodacao_w 
				from	pls_regra_categoria 
				where	nr_seq_categoria	= nr_seq_categoria_w 
				and	ie_acomod_padrao	= 'S';
			else 
				select	max(nr_seq_tipo_acomodacao) 
				into STRICT	nr_seq_tipo_acomodacao_w 
				from	pls_plano_acomodacao 
				where	nr_seq_plano		= c01_w.nr_seq_plano 
				and	ie_acomod_padrao	= 'S';
			end if;
			 
			--Se nõa houver padrão 
			if (coalesce(nr_seq_tipo_acomodacao_w::text, '') = '') then 
				select	max(nr_seq_tipo_acomodacao) 
				into STRICT	nr_seq_tipo_acomodacao_w 
				from	pls_plano_acomodacao 
				where	nr_seq_plano		= c01_w.nr_seq_plano;
			end if;
						 
			select	max(ie_tipo_acomodacao_ptu) 
			into STRICT	ie_tipo_acomodacao_ptu_w 
			from	pls_tipo_acomodacao 
			where	nr_sequencia	= nr_seq_tipo_acomodacao_w;
		 
			ie_regulamentacao_w := null;
			if (c03_w.ie_regulamentacao = 'P') then 
				ie_regulamentacao_w := 3;
			elsif (c03_w.ie_regulamentacao = 'A') then 
				ie_regulamentacao_w := 2;
			elsif (c03_w.ie_regulamentacao = 'R') then 
				ie_regulamentacao_w := 1;
			end if;
 
			if (c03_w.ie_abrangencia	= 'E') then 
				ie_abrangencia_w	:= 3;
			elsif (c03_w.ie_abrangencia	= 'GE') then 
				ie_abrangencia_w	:= 2;
			elsif (c03_w.ie_abrangencia	= 'GM') then 
				ie_abrangencia_w	:= 4;
			elsif (c03_w.ie_abrangencia	= 'M') then 
				ie_abrangencia_w	:= 5;
			elsif (c03_w.ie_abrangencia	= 'N') then 
				ie_abrangencia_w	:= 1;
			end if;
 
			insert	into ptu_resp_nomes_benef(nr_sequencia, nr_seq_resp_benef, nm_beneficiario, 
				 dt_nascimento, nm_empresa_abrev, cd_unimed, 
				 cd_usuario_plano, nm_compl_benef, nm_plano, 
				 dt_atualizacao, nm_usuario, nm_tipo_acomodacao, 
				 ie_abrangencia, cd_local_cobranca, dt_validade_carteira, 
				 dt_inclusao_benef, dt_exclusao_benef, ie_sexo, 
				 nr_via_cartao, nm_usuario_nrec, dt_atualizacao_nrec, 
				 cd_rede_atendimento, ie_tipo_plano) 
			values (nextval('ptu_resp_nomes_benef_seq'), nr_seq_resp_cons_p, c01_w.nm_beneficiario, 
				c01_w.dt_nascimento, substr(nm_empresa_w,1,18), coalesce(cd_unimed_w, c01_w.cd_unimed), 
				coalesce(cd_usuario_plano_ww, c01_w.cd_usuario_plano),c01_w.nm_pessoa_fisica, substr(c03_w.nm_plano,1,20), 
				clock_timestamp(), nm_usuario_p, coalesce(ie_tipo_acomodacao_ptu_w,'C'), 
				ie_abrangencia_w, cd_unimed_beneficiario_w, c01_w.dt_validade_carteira, 
				c01_w.dt_inclusao_operadora, c01_w.dt_rescisao, c01_w.ie_sexo, 
				c01_w.nr_via_solicitacao, nm_usuario_p, clock_timestamp(), 
				c03_w.cd_rede_atendimento, ie_regulamentacao_w);
 
			ie_inseriu_w	:= 'S';
 
		end loop;
	end loop;
elsif (nr_cpf_w IS NOT NULL AND nr_cpf_w::text <> '') then 
	for c04_w in C04( nr_cpf_w ) loop 
		for c03_w in C03( c04_w.nr_seq_plano ) loop 
			--tipo de acomodação SCS 6.0 
			begin 
				select	nr_seq_categoria 
				into STRICT	nr_seq_categoria_w 
				from	pls_plano_acomodacao 
				where	nr_seq_plano		= c04_w.nr_seq_plano;
			exception 
			when others then 
				nr_seq_categoria_w := null;
			end;
			 
			if (nr_seq_categoria_w IS NOT NULL AND nr_seq_categoria_w::text <> '') then 
				select	max(nr_seq_tipo_acomodacao) 
				into STRICT	nr_seq_tipo_acomodacao_w 
				from	pls_regra_categoria 
				where	nr_seq_categoria	= nr_seq_categoria_w 
				and	ie_acomod_padrao	= 'S';
			else 
				select	max(nr_seq_tipo_acomodacao) 
				into STRICT	nr_seq_tipo_acomodacao_w 
				from	pls_plano_acomodacao 
				where	nr_seq_plano		= c04_w.nr_seq_plano 
				and	ie_acomod_padrao	= 'S';
			end if;
			 
			--Se nõa houver padrão 
			if (coalesce(nr_seq_tipo_acomodacao_w::text, '') = '') then 
				select	max(nr_seq_tipo_acomodacao) 
				into STRICT	nr_seq_tipo_acomodacao_w 
				from	pls_plano_acomodacao 
				where	nr_seq_plano		= c04_w.nr_seq_plano;
			end if;
						 
			select	max(ie_tipo_acomodacao_ptu) 
			into STRICT	ie_tipo_acomodacao_ptu_w 
			from	pls_tipo_acomodacao 
			where	nr_sequencia	= nr_seq_tipo_acomodacao_w;
		 
			ie_regulamentacao_w := null;
			if (c03_w.ie_regulamentacao = 'P') then 
				ie_regulamentacao_w := 3;
			elsif (c03_w.ie_regulamentacao = 'A') then 
				ie_regulamentacao_w := 2;
			elsif (c03_w.ie_regulamentacao = 'R') then 
				ie_regulamentacao_w := 1;
			end if;
 
			if (c03_w.ie_abrangencia	= 'E') then 
				ie_abrangencia_w	:= 3;
			elsif (c03_w.ie_abrangencia	= 'GE') then 
				ie_abrangencia_w	:= 2;
			elsif (c03_w.ie_abrangencia	= 'GM') then 
				ie_abrangencia_w	:= 4;
			elsif (c03_w.ie_abrangencia	= 'M') then 
				ie_abrangencia_w	:= 5;
			elsif (c03_w.ie_abrangencia	= 'N') then 
				ie_abrangencia_w	:= 1;
			end if;
 
			insert	into ptu_resp_nomes_benef(nr_sequencia, nr_seq_resp_benef, nm_beneficiario, 
				 dt_nascimento, nm_empresa_abrev, cd_unimed, 
				 cd_usuario_plano, nm_compl_benef, nm_plano, 
				 dt_atualizacao, nm_usuario, nm_tipo_acomodacao, 
				 ie_abrangencia, cd_local_cobranca, dt_validade_carteira, 
				 dt_inclusao_benef, dt_exclusao_benef, ie_sexo, 
				 nr_via_cartao, nm_usuario_nrec, dt_atualizacao_nrec, 
				 cd_rede_atendimento, ie_tipo_plano) 
			values (nextval('ptu_resp_nomes_benef_seq'), nr_seq_resp_cons_p, c04_w.nm_beneficiario, 
				c04_w.dt_nascimento, substr(nm_empresa_w,1,18), coalesce(cd_unimed_w,c04_w.cd_unimed), 
				coalesce(cd_usuario_plano_ww, c04_w.cd_usuario_plano),c04_w.nm_pessoa_fisica, substr(c03_w.nm_plano,1,20), 
				clock_timestamp(), nm_usuario_p, coalesce(ie_tipo_acomodacao_ptu_w,'C'), 
				ie_abrangencia_w, cd_unimed_beneficiario_w, c04_w.dt_validade_carteira, 
				c04_w.dt_inclusao_operadora, c04_w.dt_rescisao, c04_w.ie_sexo, 
				c04_w.nr_via_solicitacao, nm_usuario_p, clock_timestamp(), 
				c03_w.cd_rede_atendimento, ie_regulamentacao_w);
 
			ie_inseriu_w	:= 'S';
 
		end loop;
	end loop;
elsif (nr_cns_w IS NOT NULL AND nr_cns_w::text <> '') then 
	for c05_w in C05( nr_cns_w ) loop 
		for c03_w in C03( c05_w.nr_seq_plano ) loop 
			--tipo de acomodação SCS 6.0 
			begin 
				select	nr_seq_categoria 
				into STRICT	nr_seq_categoria_w 
				from	pls_plano_acomodacao 
				where	nr_seq_plano		= c05_w.nr_seq_plano;
			exception 
			when others then 
				nr_seq_categoria_w := null;
			end;
			 
			if (nr_seq_categoria_w IS NOT NULL AND nr_seq_categoria_w::text <> '') then 
				select	max(nr_seq_tipo_acomodacao) 
				into STRICT	nr_seq_tipo_acomodacao_w 
				from	pls_regra_categoria 
				where	nr_seq_categoria	= nr_seq_categoria_w 
				and	ie_acomod_padrao	= 'S';
			else 
				select	max(nr_seq_tipo_acomodacao) 
				into STRICT	nr_seq_tipo_acomodacao_w 
				from	pls_plano_acomodacao 
				where	nr_seq_plano		= c05_w.nr_seq_plano 
				and	ie_acomod_padrao	= 'S';
			end if;
			 
			--Se nõa houver padrão 
			if (coalesce(nr_seq_tipo_acomodacao_w::text, '') = '') then 
				select	max(nr_seq_tipo_acomodacao) 
				into STRICT	nr_seq_tipo_acomodacao_w 
				from	pls_plano_acomodacao 
				where	nr_seq_plano		= c05_w.nr_seq_plano;
			end if;
						 
			select	max(ie_tipo_acomodacao_ptu) 
			into STRICT	ie_tipo_acomodacao_ptu_w 
			from	pls_tipo_acomodacao 
			where	nr_sequencia	= nr_seq_tipo_acomodacao_w;
		 
			ie_regulamentacao_w := null;
			if (c03_w.ie_regulamentacao = 'P') then 
				ie_regulamentacao_w := 3;
			elsif (c03_w.ie_regulamentacao = 'A') then 
				ie_regulamentacao_w := 2;
			elsif (c03_w.ie_regulamentacao = 'R') then 
				ie_regulamentacao_w := 1;
			end if;
 
			if (c03_w.ie_abrangencia	= 'E') then 
				ie_abrangencia_w	:= 3;
			elsif (c03_w.ie_abrangencia	= 'GE') then 
				ie_abrangencia_w	:= 2;
			elsif (c03_w.ie_abrangencia	= 'GM') then 
				ie_abrangencia_w	:= 4;
			elsif (c03_w.ie_abrangencia	= 'M') then 
				ie_abrangencia_w	:= 5;
			elsif (c03_w.ie_abrangencia	= 'N') then 
				ie_abrangencia_w	:= 1;
			end if;
 
			insert	into ptu_resp_nomes_benef(nr_sequencia, nr_seq_resp_benef, nm_beneficiario, 
				 dt_nascimento, nm_empresa_abrev, cd_unimed, 
				 cd_usuario_plano, nm_compl_benef, nm_plano, 
				 dt_atualizacao, nm_usuario, nm_tipo_acomodacao, 
				 ie_abrangencia, cd_local_cobranca, dt_validade_carteira, 
				 dt_inclusao_benef, dt_exclusao_benef, ie_sexo, 
				 nr_via_cartao, nm_usuario_nrec, dt_atualizacao_nrec, 
				 cd_rede_atendimento, ie_tipo_plano) 
			values (nextval('ptu_resp_nomes_benef_seq'), nr_seq_resp_cons_p, c05_w.nm_beneficiario, 
				c05_w.dt_nascimento, substr(nm_empresa_w,1,18), coalesce(cd_unimed_w,c05_w.cd_unimed), 
				coalesce(cd_usuario_plano_ww, c05_w.cd_usuario_plano),c05_w.nm_pessoa_fisica, substr(c03_w.nm_plano,1,20), 
				clock_timestamp(), nm_usuario_p, coalesce(ie_tipo_acomodacao_ptu_w,'C'), 
				ie_abrangencia_w, cd_unimed_beneficiario_w, c05_w.dt_validade_carteira, 
				c05_w.dt_inclusao_operadora, c05_w.dt_rescisao, c05_w.ie_sexo, 
				c05_w.nr_via_solicitacao, nm_usuario_p, clock_timestamp(), 
				c03_w.cd_rede_atendimento, ie_regulamentacao_w);
 
			ie_inseriu_w	:= 'S';
 
		end loop;
	end loop;
else 
	for c02_w in C02( nm_benef_consulta_w, dt_nasc_benef_w ) loop 
		for c03_w in C03( c02_w.nr_seq_plano ) loop 
			--tipo de acomodação SCS 6.0 
			begin 
				select	nr_seq_categoria 
				into STRICT	nr_seq_categoria_w 
				from	pls_plano_acomodacao 
				where	nr_seq_plano		= c02_w.nr_seq_plano;
			exception 
			when others then 
				nr_seq_categoria_w := null;
			end;
			 
			if (nr_seq_categoria_w IS NOT NULL AND nr_seq_categoria_w::text <> '') then 
				select	max(nr_seq_tipo_acomodacao) 
				into STRICT	nr_seq_tipo_acomodacao_w 
				from	pls_regra_categoria 
				where	nr_seq_categoria	= nr_seq_categoria_w 
				and	ie_acomod_padrao	= 'S';
			else 
				select	max(nr_seq_tipo_acomodacao) 
				into STRICT	nr_seq_tipo_acomodacao_w 
				from	pls_plano_acomodacao 
				where	nr_seq_plano		= c02_w.nr_seq_plano 
				and	ie_acomod_padrao	= 'S';
			end if;
			 
			--Se nõa houver padrão 
			if (coalesce(nr_seq_tipo_acomodacao_w::text, '') = '') then 
				select	max(nr_seq_tipo_acomodacao) 
				into STRICT	nr_seq_tipo_acomodacao_w 
				from	pls_plano_acomodacao 
				where	nr_seq_plano		= c02_w.nr_seq_plano;
			end if;
						 
			select	max(ie_tipo_acomodacao_ptu) 
			into STRICT	ie_tipo_acomodacao_ptu_w 
			from	pls_tipo_acomodacao 
			where	nr_sequencia	= nr_seq_tipo_acomodacao_w;
		 
			ie_regulamentacao_w := null;
			if (c03_w.ie_regulamentacao = 'P') then 
				ie_regulamentacao_w := 3;
			elsif (c03_w.ie_regulamentacao = 'A') then 
				ie_regulamentacao_w := 2;
			elsif (c03_w.ie_regulamentacao = 'R') then 
				ie_regulamentacao_w := 1;
			end if;
 
			if (c03_w.ie_abrangencia	= 'E') then 
				ie_abrangencia_w	:= 3;
			elsif (c03_w.ie_abrangencia	= 'GE') then 
				ie_abrangencia_w	:= 2;
			elsif (c03_w.ie_abrangencia	= 'GM') then 
				ie_abrangencia_w	:= 4;
			elsif (c03_w.ie_abrangencia	= 'M') then 
				ie_abrangencia_w	:= 5;
			elsif (c03_w.ie_abrangencia	= 'N') then 
				ie_abrangencia_w	:= 1;
			end if;
 
			insert	into ptu_resp_nomes_benef(nr_sequencia, nr_seq_resp_benef, nm_beneficiario, 
				 dt_nascimento, nm_empresa_abrev, cd_unimed, 
				 cd_usuario_plano, nm_compl_benef, nm_plano, 
				 dt_atualizacao, nm_usuario, nm_tipo_acomodacao, 
				 ie_abrangencia, cd_local_cobranca, dt_validade_carteira, 
				 dt_inclusao_benef, dt_exclusao_benef, ie_sexo, 
				 nr_via_cartao, nm_usuario_nrec, dt_atualizacao_nrec, 
				 cd_rede_atendimento, ie_tipo_plano) 
			values (nextval('ptu_resp_nomes_benef_seq'), nr_seq_resp_cons_p, c02_w.nm_beneficiario, 
				c02_w.dt_nascimento, substr(nm_empresa_w,1,18), coalesce(cd_unimed_w, c02_w.cd_unimed), 
				coalesce(cd_usuario_plano_ww, c02_w.cd_usuario_plano),c02_w.nm_pessoa_fisica, substr(c03_w.nm_plano,1,20), 
				clock_timestamp(), nm_usuario_p, coalesce(ie_tipo_acomodacao_ptu_w,'C'), 
				ie_abrangencia_w, cd_unimed_beneficiario_w, c02_w.dt_validade_carteira, 
				c02_w.dt_inclusao_operadora, c02_w.dt_rescisao, c02_w.ie_sexo, 
				c02_w.nr_via_solicitacao, nm_usuario_p, clock_timestamp(), 
				c03_w.cd_rede_atendimento, ie_regulamentacao_w);
 
			ie_inseriu_w	:= 'S';
 
		end loop;
	end loop;
end if;
exception 
when others then 
	ie_inseriu_w	:= 'N';	
	-- Rollback pois caso houver erro o sistema deverá abortar os registros que foram inseridos e inserir a inconsitência. 
	rollback;
end;
 
if ( ie_inseriu_w = 'N') then 
	update	ptu_resp_consulta_benef 
	set	ie_confirmacao	= 'N' 
	where	nr_sequencia	= nr_seq_resp_cons_p;
 
	CALL ptu_inserir_inconsistencia(	null, null, 5001, 
					'',cd_estabelecimento_w, nr_seq_resp_cons_p, 
					'CB', '00413', null, 
					null, null, nm_usuario_p);
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_processa_consulta_benef ( nr_seq_cons_benef_p ptu_consulta_beneficiario.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p ptu_consulta_beneficiario.nm_usuario%type, nr_seq_resp_cons_p INOUT ptu_resp_consulta_benef.nr_sequencia%type) FROM PUBLIC;
