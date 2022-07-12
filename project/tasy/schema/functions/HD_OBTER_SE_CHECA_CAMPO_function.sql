-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_se_checa_campo (nr_seq_escala_p bigint, nr_seq_dia_p bigint, nr_seq_turno_p bigint, nr_seq_ponto_acesso_p bigint DEFAULT NULL) RETURNS varchar AS $body$
DECLARE


    ds_retorno_w varchar(1);

BEGIN
    IF (nr_seq_escala_p IS NOT NULL AND nr_seq_escala_p::text <> '') THEN
        SELECT CASE WHEN COUNT(*)=0 THEN  'N'  ELSE 'S' END
          INTO STRICT ds_retorno_w
          FROM hd_escala_dialise_dia d,
               hd_escala_dialise     e
         WHERE d.nr_seq_escala = e.nr_sequencia
           AND e.nr_sequencia = nr_seq_escala_p
           AND d.ie_dia_semana = nr_seq_dia_p
           AND d.nr_seq_turno = nr_seq_turno_p
           AND (d.nr_seq_ponto = nr_seq_ponto_acesso_p OR coalesce(nr_seq_ponto_acesso_p::text, '') = '')
           AND clock_timestamp() BETWEEN e.dt_inicio AND coalesce(e.dt_fim, clock_timestamp())
           AND clock_timestamp() BETWEEN d.dt_inicio_escala_dia AND coalesce(d.dt_fim_escala_dia, clock_timestamp());
    END IF;

    RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_se_checa_campo (nr_seq_escala_p bigint, nr_seq_dia_p bigint, nr_seq_turno_p bigint, nr_seq_ponto_acesso_p bigint DEFAULT NULL) FROM PUBLIC;

