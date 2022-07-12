-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE fis_sef_edoc_arq_lfpd01_pck.fis_herar_arq_abertura_c () AS $body$
DECLARE


ie_movimento_w varchar(1) := '1';


BEGIN

if current_setting('fis_sef_edoc_arq_lfpd01_pck.vetregcontrole')::fis_sef_edoc_controle%RowType.ie_mov_c = 'S' then
   ie_movimento_w := '0';
end if;

PERFORM set_config('fis_sef_edoc_arq_lfpd01_pck.nr_linha_w', current_setting('fis_sef_edoc_arq_lfpd01_pck.nr_linha_w')::fis_sef_edoc_arquivo.nr_linha%type + 1, false);
PERFORM set_config('fis_sef_edoc_arq_lfpd01_pck.ds_linha_w', substr(current_setting('fis_sef_edoc_arq_lfpd01_pck.ds_sep_w')::varchar(1) || 'C001' || current_setting('fis_sef_edoc_arq_lfpd01_pck.ds_sep_w')::varchar(1) || ie_movimento_w ||current_setting('fis_sef_edoc_arq_lfpd01_pck.ds_sep_w')::varchar(1),1,8000), false);

CALL CALL CALL CALL fis_sef_edoc_arq_lfpd01_pck.insere_arquivo(  current_setting('fis_sef_edoc_arq_lfpd01_pck.ds_linha_w')::varchar(8000) , 'C001' );

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_sef_edoc_arq_lfpd01_pck.fis_herar_arq_abertura_c () FROM PUBLIC;
