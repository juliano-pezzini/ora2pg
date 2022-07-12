-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION prot_int_obter_nr_dias_etapa ( nr_seq_protocolo_integrado_p protocolo_integrado.nr_sequencia%TYPE ) RETURNS PROTOCOLO_INTEGRADO_ETAPA.NR_DIAS_ETAPA%TYPE AS $body$
DECLARE


nr_dias_etapa_w protocolo_integrado_etapa.nr_dias_etapa%TYPE;


BEGIN

    if (coalesce(pkg_i18n.get_user_locale, 'pt_BR') = 'ja_JP') then

      SELECT coalesce(max(b.nr_dia_final)-min(b.nr_dia_inicial)+1,0)
      INTO STRICT nr_dias_etapa_w
      FROM
          protocolo_integrado a,
          protocolo_integrado_etapa b
      WHERE 
          a.nr_sequencia = b.nr_seq_protocolo_integrado
      AND a.nr_sequencia = nr_seq_protocolo_integrado_p;

    else

      SELECT COALESCE(SUM(b.nr_dias_etapa),0)
      INTO STRICT nr_dias_etapa_w
      FROM
          protocolo_integrado a,
          protocolo_integrado_etapa b
      WHERE 
          a.nr_sequencia = b.nr_seq_protocolo_integrado
      AND a.nr_sequencia = nr_seq_protocolo_integrado_p;

    end if;

    RETURN nr_dias_etapa_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION prot_int_obter_nr_dias_etapa ( nr_seq_protocolo_integrado_p protocolo_integrado.nr_sequencia%TYPE ) FROM PUBLIC;

