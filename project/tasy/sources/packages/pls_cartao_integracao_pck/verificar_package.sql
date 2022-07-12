-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_cartao_integracao_pck.verificar (valor_atual_p text, valor_novo_p text, mensagem_p text default null) AS $body$
DECLARE

        mensagem_w varchar(4000) := 'esperava %0 e obteve %1.';

BEGIN
        if (mensagem_p IS NOT NULL AND mensagem_p::text <> '') then
            mensagem_w := mensagem_p;
        end if;
        if valor_atual_p != valor_novo_p or (coalesce(valor_atual_p::text, '') = '' and (valor_novo_p IS NOT NULL AND valor_novo_p::text <> '')) or ((valor_atual_p IS NOT NULL AND valor_atual_p::text <> '') and coalesce(valor_novo_p::text, '') = '') then
            CALL wheb_mensagem_pck.exibir_mensagem_abort(replace(replace(mensagem_w, '%0', valor_novo_p), '%1', valor_atual_p));
        end if;
    end;

    /*
    Funcao para configurar o pagamento com cartao de credito
    %param ambiente_p Configurarqual abimente PRODUCAO, SANDBOX
    %param merchant_id_p Identificador da loja na Cielo.
    %param merchant_key_p Chave Publica para Autenticacao Dupla na Cielo.
    %param nm_usuario_p Nome do usuario
    %param DS_IP_PROXY_p IP do servidor de proxy, default null
    %param DS_PORTA_PROXY_p Porta do servidor de proxy, default null
    %param DS_USUARIO_PROXY_p Nome do usuario do proxy, default null
    %param DS_SENHA_PROXY_p Senha do usuario do proxy, default null
    */


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cartao_integracao_pck.verificar (valor_atual_p text, valor_novo_p text, mensagem_p text default null) FROM PUBLIC;
