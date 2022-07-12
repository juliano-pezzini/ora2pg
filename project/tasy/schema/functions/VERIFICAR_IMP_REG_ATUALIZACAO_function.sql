-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION verificar_imp_reg_atualizacao (nm_owner_p text, ie_aplicacao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(4000) := '';
nm_tabela_w		varchar(50);
qt_registros_w		bigint;
qt_base_qtd_registros_w bigint;

C01 CURSOR FOR
	SELECT	table_name
	from	user_tables ut, tabela_sistema ts
	where	ts.nm_tabela = ut.table_name
	and	ts.ie_exportar = 'S'
	and	upper(ut.table_name) in ('INDICE','INDICE_ATRIBUTO','INTEGRIDADE_ATRIBUTO','INTEGRIDADE_REFERENCIAL','OBJETO_SISTEMA_PARAM','FUNCAO_PARAMETRO');


BEGIN

open C01;
loop
fetch C01 into
	nm_tabela_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	--Busca a quantidade da registros base para realizar a comparação no final
	if ('INDICE' = upper(nm_tabela_w)) then
		begin
		--Total de registros em 07/11/2014 = 51629
		select	coalesce(count(*) - 1000,50000)
		into STRICT	qt_base_qtd_registros_w
		from	indice;

		end;
	elsif ('INDICE_ATRIBUTO' = upper(nm_tabela_w)) then
		begin
		--Total de registros em 07/11/2014 = 55791
		select	coalesce(count(*) - 1000,54000)
		into STRICT	qt_base_qtd_registros_w
		from	indice_atributo;

		end;
	elsif ('INTEGRIDADE_ATRIBUTO' = upper(nm_tabela_w)) then
		begin
		--Total de registros em 07/11/2014 = 37634
		select	coalesce(count(*) - 1000,36000)
		into STRICT	qt_base_qtd_registros_w
		from	integridade_atributo;

		end;
	elsif ('INTEGRIDADE_REFERENCIAL' = upper(nm_tabela_w)) then
		begin
		--Total de registros em 07/11/2014 = 35831
		select	coalesce(count(*) - 1000,35000)
		into STRICT	qt_base_qtd_registros_w
		from	integridade_referencial;

		end;
	elsif ('OBJETO_SISTEMA_PARAM' = upper(nm_tabela_w)) then
		begin
		--Total de registros em 07/11/2014 = 166007
		select	coalesce(count(*) - 1000,165000)
		into STRICT	qt_base_qtd_registros_w
		from	objeto_sistema_param;

		end;
	elsif ('FUNCAO_PARAMETRO' = upper(nm_tabela_w)) then
		begin
		--Total de registros em 07/11/2014 = 34695
		select	coalesce(count(*) - 1000,33000)
		into STRICT	qt_base_qtd_registros_w
		from	funcao_parametro;

		end;
	end if;

	EXECUTE 'select nvl(count(*),0) from '|| nm_owner_p|| '.' ||nm_tabela_w
	into STRICT qt_registros_w;


	if (qt_registros_w = 0) then
		begin

		ds_retorno_w := ds_retorno_w || wheb_mensagem_pck.get_texto(323534,'nm_tabela='||nm_tabela_w||';qt_reg_nec='||qt_base_qtd_registros_w||';qt_reg_imp='||qt_registros_w) || chr(13) || chr(10);

		end;
	end if;

	end;
end loop;
close C01;

if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
	begin
	if (ie_aplicacao_p = 'D') then
		begin
		ds_retorno_w := ds_retorno_w || wheb_mensagem_pck.get_texto(323536);
		end;
	elsif (ie_aplicacao_p = 'J') then
		begin
		ds_retorno_w := ds_retorno_w || wheb_mensagem_pck.get_texto(323537);
		end;
	end if;
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION verificar_imp_reg_atualizacao (nm_owner_p text, ie_aplicacao_p text) FROM PUBLIC;
