-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_entao_regra_preco_cta_pck.obter_valor_proced ( vl_custo_operacional_p pls_conta_proc.vl_custo_operacional%type, vl_anestesista_p pls_conta_proc.vl_anestesista%type, vl_medico_p pls_conta_proc.vl_medico%type, vl_filme_p preco_tuss.vl_filme%type, vl_auxiliares_p pls_conta_proc.vl_auxiliares%type) RETURNS bigint AS $body$
DECLARE


vl_procedimento_w	pls_conta_proc.vl_procedimento%type;


BEGIN

-- soma os valores para formar o valor do procedimento. Colocado nvl por segurança, caso seja feita alguma alteração
-- onde possa chegar null neste ponto, não irá prejudicar a function
vl_procedimento_w := coalesce(vl_custo_operacional_p,0) + coalesce(vl_anestesista_p,0) +
			coalesce(vl_medico_p,0) +  coalesce(vl_filme_p,0) + coalesce(vl_auxiliares_p,0);
						
return vl_procedimento_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_entao_regra_preco_cta_pck.obter_valor_proced ( vl_custo_operacional_p pls_conta_proc.vl_custo_operacional%type, vl_anestesista_p pls_conta_proc.vl_anestesista%type, vl_medico_p pls_conta_proc.vl_medico%type, vl_filme_p preco_tuss.vl_filme%type, vl_auxiliares_p pls_conta_proc.vl_auxiliares%type) FROM PUBLIC;