-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION search_vit_sign_prof_review.get_data (nr_sequencia_p bigint, nm_tabela_p text) RETURNS SETOF T_OBJETO_ROW_DATA AS $body$
DECLARE



t_objeto_row_w		t_objeto_row;
ds_sql_w varchar(2000);
ds_sql_return_w varchar(2000);
				
tabFields CURSOR FOR 
SELECT ps.nm_atributo, ps.ds_sinal_vital, vd.cd_exp_valor_dominio, obter_expressao_idioma(vd.cd_exp_valor_dominio, wheb_usuario_pck.get_nr_seq_idioma) ds_exp
from pepo_sv ps
inner join valor_dominio vd on vd.cd_dominio = 1768 and vd.vl_dominio = ps.ie_sinal_vital
where nm_tabela = nm_tabela_p;
				
BEGIN
	for c1 in tabFields loop	
		ds_sql_w := 'select '|| c1.nm_atributo;
		ds_sql_w := ds_sql_w || ' from ' || nm_tabela_p;
		ds_sql_w := ds_sql_w || ' where nr_sequencia = ' || nr_sequencia_p;
			
		EXECUTE ds_sql_w into STRICT ds_sql_return_w;
	
		if ((ds_sql_return_w IS NOT NULL AND ds_sql_return_w::text <> '') or ds_sql_return_w > 0) then
			t_objeto_row_w.nm_atributo := c1.nm_atributo;
			t_objeto_row_w.ds_atributo := c1.ds_exp;
			t_objeto_row_w.vl_atributo := ds_sql_return_w;
			RETURN NEXT t_objeto_row_w;
		end if;
	end loop;	
return;	
end;				

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION search_vit_sign_prof_review.get_data (nr_sequencia_p bigint, nm_tabela_p text) FROM PUBLIC;