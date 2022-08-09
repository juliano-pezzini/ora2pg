-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_limpar_base_contratos ( nr_seq_contrato_p bigint) AS $body$
BEGIN
 
delete	from	pls_lote_consistencia_sib 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado	 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete	from	pls_segurado_cart_ant 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado	 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete	from	pls_carteira_leitura 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado	 
				where	nr_seq_contrato		= nr_seq_contrato_p);
				 
delete	from	pls_segurado_compl 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado	 
				where	nr_seq_contrato		= nr_seq_contrato_p);
				 
delete	from	pls_segurado_preco 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete	from	pls_segurado_preco_origem 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete	from	pls_segurado_sib 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete	from	pls_comercial_cliente	 
where	nr_seq_solicitacao in (	SELECT	nr_sequencia 
				from	pls_solicitacao_comercial 
				where	nr_seq_segurado	in (	select	nr_sequencia 
								from	pls_segurado 
								where	nr_seq_contrato		= nr_seq_contrato_p));
 
delete	from	pls_criterio_acrescimo 
where	nr_seq_regra	in (	SELECT	nr_sequencia 
				from	pls_regra_acrescimo 
				where (nr_seq_segurado in (	select	nr_sequencia 
								from	pls_segurado	 
								where	nr_seq_contrato		= nr_seq_contrato_p) 
				or	nr_seq_contrato	= nr_seq_contrato_p));
				 
delete	FROM pls_mensalidade_seg_item 
where	NR_SEQ_MENSALIDADE_SEG	in (	SELECT	nr_sequencia 
					from	PLS_MENSALIDADE_SEGURADO 
					where	nr_seq_segurado	in (	select	nr_sequencia 
									from	pls_segurado	 
									where	nr_seq_contrato		= nr_seq_contrato_p));
delete	FROM PLS_MENSALIDADE_SEGURADO 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado	 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete	from	pls_regra_acrescimo 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado	 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete	from	pls_solicitacao_comercial 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado	 
				where	nr_seq_contrato		= nr_seq_contrato_p);
				 
delete	from	pls_bonificacao_vinculo 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado	 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete	from	pls_sca_vinculo 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado	 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete	from	pls_carencia 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado	 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete	from	pls_margem_beneficiario 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado	 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete	from	pls_ocorrencia_benef 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado	 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete	from	pls_alerta 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado	 
				where	nr_seq_contrato		= nr_seq_contrato_p);
				 
delete	from	w_pls_benef_movto_mensal 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado	 
				where	nr_seq_contrato		= nr_seq_contrato_p);
				 
delete	from	pls_segurado_agravo 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado	 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete	from	pls_segurado_repasse 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado	 
				where	nr_seq_contrato		= nr_seq_contrato_p);
delete	from	pls_segurado_mensalidade 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado	 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete	from	pls_rescisao_contrato 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado	 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete	from	sip_beneficiario_exposto 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado	 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete	from	sib_log_exclusao 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado	 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete	from	pls_mensalidade_sca 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado	 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete	from	pls_lote_consistencia_sib 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado	 
				where	nr_seq_contrato		= nr_seq_contrato_p);
				 
delete	from	pls_segurado_historico 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado	 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete	from	pls_alerta 
where	nr_seq_contrato	= nr_seq_contrato_p;
 
update	pls_conta 
set	nr_seq_segurado 	 = NULL 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado	 
				where	nr_seq_contrato		= nr_seq_contrato_p);
				 
update	pls_conta 
set	NR_SEQ_ATENDIMENTO 	 = NULL 
where	NR_SEQ_ATENDIMENTO	in (	SELECT	nr_sequencia 
					from	PLS_CONTA_ATENDIMENTO 
					where	nr_seq_segurado	in (	select	nr_sequencia 
									from	pls_segurado	 
									where	nr_seq_contrato		= nr_seq_contrato_p));
update	pls_conta_mat 
set	nr_seq_atend_item	 = NULL 
where	nr_seq_atend_item	in (	SELECT	nr_sequencia 
					from	pls_conta_atend_item 
					where	nr_seq_atendimento	in (	select	nr_sequencia 
										from	pls_conta_atendimento 
										where	nr_seq_segurado	in (	select	nr_sequencia 
														from	pls_segurado	 
														where	nr_seq_contrato		= nr_seq_contrato_p)));
														 
update	PLS_CONTA_PROC 
set	nr_seq_atend_item	 = NULL 
where	nr_seq_atend_item	in (	SELECT	nr_sequencia 
					from	pls_conta_atend_item 
					where	nr_seq_atendimento	in (	select	nr_sequencia 
										from	pls_conta_atendimento 
										where	nr_seq_segurado	in (	select	nr_sequencia 
														from	pls_segurado	 
														where	nr_seq_contrato		= nr_seq_contrato_p)));
														 
delete	FROM pls_conta_atend_item 
where	nr_seq_atendimento	in (	SELECT	nr_sequencia 
					from	pls_conta_atendimento 
					where	nr_seq_segurado	in (	select	nr_sequencia 
									from	pls_segurado	 
									where	nr_seq_contrato		= nr_seq_contrato_p));
				 
delete	FROM PLS_CONTA_ATENDIMENTO 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado	 
				where	nr_seq_contrato		= nr_seq_contrato_p);
				 
update	w_pls_resumo_conta 
set	nr_seq_segurado  = NULL 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado	 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
update	pls_segurado 
set	nr_seq_pagador	 = NULL 
where	nr_seq_contrato = nr_seq_contrato_p;
 
update	pls_segurado 
set	nr_seq_subestipulante	 = NULL 
where	nr_seq_contrato = nr_seq_contrato_p;
 
update	pls_segurado 
set	nr_seq_segurado_mig	 = NULL, 
	nr_seq_pagador	 = NULL 
where	nr_seq_contrato = nr_seq_contrato_p;
 
update	pls_segurado 
set	nr_seq_segurado_mig	 = NULL 
where	nr_seq_segurado_mig	in (	SELECT	nr_sequencia 
					from	pls_segurado 
					where	nr_seq_contrato	= nr_seq_contrato_p);
 
delete	from	pls_segurado_cart_estagio 
where	nr_seq_cartao_seg in (	SELECT	nr_sequencia 
					from	pls_segurado_carteira 
					where	nr_seq_segurado		in (	select	nr_sequencia 
									from		pls_segurado 
									where		nr_seq_contrato		= nr_seq_contrato_p));
 
delete	from	pls_carteira_emissao	 
where	nr_seq_seg_carteira in (	SELECT	nr_sequencia 
					from	pls_segurado_carteira 
					where	nr_seq_segurado		in (	select	nr_sequencia 
									from		pls_segurado 
									where		nr_seq_contrato		= nr_seq_contrato_p));
 
delete	from	pls_segurado_carteira 
where	nr_seq_segurado	in (	SELECT	nr_sequencia 
				from	pls_segurado 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete	from	pls_segurado 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
				 
delete	from	pls_contrato_contato 
where	nr_seq_contrato		= nr_seq_contrato_p;
	 
update	pls_beneficiario_internado 
set	nr_seq_contrato  = NULL 
where	nr_seq_contrato = nr_seq_contrato_p;	
 
delete	from	pls_carencia 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
delete	from	pls_cobertura 
where	nr_seq_contrato		= nr_seq_contrato_p;
	 
delete	from	pls_contrato_doc_arq 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
delete	from	pls_contrato_doc_texto 
where	nr_seq_documento in (	SELECT nr_sequencia 
				from	pls_contrato_documento 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete	from	pls_contrato_documento 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
delete	from	pls_contrato_historico 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
delete	from	pls_contrato_plano 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
update	pls_contrato_vendedor 
set	nr_seq_contrato		 = NULL 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
update	pls_declaracao_segurado 
set	nr_seq_contrato		 = NULL 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
delete	from	pls_estipulante_web 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
update	pls_inclusao_beneficiario 
set	nr_seq_contrato		 = NULL 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
delete	FROM PLS_LIMITACAO_PRESTADOR 
where	nr_seq_limitacao	in (	SELECT	nr_sequencia 
					from	pls_limitacao 
					where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete	from	pls_limitacao 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
update	pls_lote_consistencia_sib 
set	nr_seq_contrato		 = NULL 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
update	pls_lote_reaj_segurado 
set	nr_seq_contrato		 = NULL 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
delete	from	pls_reajuste 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
delete	from	pls_reajuste_tabela 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
update	pls_regra_agrup_contrato 
set	nr_seq_contrato		 = NULL 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
delete	from	pls_regra_coparticipacao 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
delete	from	pls_regra_desconto 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
delete	from	pls_regra_inscricao 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
update	pls_regra_mensalidade 
set	nr_seq_contrato		 = NULL 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
delete	from	pls_regra_mens_contrato 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
delete	from	pls_regra_pos_estabelecido 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
update	pls_regra_preco_mat 
set	nr_seq_contrato		 = NULL 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
update	pls_regra_preco_proc 
set	nr_seq_contrato		 = NULL 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
update	pls_regra_preco_servico 
set	nr_seq_contrato		 = NULL 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
delete	from	pls_rescisao_contrato 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
delete	from	pls_contrato_grupo 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
delete	FROM pls_regra_conta_compl 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
delete FROM PLS_CONTRATO_REGRA_REPASSE 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
begin 
update	pls_resultado 
set	nr_seq_contrato		 = NULL 
where	nr_seq_contrato		= nr_seq_contrato_p;
exception 
when others then 
	delete	from pls_resultado 
	where	nr_seq_contrato		= nr_seq_contrato_p;
end;
 
update	pls_simulacao_preco 
set	nr_seq_contrato		 = NULL 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
 
DELETE	FROM pls_sub_estipulante 
where	nr_seq_contrato		= nr_seq_contrato_p;	
 
update	pls_tabela_preco 
set	nr_contrato		 = NULL 
where	nr_contrato		= nr_seq_contrato_p;
 
delete	FROM pls_bonificacao_vinculo 
where	nr_seq_contrato	= nr_seq_contrato_p;
 
delete	FROM pls_sca_regra_contrato 
where	nr_seq_contrato	= nr_seq_contrato_p;
 
delete	FROM pls_regra_inclusao_benef 
where	nr_seq_contrato	= nr_seq_contrato_p;
 
delete	FROM pls_carteira_renovacao 
where	nr_seq_contrato	= nr_seq_contrato_p;
 
delete	FROM pls_extensao_area 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
delete	FROM pls_contrato_regra_lanc 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
delete	FROM pls_regra_acrescimo 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
delete FROM PLS_REGRA_CARENCIA_ISENCAO 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
delete	from	pls_rescisao_contrato 
where	nr_seq_pagador in (	SELECT	nr_sequencia 
				from	pls_contrato_pagador 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete	from	pls_pagador_historico 
where	nr_seq_pagador in (	SELECT	nr_sequencia 
				from	pls_contrato_pagador 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete	from	pls_bonificacao_vinculo 
where	nr_seq_pagador in (	SELECT	nr_sequencia 
				from	pls_contrato_pagador 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete	from	pls_contrato_pagador_fin 
where	nr_seq_pagador in (	SELECT	nr_sequencia 
				from	pls_contrato_pagador 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete from pls_mensalidade_log 
where	nr_seq_pagador in (	SELECT	nr_sequencia 
				from	pls_contrato_pagador 
				where	nr_seq_contrato		= nr_seq_contrato_p);
 
delete	from	pls_contrato_pagador 
where	nr_seq_contrato		= nr_seq_contrato_p;
 
delete	from	pls_contrato 
where	nr_contrato_principal	= nr_seq_contrato_p;
 
delete	from	pls_contrato 
where	nr_sequencia		= nr_seq_contrato_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_limpar_base_contratos ( nr_seq_contrato_p bigint) FROM PUBLIC;
