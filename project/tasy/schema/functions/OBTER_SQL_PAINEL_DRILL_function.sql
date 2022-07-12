-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_sql_painel_drill (nr_seq_indicador_p bigint, ds_drill_p text, vl_dimensao_p text) RETURNS varchar AS $body$
DECLARE


nm_atributo_w		varchar(85);
ds_sql_informacao_w	varchar(2000);
ds_sql_dimensao_w	varchar(85);
ds_dimensao_w		varchar(85);
ds_sql_w		varchar(4000);
ds_tabela_visao_w	varchar(50);
ds_order_w		varchar(100);
ds_sql_where_w		varchar(2000);

C01 CURSOR FOR
	SELECT		nm_atributo
	from		indicador_gestao_atrib
	where		nr_seq_ind_gestao	=	nr_seq_indicador_p
	and		(ds_informacao IS NOT NULL AND ds_informacao::text <> '');


BEGIN

OPEN C01;
LOOP
FETCH C01 into
	nm_atributo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_sql_informacao_w	:=	ds_sql_informacao_w || ', ' || 'sum(' || nm_atributo_w || ') ' || nm_atributo_w;
	end;
END LOOP;
CLOSE C01;

select	nm_atributo,
	CASE WHEN ie_classificacao_ordem='D' THEN  '1'||CASE WHEN ie_tipo_ordem_classif='A' THEN  ' Asc '  ELSE ' Desc ' END  ||',2'   ELSE '2 '||CASE WHEN ie_tipo_ordem_classif='A' THEN  ' Asc

'  ELSE ' Desc ' END  ||',1' END
into STRICT	ds_dimensao_w,
	ds_order_w
from	indicador_gestao_atrib
where	nr_seq_ind_gestao	=	nr_seq_indicador_p
and	(ds_dimensao IS NOT NULL AND ds_dimensao::text <> '');


select	ds_tabela_visao,
	ds_sql_where
into STRICT	ds_tabela_visao_w,
	ds_sql_where_w
from	indicador_gestao
where	nr_sequencia		=	nr_seq_indicador_p;

if (substr(ds_dimensao_w,1,3) = 'DT_') then
	ds_sql_dimensao_w	:=	ds_dimensao_w;
else
	ds_sql_dimensao_w	:=	'substr(' || ds_dimensao_w || ',1,255)'|| ds_dimensao_w;
end if;

ds_sql_w	:= 	' select '	|| ds_drill_p || ds_sql_informacao_w ||
			' from ' 	|| ds_tabela_visao_w	||
			' where 1 = 1 ' || ds_sql_where_w	||
			' and '		|| ds_dimensao_w || '=' || chr(39) || vl_dimensao_p || chr(39) ||
			' group by ' 	|| ds_drill_p || chr(13) ||
			' order by ' 	|| ds_order_w;


return ds_sql_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_sql_painel_drill (nr_seq_indicador_p bigint, ds_drill_p text, vl_dimensao_p text) FROM PUBLIC;

