-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_documentos (cd_procedimento_p bigint DEFAULT NULL, ie_origem_proced_p bigint DEFAULT NULL, cd_perfil_p bigint DEFAULT NULL, ie_tipo_consentimento_p text DEFAULT NULL, nr_seq_proc_interno_p bigint DEFAULT NULL, ds_retorno_p text DEFAULT NULL) RETURNS varchar AS $body$
DECLARE

  cdocumento CURSOR(cd_procedimento_p       bigint,
                    ie_origem_proced_p      bigint,
                    cd_perfil_p             bigint,
                    ie_tipo_consentimento_p text,
                    nr_seq_proc_interno_p   bigint) FOR
    SELECT qc.ds_arquivo,
           qc.nr_sequencia,
           qc.nr_seq_tipo,
           rgc.ie_padrao_abrir ie_open,
           rgc.ie_padrao_imprimir ie_print
      FROM regra_geracao_consent rgc,
           qua_documento         qc
     WHERE ((rgc.cd_procedimento = cd_procedimento_p) OR (coalesce(rgc.cd_procedimento::text, '') = '' AND coalesce(cd_procedimento_p::text, '') = ''))
       AND (coalesce(rgc.ie_origem_proced::text, '') = '' OR coalesce(ie_origem_proced_p::text, '') = '' OR  rgc.ie_origem_proced = ie_origem_proced_p)
       AND (coalesce(rgc.cd_perfil::text, '') = '' OR rgc.cd_perfil = cd_perfil_p)
       AND (coalesce(rgc.ie_tipo_consentimento::text, '') = '' OR coalesce(ie_tipo_consentimento_p::text, '') = '' OR rgc.ie_tipo_consentimento = ie_tipo_consentimento_p)
       AND ((rgc.nr_seq_proc_interno = nr_seq_proc_interno_p) OR (coalesce(rgc.nr_seq_proc_interno::text, '') = '' AND  coalesce(nr_seq_proc_interno_p::text, '') = ''))
       AND rgc.nr_seq_documento = qc.nr_sequencia
       AND (qc.ds_arquivo IS NOT NULL AND qc.ds_arquivo::text <> '');

  ds_retorno_w varchar(4000) := '';
BEGIN
  FOR c IN cdocumento(cd_procedimento_p       => cd_procedimento_p,
                      ie_origem_proced_p      => ie_origem_proced_p,
                      cd_perfil_p             => cd_perfil_p,
                      ie_tipo_consentimento_p => ie_tipo_consentimento_p,
                      nr_seq_proc_interno_p   => nr_seq_proc_interno_p) LOOP

    if (ds_retorno_p = 'NR_SEQUENCIA') then
        ds_retorno_w := c.nr_sequencia||chr(10)||ds_retorno_w;
    elsif (ds_retorno_p = 'CD_TIPO_DOCUMENTO') then
        ds_retorno_w := c.nr_seq_tipo||chr(10)||ds_retorno_w;
    elsif (ds_retorno_p = 'ie_open') then
        ds_retorno_w := c.ie_open||chr(10)||ds_retorno_w;
    elsif (ds_retorno_p = 'ie_print') then
        ds_retorno_w := c.ie_print||chr(10)||ds_retorno_w;
    else
        ds_retorno_w := c.ds_arquivo||chr(10)||ds_retorno_w;
    end if;
  END LOOP;
  RETURN ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_documentos (cd_procedimento_p bigint DEFAULT NULL, ie_origem_proced_p bigint DEFAULT NULL, cd_perfil_p bigint DEFAULT NULL, ie_tipo_consentimento_p text DEFAULT NULL, nr_seq_proc_interno_p bigint DEFAULT NULL, ds_retorno_p text DEFAULT NULL) FROM PUBLIC;

