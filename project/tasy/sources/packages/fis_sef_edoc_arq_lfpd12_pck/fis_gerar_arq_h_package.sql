-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE fis_sef_edoc_arq_lfpd12_pck.fis_gerar_arq_h ( nr_seq_controle_p bigint, nr_linha_p INOUT bigint ) AS $body$
BEGIN

--Inicializa valores de variaveias
PERFORM set_config('fis_sef_edoc_arq_lfpd12_pck.nr_linha_w', nr_linha_p, false);
PERFORM set_config('fis_sef_edoc_arq_lfpd12_pck.nr_seq_controle_w', nr_seq_controle_p, false);
PERFORM set_config('fis_sef_edoc_arq_lfpd12_pck.nm_usuario_w', Obter_Usuario_Ativo, false);

--Cursor Pincipal
open current_setting('fis_sef_edoc_arq_lfpd12_pck.c_controle')::CURSOR;
fetch current_setting('fis_sef_edoc_arq_lfpd12_pck.c_controle')::into CURSOR current_setting('fis_sef_edoc_arq_lfpd12_pck.vetregcontrole')::fis_sef_edoc_controle%RowType;
close current_setting('fis_sef_edoc_arq_lfpd12_pck.c_controle')::CURSOR;

-- Abertura do bloco
CALL fis_sef_edoc_arq_lfpd12_pck.fis_gerar_arq_abertura_h();

-- chama fis_gerar_arq_H020_edoc
CALL fis_sef_edoc_arq_lfpd12_pck.fis_gerar_arq_h020_edoc();

-- Encerramento do bloco
CALL fis_sef_edoc_arq_lfpd12_pck.fis_gerar_arq_encerram_h();

nr_linha_p := current_setting('fis_sef_edoc_arq_lfpd12_pck.nr_linha_w')::fis_sef_edoc_arquivo.nr_linha%type;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_sef_edoc_arq_lfpd12_pck.fis_gerar_arq_h ( nr_seq_controle_p bigint, nr_linha_p INOUT bigint ) FROM PUBLIC;
