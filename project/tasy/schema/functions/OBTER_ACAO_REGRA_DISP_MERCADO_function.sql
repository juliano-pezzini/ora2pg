-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_acao_regra_disp_mercado ( cd_evento_p text, cd_material_p bigint, cd_local_estoque_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
/* Retorno 
 N - Não existe Regra 
 C - Consiste 
 M - Somente Avisa 
*/
 
ie_retorno_w			varchar(1) := 'N';

ie_consiste_disp_mercado_w		varchar(1) := 'N';

/* Shift + F11 = Regra para consistência do item disp. mercado */
 
qt_existe_regra_w			bigint;
nr_seq_regra_w			bigint := 0;
ie_acao_w			varchar(15);

/* Cadastro Material */
 
ie_disp_mercado_w			varchar(1);


BEGIN 
 
select	coalesce(substr(Obter_Dados_Material(cd_material_p, 'MCD'),1,1),'X') ie_disponivel_mercado 
into STRICT	ie_disp_mercado_w
;
 
select	coalesce(max(nr_sequencia),0) 
into STRICT	nr_seq_regra_w 
from	consiste_disp_mercado 
where	cd_evento = cd_evento_p 
and	((ie_disponivel_mercado = ie_disp_mercado_w) or (coalesce(ie_disponivel_mercado::text, '') = ''));
 
if (nr_seq_regra_w > 0) then 
	begin 
 
	/* Ação da regra C - Consiste; M - Somente Avisa */
 
	select	max(coalesce(ie_acao, 'C')) ie_acao 
	into STRICT	ie_acao_w 
	from	consiste_disp_mercado 
	where	nr_sequencia = nr_seq_regra_w;
 
	select	obter_consiste_disp_material(cd_material_p, cd_local_estoque_p, cd_estabelecimento_p) 
	into STRICT	ie_consiste_disp_mercado_w 
	;
 
	/* Retorno recebe a ação que a regra possui */
 
	if (ie_consiste_disp_mercado_w = 'S') then 
		ie_retorno_w := ie_acao_w;
	end if;
 
	end;
end if;
 
return	ie_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_acao_regra_disp_mercado ( cd_evento_p text, cd_material_p bigint, cd_local_estoque_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
