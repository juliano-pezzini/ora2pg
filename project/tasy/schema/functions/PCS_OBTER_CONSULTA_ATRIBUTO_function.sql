-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pcs_obter_consulta_atributo ( nm_tabela_p text, nm_atributo_p text, ie_possui_integridade_p text, ie_cadastro_geral_p text default 'N') RETURNS varchar AS $body$
DECLARE


ds_consulta_w			varchar(2000);
ds_consulta_integridade_w	varchar(2000);
ds_consulta_dominio_w		varchar(2000);
nm_tabela_referencia_w		varchar(50);
nm_atributo_referencia_w	varchar(80);
cd_dominio_w			integer;
ds_descricao_atributo_w		varchar(255);
qt_posicao_ds_ini_w		integer;
qt_posicao_ds_fim_w		integer;
qt_posicao_from_w		integer;


BEGIN

if (ie_cadastro_geral_p = 'N') then
	begin
	select	upper(max(nm_tabela_referencia))
	into STRICT	nm_tabela_referencia_w
	from	integridade_referencial a,
		integridade_atributo b
	where	b.nm_tabela = upper(nm_tabela_p )
	and	b.nm_atributo = upper(nm_atributo_p)
	and	a.nm_tabela = b.nm_tabela
	and	a.nm_integridade_referencial = b.nm_integridade_referencial;

	select	upper(max(c.column_name))
	into STRICT	nm_atributo_referencia_w
	from	user_constraints a,
		user_constraints b,
		user_cons_columns c
	where	a.table_name = nm_tabela_p
	and	b.table_name = nm_tabela_referencia_w
	and	a.r_constraint_name = b.constraint_name
	and	b.constraint_name = c.constraint_name;

	if (ie_possui_integridade_p = 'R') then
		begin
		select	max(ds_valores)
		into STRICT	ds_consulta_integridade_w
		from	tabela_atributo
		where	nm_tabela = nm_tabela_referencia_w
		and	nm_atributo = nm_atributo_referencia_w
		and	ds_valores like 'select%';

		if (coalesce(ds_consulta_integridade_w::text, '') = '') then
			begin
			select	max(ds_sql_lookup)
			into STRICT	ds_consulta_integridade_w
			from	tabela_sistema
			where	nm_tabela = nm_tabela_referencia_w;
			end;
		end if;
		end;
	end if;

	if (ie_possui_integridade_p = 'D') then
		begin
		select	max(cd_dominio)
		into STRICT	cd_dominio_w
		from	tabela_atributo
		where	nm_tabela = upper(nm_tabela_p)
		and	nm_atributo = upper(nm_atributo_p);


		ds_consulta_dominio_w :=' select vl_dominio cd, ' || chr(13) || chr(10) ||
					'	 ds_valor_dominio ds ' || chr(13) || chr(10) ||
					' from	 valor_dominio ' || chr(13) || chr(10) ||
					' where	 cd_dominio = ' || to_char(cd_dominio_w);

		end;
	end if;
	end;
elsif (ie_cadastro_geral_p in ('DS_DESCRICAO','S')) then
	begin
	select	upper(max(ds_sql_lookup))
	into STRICT	ds_consulta_integridade_w
	from	tabela_sistema
	where	nm_tabela = nm_tabela_p;

	qt_posicao_ds_ini_w := position('DS' in ds_consulta_integridade_w); --Verificado a posição inicial do campo descrição
	qt_posicao_from_w   := position('FROM' in ds_consulta_integridade_w);	--Verificado a posição inicial do from
  	qt_posicao_ds_fim_w := instr(substr(ds_consulta_integridade_w,1,qt_posicao_from_w),'DS',qt_posicao_ds_ini_w + 1); --Verifica até o from,  se existe algum tipo de alias DS
	if (qt_posicao_ds_fim_w = 0) then --Caso não existir o alias 'DS'
		ds_descricao_atributo_w := substr(ds_consulta_integridade_w,qt_posicao_ds_ini_w,(qt_posicao_from_w-2) - qt_posicao_ds_ini_w);
	else				  --Caso existir o alias 'DS'
		ds_descricao_atributo_w := substr(ds_consulta_integridade_w,qt_posicao_ds_ini_w,qt_posicao_ds_fim_w - qt_posicao_ds_ini_w);
	end if;

	end;
end if;

if (coalesce(ds_consulta_integridade_w,'X' ) <> 'X') then
	ds_consulta_w := substr(ds_consulta_integridade_w,1,2000);
elsif (coalesce(ds_consulta_dominio_w,'X' ) <> 'X') then
	ds_consulta_w := substr(ds_consulta_dominio_w,1,2000);
end if;

if (ie_cadastro_geral_p = 'DS_DESCRICAO') and (ds_descricao_atributo_w IS NOT NULL AND ds_descricao_atributo_w::text <> '') then
	ds_consulta_w := substr(UPPER(ds_descricao_atributo_w),1,255);
end if;

return	ds_consulta_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pcs_obter_consulta_atributo ( nm_tabela_p text, nm_atributo_p text, ie_possui_integridade_p text, ie_cadastro_geral_p text default 'N') FROM PUBLIC;

