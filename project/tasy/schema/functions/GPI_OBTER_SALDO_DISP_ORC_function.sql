-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gpi_obter_saldo_disp_orc ( nr_seq_proj_gpi_p gpi_projeto.nr_sequencia%type, nr_seq_orcamento_p gpi_orcamento.nr_sequencia%type, nr_seq_orc_item_p gpi_orc_item.nr_sequencia%type, cd_material_p gpi_orc_item.cd_material%type, cd_centro_custo_p gpi_orc_item.cd_centro_custo%type) RETURNS bigint AS $body$
DECLARE


qt_saldo_w  gpi_orc_item.qt_real%type;


BEGIN

if (coalesce(nr_seq_orc_item_p,0) != 0) then
    begin
    select (coalesce(a.qt_item,0) - coalesce(a.qt_real,0))
    into STRICT    qt_saldo_w
    from    gpi_orc_item a
    where   a.nr_sequencia  = nr_seq_orc_item_p;
    exception when others then
        qt_saldo_w  := 0;
    end;
else
    begin
    select  coalesce(sum(a.qt_item),0) - coalesce(sum(a.qt_real),0)
    into STRICT    qt_saldo_w
    from    gpi_orc_item a,
            gpi_orcamento b
    where   b.nr_sequencia      = a.nr_seq_orcamento
    and     b.nr_seq_projeto    = coalesce(nr_seq_proj_gpi_p,b.nr_seq_projeto)
    and     b.nr_sequencia      = coalesce(nr_seq_orcamento_p,b.nr_sequencia)
    and     coalesce(a.cd_material,coalesce(cd_material_p,0)) = coalesce(cd_material_p,0)
    and     coalesce(a.cd_centro_custo, coalesce(cd_centro_custo_p,0)) = coalesce(cd_centro_custo_p,0)
    and     (b.dt_aprovacao IS NOT NULL AND b.dt_aprovacao::text <> '')
    and     b.ie_situacao   = 'A';

    end;
end if;

return qt_saldo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gpi_obter_saldo_disp_orc ( nr_seq_proj_gpi_p gpi_projeto.nr_sequencia%type, nr_seq_orcamento_p gpi_orcamento.nr_sequencia%type, nr_seq_orc_item_p gpi_orc_item.nr_sequencia%type, cd_material_p gpi_orc_item.cd_material%type, cd_centro_custo_p gpi_orc_item.cd_centro_custo%type) FROM PUBLIC;
