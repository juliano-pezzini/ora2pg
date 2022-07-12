-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_se_grupo_preco_doenca ( nr_seq_grupo_doenca_p bigint, cd_doenca_cid_p text) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Function Utilizada para obter se a doenca está vinculada a algum grupo na pasta Cadastros em OPS - Regras e Critérios de Preço
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ x] Tasy (Delphi/Java) [ x] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção: Retorno : S se sim N se não
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_regra_w			bigint;
ds_retorno_w			varchar(10)	:= 'N';
C01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_preco_grupo_doenca	a,
		pls_preco_doenca	b
	where	a.nr_sequencia		= b.nr_seq_grupo
	and	a.ie_situacao		= 'A'
	and	a.nr_sequencia		= nr_seq_grupo_doenca_p
	and	((b.cd_doenca_cid	= cd_doenca_cid_p)	or (coalesce(b.cd_doenca_cid::text, '') = ''));

BEGIN
open C01;
loop
fetch C01 into
	nr_seq_regra_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;

if (coalesce(nr_seq_regra_w,0)	<> 0) then
	ds_retorno_w	:= 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_se_grupo_preco_doenca ( nr_seq_grupo_doenca_p bigint, cd_doenca_cid_p text) FROM PUBLIC;

