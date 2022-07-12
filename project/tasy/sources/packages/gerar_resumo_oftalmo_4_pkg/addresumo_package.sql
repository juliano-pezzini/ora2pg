-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE gerar_resumo_oftalmo_4_pkg.addresumo (ds_resumo_p text) AS $body$
BEGIN
        begin
            PERFORM set_config('gerar_resumo_oftalmo_4_pkg.ds_resumo_w', current_setting('gerar_resumo_oftalmo_4_pkg.ds_resumo_w')::varchar(32000) || ds_resumo_p, false);
        exception
            when OTHERS then
            CALL CALL CALL CALL gerar_resumo_oftalmo_4_pkg.gravar_resumo_banco(null);
            PERFORM set_config('gerar_resumo_oftalmo_4_pkg.ds_resumo_w', ds_resumo_p, false);
        end;
    end;


$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON PROCEDURE gerar_resumo_oftalmo_4_pkg.addresumo (ds_resumo_p text) FROM PUBLIC;
