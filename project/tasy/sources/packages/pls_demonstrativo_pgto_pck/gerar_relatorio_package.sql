-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_demonstrativo_pgto_pck.gerar_relatorio ( nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_rec_p pls_rec_glosa_protocolo.nr_sequencia%type, nr_seq_prestador_p pls_prestador.nr_sequencia%type, nr_seq_usuario_web_p pls_regra_demons_pagto.nr_seq_usuario%type, dt_pagamento_p pls_rel_pag_prestador.dt_pagamento%type, dt_competencia_p pls_rel_pag_prestador.dt_competencia%type, nr_seq_lote_p pls_lote_pagamento.nr_sequencia%type, cpf_prestador_p pls_rel_pag_prestador.cpf_prestador%type, cnpj_prestador_p pls_rel_pag_prestador.cnpj_prestador%type, ie_tipo_demonstrativo_p pls_rel_pag_prestador.ie_tipo_demonstrativo%type, cd_prestador_p pls_rel_pag_prestador.cd_prestador%type, ie_gerar_p text, nm_usuario_p usuario.nm_usuario%type, ie_funcao_pagamento_p pls_parametro_pagamento.ie_funcao_pagamento%type, nr_seq_relatorio_p INOUT pls_rel_pag_prestador.nr_sequencia%type) AS $body$
DECLARE

				
ie_gerar_deb_cred_w			pls_regra_demons_pagto.ie_gerar_deb_cred%type := 'S';
nr_seq_prestador_atend_w	pls_protocolo_conta.nr_seq_prestador%type;
ie_valor_processado_w		pls_regra_demons_pagto.ie_valor_processado%type := 'S';
ie_valor_bruto_w			pls_regra_demons_pagto.ie_valor_bruto%type;

c01 CURSOR(	nr_seq_prestador_pc		pls_regra_demons_pagto.nr_seq_prestador_pgto%type,
		nr_seq_prestador_atend_pc	pls_regra_demons_pagto.nr_seq_prestador_atend%type,
		nr_seq_usuario_web_pc		pls_regra_demons_pagto.nr_seq_usuario%type) FOR		
	SELECT	coalesce(a.ie_gerar_deb_cred,'S') ie_gerar_deb_cred,
		coalesce(a.ie_valor_processado,'S') ie_valor_processado,
		coalesce(a.ie_valor_bruto,'N') ie_valor_bruto
	from	pls_regra_demons_pagto a
	where	coalesce(a.nr_seq_prestador_pgto,nr_seq_prestador_pc) = nr_seq_prestador_pc
	and	coalesce(coalesce(a.nr_seq_prestador_atend,nr_seq_prestador_atend_pc),0) = coalesce(coalesce(nr_seq_prestador_atend_pc,a.nr_seq_prestador_atend),0)
	and	coalesce(coalesce(a.nr_seq_usuario,nr_seq_usuario_web_pc),0) = coalesce(coalesce(nr_seq_usuario_web_pc,a.nr_seq_usuario),0)
	order by coalesce(a.nr_seq_prestador_pgto,1),
		coalesce(a.nr_seq_usuario,1),
		coalesce(a.nr_seq_prestador_atend,1),
		CASE WHEN coalesce(a.ie_gerar_deb_cred,'S')='N' THEN 1  ELSE 0 END ,
		CASE WHEN coalesce(a.ie_valor_processado,'S')='N' THEN 1  ELSE 0 END ,
		CASE WHEN coalesce(a.ie_valor_bruto,'N')='S' THEN 1  ELSE 0 END;--nesse campo o default e N, prioriza quando for S, entao decodifica S como 1 para ser executado por ultimo;
	

cd_estabelecimento_w estabelecimento.cd_estabelecimento%type;
ie_funcao_pagamento_w PLS_PARAMETRO_PAGAMENTO.Ie_Funcao_Pagamento%type;

BEGIN

if (coalesce(nr_seq_prestador_p::text, '') = '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(438687);
end if;

/*Busca o estabelecimento da operadora*/


select	max(cd_estabelecimento)
into STRICT	cd_estabelecimento_w
from	pls_web_param_geral;

/*Caso nao tiver, busca da outorgante*/


if (coalesce(cd_estabelecimento_w::text, '') = '') then
	select	max(cd_estabelecimento)
	into STRICT	cd_estabelecimento_w
	from	pls_outorgante;
end if;

if (cd_estabelecimento_w IS NOT NULL AND cd_estabelecimento_w::text <> '') then
	select	pls.ie_funcao_pagamento
	into STRICT	ie_funcao_pagamento_w
	from	pls_parametro_pagamento	pls
	where	pls.cd_estabelecimento	= cd_estabelecimento_w;
end if;

for r_C01_w in C01( nr_seq_prestador_p, nr_seq_prestador_atend_w, nr_seq_usuario_web_p ) loop
	ie_gerar_deb_cred_w   	:= r_C01_w.ie_gerar_deb_cred;
	ie_valor_processado_w	:= r_C01_w.ie_valor_processado;
	ie_valor_bruto_w	:= r_c01_w.ie_valor_bruto;
end loop;

-- verifica se ja existe relatorio conforme o filtro buscado

if (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') then
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_relatorio_p
	from	pls_rel_pag_prestador a
	where	a.nr_seq_prestador = nr_seq_prestador_p
	and	a.nr_seq_protocolo = nr_seq_protocolo_p
	and	a.ie_funcao_pagamento = coalesce(ie_funcao_pagamento_p,ie_funcao_pagamento_w,ie_funcao_pagamento);
	
	select	max(nr_seq_prestador)
	into STRICT	nr_seq_prestador_atend_w
	from	pls_protocolo_conta
	where	nr_sequencia = nr_seq_protocolo_p;
	
elsif (nr_seq_protocolo_rec_p IS NOT NULL AND nr_seq_protocolo_rec_p::text <> '') then
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_relatorio_p
	from	pls_rel_pag_prestador a
	where	a.nr_seq_prestador = nr_seq_prestador_p
	and	a.nr_seq_protocolo_rec = nr_seq_protocolo_rec_p
	and	a.ie_funcao_pagamento = coalesce(ie_funcao_pagamento_p,ie_funcao_pagamento_w,ie_funcao_pagamento);
	
elsif (dt_pagamento_p IS NOT NULL AND dt_pagamento_p::text <> '') then
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_relatorio_p
	from	pls_rel_pag_prestador a
	where	a.nr_seq_prestador = nr_seq_prestador_p
	and	a.dt_pagamento = dt_pagamento_p
	and	a.ie_funcao_pagamento = coalesce(ie_funcao_pagamento_p,ie_funcao_pagamento_w,ie_funcao_pagamento);
	
elsif (dt_competencia_p IS NOT NULL AND dt_competencia_p::text <> '') then
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_relatorio_p
	from	pls_rel_pag_prestador a
	where	a.nr_seq_prestador = nr_seq_prestador_p
	and	a.dt_competencia = dt_competencia_p
	and	a.ie_funcao_pagamento = coalesce(ie_funcao_pagamento_p,ie_funcao_pagamento_w,ie_funcao_pagamento);
	
elsif (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_relatorio_p
	from	pls_rel_pag_prestador a
	where	a.nr_seq_prestador = nr_seq_prestador_p
	and	a.nr_seq_lote_pgto = nr_seq_lote_p
	and	a.ie_funcao_pagamento = coalesce(ie_funcao_pagamento_p,ie_funcao_pagamento_w,ie_funcao_pagamento);
end if;

if (ie_gerar_p = 'S') then
	if (coalesce(nr_seq_relatorio_p::text, '') = '') then
		insert into pls_rel_pag_prestador(
				nr_sequencia, nm_usuario, dt_atualizacao,
				nm_usuario_nrec, dt_atualizacao_nrec, nr_seq_prestador,
				nr_seq_protocolo, nr_seq_protocolo_rec, dt_pagamento,
				dt_competencia, nr_seq_lote_pgto, cpf_prestador,
				cnpj_prestador, ie_tipo_demonstrativo, cd_prestador,
				ie_funcao_pagamento, ie_gerar_deb_cred, ie_valor_processado,
				ie_valor_bruto
		) values (
				nextval('pls_rel_pag_prestador_seq'), nm_usuario_p, clock_timestamp(),
				nm_usuario_p, clock_timestamp(), nr_seq_prestador_p,
				nr_seq_protocolo_p, nr_seq_protocolo_rec_p, dt_pagamento_p,
				dt_competencia_p, nr_seq_lote_p, cpf_prestador_p,
				cnpj_prestador_p, ie_tipo_demonstrativo_p, cd_prestador_p,
				coalesce(ie_funcao_pagamento_p,ie_funcao_pagamento_w,'1'), ie_gerar_deb_cred_w, ie_valor_processado_w,
				ie_valor_bruto_w
		) returning nr_sequencia into nr_seq_relatorio_p;
		commit;
	else
		update	pls_rel_pag_prestador	a
		set	a.ie_gerar_deb_cred 	= ie_gerar_deb_cred_w,
			a.ie_valor_processado 	= ie_valor_processado_w,
			a.ie_valor_bruto	= ie_valor_bruto_w
		where	a.nr_sequencia 		= nr_seq_relatorio_p;
		commit;
	end if;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_demonstrativo_pgto_pck.gerar_relatorio ( nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_rec_p pls_rec_glosa_protocolo.nr_sequencia%type, nr_seq_prestador_p pls_prestador.nr_sequencia%type, nr_seq_usuario_web_p pls_regra_demons_pagto.nr_seq_usuario%type, dt_pagamento_p pls_rel_pag_prestador.dt_pagamento%type, dt_competencia_p pls_rel_pag_prestador.dt_competencia%type, nr_seq_lote_p pls_lote_pagamento.nr_sequencia%type, cpf_prestador_p pls_rel_pag_prestador.cpf_prestador%type, cnpj_prestador_p pls_rel_pag_prestador.cnpj_prestador%type, ie_tipo_demonstrativo_p pls_rel_pag_prestador.ie_tipo_demonstrativo%type, cd_prestador_p pls_rel_pag_prestador.cd_prestador%type, ie_gerar_p text, nm_usuario_p usuario.nm_usuario%type, ie_funcao_pagamento_p pls_parametro_pagamento.ie_funcao_pagamento%type, nr_seq_relatorio_p INOUT pls_rel_pag_prestador.nr_sequencia%type) FROM PUBLIC;
