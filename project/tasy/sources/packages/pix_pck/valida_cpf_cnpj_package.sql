-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pix_pck.valida_cpf_cnpj (ds_chave_p banco_estab_pix.ds_chave%type) AS $body$
DECLARE

        ie_valido_w varchar(1) := 'N';

BEGIN
        
        if (length(ds_chave_p) = 11) then
            ie_valido_w := obter_se_cpf_valido(nr_cpf_p => ds_chave_p);
        elsif (length(ds_chave_p) = 14) then
            ie_valido_w := obter_se_cnpj_valido(nr_cnpj_p => ds_chave_p);
        else
            ie_valido_w := 'N';
        end if;

        if (ie_valido_w = 'N') then
            CALL wheb_mensagem_pck.exibir_mensagem_abort(1080026);
        end if;

    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pix_pck.valida_cpf_cnpj (ds_chave_p banco_estab_pix.ds_chave%type) FROM PUBLIC;
