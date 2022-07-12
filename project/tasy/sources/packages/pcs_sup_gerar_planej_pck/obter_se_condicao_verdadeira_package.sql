-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

 
/* Procedure para identificar as condições lógicas das fórmulas */
 


CREATE OR REPLACE PROCEDURE pcs_sup_gerar_planej_pck.obter_se_condicao_verdadeira ( ds_condicao_p text, ie_retorno_p INOUT text, nm_usuario_p text) AS $body$
DECLARE

 
c001				integer;
ds_sql_w			varchar(2000);
vl_coluna_w			varchar(255);
ds_retorno_w			varchar(1);
ds_condicao_original_w		varchar(2000);
ds_informacao_w			varchar(255);
vl_informacao_w			double precision;
vl_atributo_w			varchar(50);
ds_condicao_w			varchar(2000);
tam_condicao_w			bigint;
qt_existe_w			bigint;
ie_pos_separador_w		bigint;
vl_retorno_atrib_w		bigint;


BEGIN 
 
ds_condicao_w				:= '';
ds_condicao_original_w		:= ds_condicao_p;
 
/* Verifica se existe algum atributo e/ou fórmula dentro da condição para substituir */
 
select	count(*) 
into STRICT	qt_existe_w 
 
where	ds_condicao_original_w like '%#%';
 
 
/* Monta o SQL para verificar se a condição é True ou False */
 --importante 
 
if (coalesce(ds_condicao_original_w::text, '') = '') then 
	ds_condicao_original_w := '1 = 1';
end if;
 
ds_sql_w	:= 'select count(*) from dual where ' || ds_condicao_original_w;
c001	:= dbms_sql.open_cursor;
dbms_sql.parse(c001,ds_sql_w,dbms_sql.native);
dbms_sql.define_column(c001, 1, vl_coluna_w, 255);
vl_retorno_atrib_w	:= dbms_sql.execute(c001);
vl_retorno_atrib_w	:= dbms_sql.fetch_rows(c001);
dbms_sql.column_value(c001, 1, vl_coluna_w);
dbms_sql.close_cursor(c001);
 
if (vl_coluna_w = '0') then 
	ie_retorno_p	:= 'N';
else 
	ie_retorno_p	:= 'S';
end if;
 
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pcs_sup_gerar_planej_pck.obter_se_condicao_verdadeira ( ds_condicao_p text, ie_retorno_p INOUT text, nm_usuario_p text) FROM PUBLIC;