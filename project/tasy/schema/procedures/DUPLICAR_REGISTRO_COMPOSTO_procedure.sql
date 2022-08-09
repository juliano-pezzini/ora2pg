-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_registro_composto ( nm_tabela_p text, nm_usuario_p text, nr_seq_pk_p INOUT bigint, nr_seq_pk2_p bigint  --Tratado para quando existir 2 pk's. Ex:  EXAME_LAB_CONVENIO. Esta PK é a utilizada para ligação com outra tabela. Ex: NR_SEQ_EXAME com a EXAME_LABORATORIO.
 ) AS $body$
DECLARE


ds_virgula_w			varchar(01);
ds_insert_w			varchar(32000);
nm_tabela_w          		varchar(50);
nm_atributo_pk_w		varchar(50);
nm_atributo_pk2_w		varchar(50);
nm_atributo_w          		varchar(50);
nm_atributo_long_w	varchar(50);
ds_comando_w			varchar(32000);
vl_atributo_pk_w		bigint;
c001				integer;
retorno_w			integer;

C010 CURSOR FOR
	SELECT	nm_atributo
	FROM	tabela_atributo
	WHERE	nm_tabela		= nm_tabela_w
	and	ie_tipo_atributo 	not in ('FUNCTION','VISUAL','LONG')
	and	nm_atributo		not in (nm_atributo_pk_w, 'NM_USUARIO', 'DT_ATUALIZACAO')
	order by nr_sequencia_criacao;


BEGIN

ds_virgula_w			:= '';
ds_insert_w			:= '';
nm_tabela_w			:= UPPER(nm_tabela_p);

if (nm_tabela_w	= 'CONVERSAO_MATERIAL_CONVENIO')
or (nm_tabela_w	= 'SETOR_ATENDIMENTO') then /* Anderson - OS 302865 - Tabela não possui sequence. */
	select	coalesce(max(a.nm_atributo),' ')
	into STRICT	nm_atributo_pk_w
	from	indice_atributo c,
		indice b,
		tabela_atributo a
	where a.nm_tabela		= b.nm_tabela
	  and b.nm_indice		= c.nm_indice
	  and b.ie_tipo			= 'PK'
	  and a.nm_atributo		= c.nm_atributo
	  and a.nm_tabela		= nm_tabela_w
	  and coalesce(a.ds_filter, ' ')     <> 'NAO DUPLICAR';
else
	select	coalesce(max(a.nm_atributo),' ')
	into STRICT	nm_atributo_pk_w
	from	indice_atributo c,
		indice b,
		tabela_atributo a
	where a.nm_tabela		= b.nm_tabela
	  and b.nm_indice		= c.nm_indice
	  and b.ie_tipo			= 'PK'
	  and a.nm_atributo		= c.nm_atributo
	  and a.nm_tabela		= nm_tabela_w
	  and coalesce(a.ds_filter, ' ')     <> 'NAO DUPLICAR'
	  and not exists (SELECT 1 from integridade_atributo x where x.nm_tabela = a.nm_tabela and x.nm_atributo = a.nm_atributo);

	 select	coalesce(max(a.nm_atributo),' ')
	into STRICT	nm_atributo_pk2_w
	from	indice_atributo c,
		indice b,
		tabela_atributo a
	where a.nm_tabela		= b.nm_tabela
	  and b.nm_indice		= c.nm_indice
	  and b.ie_tipo			= 'PK'
	  and a.nm_atributo		= c.nm_atributo
	  and a.nm_tabela		= nm_tabela_w
	  and coalesce(a.ds_filter, ' ')     <> 'NAO DUPLICAR'
	  and exists (SELECT 1 from integridade_atributo x where x.nm_tabela = a.nm_tabela and x.nm_atributo = a.nm_atributo);
end if;

if (nm_atributo_pk_w <> ' ') then
	OPEN C010;
	LOOP
		FETCH C010 INTO 	nm_atributo_w;
		EXIT WHEN NOT FOUND; /* apply on C010 */
		ds_insert_w	:= ds_insert_w || ds_virgula_w || nm_atributo_w;
		ds_virgula_w	:= ',';
	END LOOP;
	CLOSE C010;

	if (nm_tabela_w <> 'CONVERSAO_MATERIAL_CONVENIO')
	and (nm_tabela_w <> 'SETOR_ATENDIMENTO') then
		ds_comando_w	:= 'Select ' || nm_tabela_w || '_seq.NextVal' || ' from dual';
		begin
		vl_atributo_pk_w := Obter_valor_Dinamico(ds_comando_w, vl_atributo_pk_w);
		exception
		when others then
			vl_atributo_pk_w	:= 0;
		end;
		if (coalesce(vl_atributo_pk_w,0) = 0) then
			ds_comando_w	:= 'select nvl(max('||nm_atributo_pk_w||'),0)+1 from '|| nm_tabela_w ||' where '||nm_atributo_pk2_w || ' = '||to_char(nr_seq_pk2_p);
			vl_atributo_pk_w := Obter_valor_Dinamico(ds_comando_w, vl_atributo_pk_w);
		end if;
	elsif (nm_tabela_w = 'CONVERSAO_MATERIAL_CONVENIO') then
		ds_comando_w	:= 'Select ' || 'CONVERSAO_MAT_CONVENIO' || '_seq.NextVal' || ' from dual';
		vl_atributo_pk_w := Obter_valor_Dinamico(ds_comando_w, vl_atributo_pk_w);
	elsif (nm_tabela_w = 'SETOR_ATENDIMENTO') then
		ds_comando_w	:= 'Select max(cd_setor_atendimento) + 1 from setor_atendimento'; /* Anderson - OS 302865 - Tabela não possui sequence. */
		vl_atributo_pk_w := Obter_valor_Dinamico(ds_comando_w, vl_atributo_pk_w);
	end if;

	--Obter_valor_Dinamico(ds_comando_w, vl_atributo_pk_w);
	ds_comando_w	:= 'Insert into ' || nm_tabela_w || '(' || nm_atributo_pk_w || ds_virgula_w || 'NM_USUARIO,DT_ATUALIZACAO,' || ds_insert_w || ') ';
	ds_comando_w	:= ds_comando_w || 'select ' || vl_atributo_pk_w || ds_virgula_w ||
				chr(39) || nm_usuario_p || chr(39) || ds_virgula_w || 'sysdate,' ||
				ds_insert_w || ' from ' || nm_tabela_w || ' a ';
	ds_comando_w	:= ds_comando_w || 'where a.' || nm_atributo_pk_w || ' = ' || nr_seq_pk_p;
	if (nm_atributo_pk2_w IS NOT NULL AND nm_atributo_pk2_w::text <> '') and (nr_seq_pk2_p IS NOT NULL AND nr_seq_pk2_p::text <> '') then
		ds_comando_w	:= ds_comando_w || ' and a.' || nm_atributo_pk2_w || ' = ' || nr_seq_pk2_p;
	end if;

	C001 := DBMS_SQL.OPEN_CURSOR;
	DBMS_SQL.PARSE(C001, ds_comando_w, dbms_sql.Native);
	Retorno_w := DBMS_SQL.execute(c001);
	DBMS_SQL.CLOSE_CURSOR(C001);

	begin

	select	column_name
	into STRICT	nm_atributo_long_w
	from	user_tab_columns
	where	table_name = nm_tabela_w
	and	data_type = 'LONG';

	exception
	when others then
		nm_atributo_long_w := null;
	end;

	if (nm_atributo_long_w IS NOT NULL AND nm_atributo_long_w::text <> '') then
		if (coalesce(nm_atributo_pk2_w::text, '') = '') then
			CALL COPIA_CAMPO_LONG_DE_PARA(nm_tabela_w,
						nm_atributo_long_w,
						'where ' || nm_atributo_pk_w || ' = :nr_sequencia ',
						'nr_sequencia=' || nr_seq_pk_p,
						nm_tabela_w,
						nm_atributo_long_w,
						'where ' || nm_atributo_pk_w || ' = :nr_sequencia ',
						'nr_sequencia=' || vl_atributo_pk_w );
		else
			CALL COPIA_CAMPO_LONG_DE_PARA(nm_tabela_w,
						nm_atributo_long_w,
						'where ' || nm_atributo_pk_w || ' = :nr_sequencia '||
						'and ' || nm_atributo_pk2_w || ' = '||nr_seq_pk2_p,
						'nr_sequencia=' || nr_seq_pk_p,
						nm_tabela_w,
						nm_atributo_long_w,
						'where ' || nm_atributo_pk_w || ' = :nr_sequencia '||
						'and ' || nm_atributo_pk2_w || ' = '||nr_seq_pk2_p,
						'nr_sequencia=' || vl_atributo_pk_w );
		end if;

	end	if;

	nr_seq_pk_p	:= vl_atributo_pk_w;

	commit;
end if;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_registro_composto ( nm_tabela_p text, nm_usuario_p text, nr_seq_pk_p INOUT bigint, nr_seq_pk2_p bigint  ) FROM PUBLIC;
