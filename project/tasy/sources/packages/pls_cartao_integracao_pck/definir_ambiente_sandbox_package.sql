-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_cartao_integracao_pck.definir_ambiente_sandbox () AS $body$
DECLARE

        c01 CURSOR(ds_sistema_p intpd_sistemas.ds_sistema%type) FOR
            SELECT nr_sequencia from intpd_sistemas where upper(ds_sistema) = upper(ds_sistema_p);

        ds_endpoint_w intpd_sistemas.ds_endpoint%type;
        ambiente_w    ambiente_r := pls_cartao_integracao_pck.sandbox();

        merchant_key_sandbox_w constant varchar(32) := 'BJBIRDYLGYTOFODDMTMHSACGOKWWXHOKAICMILYJ';
        merchant_id_sandbox_w  constant varchar(32) := '9fec3672-c507-489f-beb4-697ae0f64c11';
        nr_sequencia_w intpd_sistemas.nr_sequencia%type;

BEGIN
        nr_sequencia_w := null;
        ds_endpoint_w  := ambiente_w.api_url || current_setting('pls_cartao_integracao_pck.ds_endpoint_sales_w')::intpd_sistemas.ds_endpoint%type;
        open c01(wheb_mensagem_pck.get_texto(1112567));
        fetch c01
            into nr_sequencia_w;
        close c01;

        update intpd_sistemas
           set ds_endpoint = ds_endpoint_w,
               ds_host     = ambiente_w.api_url
         where nr_sequencia = nr_sequencia_w;

        nr_sequencia_w := null;
        ds_endpoint_w  := ambiente_w.api_url || current_setting('pls_cartao_integracao_pck.ds_endpoint_cancelar_w')::intpd_sistemas.ds_endpoint%type;
        open c01('CIELO - Capturar Transacao');
        fetch c01
            into nr_sequencia_w;
        close c01;

        update intpd_sistemas
           set ds_endpoint = ds_endpoint_w,
               ds_host     = ambiente_w.api_url
         where nr_sequencia = nr_sequencia_w;

        nr_sequencia_w := null;
        ds_endpoint_w  := ambiente_w.api_url || current_setting('pls_cartao_integracao_pck.ds_endpoint_capturar_w')::intpd_sistemas.ds_endpoint%type;
        open c01('CIELO - Capturar Transacao');
        fetch c01
            into nr_sequencia_w;
        close c01;

        update intpd_sistemas
           set ds_endpoint = ds_endpoint_w,
               ds_host     = ambiente_w.api_url
         where nr_sequencia = nr_sequencia_w;

        update intpd_eventos_cabecalho iec
           set iec.ds_value = merchant_key_sandbox_w
         where iec.nr_seq_evento_sis in (SELECT ies.nr_sequencia
                  from intpd_eventos_sistema ies,
                       intpd_eventos         ie
                 where ies.nr_seq_evento = ie.nr_sequencia
                   and ie.ie_evento in (current_setting('pls_cartao_integracao_pck.ie_evento_recorrencia_propria')::valor_dominio.vl_dominio%type, current_setting('pls_cartao_integracao_pck.ie_evento_capturar_transacao')::valor_dominio.vl_dominio%type, current_setting('pls_cartao_integracao_pck.ie_evento_cancelar_transacao')::valor_dominio.vl_dominio%type))
           and iec.ds_header_name = 'MerchantKey';

        update intpd_eventos_cabecalho iec
           set iec.ds_value = merchant_id_sandbox_w
         where iec.nr_seq_evento_sis in (SELECT ies.nr_sequencia
                  from intpd_eventos_sistema ies,
                       intpd_eventos         ie
                 where ies.nr_seq_evento = ie.nr_sequencia
                   and ie.ie_evento in (current_setting('pls_cartao_integracao_pck.ie_evento_recorrencia_propria')::valor_dominio.vl_dominio%type, current_setting('pls_cartao_integracao_pck.ie_evento_capturar_transacao')::valor_dominio.vl_dominio%type, current_setting('pls_cartao_integracao_pck.ie_evento_cancelar_transacao')::valor_dominio.vl_dominio%type))
           and iec.ds_header_name = 'MerchantId';
        -- Alterar Tabela de Parametro

        update pls_cartao_parametro pcp
           set pcp.ds_api_url       = ambiente_w.api_url,
               pcp.ds_api_query_url = ambiente_w.api_query_url,
               pcp.ds_merchant_key  = merchant_key_sandbox_w,
               pcp.ds_merchant_id   = merchant_id_sandbox_w;
    end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cartao_integracao_pck.definir_ambiente_sandbox () FROM PUBLIC;