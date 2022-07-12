-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

  --
CREATE OR REPLACE FUNCTION pkg_vte_prophylaxis.get_dt_first_dev (NR_ATEND bigint, DT_ENTRADA_SETOR timestamp, DT_SAIDA_SETOR timestamp) RETURNS timestamp AS $body$
DECLARE


    dt_treat_w  timestamp;


BEGIN

    SELECT MIN(apd.dt_instalacao)
      INTO STRICT dt_treat_w
      FROM atend_pac_dispositivo apd
     INNER JOIN dispositivo d
        ON d.nr_sequencia = apd.nr_seq_dispositivo
       AND d.ie_situacao = 'A'
       AND d.ie_tipo_rel in(1, 2)
     WHERE apd.nr_atendimento = NR_ATEND
       AND apd.dt_instalacao BETWEEN DT_ENTRADA_SETOR AND DT_SAIDA_SETOR;

    RETURN dt_treat_w;

  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pkg_vte_prophylaxis.get_dt_first_dev (NR_ATEND bigint, DT_ENTRADA_SETOR timestamp, DT_SAIDA_SETOR timestamp) FROM PUBLIC;