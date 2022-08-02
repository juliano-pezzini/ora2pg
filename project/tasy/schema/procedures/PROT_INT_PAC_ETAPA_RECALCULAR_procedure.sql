-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE prot_int_pac_etapa_recalcular ( nr_seq_prot_int_pac_etapa_p protocolo_int_pac_etapa.nr_sequencia%TYPE, nr_seq_protocolo_int_pac_p protocolo_int_paciente.nr_sequencia%TYPE ) AS $body$
DECLARE


dt_inicial_proxima_w protocolo_int_pac_etapa.dt_inicial_previsto%TYPE;
dt_final_proxima_w protocolo_int_pac_etapa.dt_final_previsto%TYPE;
nr_dias_previsto_w protocolo_int_pac_etapa.nr_dias_previsto%TYPE;

-- Etapas posteriores
C01 CURSOR FOR
SELECT
    etapa_posterior.nr_sequencia,
    etapa_posterior.nr_dias_previsto,
    etapa.dt_final_previsto
FROM
    protocolo_int_pac_etapa etapa,
    protocolo_int_pac_etapa etapa_posterior
WHERE
    etapa.nr_sequencia = nr_seq_prot_int_pac_etapa_p
AND etapa.nr_sequencia < etapa_posterior.nr_sequencia
AND etapa_posterior.nr_seq_protocolo_int_pac = nr_seq_protocolo_int_pac_p;


BEGIN

SELECT dt_final_previsto
INTO STRICT dt_final_proxima_w
FROM protocolo_int_pac_etapa
WHERE nr_sequencia = (
        SELECT MAX(nr_sequencia)
        FROM protocolo_int_pac_etapa
        WHERE nr_sequencia < nr_seq_prot_int_pac_etapa_p);

FOR etapa_posterior IN C01 LOOP BEGIN

    dt_inicial_proxima_w := dt_final_proxima_w + 1;
    dt_final_proxima_w := dt_inicial_proxima_w + etapa_posterior.nr_dias_previsto - 1;

    UPDATE protocolo_int_pac_etapa
    SET dt_inicial_previsto = dt_inicial_proxima_w,
        dt_final_previsto = dt_final_proxima_w
    WHERE nr_sequencia = etapa_posterior.nr_sequencia;

END; END LOOP;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE prot_int_pac_etapa_recalcular ( nr_seq_prot_int_pac_etapa_p protocolo_int_pac_etapa.nr_sequencia%TYPE, nr_seq_protocolo_int_pac_p protocolo_int_paciente.nr_sequencia%TYPE ) FROM PUBLIC;

