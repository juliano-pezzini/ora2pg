-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_se_permite_copartic ( param_1_p text, ie_calculo_coparticipacao_p text, ie_retorno_p INOUT text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Verificar se é permitido salvar esta configuração utilizado, na função corpls_fx o item só poderá ser salvo se o parametro ie_geracao_coparticipacao estiver como F ou então estiver como C e o ie_calculo_coparticipacao estiver como 'O' ou 'R'
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_retorno_w	varchar(1) := 'S';

BEGIN

	ie_retorno_w := 'S';


ie_retorno_p := ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_se_permite_copartic ( param_1_p text, ie_calculo_coparticipacao_p text, ie_retorno_p INOUT text) FROM PUBLIC;

