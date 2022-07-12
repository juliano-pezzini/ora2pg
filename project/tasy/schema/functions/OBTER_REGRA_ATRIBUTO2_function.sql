-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_atributo2 ( nm_tabela_p text, nm_atributo_p text, nr_seq_visao_p bigint, ie_opcao_p text, cd_estabelecimento_p bigint, cd_perfil_p bigint, cd_funcao_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


qt_tam_max_p	integer;
qt_tam_min_p	integer;
ds_atributo_w	varchar(2000);
ds_retorno_w	varchar(4000);
vl_default_w	varchar(2000);
vl_default_nulo_w	tabela_atrib_regra.ie_padrao_nulo%type;

C01 CURSOR FOR
	SELECT	qt_tam_max,
		ds_atributo,
		vl_default,
		qt_tam_min,
		coalesce(ie_padrao_nulo, 'N')
	from	tabela_atrib_regra
	where	nm_tabela 		= nm_tabela_p
	and	nm_atributo 		= nm_atributo_p
	and	coalesce(cd_estabelecimento,	cd_estabelecimento_p)	= cd_estabelecimento_p
	and	coalesce(cd_perfil, 		cd_perfil_p)		= cd_perfil_p
	and	coalesce(cd_funcao, 		cd_funcao_p)		= cd_funcao_p
	and	coalesce(nm_usuario_param, 	nm_usuario_p) 		= nm_usuario_p
	and	coalesce(nr_seq_visao, 	nr_seq_visao_p)		= nr_seq_visao_p
	order by
		coalesce(nm_usuario_param,'AAAAAAAA'), 
		coalesce(cd_perfil,0),
		coalesce(cd_estabelecimento,0), 
		coalesce(cd_funcao,0), 
		coalesce(nr_seq_visao,0), 
		coalesce(nr_seq_regra_funcao,0);


BEGIN

open C01;
loop
	fetch C01 into
		qt_tam_max_p,
		ds_atributo_w,
		vl_default_w,
		qt_tam_min_p,
		vl_default_nulo_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */		
end loop;
close C01;

if (ie_opcao_p = 'QTM') then
	ds_retorno_w	:= qt_tam_max_p;
elsif (ie_opcao_p = 'QTMIN') then
	ds_retorno_w	:= qt_tam_min_p;	
elsif (ie_opcao_p = 'DESC') then
	ds_retorno_w	:= ds_atributo_w;
elsif (ie_opcao_p = 'VLD') then
	ds_retorno_w	:= vl_default_w;	
elsif (ie_opcao_p = 'VLN') then
	ds_retorno_w	:= vl_default_nulo_w;	
end	if;

return	ds_retorno_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_atributo2 ( nm_tabela_p text, nm_atributo_p text, nr_seq_visao_p bigint, ie_opcao_p text, cd_estabelecimento_p bigint, cd_perfil_p bigint, cd_funcao_p bigint, nm_usuario_p text) FROM PUBLIC;
