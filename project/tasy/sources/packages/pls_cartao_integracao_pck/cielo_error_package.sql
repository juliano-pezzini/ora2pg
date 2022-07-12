-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_cartao_integracao_pck.cielo_error (value_p text) RETURNS CIELO_ERROR_TAB AS $body$
DECLARE

        erro_list_w philips_json_list;
        erro_w      philips_json;
        result_w    cielo_error_tab;

BEGIN
        erro_list_w := philips_json_list(value_p);
        for i in 1 .. erro_list_w.count loop
            erro_w := philips_json(erro_list_w.get(i));
            if erro_w.exist('Code') then
                result_w[i].code := erro_w.get['Code'].get_number;
            else
                result_w[i].code := null;
            end if;

            if erro_w.exist('Message') then
                result_w[i].message := erro_w.get['Message'].get_string;
            end if;
        end loop;

        return result_w;
    end;

    /*
    Procedimento para realizar a solicitacao de pagamento
    %param nr_seq_pagador_fin_p Sequencia do pagador
    %param vl_solicitacao_p valor da solicitacao
    %param qt_parcela_p quantidade de parcela
    %param ds_curta_fatura_p Texto que sera impresso na fatura bancaria do portador - Disponivel apenas para VISA/MASTER - nao permite caracteres especiais
    %param nm_usuario_p nome do usuario que fez a solicitocao do pagamento
    */


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_cartao_integracao_pck.cielo_error (value_p text) FROM PUBLIC;
