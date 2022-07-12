-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_high_cost_file_name_code ( cd_convenio_p alto_custo.cd_convenio%type) RETURNS varchar AS $body$
DECLARE


cd_eabp_w convenio_plano.cd_entidade_administradora%type := null;
cd_divipola_w end_endereco.cd_endereco_catalogo%type := null;
cd_file_name_w end_endereco.cd_endereco_catalogo%type := null;


BEGIN

    select  max(c.cd_entidade_administradora)
    into STRICT    cd_eabp_w
    from    alto_custo a,
            convenio_plano c
    where   a.cd_convenio = cd_convenio_p
    and     c.cd_convenio = a.cd_convenio
    and     (c.cd_entidade_administradora IS NOT NULL AND c.cd_entidade_administradora::text <> '');

    if (coalesce(cd_eabp_w::text, '') = '') then
        select  max(distinct n.cd_endereco_catalogo)
        into STRICT cd_divipola_w
        from alto_custo a,
            convenio c,
            pessoa_juridica p,
            pessoa_endereco e,
            pessoa_endereco_item i,
            end_endereco n
        where a.cd_convenio = cd_convenio_p
        and c.cd_convenio = a.cd_convenio
        and upper(p.cd_cgc) like upper(c.cd_cgc)
        and e.nr_sequencia = p.nr_seq_pessoa_endereco
        and i.nr_seq_pessoa_endereco = e.nr_sequencia
        and n.nr_seq_catalogo = e.nr_seq_catalogo
        and n.nr_sequencia = i.nr_seq_end_endereco
        and n.ie_informacao = 'DISTRITO';
    end if;

    if (cd_eabp_w IS NOT NULL AND cd_eabp_w::text <> '') then
        cd_file_name_w := cd_eabp_w;
    else
        cd_file_name_w := cd_divipola_w;
    end if;

    return cd_file_name_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_high_cost_file_name_code ( cd_convenio_p alto_custo.cd_convenio%type) FROM PUBLIC;

