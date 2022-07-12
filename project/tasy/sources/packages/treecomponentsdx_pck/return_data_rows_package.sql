-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION treecomponentsdx_pck.return_data_rows ( nr_sequencia_p objeto_schematic.nr_sequencia%TYPE, nr_seq_visao_dbpanel_p objeto_schematic.nr_seq_visao%TYPE DEFAULT null, nm_tabela_dbpanel_p objeto_schematic.nm_tabela%TYPE DEFAULT null) RETURNS SETOF T_ITEM_ROW_DATA AS $body$
DECLARE


c01 CURSOR FOR
    SELECT	a.nr_sequencia cd,
            coalesce(obter_desc_expressao(a.cd_exp_desc_obj), a.ds_objeto) ds,
            a.nr_sequencia nr_sequencia,
            a.nm_tabela nm_tabela_dbpanel,
            a.nr_seq_visao nr_seq_visao_dbpanel,
            a.IE_TIPO_OBJETO,
            null nm_tabela_atributo,
            null nm_atributo,
            null ie_informacao_sensivel,
            null label_atributo
    FROM	objeto_schematic a
    WHERE	a.nr_seq_obj_sup = nr_sequencia_p
    and (exists (WITH RECURSIVE cte AS (
	SELECT	1
            FROM	objeto_schematic b WHERE b.nr_sequencia = a.nr_sequencia
  UNION ALL
	SELECT	1
            FROM	objeto_schematic b JOIN cte c ON (c.nr_sequencia = b.nr_seq_obj_sup)

) SELECT * FROM cte WHERE nr_seq_funcao_schematic = nr_seq_funcao_schematic
            AND	nr_sequencia <> nr_sequencia
            AND	IE_TIPO_COMPONENTE = 'WDBP';
)
    or	a.IE_TIPO_COMPONENTE = 'WDBP')
    
union all

    select	999 cd,
        b.nm_atributo ds,
        null nr_sequencia,
        null nm_tabela_dbpanel,
        null nr_seq_visao_dbpanel,
        null IE_TIPO_OBJETO,
        a.nm_tabela nm_tabela_atributo,
        b.nm_atributo,
        c.ie_informacao_sensivel,
        substr(obter_desc_expressao(b.cd_exp_label),1,254) label_atributo
    from	tabela_visao a,
        tabela_visao_atributo b,
        tabela_atributo c
    where	a.nm_tabela = nm_tabela_dbpanel_p
    and	a.nr_sequencia = obter_visao_pais_usage_config(nr_seq_visao_dbpanel_p)
    and	a.nr_sequencia = b.nr_sequencia
    and	a.nm_tabela = c.nm_tabela
    and	b.nm_atributo = c.nm_atributo
    and	c.ie_tipo_atributo <> 'FUNCTION';

    t_item_row_w	t_item_row;


BEGIN

    for r_c01 in c01
    loop
        begin
            t_item_row_w := r_c01;
            RETURN NEXT t_item_row_w;
        END;
    END LOOP;

    return;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION treecomponentsdx_pck.return_data_rows ( nr_sequencia_p objeto_schematic.nr_sequencia%TYPE, nr_seq_visao_dbpanel_p objeto_schematic.nr_seq_visao%TYPE DEFAULT null, nm_tabela_dbpanel_p objeto_schematic.nm_tabela%TYPE DEFAULT null) FROM PUBLIC;