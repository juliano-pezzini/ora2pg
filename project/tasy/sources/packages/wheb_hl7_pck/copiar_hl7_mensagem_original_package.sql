-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_hl7_pck.copiar_hl7_mensagem_original (nr_seq_proj_origem_p bigint, nr_seq_proj_destino_p bigint, nr_seq_mensagem_origem_p bigint) AS $body$
DECLARE

        nr_sequencia_w bigint;
        c01 CURSOR FOR
            SELECT nr_sequencia,
                   nm_mensagem,
                   nr_seq_projeto,
                   nr_seq_tipo
              from wheb_hl7_mensagem
             where nr_seq_projeto = nr_seq_proj_origem_p
               and coalesce(nr_seq_mensagem_origem_p::text, '') = ''

union

            SELECT nr_sequencia,
                   nm_mensagem,
                   nr_seq_projeto,
                   nr_seq_tipo
              from wheb_hl7_mensagem
             where (nr_seq_mensagem_origem_p IS NOT NULL AND nr_seq_mensagem_origem_p::text <> '')
               and nr_sequencia = nr_seq_mensagem_origem_p
             order by nr_sequencia;

        hl7_mensagem_w c01%rowtype;

BEGIN
    
        open c01;
        loop
            fetch c01
                into hl7_mensagem_w;
            EXIT WHEN NOT FOUND; /* apply on c01 */
            begin

                $if $$tasy_local_dict=true $then
                nr_sequencia_w := get_remote_sequence('seq:hl7_mensagem_seq');
                $else
                select nextval('hl7_mensagem_seq') into STRICT nr_sequencia_w;
                $end

                insert into hl7_mensagem(nr_sequencia,
                     nm_mensagem,
                     nr_seq_projeto,
                     nr_seq_tipo,
                     dt_atualizacao,
                     nm_usuario,
                     dt_atualizacao_nrec,
                     nm_usuario_nrec,
                     ie_situacao)
                values (nr_sequencia_w,
                     hl7_mensagem_w.nm_mensagem,
                     coalesce(nr_seq_proj_destino_p, current_setting('wheb_hl7_pck.nr_seq_proj_new_w')::bigint),
                     hl7_mensagem_w.nr_seq_tipo,
                     clock_timestamp(),
                     wheb_usuario_pck.get_nm_usuario,
                     clock_timestamp(),
                     wheb_usuario_pck.get_nm_usuario,
                     'A');
                CALL wheb_hl7_pck.copiar_hl7_segmento_original(hl7_mensagem_w.nr_sequencia, nr_sequencia_w, null);
            end;
        end loop;
        close c01;
    end;


$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON PROCEDURE wheb_hl7_pck.copiar_hl7_mensagem_original (nr_seq_proj_origem_p bigint, nr_seq_proj_destino_p bigint, nr_seq_mensagem_origem_p bigint) FROM PUBLIC;