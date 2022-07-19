-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_criar_indice ( nm_tabela_p text, nm_Indice_p text, qt_registro_p bigint, ie_dropar_p text, ie_online_p text default 'N', ie_logging_p text default 'N', qt_nivel_p bigint default 0) AS $body$
DECLARE


nm_atributo_w          	varchar(50)    := '';
ie_temporaria_w		varchar(2);
ds_virgula_w		varchar(01)	:= '';
ds_tablespace_ind_w    	varchar(50)    := '';
ie_tipo_w		varchar(02)    := '';
ds_tipo_indice_w	varchar(15)    := '';
ds_comando_w		varchar(2000);
vl_retorno_w		varchar(255);
qt_tamanho_w		integer;
qt_total_Indice_w	integer;
qt_Initial_w		integer;
qt_next_w		integer;
ds_indice_function_w	varchar(255);
ie_configurar_w		varchar(1);
ie_classificacao_w	varchar(3);
temporary_w		varchar(3);

C010 CURSOR FOR
	SELECT 	a.nm_atributo,
		coalesce(CASE WHEN ie_tipo_atributo='DATE' THEN 5  ELSE qt_tamanho END ,5),
		a.ds_indice_function
	FROM 	tabela_atributo b,
		Indice_Atributo a
	WHERE b.nm_tabela		= nm_tabela_p
	  and a.nm_tabela		= nm_tabela_p
	  and a.nm_indice		= nm_indice_p
	  and a.nm_atributo	= b.nm_atributo
	order by a.nr_sequencia;


BEGIN

begin

SELECT	ie_tipo,
	b.ie_temporaria,
	a.ie_classificacao
INTO STRICT	ie_tipo_w,
	ie_temporaria_w,
	ie_classificacao_w
FROM	indice a,
	tabela_sistema b
WHERE	a.nm_tabela		= nm_tabela_p
  and	a.nm_tabela		= b.nm_tabela
  and	a.nm_indice		= nm_indice_p;

select 	max(temporary)
into STRICT	temporary_w
from	user_tables
where	table_name = upper(nm_tabela_p);

if (ie_temporaria_w	= 'N') and (temporary_w	= 'Y') then
	ie_temporaria_w	:= 'G';
end if;


if (ie_classificacao_w <> 'IC') or (coalesce(ie_classificacao_w::text, '') = '') then
	EXECUTE 'BEGIN :a := wheb_usuario_pck.get_configurar_tablespace; END;' USING IN OUT ie_configurar_w;

	if (ie_configurar_w = 'S') then
		ds_tablespace_ind_w := OBTER_VALOR_DINAMICO_CHAR_BV('select Obter_Tablespace_Index(:nm_Indice_p) from dual', 'nm_indice_p=' || nm_indice_p || ';', ds_tablespace_ind_w);
	elsif (ie_temporaria_w <> 'N') then
		ds_tablespace_ind_w := OBTER_VALOR_DINAMICO_CHAR_BV(
			'select nvl(max(nvl(vl_parametro,vl_parametro_padrao)),Obter_Tablespace_Index) '||
			'from 	funcao_parametro '||
			'where	nr_sequencia = 135 ' ||
			'and 	cd_funcao = 0 ', '', ds_tablespace_ind_w);
	else
		ds_tablespace_ind_w := OBTER_VALOR_DINAMICO_CHAR_BV('select Obter_Tablespace_Index(:nm_Indice_p) from dual', 'nm_indice_p=' || nm_indice_p || ';', ds_tablespace_ind_w);
	end	if;

	if (ie_dropar_p = 'S') then
		begin
		if (ie_tipo_w = 'PK') or (ie_tipo_w = 'UK') then
			begin
			ds_comando_w	:= 'alter table ' || nm_tabela_p || ' drop constraint ';
			ds_comando_w	:= ds_comando_w || nm_Indice_p;
			end;
		else
			ds_comando_w	:= 'drop index ' || nm_Indice_p;
		end if;
		CALL gravar_processo_longo(ds_comando_w,'TASY_CRIAR_INDICE',null);
		vl_retorno_w := Obter_Valor_Dinamico(ds_comando_w, vl_retorno_w);
		end;
	end if;
	if (ie_tipo_w = 'PK') or (ie_tipo_w = 'UK') then
		begin
		if (ie_tipo_w = 'PK') then
	    		ds_tipo_indice_w    	:= 'Primary Key ';
		else
			ds_tipo_indice_w        := 'Unique ';
		end if;

		ds_comando_w	:= 'alter table ' || nm_tabela_p || ' add constraint ';
		ds_comando_w	:= ds_comando_w || nm_Indice_p || ' ' || ds_tipo_indice_w || '(';

		end;
	else
		ds_tipo_indice_w := '';
		if (ie_tipo_w = 'IU') then
			ds_tipo_indice_w := ' unique ';
		elsif (ie_tipo_w = 'IB') then
			ds_tipo_indice_w := ' bitmap ';
		end if;

		ds_comando_w	:= 'Create '|| ds_tipo_indice_w ||' Index ' || nm_indice_p || ' ON ' || nm_tabela_p || '(';
	end if;
	ds_virgula_w	:= '';
	qt_total_Indice_w := 0;
	OPEN C010;
	LOOP
		FETCH C010 INTO
			nm_atributo_w,
			qt_tamanho_w,
			ds_indice_function_w;
		EXIT WHEN NOT FOUND; /* apply on C010 */
			if ( ie_tipo_w = 'IF') then
				ds_comando_w	:= ds_comando_w  || ds_indice_function_w;
			elsif ( ie_tipo_w = 'IU') and (ds_indice_function_w IS NOT NULL AND ds_indice_function_w::text <> '') then
				ds_comando_w	:= ds_comando_w  || ds_indice_function_w;
			else
				ds_comando_w	:= ds_comando_w  || ds_virgula_w || nm_atributo_w;
				ds_virgula_w	:= ',';
			end if;
			qt_total_Indice_w	:= qt_total_Indice_w + qt_tamanho_w;
	END LOOP;
	CLOSE C010;
	qt_Initial_w	:= round(coalesce(qt_registro_p,100) * qt_total_indice_w / 1024);
	qt_next_w	:= round(qt_initial_w / 10);

	/* 	Tratar se índice nulo OS298078
		Exemplo:  Create Index LABIMPE_IX on LAB_IMPORTACAO_EXAME(DT_INTEGRACAO,1); */
	if (ie_tipo_w = 'IC') then
		ds_comando_w	:= ds_comando_w	|| ',1';
	end	if;

	ds_comando_w	:= ds_comando_w  || ')';

	if (qt_nivel_p > 0) then
		ds_comando_w	:= ds_comando_w  || ' PARALLEL ' || qt_nivel_p;
	end	if;

	if (ie_tipo_w = 'PK') or (ie_tipo_w = 'UK') then
		ds_comando_w	:= ds_comando_w || ' Using Index';
	end if;

	if (ie_temporaria_w not in ('G','GD')) then

		if (ie_configurar_w = 'S') then
			--ds_tablespace_ind_w	:= Obter_Tablespace_Index(nm_Indice_p);
			ds_tablespace_ind_w := OBTER_VALOR_DINAMICO_CHAR_BV('select Obter_Tablespace_Index(:nm_Indice_p) from dual', 'nm_indice_p=' || nm_indice_p || ';', ds_tablespace_ind_w);
		end	if;

		ds_comando_w	:= ds_comando_w || ' STORAGE(INITIAL ' || qt_initial_w || 'K NEXT ';
		ds_comando_w	:= ds_comando_w || qt_next_w || 'K PCTINCREASE 0)';
		ds_comando_w	:= ds_comando_w || ' PCTFREE 10 Tablespace ' || ds_tablespace_ind_w;

		if (ie_logging_p = 'N') then
			ds_comando_w	:= ds_comando_w || ' NOLOGGING ';
		else
			ds_comando_w	:= ds_comando_w || ' LOGGING ';
		end	if;

		if (ie_online_p = 'S') then
			ds_comando_w := ds_comando_w || ' ONLINE';
		end	if;

	end	if;

	CALL gravar_processo_longo(ds_comando_w,'TASY_CRIAR_ALTERAR_TABELA',null);
	vl_retorno_w := Obter_Valor_Dinamico(ds_comando_w, vl_retorno_w);

	if (ie_logging_p = 'N') then
		ds_comando_w	:= 'alter index ' || nm_indice_p || ' LOGGING ';
		CALL gravar_processo_longo(ds_comando_w,'TASY_CRIAR_ALTERAR_TABELA',null);
		vl_retorno_w := Obter_Valor_Dinamico(ds_comando_w, vl_retorno_w);
	end	if;

	if (qt_nivel_p > 0) then
		ds_comando_w	:= 'alter index ' || nm_indice_p || ' NOPARALLEL ';
		CALL gravar_processo_longo(ds_comando_w,'TASY_CRIAR_ALTERAR_TABELA',null);
		vl_retorno_w := Obter_Valor_Dinamico(ds_comando_w, vl_retorno_w);
	end	if;

end	if;

exception
when others then
	null;
	--insert into LogxxxxxTasy values (sysdate, 'Tasy', 752, ds_comando_w);
end;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_criar_indice ( nm_tabela_p text, nm_Indice_p text, qt_registro_p bigint, ie_dropar_p text, ie_online_p text default 'N', ie_logging_p text default 'N', qt_nivel_p bigint default 0) FROM PUBLIC;

