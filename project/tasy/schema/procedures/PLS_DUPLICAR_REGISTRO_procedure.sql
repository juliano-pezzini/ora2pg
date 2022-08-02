-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_duplicar_registro ( nm_tabela_p text, nm_usuario_p text, ie_commit_p text, nr_seq_pk_p INOUT bigint) AS $body$
DECLARE

 
ds_virgula_w			varchar(01);
ds_insert_w			varchar(32000);
nm_tabela_w     		varchar(50);
nm_atributo_pk_w		varchar(50);
nm_atributo_w     		varchar(50);
NR_PROTOCOLO_W			varchar(40);
nm_atributo_long_w	varchar(50);
ds_comando_w			varchar(32000);
vl_atributo_pk_w		bigint;
c001				integer;
retorno_w			integer;
ds_insert_prot_w		varchar(50);
ds_campo_prot_w			varchar(50);

c010 CURSOR FOR 
	SELECT	nm_atributo 
	from	tabela_atributo 
	where	nm_tabela		= nm_tabela_w 
	and	ie_tipo_atributo 	not in ('FUNCTION','VISUAL','LONG') 
	and	nm_atributo		not in (nm_atributo_pk_w, 'NM_USUARIO', 'DT_ATUALIZACAO') 
	and (nm_tabela_w		<> 'PROTOCOLO_CONVENIO' or nm_atributo <> 'NR_PROTOCOLO') 
	order by nr_sequencia_criacao;


BEGIN 
 
ds_virgula_w			:= '';
ds_insert_w			:= '';
ds_insert_prot_w		:= '';
ds_campo_prot_w			:= '';
nm_tabela_w			:= UPPER(nm_tabela_p);
 
if (nm_tabela_w	= 'CONVERSAO_MATERIAL_CONVENIO') or (nm_tabela_w	= 'SETOR_ATENDIMENTO') or /* Anderson - OS 302865 - Tabela não possui sequence. */
 
	(nm_tabela_w	= 'TRIBUTO') then 
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
	 and coalesce(a.ds_filter, ' ')   <> 'NAO DUPLICAR';
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
	 and coalesce(a.qt_seq_inicio,0) 	> 0	  
	 and a.nm_tabela		= nm_tabela_w 
	 and coalesce(a.ds_filter, ' ')   <> 'NAO DUPLICAR';
end if;
 
 
if (nm_atributo_pk_w <> ' ') then 
	open c010;
	loop 
		fetch c010 into 	nm_atributo_w;
		EXIT WHEN NOT FOUND; /* apply on c010 */
		ds_insert_w	:= ds_insert_w || ds_virgula_w || nm_atributo_w;
		ds_virgula_w	:= ',';
	end loop;
	close c010;
 
	if (nm_tabela_w <> 'CONVERSAO_MATERIAL_CONVENIO') 
	and (nm_tabela_w <> 'SETOR_ATENDIMENTO') 
	and (nm_tabela_w <> 'PROTOCOLO_CONVENIO') 
	and (nm_tabela_w <> 'TRIBUTO') then 
		ds_comando_w	:= 'Select ' || nm_tabela_w || '_seq.NextVal' || ' from dual';
	elsif (nm_tabela_w = 'CONVERSAO_MATERIAL_CONVENIO') then 
		ds_comando_w	:= 'Select ' || 'CONVERSAO_MAT_CONVENIO' || '_seq.NextVal' || ' from dual';
	elsif (nm_tabela_w = 'SETOR_ATENDIMENTO') then 
		ds_comando_w	:= 'Select max(cd_setor_atendimento) + 1 from setor_atendimento'; /* Anderson - OS 302865 - Tabela não possui sequence. */
	elsif (nm_tabela_w = 'PROTOCOLO_CONVENIO') then 
		ds_comando_w	:= 'Select ' || nm_tabela_w || '_seq.NextVal' || ' from dual';
		ds_campo_prot_w := ds_virgula_w || 'NR_PROTOCOLO';
		 
		select chr(39) || substr(wheb_mensagem_pck.get_texto(306673, 'NM_PROTOCOLO=' || nr_protocolo),1,40)|| chr(39) -- Cópia de #@NM_PROTOCOLO#@ 
		into STRICT NR_PROTOCOLO_W 
		from protocolo_convenio 
		where nr_seq_protocolo = nr_seq_pk_p;
		 
		ds_insert_prot_w := ds_virgula_w || NR_PROTOCOLO_W;
	elsif (nm_tabela_w = 'TRIBUTO') then 
		ds_comando_w	:= 'select nvl(max(a.cd_tributo),0) + 1 from tributo a';
	end if;
	 
	vl_atributo_pk_w := Obter_valor_Dinamico(ds_comando_w, vl_atributo_pk_w);
 
	ds_comando_w	:= 'Insert into ' || nm_tabela_w || '(' || nm_atributo_pk_w || ds_virgula_w || 'NM_USUARIO,DT_ATUALIZACAO,' || ds_insert_w || ds_campo_prot_w || ') ';
	 
	ds_comando_w	:= ds_comando_w || 'select ' || vl_atributo_pk_w || ds_virgula_w || 
				chr(39) || nm_usuario_p || chr(39) || ds_virgula_w || 'sysdate,' || 
				ds_insert_w || ds_insert_prot_w || ' from ' || nm_tabela_w || ' a ';
	ds_comando_w	:= ds_comando_w || 'where a.' || nm_atributo_pk_w || ' = ' || nr_seq_pk_p;	
	 
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
		CALL copia_campo_long_de_para(nm_tabela_w, 
					nm_atributo_long_w, 
					'where ' || nm_atributo_pk_w || ' = :nr_sequencia ', 					 
					'nr_sequencia=' || nr_seq_pk_p, 
					nm_tabela_w, 
					nm_atributo_long_w, 
					'where ' || nm_atributo_pk_w || ' = :nr_sequencia ', 
					'nr_sequencia=' || vl_atributo_pk_w );
								 
	end	if;
	 
	nr_seq_pk_p	:= vl_atributo_pk_w;	
	if (ie_commit_p = 'S') then 
		commit;
	end if;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_duplicar_registro ( nm_tabela_p text, nm_usuario_p text, ie_commit_p text, nr_seq_pk_p INOUT bigint) FROM PUBLIC;

