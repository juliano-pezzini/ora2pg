-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reg_approve_item ( ds_table_name text, nr_seq_item bigint, nm_user_p text, nm_dt_approving_field_p text default 'dt_aprovacao', nm_user_column_p text default null) AS $body$
DECLARE



/*
 * Utilizada para liberar e desfazer a liberação dos itens da função Documentação do Produto (CorQuaDP)
 * Alterna o campo dt_atualizacao da tabela passada por parâmetro, no registro correspondente ao indice passado por parâmetro: se o campo estiver null, é inserida a data atual, senão é inserido null.
 */
ds_campos_adic_w	varchar(255);
ds_table_pk_field_w	varchar(50);


BEGIN
	select	max(a.nm_atributo)
	into STRICT	ds_table_pk_field_w
	from	indice_atributo a,
		indice i
	where	lower(i.nm_tabela) = lower(ds_table_name)
	and	a.nm_indice = i.nm_indice
	and	i.ie_tipo = 'PK';

	select	CASE WHEN coalesce(nm_user_column_p::text, '') = '' THEN  ''  ELSE nm_user_column_p || ' = decode(' || nm_user_column_p || ', null, ''' || nm_user_p || ''', null),' END
	into STRICT	ds_campos_adic_w
	;

	EXECUTE	' update ' || ds_table_name ||
				' set	 ' || nm_dt_approving_field_p || ' = decode(' || nm_dt_approving_field_p || ', null, sysdate, null),' ||
				ds_campos_adic_w ||
				'	dt_atualizacao = sysdate,' ||
				'	nm_usuario = ''' || nm_user_p || '''' ||
				' where	' || ds_table_pk_field_w || ' = ' || to_char(nr_seq_item);

	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reg_approve_item ( ds_table_name text, nr_seq_item bigint, nm_user_p text, nm_dt_approving_field_p text default 'dt_aprovacao', nm_user_column_p text default null) FROM PUBLIC;

