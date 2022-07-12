-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_cons_val_lote_massas (nr_seq_exame_p bigint, qt_result_p bigint, ds_result_p text, nr_seq_prescr_p bigint, ie_opcao_p bigint, nr_seq_resultado_p bigint, nr_seq_patologia_p bigint, nr_seq_grupo_pat_p bigint) RETURNS varchar AS $body$
DECLARE


criterio                                            lab_lote_crit_massa%rowtype;
ds_mensagem_criterio_padrao_w                       exame_lab_result_item.ds_mensagem_criterio%type;
ds_retorno_w                                        varchar(4000);


BEGIN

    /*
    ie_opcao_p
    1 - retorna descricao do tipo de valor
    2 - retorna o ie_tipo_valor como number
    3 - retorna a mensagem do criterio
    4 - retorna a acao cadastrada no criterio
    5 - retorna o qt_dias cadastrado no criterio
    6 - retorna o tipo de busca cadastrado para o criterio
    7 - retorna codigo ie_acao_criterio
    8 - retorna resultado sugerido
    9 - retorna o material do criterio
    10 - retorna o metodo do criterio
    */
    -- obtendo o criterio
    criterio := pkg_manter_criterio_massas.consultar_criterio_massas(nr_seq_exame_p,
                                                                     qt_result_p,
                                                                     ds_result_p,
                                                                     nr_seq_prescr_p,
                                                                     nr_seq_resultado_p,
                                                                     nr_seq_patologia_p,
                                                                     nr_seq_grupo_pat_p);

    -- nao trouxe registros no select
    if (coalesce(criterio.nr_sequencia::text, '') = '' or criterio.ie_tipo_valor = 0) then
        if (ie_opcao_p = 1) then
            -- 'referencia'
            ds_retorno_w := wheb_mensagem_pck.get_texto(308858);
        elsif (ie_opcao_p = 2) then
            ds_retorno_w := '0';
        end if;
    else
        if (ie_opcao_p = 1) then
            if (criterio.ie_tipo_valor = 1) then
                ds_retorno_w := wheb_mensagem_pck.get_texto(308857);
            else
                ds_retorno_w := wheb_mensagem_pck.get_texto(308856);
            end if;
        elsif (ie_opcao_p = 2) then
            ds_retorno_w := '1';
        elsif (ie_opcao_p = 3) then
            ds_retorno_w := criterio.ds_msg_criterio;
        elsif (ie_opcao_p = 4) then
            ds_retorno_w := criterio.ds_acao_criterio;
        elsif (ie_opcao_p = 5) then
            ds_retorno_w := criterio.qt_dias_prev;
        elsif (ie_opcao_p = 6) then
            ds_retorno_w := criterio.ie_tipo_busca;
        elsif (ie_opcao_p = 7) then
            ds_retorno_w := criterio.ie_acao_criterio;
        elsif (ie_opcao_p = 8) then
            ds_retorno_w := criterio.ds_resultado_sugerido;
        elsif (ie_opcao_p = 9) then
            ds_retorno_w := criterio.ds_material_criterio;
        elsif (ie_opcao_p = 10) then
            ds_retorno_w := criterio.ds_metodo_criterio;
        end if;
    end if;

    if (ie_opcao_p = 3) then
        select    max(ds_mensagem_criterio)
        into STRICT      ds_mensagem_criterio_padrao_w
        from      exame_lab_result_item
        where     nr_seq_resultado = nr_seq_resultado_p
            and   nr_seq_prescr = nr_seq_prescr_p
            and   (nr_seq_material IS NOT NULL AND nr_seq_material::text <> '');

        if (ds_mensagem_criterio_padrao_w IS NOT NULL AND ds_mensagem_criterio_padrao_w::text <> '') then
            ds_retorno_w := ds_mensagem_criterio_padrao_w;
        end if;
    end if;

    return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_cons_val_lote_massas (nr_seq_exame_p bigint, qt_result_p bigint, ds_result_p text, nr_seq_prescr_p bigint, ie_opcao_p bigint, nr_seq_resultado_p bigint, nr_seq_patologia_p bigint, nr_seq_grupo_pat_p bigint) FROM PUBLIC;

