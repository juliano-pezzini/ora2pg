-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gqa_obter_etapa_tempo_resposta (nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


qt_resposta_w             bigint;
dt_resposta_w             gqa_protocolo_etapa_pac.dt_fim%type;
nr_seq_etapa_parent_w     gqa_protocolo_etapa_pac.nr_seq_etapa_prot_sup%type;
nr_seq_prot_pac_w         gqa_protocolo_etapa_pac.nr_seq_prot_pac%type;


BEGIN

    select nr_seq_etapa_prot_sup, nr_seq_prot_pac into STRICT nr_seq_etapa_parent_w, nr_seq_prot_pac_w from gqa_protocolo_etapa_pac where nr_sequencia = nr_sequencia_p;

    if (coalesce(nr_seq_etapa_parent_w::text, '') = '') then
        select dt_liberacao into STRICT dt_resposta_w from gqa_protocolo_pac where nr_sequencia = nr_seq_prot_pac_w;
        if (coalesce(dt_resposta_w::text, '') = '') then
            qt_resposta_w := null;
        else
            select trunc((clock_timestamp() - dt_resposta_w) * 24 * 60) into STRICT qt_resposta_w;
        end if;
    else
        select dt_fim into STRICT dt_resposta_w from gqa_protocolo_etapa_pac where nr_sequencia = nr_seq_etapa_parent_w;
        if (coalesce(dt_resposta_w::text, '') = '') then
            qt_resposta_w := null;
        else
            select trunc((clock_timestamp() - dt_resposta_w) * 24 * 60) into STRICT qt_resposta_w;
        end if;
    end if;

  return qt_resposta_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gqa_obter_etapa_tempo_resposta (nr_sequencia_p bigint) FROM PUBLIC;

