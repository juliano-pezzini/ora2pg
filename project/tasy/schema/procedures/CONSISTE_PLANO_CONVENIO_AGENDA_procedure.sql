-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_plano_convenio_agenda (nr_atendimento_p bigint, cd_convenio_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, dt_procedimento_p timestamp, cd_plano_p text, cd_setor_atendimento_p bigint, nr_seq_agenda_p bigint, cd_categoria_p text, cd_estabelecimento_p bigint, ie_tipo_atendimento_p bigint, ie_regra_p INOUT text, ds_resp_autor_p INOUT text, cd_medico_p text, cd_pessoa_fisica_p text DEFAULT NULL) AS $body$
DECLARE


  ie_tipo_atendimento_w smallint;
  ie_resp_autor_w       varchar(254);
  ds_texto_w            varchar(255);
  ds_resp_autor_w       varchar(255);
  ds_erro_w             varchar(255);
  nr_seq_regra_w        bigint;
  ie_regra_w            smallint;
  cd_pessoa_fisica_w    varchar(10);
  ie_glosa_w            regra_ajuste_proc.ie_glosa%TYPE;
  nr_seq_regra_preco_w  regra_ajuste_proc.nr_sequencia%TYPE;

BEGIN
  SELECT MAX(ie_tipo_atendimento),
         coalesce(MAX(cd_pessoa_fisica),cd_pessoa_fisica_p)
    INTO STRICT ie_tipo_atendimento_w,
         cd_pessoa_fisica_w
    FROM atendimento_paciente
   WHERE nr_atendimento = nr_atendimento_p;

  ie_tipo_atendimento_w := coalesce(ie_tipo_atendimento_p, ie_tipo_atendimento_w);

  SELECT * FROM consiste_plano_convenio(nr_atendimento_p, cd_convenio_p, cd_procedimento_p, ie_origem_proced_p, dt_procedimento_p, 1, ie_tipo_atendimento_w, cd_plano_p, '', ds_erro_w, cd_setor_atendimento_p, 0, ie_regra_w, nr_seq_agenda_p, nr_seq_regra_w, nr_seq_proc_interno_p, cd_categoria_p, cd_estabelecimento_p, 0, cd_medico_p, cd_pessoa_fisica_w, ie_glosa_w, nr_seq_regra_preco_w) INTO STRICT ds_erro_w, ie_regra_w, nr_seq_regra_w, ie_glosa_w, nr_seq_regra_preco_w;

  IF (nr_seq_regra_w > 0) THEN
    BEGIN
      SELECT substr(obter_valor_dominio(1904, ie_resp_autor), 1, 254)
        INTO STRICT ie_resp_autor_w
        FROM regra_convenio_plano
       WHERE nr_sequencia = nr_seq_regra_w;

      IF (ie_resp_autor_w IS NOT NULL AND ie_resp_autor_w::text <> '') THEN
        BEGIN
          ds_texto_w := substr(obter_texto_tasy(37605, wheb_usuario_pck.get_nr_seq_idioma),
                               1,
                               255);

          ds_resp_autor_w := ds_texto_w || ' ' || ie_resp_autor_w || '.';

        END;
      END IF;
    END;
  END IF;

  ie_regra_p      := ie_regra_w;
  ds_resp_autor_p := ds_resp_autor_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_plano_convenio_agenda (nr_atendimento_p bigint, cd_convenio_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, dt_procedimento_p timestamp, cd_plano_p text, cd_setor_atendimento_p bigint, nr_seq_agenda_p bigint, cd_categoria_p text, cd_estabelecimento_p bigint, ie_tipo_atendimento_p bigint, ie_regra_p INOUT text, ds_resp_autor_p INOUT text, cd_medico_p text, cd_pessoa_fisica_p text DEFAULT NULL) FROM PUBLIC;
