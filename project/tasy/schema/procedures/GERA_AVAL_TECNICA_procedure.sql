-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gera_aval_tecnica ( nr_cirur_tecnica_p bigint) AS $body$
DECLARE

nr_seq_tipo_avaliacao_w bigint;
nr_seq_tecnica_w        bigint;
nr_cirurgia_w           bigint;
nr_seq_pepo_w           bigint;

BEGIN
    if (nr_cirur_tecnica_p IS NOT NULL AND nr_cirur_tecnica_p::text <> '') then
        select nr_seq_tecnica ,nr_cirurgia,nr_seq_pepo
        into STRICT nr_seq_tecnica_w,nr_cirurgia_w,nr_seq_pepo_W
        from CIRURGIA_TEC_ANESTESICA
        where nr_sequencia  = nr_cirur_tecnica_p;

        select   max(nr_seq_tipo_avaliacao)
        into STRICT     nr_seq_tipo_avaliacao_w
        from     tecnica_anestesica
        where    nr_sequencia = nr_seq_tecnica_w;

        if (nr_seq_tipo_avaliacao_w IS NOT NULL AND nr_seq_tipo_avaliacao_w::text <> '') then
            CALL gerar_avaliacao_tecnica_anest(nr_seq_tipo_avaliacao_w,nr_cirur_tecnica_p,null,nr_cirurgia_w,nr_seq_pepo_w);
        end if;
    end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gera_aval_tecnica ( nr_cirur_tecnica_p bigint) FROM PUBLIC;

