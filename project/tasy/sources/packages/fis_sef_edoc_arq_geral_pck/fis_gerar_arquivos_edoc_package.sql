-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE fis_sef_edoc_arq_geral_pck.fis_gerar_arquivos_edoc ( nr_seq_controle_p bigint ) AS $body$
BEGIN

PERFORM set_config('fis_sef_edoc_arq_geral_pck.nm_usuario_w', Obter_Usuario_Ativo, false);

PERFORM set_config('fis_sef_edoc_arq_geral_pck.nr_seq_controle_w', nr_seq_controle_p, false);

PERFORM set_config('fis_sef_edoc_arq_geral_pck.nr_linha_w', 0, false);

delete FROM fis_sef_edoc_arquivo
where nr_seq_controle = current_setting('fis_sef_edoc_arq_geral_pck.nr_seq_controle_w')::bigint;

open current_setting('fis_sef_edoc_arq_geral_pck.c_controle')::CURSOR;
fetch current_setting('fis_sef_edoc_arq_geral_pck.c_controle')::into CURSOR current_setting('fis_sef_edoc_arq_geral_pck.vetregcontrole')::fis_sef_edoc_controle%RowType;
close current_setting('fis_sef_edoc_arq_geral_pck.c_controle')::CURSOR;


  PERFORM set_config('fis_sef_edoc_arq_geral_pck.ds_proc_longo_w', substr(wheb_mensagem_pck.get_texto(300326),1,40), false);
  CALL gravar_processo_longo(current_setting('fis_sef_edoc_arq_geral_pck.ds_proc_longo_w')::varchar(40) || ' SEF/e-Doc: ' || current_setting('fis_sef_edoc_arq_geral_pck.vetregcontrole')::fis_sef_edoc_controle%RowType.ds_arquivo  ,'FIS_GERAR_ARQS_SEFEDOC_PCK', 1);

  CALL fis_sef_edoc_arq_geral_pck.fis_gerar_arq_0000();

  if (current_setting('fis_sef_edoc_arq_geral_pck.vetregcontrole')::fis_sef_edoc_controle%RowType.ie_tipo_arquivo = '1') then
    current_setting('fis_sef_edoc_arq_geral_pck.nr_linha_w')::fis_sef_edoc_arquivo.nr_linha%type := fis_sef_edoc_arq_lfpd01_pck.fis_gerar_arq_c(  current_setting('fis_sef_edoc_arq_geral_pck.nr_seq_controle_w')::bigint, current_setting('fis_sef_edoc_arq_geral_pck.nr_linha_w')::fis_sef_edoc_arquivo.nr_linha%type);
  elsif (current_setting('fis_sef_edoc_arq_geral_pck.vetregcontrole')::fis_sef_edoc_controle%RowType.ie_tipo_arquivo = '2') then
    current_setting('fis_sef_edoc_arq_geral_pck.nr_linha_w')::fis_sef_edoc_arquivo.nr_linha%type := fis_sef_edoc_arq_lfpd05_pck.fis_gerar_arq_e(  current_setting('fis_sef_edoc_arq_geral_pck.nr_seq_controle_w')::bigint, current_setting('fis_sef_edoc_arq_geral_pck.nr_linha_w')::fis_sef_edoc_arquivo.nr_linha%type);
  elsif (current_setting('fis_sef_edoc_arq_geral_pck.vetregcontrole')::fis_sef_edoc_controle%RowType.ie_tipo_arquivo = '3') then
    current_setting('fis_sef_edoc_arq_geral_pck.nr_linha_w')::fis_sef_edoc_arquivo.nr_linha%type := fis_sef_edoc_arq_lfpd07_pck.fis_gerar_arq_g(  current_setting('fis_sef_edoc_arq_geral_pck.nr_seq_controle_w')::bigint, current_setting('fis_sef_edoc_arq_geral_pck.nr_linha_w')::fis_sef_edoc_arquivo.nr_linha%type);
  elsif (current_setting('fis_sef_edoc_arq_geral_pck.vetregcontrole')::fis_sef_edoc_controle%RowType.ie_tipo_arquivo in ('4','5','6')) then
    current_setting('fis_sef_edoc_arq_geral_pck.nr_linha_w')::fis_sef_edoc_arquivo.nr_linha%type := fis_sef_edoc_arq_lfpd08a10_pck.fis_gerar_arq_f(  current_setting('fis_sef_edoc_arq_geral_pck.nr_seq_controle_w')::bigint, current_setting('fis_sef_edoc_arq_geral_pck.nr_linha_w')::fis_sef_edoc_arquivo.nr_linha%type);
  elsif (current_setting('fis_sef_edoc_arq_geral_pck.vetregcontrole')::fis_sef_edoc_controle%RowType.ie_tipo_arquivo = '7') then
    current_setting('fis_sef_edoc_arq_geral_pck.nr_linha_w')::fis_sef_edoc_arquivo.nr_linha%type := fis_sef_edoc_arq_lfpd12_pck.fis_gerar_arq_h(  current_setting('fis_sef_edoc_arq_geral_pck.nr_seq_controle_w')::bigint, current_setting('fis_sef_edoc_arq_geral_pck.nr_linha_w')::fis_sef_edoc_arquivo.nr_linha%type);
  end if;

  CALL fis_sef_edoc_arq_geral_pck.fis_gerar_arq_abertura_sefedoc();
  CALL fis_sef_edoc_arq_geral_pck.fis_gerar_arq_9900_sefedoc();
  CALL fis_sef_edoc_arq_geral_pck.fis_gerar_arq_encerram_sefedoc();
  CALL fis_sef_edoc_arq_geral_pck.fis_gerar_arq_9999_sefedoc();

  update   fis_sef_edoc_controle a
  set      a.dt_geracao  =  clock_timestamp()
  where    a.nr_sequencia  = nr_seq_controle_p;

  commit;

  CALL fis_gerar_arquivo_sef_edoc( nr_seq_controle_p);

  commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_sef_edoc_arq_geral_pck.fis_gerar_arquivos_edoc ( nr_seq_controle_p bigint ) FROM PUBLIC;