-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_hl7_pck.copiar_hl7_atributo (nr_seq_segmento_p bigint, nr_seq_segmento_new_p bigint, nr_seq_mensagem_p bigint) AS $body$
DECLARE

        nr_sequencia_w bigint;

        c01 CURSOR FOR
            SELECT nr_sequencia,
                   nr_seq_segmento,
                   nr_seq_apresentacao,
                   nm_atributo_hl7,
                   nm_atributo,
                   ie_tipo_atributo,
                   ds_mascara,
                   ie_criar_atributo,
                   nr_seq_atrib_segm,
                   ie_tipo_atributo_hl7,
                   nr_seq_tabela,
                   nr_tamanho
              from hl7_atributo
             where nr_seq_segmento = nr_seq_segmento_p
             order by nr_seq_apresentacao;

        hl7_atributo_w c01%rowtype;

BEGIN
        open c01;
        loop
            fetch c01
                into hl7_atributo_w;
            EXIT WHEN NOT FOUND; /* apply on c01 */
            begin

                $if $$tasy_local_dict=true $then
                nr_sequencia_w := get_remote_sequence('seq:hl7_atributo_seq');
                $else
                select nextval('hl7_atributo_seq') into STRICT nr_sequencia_w;
                $end

                insert into hl7_atributo(nr_sequencia,
                     nr_seq_segmento,
                     nr_seq_apresentacao,
                     nm_atributo_hl7,
                     nm_atributo,
                     ie_tipo_atributo,
                     ds_mascara,
                     nm_usuario_nrec,
                     dt_atualizacao_nrec,
                     nm_usuario,
                     dt_atualizacao,
                     ie_criar_atributo,
                     nr_seq_atrib_segm,
                     ie_tipo_atributo_hl7,
                     nr_seq_tabela,
                     nr_tamanho)
                values (nr_sequencia_w,
                     nr_seq_segmento_new_p,
                     hl7_atributo_w.nr_seq_apresentacao,
                     hl7_atributo_w.nm_atributo_hl7,
                     hl7_atributo_w.nm_atributo,
                     hl7_atributo_w.ie_tipo_atributo,
                     hl7_atributo_w.ds_mascara,
                     wheb_usuario_pck.get_nm_usuario,
                     clock_timestamp(),
                     wheb_usuario_pck.get_nm_usuario,
                     clock_timestamp(),
                     hl7_atributo_w.ie_criar_atributo,
                     null,
                     hl7_atributo_w.ie_tipo_atributo_hl7,
                     hl7_atributo_w.nr_seq_tabela,
                     hl7_atributo_w.nr_tamanho);

                if (hl7_atributo_w.nr_seq_atrib_segm IS NOT NULL AND hl7_atributo_w.nr_seq_atrib_segm::text <> '') then
                    CALL wheb_hl7_pck.copiar_hl7_segmento_atrib(hl7_atributo_w.nr_seq_atrib_segm, nr_seq_mensagem_p, nr_sequencia_w);
                end if;

            end;
        end loop;
        close c01;
    end;


$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON PROCEDURE wheb_hl7_pck.copiar_hl7_atributo (nr_seq_segmento_p bigint, nr_seq_segmento_new_p bigint, nr_seq_mensagem_p bigint) FROM PUBLIC;
