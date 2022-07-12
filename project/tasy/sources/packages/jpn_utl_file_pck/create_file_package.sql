-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE jpn_utl_file_pck.create_file ( cd_evento_p evento_tasy_utl_file.cd_evento%type, nm_arquivo_p text, ie_valida_dir_ws_p text, qt_tamanho_max_linha_p bigint, ds_local_p INOUT text, ie_local_p text default 'W') AS $body$
DECLARE


-- Variaveis				
ds_local_w		varchar(4000) := null;
ds_local_windows_w	varchar(4000) := null;


BEGIN
-- Get location recognized by ORACLE and WINDOWS to generate the UTL_FILE file
SELECT * FROM jpn_utl_file_pck.get_directory_information_utl( cd_evento_p, ds_local_w, ds_local_windows_w, ie_valida_dir_ws_p) INTO STRICT ds_local_w, ds_local_windows_w;

-- Create and open the text file by UTL_FILE inside the directory recognized by ORACLE
CALL jpn_utl_file_pck.file_options_by_mode( ds_local_w, nm_arquivo_p, 'WB', qt_tamanho_max_linha_p);

ds_local_p := ds_local_w;
if (ie_local_p = 'W') then
	ds_local_p := ds_local_windows_w;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE jpn_utl_file_pck.create_file ( cd_evento_p evento_tasy_utl_file.cd_evento%type, nm_arquivo_p text, ie_valida_dir_ws_p text, qt_tamanho_max_linha_p bigint, ds_local_p INOUT text, ie_local_p text default 'W') FROM PUBLIC;