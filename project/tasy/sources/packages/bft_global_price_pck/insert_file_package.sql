-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE bft_global_price_pck.insert_file ( ds_file_p text, cd_empresa_p text, cd_estabelecimento_p bigint, cd_tab_preco_mat_p bigint, nm_usuario_p text) AS $body$
BEGIN

   
    if (cd_empresa_p    = 'Alfabeta') then
        CALL processar_xml_alfabeta(ds_file_p,cd_estabelecimento_p,cd_tab_preco_mat_p,nm_usuario_p);
    end if;

    commit;

    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE bft_global_price_pck.insert_file ( ds_file_p text, cd_empresa_p text, cd_estabelecimento_p bigint, cd_tab_preco_mat_p bigint, nm_usuario_p text) FROM PUBLIC;
