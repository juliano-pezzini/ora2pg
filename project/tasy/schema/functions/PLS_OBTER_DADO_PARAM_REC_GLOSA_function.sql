-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dado_param_rec_glosa ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Retorna os parametros em Gestão de operadoras, para o recurso de glosa
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  X] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
-------------------------------------------------------------------------------------------------------------------
Referências:

Opções:
	II	- Integra ao importar o XML
	AP	- Agrupar protocolo importado via Uploado de XML, no lote mais recente e pendente do usuario
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w	varchar(500) := '';

BEGIN

if (ie_opcao_p = 'II') then

	select	coalesce(max(a.ie_integrar_imp), 'S')
	into STRICT	ds_retorno_w
	from	pls_parametros_rec_glosa	a
	where	a.cd_estabelecimento		= cd_estabelecimento_p;

elsif (ie_opcao_p = 'AP') then

	select	coalesce(max(a.ie_agrupar_lote_imp), 'N')
	into STRICT	ds_retorno_w
	from	pls_parametros_rec_glosa	a
	where	a.cd_estabelecimento		= cd_estabelecimento_p;

end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dado_param_rec_glosa ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_opcao_p text) FROM PUBLIC;

