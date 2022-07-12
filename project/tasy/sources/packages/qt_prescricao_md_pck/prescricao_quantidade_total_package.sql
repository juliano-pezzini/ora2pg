-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION qt_prescricao_md_pck.prescricao_quantidade_total (prescricao_p qt_prescricao_pck.prescricao) RETURNS bigint AS $body$
DECLARE

        nr_retorno_w bigint;
        medicamento_w qt_prescricao_pck.medicamento;
        indice_w bigint;

BEGIN
        nr_retorno_w := 0;

        indice_w := prescricao_p.medicamentos.first;

        while(indice_w IS NOT NULL AND indice_w::text <> '') loop
            medicamento_w := prescricao_p.medicamentos(indice_w);
            nr_retorno_w := nr_retorno_w + ceil(medicamento_w.quantidade);

            indice_w := prescricao_p.medicamentos.next(indice_w);
        end loop;

        return nr_retorno_w;
    end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qt_prescricao_md_pck.prescricao_quantidade_total (prescricao_p qt_prescricao_pck.prescricao) FROM PUBLIC;