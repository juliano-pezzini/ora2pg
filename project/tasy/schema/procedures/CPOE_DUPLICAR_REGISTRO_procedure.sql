-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_duplicar_registro ( nm_tabela_p text, nm_usuario_p text, nr_seq_registro_p bigint, nr_seq_novo_p INOUT bigint) AS $body$
DECLARE


ds_insert_w			varchar(32000);
nm_tabela_w          		varchar(50);
nm_atributo_pk_w		varchar(50);
nm_atributo_w          		varchar(50);
ds_comando_w			varchar(32000);
vl_atributo_pk_w		bigint;
bind_variables_w		varchar(250);

C010 CURSOR FOR
	SELECT	nm_atributo
	FROM	tabela_atributo
	WHERE	nm_tabela		= nm_tabela_w
	and	ie_tipo_atributo 	not in ('FUNCTION','VISUAL','LONG')
	and	nm_atributo		not in (nm_atributo_pk_w, 'NM_USUARIO', 'DT_ATUALIZACAO','DT_LIBERACAO','NR_SEQ_CPOE_ANTERIOR')
	order by nr_sequencia_criacao;


BEGIN

ds_insert_w			:= '';
nm_tabela_w			:= UPPER(nm_tabela_p);

select	max(a.nm_atributo)
into STRICT	nm_atributo_pk_w
from	indice_atributo c,
	indice b,
	tabela_atributo a
where 	a.nm_tabela		= b.nm_tabela
and 	b.nm_indice		= c.nm_indice
and 	b.ie_tipo		= 'PK'
and 	a.nm_atributo		= c.nm_atributo
and 	coalesce(a.qt_seq_inicio,0) 	> 0
and 	a.nm_tabela		= nm_tabela_w;


if (nm_atributo_pk_w IS NOT NULL AND nm_atributo_pk_w::text <> '') then
	OPEN C010;
	LOOP
		FETCH C010 INTO 	nm_atributo_w;
		EXIT WHEN NOT FOUND; /* apply on C010 */
		ds_insert_w	:= ds_insert_w || ',' || nm_atributo_w;
	END LOOP;
	CLOSE C010;

	ds_comando_w	:= 'Select ' || nm_tabela_w || '_seq.NextVal' || ' from dual';

	vl_atributo_pk_w := Obter_valor_Dinamico(ds_comando_w, vl_atributo_pk_w);

	ds_comando_w	:= 'Insert into ' || nm_tabela_w || '(' || nm_atributo_pk_w || ', NM_USUARIO, DT_ATUALIZACAO' || ds_insert_w || ') ';
	ds_comando_w	:= ds_comando_w || ' select :new_pk, :nm_usuario_p, sysdate ' || ds_insert_w;
	ds_comando_w	:= ds_comando_w || ' from ' || nm_tabela_w || ' a ' || 'where a.' || nm_atributo_pk_w || ' = :seq_reg_p ';

	bind_variables_w := 'new_pk=' || vl_atributo_pk_w || ';';
	bind_variables_w := bind_variables_w || 'nm_usuario_p=' || nm_usuario_p || ';';
	bind_variables_w := bind_variables_w || 'seq_reg_p=' || nr_seq_registro_p || ';';

	CALL Exec_sql_Dinamico_bv('',ds_comando_w,bind_variables_w);-- utilizando bind variables  para realizar o update
	ds_comando_w := 'update ' || nm_tabela_w || ' set nr_seq_cpoe_anterior = :nr_seq_cpoe_anterior where ' || nm_atributo_pk_w || ' = :new_pk';
	bind_variables_w := 'nr_seq_cpoe_anterior='||nr_seq_registro_p||';';
	bind_variables_w := bind_variables_w || 'new_pk='||vl_atributo_pk_w||';';
	CALL Exec_sql_Dinamico_bv('',ds_comando_w,bind_variables_w);-- utilizando bind variables  para realizar o update
	nr_seq_novo_p	:= vl_atributo_pk_w;
	commit;
end if;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_duplicar_registro ( nm_tabela_p text, nm_usuario_p text, nr_seq_registro_p bigint, nr_seq_novo_p INOUT bigint) FROM PUBLIC;

