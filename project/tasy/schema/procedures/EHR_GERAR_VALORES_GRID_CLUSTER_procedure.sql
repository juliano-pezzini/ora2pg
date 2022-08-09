-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ehr_gerar_valores_grid_cluster ( nr_seq_reg_template_p bigint, nr_seq_template_p bigint) AS $body$
DECLARE

ds_resultado_w	varchar(4000);
dt_resultado_w	timestamp;
vl_resultado_w	double precision;
ds_openehr_w	varchar(50);
nm_tabela_w	varchar(30) := 'EHR_CLUSTER_' || to_char(nr_seq_template_p);
column_name_w	varchar(30);
ds_colunas_w	varchar(2000);
ds_parametros_w	varchar(2000);
ds_comando_w	varchar(2000);
nr_registro_cluster_w	bigint;
nr_seq_reg_template_w	bigint;
nr_sequencia_w	bigint;
ds_separado_w	varchar(200);
ds_sql_forupdate_w varchar(2000);

v_ehr_cursor REFCURSOR;

C01 CURSOR FOR
	SELECT	a.nr_seq_reg_template,
		b.nr_sequencia,
		a.ds_resultado,
		a.dt_resultado,
		a.vl_resultado,
		a.nr_registro_cluster,
		substr(obter_desc_tipo_openehr(ehr_obter_inf_elemento(a.nr_seq_elemento,'TDADO')),1,50)
	from	ehr_reg_elemento a,
		ehr_template_conteudo b
	where	a.nr_seq_reg_template = nr_seq_reg_template_p
	and	(a.nr_registro_cluster IS NOT NULL AND a.nr_registro_cluster::text <> '')
	anD	a.NR_SEQ_TEMP_CONTEUDO = b.nr_sequencia
	and	b.NR_SEQ_TEMPLATE = nr_seq_template_p
	and	a.nr_registro_cluster = nr_registro_cluster_w
	order by a.nr_registro_cluster;

C02 CURSOR FOR
	SELECT	distinct a.nr_registro_cluster
	from	ehr_reg_elemento a,
		ehr_template_conteudo b
	where	a.nr_seq_reg_template = nr_seq_reg_template_p
	and	(a.nr_registro_cluster IS NOT NULL AND a.nr_registro_cluster::text <> '')
	anD	a.NR_SEQ_TEMP_CONTEUDO = b.nr_sequencia
	and	b.NR_SEQ_TEMPLATE = nr_seq_template_p
	order by a.nr_registro_cluster;

C03 CURSOR FOR
	SELECT	column_name
	from	user_tab_columns
	where	table_name = nm_tabela_w;

BEGIN

ds_sql_forupdate_w := 'SELECT * FROM ' || nm_tabela_w || ' WHERE NR_SEQ_REG_TEMPLATE = :v1 FOR UPDATE NOWAIT';

begin
    OPEN v_ehr_cursor FOR EXECUTE ds_sql_forupdate_w USING nr_seq_reg_template_p;
	
	CALL exec_sql_dinamico_bv('EHR_CLUSTER',	' delete from ' || nm_tabela_w ||
						' where nr_seq_reg_template = :nr_seq_reg_template',
						'nr_seq_reg_template=' || to_char(nr_seq_reg_template_p));
ds_separado_w	:= obter_separador_bv;
open C03;
	loop
	fetch C03 into
		column_name_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		ds_colunas_w	:= ds_colunas_w		|| ',' 	|| column_name_w;
		ds_parametros_w	:= ds_parametros_w	|| ',:'	|| column_name_w;
		end;
	end loop;
	close C03;
ds_colunas_w	:= substr(column_name_w,2,length(column_name_w));
ds_comando_w	:=	' insert into ' || nm_tabela_w || ' ( ' || ds_colunas_w ||
					') values (' || ds_parametros_w || ')';
open C02;
	loop
	fetch C02 into
		nr_registro_cluster_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	CALL exec_sql_dinamico_bv('EHR_CLUSTER', ' insert into ' || nm_tabela_w ||
		' (nr_seq_template,nr_seq_reg_template,nr_registro_cluster) values (:nr_seq_template, :nr_seq_reg_template, :nr_registro_cluster)',
		'nr_seq_template='		|| nr_seq_template_p || ';' ||
		'nr_seq_reg_template=' || nr_seq_reg_template_p || ';' ||
		'nr_registro_cluster=' || nr_registro_cluster_w);
	open C01;
		loop
		fetch C01 into
			nr_seq_reg_template_w,
			nr_sequencia_w,
			ds_resultado_w,
			dt_resultado_w,
			vl_resultado_w,
			nr_registro_cluster_w,
			ds_openehr_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (ds_openehr_w = 'DV_TEXT') or (ds_openehr_w = 'DV_CODED_TEXT') or (ds_openehr_w = 'DV_BOOLEAN') then
			CALL exec_sql_dinamico_bv('EHR_CLUSTER',	' update ' || nm_tabela_w ||
								' set	ds_' || to_char(nr_sequencia_w) || ' = :ds_resultado ' ||
								' where	nr_registro_cluster = :nr_registro_cluster	' ||
								' and nr_seq_template = :nr_seq_template ' ||
								' and nr_seq_reg_template = :nr_seq_reg_template',
								'nr_registro_cluster=' || nr_registro_cluster_w || ds_separado_w ||
								'nr_seq_template=' || nr_seq_template_p ||ds_separado_w ||
								'nr_seq_reg_template='|| nr_seq_reg_template_p||ds_separado_w||
								'ds_resultado=' || ds_resultado_w);
		elsif (ds_openehr_w = 'DV_COUNT') or (ds_openehr_w = 'DV_QUANTITY') then
			CALL exec_sql_dinamico_bv('EHR_CLUSTER',	' update ' || nm_tabela_w ||
								' set	vl_' || to_char(nr_sequencia_w) || ' = :vl_resultado ' ||
								' where	nr_registro_cluster = :nr_registro_cluster	' ||
								' and nr_seq_template = :nr_seq_template '||
								' and nr_seq_reg_template = :nr_seq_reg_template',
								'nr_registro_cluster=' || nr_registro_cluster_w || ds_separado_w ||
								'nr_seq_template=' || nr_seq_template_p || ds_separado_w ||
								'nr_seq_reg_template='|| nr_seq_reg_template_p||ds_separado_w||
								'vl_resultado=' || vl_resultado_w);
		elsif (ds_openehr_w = 'DV_DATE') or (ds_openehr_w = 'DV_TIME') or (ds_openehr_w = 'DV_DATE_TIME') then
			CALL exec_sql_dinamico_bv('EHR_CLUSTER',	' update ' || nm_tabela_w ||
								' set	dt_' || to_char(nr_sequencia_w) || ' = :dt_resultado ' ||
								' where	nr_registro_cluster = :nr_registro_cluster	' ||
								' and nr_seq_template = :nr_seq_template '||
								' and nr_seq_reg_template = :nr_seq_reg_template',
								'nr_registro_cluster=' || nr_registro_cluster_w || ds_separado_w ||
								'nr_seq_template=' || nr_seq_template_p || ds_separado_w ||
								'nr_seq_reg_template='|| nr_seq_reg_template_p||ds_separado_w||
								'dt_resultado=' || to_char(dt_resultado_w,'dd/mm/yyyy hh24:mi:ss'));
		end	if;
		end;
		end	loop;
	close	C01;
	end;
	end	loop;
close C02;
commit;

exception
  when others then
    ds_sql_forupdate_w := '';
end;

close v_ehr_cursor;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ehr_gerar_valores_grid_cluster ( nr_seq_reg_template_p bigint, nr_seq_template_p bigint) FROM PUBLIC;
