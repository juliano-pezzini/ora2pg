-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pontuacao_score_flex ( nr_atendimento_p bigint, ds_table_p text, ds_table_nr_field_p text, nr_seq_escala_p bigint, ds_table_dt_field_p text, vl_rownumber_p bigint) RETURNS bigint AS $body$
DECLARE


ds_pontuacao_w		double precision := null;
ds_sql				varchar(1000);
ds_query_column varchar(150) := ds_table_nr_field_p;
filtrar_liberacao_w    tabela_atributo.nr_sequencia_criacao%type;


BEGIN

if ((nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '')
	and (ds_table_p IS NOT NULL AND ds_table_p::text <> '')
	and (ds_table_nr_field_p IS NOT NULL AND ds_table_nr_field_p::text <> '')
	and (nr_seq_escala_p IS NOT NULL AND nr_seq_escala_p::text <> '')
	and (ds_table_dt_field_p IS NOT NULL AND ds_table_dt_field_p::text <> '')
	and (vl_rownumber_p IS NOT NULL AND vl_rownumber_p::text <> '')) then

	  select max(a.nr_sequencia_criacao)
    into STRICT filtrar_liberacao_w
    from tabela_atributo a
    where a.nm_tabela = upper(ds_table_p)
      and a.nm_atributo = 'DT_LIBERACAO';

	if (ds_table_p = 'escala_eif' and ds_table_nr_field_p = 'qt_pontos') then
	   ds_query_column := 'substr(obter_resultado_escala_eif(nr_sequencia,''T''),1,255) ' || ds_table_nr_field_p;
	end if;

	ds_sql :=	' select ' || ds_table_nr_field_p || ' from (' ||
				'       select rownum RN, ' || ds_table_nr_field_p || ' from (' ||
				'                 select ' || ds_query_column || ' from ' || ds_table_p ||
				'                 where nr_atendimento = :nr_atendimento_p' ||
				'                 and nr_seq_escala = :nr_seq_escala_p';

    if (filtrar_liberacao_w = 1) then
        ds_sql := ds_sql || ' AND DT_LIBERACAO IS NOT NULL';
    end if;

	ds_sql :=	ds_sql ||
				'                 order by ' || ds_table_dt_field_p || ' desc, nr_sequencia desc)' ||
				'       where  rownum <=2) ' ||
				' where RN = :vl_rownumber_p';

	begin
		EXECUTE
			ds_sql
		into STRICT
			ds_pontuacao_w
		using
			nr_atendimento_p, nr_seq_escala_p, vl_rownumber_p;

		EXCEPTION WHEN no_data_found then
			ds_pontuacao_w := null;

	end;

end if;

return ds_pontuacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pontuacao_score_flex ( nr_atendimento_p bigint, ds_table_p text, ds_table_nr_field_p text, nr_seq_escala_p bigint, ds_table_dt_field_p text, vl_rownumber_p bigint) FROM PUBLIC;
