-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_uti_nivel_lib_aut (cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Verificar na função OPS - Gestão de Operadoras > Parâmetros da OPS > Análise de autorizações se a operadora irá utilizar níveis de liberação na análsie de autorizações.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção: Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w		varchar(1) := 'N';


BEGIN

begin
	select	ie_utiliza_nivel
	into STRICT	ds_retorno_w
	from	pls_param_analise_aut
	where	cd_estabelecimento = cd_estabelecimento_p;
exception
when others then
	ds_retorno_w := 'N';
end;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_uti_nivel_lib_aut (cd_estabelecimento_p bigint) FROM PUBLIC;

