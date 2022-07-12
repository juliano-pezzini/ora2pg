-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_hl7_pck.copiar_hl7_segmento (nr_seq_mensagem_p bigint, nr_seq_mensagem_dest_p bigint, nr_seq_segm_origem_p bigint) AS $body$
DECLARE

        nr_sequencia_w bigint;
        c01 CURSOR FOR
            SELECT nr_sequencia,
                   nr_seq_apresentacao,
                   nr_seq_mensagem,
                   nm_segmento,
                   ds_segmento,
                   ds_sql,
                   nm_usuario,
                   dt_atualizacao,
                   nm_usuario_nrec,
                   dt_atualizacao_nrec,
                   ie_criar_segmento,
                   ie_tipo
              from hl7_segmento a
             where nr_seq_mensagem = nr_seq_mensagem_p
               and nr_sequencia = coalesce(nr_seq_segm_origem_p, nr_sequencia)
               and ie_tipo in ('GRU', 'SEG')
               and not exists (SELECT 1
                      from hl7_atributo z,
                           hl7_segmento x
                     where x.nr_sequencia = z.nr_seq_segmento
                       and x.nr_seq_mensagem = a.nr_seq_mensagem
                       and z.nr_seq_atrib_segm = a.nr_sequencia
                       and (z.nr_seq_atrib_segm IS NOT NULL AND z.nr_seq_atrib_segm::text <> ''))
             order by a.nr_seq_apresentacao;

        hl7_segmento_w c01%rowtype;

    
BEGIN
    
        open c01;
        loop
            fetch c01
                into hl7_segmento_w;
            EXIT WHEN NOT FOUND; /* apply on c01 */
            begin

                $if $$tasy_local_dict=true $then
                nr_sequencia_w := get_remote_sequence('seq:hl7_segmento_seq');
                $else
                select nextval('hl7_segmento_seq') into STRICT nr_sequencia_w;
                $end

                insert into hl7_segmento(nr_sequencia,
                     nr_seq_apresentacao,
                     nr_seq_mensagem,
                     nm_segmento,
                     ds_segmento,
                     ds_sql,
                     nm_usuario,
                     dt_atualizacao,
                     nm_usuario_nrec,
                     dt_atualizacao_nrec,
                     ie_criar_segmento,
                     ie_tipo)
                values (nr_sequencia_w,
                     hl7_segmento_w.nr_seq_apresentacao,
                     nr_seq_mensagem_dest_p,
                     hl7_segmento_w.nm_segmento,
                     hl7_segmento_w.ds_segmento,
                     hl7_segmento_w.ds_sql,
                     wheb_usuario_pck.get_nm_usuario,
                     clock_timestamp(),
                     wheb_usuario_pck.get_nm_usuario,
                     clock_timestamp(),
                     hl7_segmento_w.ie_criar_segmento,
                     hl7_segmento_w.ie_tipo);

                CALL wheb_hl7_pck.copiar_hl7_atributo(hl7_segmento_w.nr_sequencia, nr_sequencia_w, nr_seq_mensagem_dest_p);
            end;
        end loop;
        close c01;
    end;

    --procedure copiar_hl7_mensagem as


$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON PROCEDURE wheb_hl7_pck.copiar_hl7_segmento (nr_seq_mensagem_p bigint, nr_seq_mensagem_dest_p bigint, nr_seq_segm_origem_p bigint) FROM PUBLIC;
