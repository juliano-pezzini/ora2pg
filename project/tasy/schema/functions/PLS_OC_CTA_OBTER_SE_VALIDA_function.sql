-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_oc_cta_obter_se_valida ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_seq_conta_p bigint, nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint) RETURNS PLS_TIPOS_OCOR_PCK.RET_VALID AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Verificar se a conta ou item se encaixam na regra de validação associada
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
ATOMIZAÇÃO. Não ficar fazendo tratamentos e selects internos, apenas chamar a procedure
de cada validação aqui
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
retorno_w	pls_tipos_ocor_pck.ret_valid;


BEGIN
retorno_w.nr_sequencia		:= null;
retorno_w.ie_aplicavel		:= 'N';
retorno_w.ie_gera_ocorrencia	:= 'S';

if (dados_regra_p.nr_sequencia > 0) then
	/* Somente filtros */

	if (dados_regra_p.ie_validacao = 1) then
		retorno_w.nr_sequencia		:= null;
		retorno_w.ie_aplicavel		:= 'N';
		retorno_w.ie_gera_ocorrencia	:= 'S';
	/* Validar sexo exclusivo do procedimento */

	elsif (dados_regra_p.ie_validacao = 2) then
		retorno_w	:= pls_oc_cta_obter_val_cart(dados_regra_p,nr_seq_conta_p);
	/* Validar carteirinha */

	elsif (dados_regra_p.ie_validacao = 3) then
		retorno_w	:= pls_oc_cta_obter_val_sexo_exc(dados_regra_p,nr_seq_conta_proc_p);
	end if;
end if;

return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_oc_cta_obter_se_valida ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_seq_conta_p bigint, nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint) FROM PUBLIC;

