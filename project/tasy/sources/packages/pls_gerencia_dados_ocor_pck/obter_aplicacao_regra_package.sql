-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_gerencia_dados_ocor_pck.obter_aplicacao_regra ( dados_regra_p pls_tipos_ocor_pck.dados_regra) RETURNS PLS_OC_CTA_TIPO_VALIDACAO.IE_APLICACAO_OCORRENCIA%TYPE AS $body$
DECLARE

				 
ie_tipo_aplicacao_ocor_w	pls_oc_cta_tipo_validacao.ie_aplicacao_ocorrencia%type;	
ie_ocorrencia_conta_w		pls_combinacao_item_cta.ie_ocorrencia_conta%type;			

BEGIN 
 
ie_tipo_aplicacao_ocor_w := null;
 
case(dados_regra_p.ie_validacao) 
-- se for validação de itens simultâneos/concorrentes busca a geração da ocorrência no cadastro da regra externa 
when 32 then 
	begin 
 
	select	max(ie_ocorrencia_conta) 
	into STRICT	ie_ocorrencia_conta_w 
	from	pls_oc_cta_val_comb_item a, 
		pls_combinacao_item_cta b 
	where 	a.nr_seq_oc_cta_comb 	= dados_regra_p.nr_sequencia 
	and	b.nr_sequencia		= a.nr_seq_combinacao_item;
	 
	-- se o campo dizer que é para gerar por conta faremos isto 
	if (ie_ocorrencia_conta_w = 'S') then 
		ie_tipo_aplicacao_ocor_w := 'C';
	end if;
	 
	end;
else 
	ie_tipo_aplicacao_ocor_w := dados_regra_p.ie_aplicacao_ocorrencia;
end case;
 
-- se não for definido nada acima, pega o padrão que está cadastrado na regra da ocorrência 
if (coalesce(ie_tipo_aplicacao_ocor_w::text, '') = '') then 
	ie_tipo_aplicacao_ocor_w := dados_regra_p.ie_aplicacao_ocorrencia;
end if;
 
return ie_tipo_aplicacao_ocor_w;
 
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_gerencia_dados_ocor_pck.obter_aplicacao_regra ( dados_regra_p pls_tipos_ocor_pck.dados_regra) FROM PUBLIC;