-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE update_cups_trace_procedure ( cd_2018_p W_CUPS_CATALOG_BOLIVIA.cd_2018%TYPE , ds_2018_p W_CUPS_CATALOG_BOLIVIA.ds_2018%TYPE , cd_tracebility_p W_CUPS_CATALOG_BOLIVIA.cd_tracebility%TYPE, cd_2019_P W_CUPS_CATALOG_BOLIVIA.cd_2019%TYPE , ds_2019_p W_CUPS_CATALOG_BOLIVIA.ds_2019%TYPE) AS $body$
DECLARE


  cd_procediment_w varchar(10);

  
BEGIN
  
  select max(cd_procedimento)
    into STRICT cd_procediment_w
    from procedimento
    where cd_procedimento_loc = cd_2019_p;

  
  insert into PROCEDIMENTO_HIST(
    nr_sequencia,
    DT_ATUALIZACAO,
    NM_USUARIO,
    DT_ATUALIZACAO_NREC,
    NM_USUARIO_NREC,
    CD_PROCEDIMENTO,
    IE_ORIGEM_PROCED,
    DS_TITULO,
    DS_HISTORICO)
    values (
    nextval('procedimento_hist_seq'),
    clock_timestamp(),
    'TASY',
    null,
    'TASY',
    cd_procediment_w,
    1,
    'INFORMATION',
    wheb_mensagem_pck.get_texto( 1130525, 'UPDATED_DATE='|| clock_timestamp())
    );

    update procedimento
    set ie_situacao = 'I'
    where cd_procedimento_loc = cd_2019_p;

    update procedimento_versao
    set dt_vigencia_final = clock_timestamp() 
    where cd_proc_previous = cd_2019_p;

    commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE update_cups_trace_procedure ( cd_2018_p W_CUPS_CATALOG_BOLIVIA.cd_2018%TYPE , ds_2018_p W_CUPS_CATALOG_BOLIVIA.ds_2018%TYPE , cd_tracebility_p W_CUPS_CATALOG_BOLIVIA.cd_tracebility%TYPE, cd_2019_P W_CUPS_CATALOG_BOLIVIA.cd_2019%TYPE , ds_2019_p W_CUPS_CATALOG_BOLIVIA.ds_2019%TYPE) FROM PUBLIC;
