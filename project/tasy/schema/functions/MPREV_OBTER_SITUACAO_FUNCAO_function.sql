-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mprev_obter_situacao_funcao ( dt_inclusao_p timestamp, dt_exclusao_p timestamp, dt_referencia_p timestamp, ie_descricao_p text) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Obter a situação da função de acordo com a date de inclusão e exclusão em relação a data de referencia.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção: S - Completa
	           N - Caracter inicial
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_retorno_w	dic_expressao.DS_EXPRESSAO_BR%type;

BEGIN
	if (dt_referencia_p between dt_inclusao_p and coalesce(dt_exclusao_p, dt_referencia_p)) then
		if ('S' = ie_descricao_p) then
			ie_retorno_w := Wheb_mensagem_pck.get_texto(308804); --'Ativo';
		else
			ie_retorno_w := 'A';
		end if;
	else
		if ('S' = ie_descricao_p) then
			ie_retorno_w := Wheb_mensagem_pck.get_texto(308807); --'Inativo';
		else
			ie_retorno_w := 'I';
		end if;
	end if;
return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mprev_obter_situacao_funcao ( dt_inclusao_p timestamp, dt_exclusao_p timestamp, dt_referencia_p timestamp, ie_descricao_p text) FROM PUBLIC;

