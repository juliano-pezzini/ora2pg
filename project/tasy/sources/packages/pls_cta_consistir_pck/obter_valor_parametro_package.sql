-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--'S' =  o sistema ir_ verificar se a glosa lan_ada para o item impede ou n_o o fechamento da conta. 

--Caso n_o permita, o sistema despreza a situa__o da glosa e n_o permite o fechamento da conta.

--'N' o sistema ir_ verificar se a glosa lan_ada para o item impede ou n_o o fechamento da conta. Caso n_o permita, 

--o sistema verifica a situa__o da glosa. Caso a glosa esteja inativa, o sistema permite o fechamento da conta.



CREATE OR REPLACE FUNCTION pls_cta_consistir_pck.obter_valor_parametro (cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_tipo_parametro_p text) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(5);
	

BEGIN
--Obter par_metro de acordo com o ie_tipo_parametro informado

if (ie_tipo_parametro_p = 'F') then	
	select	ie_fechar_conta_glosa
	into STRICT	ie_retorno_w
	from	table(pls_parametros_pck.f_retorna_param(cd_estabelecimento_p));
elsif (ie_tipo_parametro_p = 'A') then
	select	ie_analise_cm_nova
	into STRICT	ie_retorno_w
	from	table(pls_parametros_pck.f_retorna_param(cd_estabelecimento_p));
elsif (ie_tipo_parametro_p = 'G') then
	select ie_atualizar_grupo_ans
	into STRICT	ie_retorno_w
	from	table(pls_parametros_pck.f_retorna_param(cd_estabelecimento_p));
end if;

return ie_retorno_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_cta_consistir_pck.obter_valor_parametro (cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_tipo_parametro_p text) FROM PUBLIC;