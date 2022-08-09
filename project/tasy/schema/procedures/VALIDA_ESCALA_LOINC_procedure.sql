-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE valida_escala_loinc (scale_Type_p text, nm_usuario_p text, cd_versao_release_p text, cd_versao_ult_alt_p text, ie_tipo_importacao_p text, nr_seq_loinc_dados_p bigint, nr_seq_escala_p INOUT bigint) AS $body$
DECLARE

nr_seq_escala_w bigint;
mensagem_w varchar(255);

BEGIN
  select max(nr_sequencia)
    into STRICT nr_seq_escala_w
    from lab_loinc_escala
   where cd_escala = scale_Type_p;

  if (coalesce(nr_seq_escala_w::text, '') = '') then
    select nextval('lab_loinc_escala_seq')
      into STRICT nr_seq_escala_w
;

    insert into lab_loinc_escala(nr_sequencia,
                                  cd_escala,
                                  ie_situacao,
                                  dt_atualizacao,
                                  dt_atualizacao_nrec,
                                  nm_usuario,
                                  nm_usuario_nrec)
                          values (nr_seq_escala_w,
                                  scale_Type_p,
                                  'A',
                                  clock_timestamp(),
                                  clock_timestamp(),
                                  nm_usuario_p,
                                  nm_usuario_p);

    mensagem_w := wheb_mensagem_pck.get_texto(1028601, 'DS_TIPO_CADASTRO=' || wheb_mensagem_pck.get_texto(1028612) || ';CD_CODIGO=' || scale_Type_p);
    CALL GRAVA_LOG_LOINC_IMP(mensagem_w, nm_usuario_p, cd_versao_release_p, cd_versao_ult_alt_p, ie_tipo_importacao_p, nr_seq_loinc_dados_p);
  end if;
  commit;
  nr_seq_escala_p := nr_seq_escala_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE valida_escala_loinc (scale_Type_p text, nm_usuario_p text, cd_versao_release_p text, cd_versao_ult_alt_p text, ie_tipo_importacao_p text, nr_seq_loinc_dados_p bigint, nr_seq_escala_p INOUT bigint) FROM PUBLIC;
