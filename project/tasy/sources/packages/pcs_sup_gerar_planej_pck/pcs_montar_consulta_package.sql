-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pcs_sup_gerar_planej_pck.pcs_montar_consulta (( cd_material_p bigint,				--aqui pega o sql que foi construído no pcs_montar_sql_atrib_formula 
 cd_estabelecimento_p bigint, cd_empresa_p bigint, nm_usuario_p text) is  	-- vai executar esse sqlk e gravar os valores em uma tabela W para posteriormente substituírem as macros. 
 c001 integer) AS $body$
DECLARE
 not null;


BEGIN 
 
open C01;
loop 
fetch C01 into 
	ds_macro_w, 
	ds_sql_w, 
	ie_periodo_w, 
	qt_periodo_w, 
	ie_periodo_atual_w, 
	nr_seq_atributo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
 
	if (ie_periodo_w IS NOT NULL AND ie_periodo_w::text <> '') and (qt_periodo_w IS NOT NULL AND qt_periodo_w::text <> '') and (ie_periodo_atual_w = 'S') then 
		begin 
		dt_final_ww := clock_timestamp();
		if (ie_periodo_w = 'A') then 
			qt_periodo_w	:= qt_periodo_w * 12;
			dt_inicial_ww	:= PKG_DATE_UTILS.ADD_MONTH(clock_timestamp(), -qt_periodo_w, 0);
		elsif (ie_periodo_w = 'M') then 
			dt_inicial_ww	:= PKG_DATE_UTILS.ADD_MONTH(clock_timestamp(), -qt_periodo_w, 0);
		elsif (ie_periodo_w = 'S') then 
			qt_periodo_w	:= qt_periodo_w * 7;
			dt_inicial_ww	:= clock_timestamp() - qt_periodo_w;
		elsif (ie_periodo_w = 'D') then 
			dt_final_ww	:= clock_timestamp();
			dt_inicial_ww	:= clock_timestamp() - qt_periodo_w/24;
		end if;
 
		dt_inicial_w	:= 'to_date('||''''||to_char(dt_inicial_ww,'dd/mm/yyyy')||''','''||'dd/mm/yyyy'||''''||')';
		dt_final_w	:= 'to_date('||''''||to_char(fim_dia(dt_final_ww),'dd/mm/yyyy hh24:mi:ss')||''','''||'dd/mm/yyyy hh24:mi:ss'||''''||')';
 
		end;
	elsif (ie_periodo_w IS NOT NULL AND ie_periodo_w::text <> '') and (qt_periodo_w IS NOT NULL AND qt_periodo_w::text <> '') and (ie_periodo_atual_w = 'N') then 
		begin 
		dt_final_ww := clock_timestamp();
		if (ie_periodo_w = 'A') then 
			qt_periodo_w	:= qt_periodo_w * 12;
			dt_final_ww	:= PKG_DATE_UTILS.start_of(clock_timestamp(), 'YEAR', 0);
			dt_inicial_ww	:= PKG_DATE_UTILS.ADD_MONTH(pkg_date_utils.start_of(clock_timestamp(),'DD',0), -qt_periodo_w, 0);
		elsif (ie_periodo_w = 'M') then 
			dt_final_ww	:= PKG_DATE_UTILS.start_of(clock_timestamp(), 'MONTH', 0);
			dt_inicial_ww	:= PKG_DATE_UTILS.ADD_MONTH(PKG_DATE_UTILS.start_of(clock_timestamp(), 'MONTH', 0), -qt_periodo_w, 0);
		elsif (ie_periodo_w = 'S') then 
			qt_periodo_w	:= qt_periodo_w * 7;
			dt_final_ww	:= pkg_date_utils.start_of(clock_timestamp(),'DD',0);
			dt_inicial_ww	:= pkg_date_utils.start_of(clock_timestamp(),'DD',0) - qt_periodo_w;
		elsif (ie_periodo_w = 'D') then 
			dt_final_w	:= clock_timestamp();
			dt_inicial_ww	:= clock_timestamp() - qt_periodo_w/24;
		end if;
 
		dt_inicial_w	:= 'to_date('||''''||to_char(dt_inicial_ww,'dd/mm/yyyy')||''','''||'dd/mm/yyyy'||''''||')';
		dt_final_w	:= 'to_date('||''''||to_char(fim_dia(dt_final_ww),'dd/mm/yyyy hh24:mi:ss')||''','''||'dd/mm/yyyy hh24:mi:ss'||''''||')';
 
		end;
	end if;
 
	DS_SQL_W := REPLACE(DS_SQL_W, ':DT_INI', DT_INICIAL_W);
	DS_SQL_W := REPLACE(DS_SQL_W, ':DT_FIM', DT_FINAL_W);
	DS_SQL_W := REPLACE(DS_SQL_W, ':CD_MATERIAL', CD_MATERIAL_P);
	DS_SQL_W := REPLACE(DS_SQL_W, ':CD_ESTABELECIMENTO', CD_ESTABELECIMENTO_P);
	DS_SQL_W := REPLACE(DS_SQL_W, ':CD_EMPRESA', CD_EMPRESA_P);
 
	begin 
 
	c001	:= dbms_sql.open_cursor;
	dbms_sql.parse(c001,ds_sql_w,dbms_sql.native);
	dbms_sql.define_column(c001, 1, vl_coluna_w, 255);
	ds_resultado_w	:= dbms_sql.execute(c001);
	ds_resultado_w	:= dbms_sql.fetch_rows(c001);
	dbms_sql.column_value(c001,1,vl_coluna_w);
	dbms_sql.close_cursor(c001);
 
 
	ds_resultado_w := coalesce(vl_coluna_w,0);
 
	ds_macro_w := '#A_'||ds_macro_w||'@';
 
	exception 
	when others then 
		begin 
		ds_resultado_w := null;
		ds_macro_w := '#E_'||ds_macro_w||'@';
		end;
	end;
 
	insert into w_pcs_atributo_formula( 
		ds_macro, 
		ds_resultado, 
		nr_seq_formula, 
		ds_sql, 
		cd_material, 
		nm_usuario) 
	values (ds_macro_w, 
		ds_resultado_w, 
		null, 
		ds_sql_w, 
		cd_material_p, 
		nm_usuario_p);
	end;
end loop;
close C01;
 
commit;
 
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pcs_sup_gerar_planej_pck.pcs_montar_consulta (( cd_material_p bigint, cd_estabelecimento_p bigint, cd_empresa_p bigint, nm_usuario_p text) is  c001 integer) FROM PUBLIC;