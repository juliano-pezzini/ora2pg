-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_smp_pck.gerar_precos_servico ( regra_simulacao_p pls_smp_pck.regra_simulacao, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Gerar os precos dos servicos
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atencao:
Alteracoes:
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
regra_simulacao_preco_serv_w	pls_smp_pck.regra_simulacao_preco_ser;
nr_seq_categoria_w		pls_categoria.nr_sequencia%type;

-- Informacoes sobre o beneficiario
c01 CURSOR(	nr_seq_smp_pc	pls_smp.nr_sequencia%type) FOR
SELECT	a.nr_seq_segurado,
	a.nr_sequencia nr_seq_smp_result_benef,
	(pls_obter_dados_segurado(a.nr_seq_segurado, 'NC'))::numeric  nr_seq_contrato,
	pls_obter_dados_segurado(a.nr_seq_segurado, 'NRCI') nr_seq_contrato_intercambio,
	pls_obter_dados_segurado(a.nr_seq_segurado, 'TP') ie_tipo_beneficiario,
	c.nr_sequencia cd_plano,
	c.ie_preco,
	b.nr_seq_congenere,
	coalesce(b.nr_seq_intercambio,0) nr_seq_intercambio,
	coalesce(b.ie_pcmso,'N') ie_pcmso,
	c.ie_acomodacao,
	coalesce(c.ie_franquia, 'N') ie_franquia,
	b.nr_seq_grupo_intercambio,
	coalesce(b.ie_pcmso,'A') ie_atend_pcmso
from	pls_smp_result_benef	a,
	pls_segurado		b,
	pls_plano		c
where	b.nr_sequencia	= a.nr_seq_segurado
and	c.nr_sequencia	= b.nr_seq_plano
and	a.nr_seq_smp	= nr_seq_smp_pc;


-- Informacoes sobre o procedimento
c02 CURSOR(	nr_seq_smp_result_benef_pc	pls_smp_result_benef.nr_sequencia%type) FOR
SELECT	c.cd_procedimento,
	c.ie_origem_proced,
	b.nr_seq_prestador,
	d.nr_seq_classificacao,
	d.ie_tipo_vinculo,
	d.nr_seq_tipo_prestador,
	d.cd_prestador,
	b.nr_sequencia nr_seq_smp_result_prest,
	c.qt_item,
	c.nr_sequencia nr_seq_item_serv,
	d.cd_pessoa_fisica,
	(	select	max(x.nr_seq_grupo_rec)
		from	procedimento	x
		where	x.cd_procedimento	= c.cd_procedimento
		and	x.ie_origem_proced	= c.ie_origem_proced
		and	x.ie_situacao		= 'A'
	) nr_seq_grupo_rec
FROM procedimento e, pls_smp_result_item c, pls_smp_result_benef a, pls_smp_result_prest b
LEFT OUTER JOIN pls_prestador d ON (b.nr_seq_prestador = d.nr_sequencia)
WHERE b.nr_seq_smp_result_benef	= a.nr_sequencia and c.nr_seq_smp_result_prest	= b.nr_sequencia  and e.cd_procedimento		= c.cd_procedimento and e.ie_origem_proced		= c.ie_origem_proced and e.ie_classificacao 		<> 1  -- somente procedimentos que sao considerados "servicos"
  and a.nr_sequencia			= nr_seq_smp_result_benef_pc;
BEGIN

-- somente gera se tiver simulacao
if (regra_simulacao_p.nr_sequencia IS NOT NULL AND regra_simulacao_p.nr_sequencia::text <> '') then

	-- inicializa as informacoes que serao identicas para beneficiario, prestador e servico
	-- categoria
	begin
		select	nr_sequencia
		into STRICT	nr_seq_categoria_w
		from	pls_categoria
		where	cd_estabelecimento	= cd_estabelecimento_p
		and	ie_situacao	= 'A'  LIMIT 1;
	exception
		when no_data_found then nr_seq_categoria_w := null;
	end;

	-- carrega os beneficiarios
	for r_c01_w in c01(regra_simulacao_p.nr_sequencia) loop
	
		-- carrega os prestadores e servicos
		for r_c02_w in c02(r_c01_w.nr_seq_smp_result_benef) loop
			
			-- alimenta os parametros
			regra_simulacao_preco_serv_w.cd_estabelecimento		:= cd_estabelecimento_p;
			regra_simulacao_preco_serv_w.nr_seq_prestador		:= r_c02_w.nr_seq_prestador;
			regra_simulacao_preco_serv_w.dt_servico			:= regra_simulacao_p.dt_referencia;
			regra_simulacao_preco_serv_w.cd_servico			:= r_c02_w.cd_procedimento;
			regra_simulacao_preco_serv_w.ie_origem_proced		:= r_c02_w.ie_origem_proced;
			regra_simulacao_preco_serv_w.ie_tipo_tabela		:= regra_simulacao_p.ie_regra_preco;
			regra_simulacao_preco_serv_w.nr_seq_procedimento	:= null;
			regra_simulacao_preco_serv_w.ie_tipo_contratacao	:= null;
			regra_simulacao_preco_serv_w.nr_seq_plano		:= r_c01_w.cd_plano;
			regra_simulacao_preco_serv_w.nr_seq_contrato		:= r_c01_w.nr_seq_contrato;
			regra_simulacao_preco_serv_w.nr_seq_classificacao	:= r_c02_w.nr_seq_classificacao;
			regra_simulacao_preco_serv_w.nr_seq_categoria		:= nr_seq_categoria_w;
			regra_simulacao_preco_serv_w.ie_internado		:= 'N';
			regra_simulacao_preco_serv_w.ie_tipo_vinculo		:= r_c02_w.ie_tipo_vinculo;
			regra_simulacao_preco_serv_w.nr_seq_contrato_intercambio:= r_c01_w.nr_seq_contrato_intercambio;
			regra_simulacao_preco_serv_w.nr_seq_segurado		:= r_c01_w.nr_seq_segurado;
			regra_simulacao_preco_serv_w.ie_tipo_intercambio	:= null;
			regra_simulacao_preco_serv_w.ie_tipo_guia		:= null;
			regra_simulacao_preco_serv_w.nr_seq_cbo_saude		:= null;
			regra_simulacao_preco_serv_w.ie_carater_internacao	:= null;
			regra_simulacao_preco_serv_w.nr_seq_clinica		:= null;
			regra_simulacao_preco_serv_w.nr_seq_tipo_atendimento	:= null;
			regra_simulacao_preco_serv_w.nr_seq_tipo_acomodacao	:= null;
			regra_simulacao_preco_serv_w.cd_prestador		:= r_c02_w.cd_prestador;
			regra_simulacao_preco_serv_w.nr_seq_tipo_prestador	:= r_c02_w.nr_seq_tipo_prestador;
			regra_simulacao_preco_serv_w.ie_ref_guia_internacao	:= null;
			regra_simulacao_preco_serv_w.nr_seq_tipo_atend_princ	:= null;
			regra_simulacao_preco_serv_w.ie_atend_pcmso		:= r_c01_w.ie_atend_pcmso;
			regra_simulacao_preco_serv_w.cd_prestador_solic		:= null;
			regra_simulacao_preco_serv_w.cd_grupo_proc		:= null;
			regra_simulacao_preco_serv_w.cd_especialidade		:= null;
			regra_simulacao_preco_serv_w.cd_area_procedimento	:= null;
			regra_simulacao_preco_serv_w.ie_preco			:= r_c01_w.ie_preco;
			regra_simulacao_preco_serv_w.cd_prestador_prot		:= null;
			regra_simulacao_preco_serv_w.nr_seq_tipo_prestador_prot	:= null;
			regra_simulacao_preco_serv_w.nr_seq_prestador_inter	:= null;
			regra_simulacao_preco_serv_w.ie_tipo_segurado		:= r_c01_w.ie_tipo_beneficiario;
			regra_simulacao_preco_serv_w.nr_seq_grupo_rec		:= r_c02_w.nr_seq_grupo_rec;
			regra_simulacao_preco_serv_w.ie_acomodacao		:= r_c01_w.ie_acomodacao;
			regra_simulacao_preco_serv_w.nr_seq_intercambio		:= r_c01_w.nr_seq_intercambio;
			regra_simulacao_preco_serv_w.ie_cooperado		:= null;
			regra_simulacao_preco_serv_w.ie_pcmso			:= r_c01_w.ie_pcmso;
			regra_simulacao_preco_serv_w.nr_seq_grupo_intercambio	:= r_c01_w.nr_seq_grupo_intercambio;
			regra_simulacao_preco_serv_w.nr_seq_congenere		:= r_c01_w.nr_seq_congenere;
			regra_simulacao_preco_serv_w.nr_seq_congenere_prot	:= null;
			regra_simulacao_preco_serv_w.ie_origem_protocolo	:= null;
			regra_simulacao_preco_serv_w.cd_versao_tiss		:= null;
			regra_simulacao_preco_serv_w.ie_acomodacao_autorizada	:= null;
			regra_simulacao_preco_serv_w.nr_seq_smp_result_prest	:= r_c02_w.nr_seq_smp_result_prest;
			regra_simulacao_preco_serv_w.qt_item			:= r_c02_w.qt_item;
			regra_simulacao_preco_serv_w.nr_seq_item_serv		:= r_c02_w.nr_seq_item_serv;
			regra_simulacao_preco_serv_w.cd_especialidade_prest	:= substr(pls_obter_cod_espec_prest(r_c02_w.nr_seq_prestador, r_c02_w.cd_pessoa_fisica)||',',1,4000);
			regra_simulacao_preco_serv_w.nr_seq_prest_inter		:= null;
			regra_simulacao_preco_serv_w.ie_tipo_atendimento	:= 'A';
			
			CALL pls_smp_pck.gerar_regra_preco_servico(regra_simulacao_p, nm_usuario_p, regra_simulacao_preco_serv_w);			
			
		end loop; -- Prestadores e Procedimentos 
	end loop; -- Beneficiarios
end if; -- Fim existe simulacao
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_smp_pck.gerar_precos_servico ( regra_simulacao_p pls_smp_pck.regra_simulacao, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;