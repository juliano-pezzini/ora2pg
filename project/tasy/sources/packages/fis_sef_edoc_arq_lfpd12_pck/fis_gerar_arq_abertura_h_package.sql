-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE fis_sef_edoc_arq_lfpd12_pck.fis_gerar_arq_abertura_h () AS $body$
DECLARE


ie_movimento_w varchar(1) := '1';


BEGIN

if current_setting('fis_sef_edoc_arq_lfpd12_pck.vetregcontrole')::fis_sef_edoc_controle%RowType.ie_mov_h = 'S' then
   ie_movimento_w := '0';
end if;

PERFORM set_config('fis_sef_edoc_arq_lfpd12_pck.nr_linha_w', current_setting('fis_sef_edoc_arq_lfpd12_pck.nr_linha_w')::fis_sef_edoc_arquivo.nr_linha%type + 1, false);
PERFORM set_config('fis_sef_edoc_arq_lfpd12_pck.ds_linha_w', substr(current_setting('fis_sef_edoc_arq_lfpd12_pck.ds_sep_w')::varchar(1) || 'H001' || current_setting('fis_sef_edoc_arq_lfpd12_pck.ds_sep_w')::varchar(1) || ie_movimento_w ||current_setting('fis_sef_edoc_arq_lfpd12_pck.ds_sep_w')::varchar(1),1,8000), false);

-- Insere  registro de arquivo
CALL CALL CALL CALL fis_sef_edoc_arq_lfpd12_pck.insere_arquivo(  current_setting('fis_sef_edoc_arq_lfpd12_pck.ds_linha_w')::varchar(8000) , 'H001' );

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_sef_edoc_arq_lfpd12_pck.fis_gerar_arq_abertura_h () FROM PUBLIC;
