-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

    
    /** 
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	create/update log and index file
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    **/
 


CREATE OR REPLACE PROCEDURE tosho_pck.save_log (cd_event_p bigint, ds_file_p text, new_line_p text) AS $body$
BEGIN
            CALL pls_utl_file_pck.nova_leitura(cd_event_p, ds_file_p, 'A'); --If the file exists it appends to the file and if it doesnot exist it will open the file in Write mode
            CALL pls_utl_file_pck.escrever(new_line_p);
            CALL pls_utl_file_pck.fechar_arquivo('T'); --close the file
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tosho_pck.save_log (cd_event_p bigint, ds_file_p text, new_line_p text) FROM PUBLIC;