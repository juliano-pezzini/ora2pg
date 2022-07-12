-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pix_pck.valida_chave_aleatoria (ds_chave_p banco_estab_pix.ds_chave%type) AS $body$
DECLARE

        ds_reg_aleatoria_w varchar(60):= '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}';
        ie_valido_w varchar(1) := 'N';

BEGIN
        select  1
        into STRICT  ie_valido_w
        
        where   regexp_like(ds_chave_p, ds_reg_aleatoria_w);
        exception
            when no_data_found then
                CALL wheb_mensagem_pck.exibir_mensagem_abort(1080026);
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pix_pck.valida_chave_aleatoria (ds_chave_p banco_estab_pix.ds_chave%type) FROM PUBLIC;
