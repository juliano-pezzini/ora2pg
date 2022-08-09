-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE check_all_orders_prescr_quimio ( ie_conferido_p text, nr_seq_ordem_lista_p text, nm_usuario_p can_ordem_prod.nm_usuario_conf%type default null) AS $body$
DECLARE


    nr_seq_lista_w       varchar(4000);
    posicao_w            bigint;
    qt_loop_w            smallint := 0;
    nr_sequencia_w       can_ordem_prod.nr_sequencia%TYPE;
    nr_prescricao_w      can_ordem_prod.nr_prescricao%TYPE;
    nm_usuario_w          can_ordem_prod.nm_usuario%TYPE;
    cd_estabelecimento_w can_ordem_prod.cd_estabelecimento%TYPE;
    type prescricoes_geradas is table of bigint index by varchar(20);
    prescricoes_geradas_w prescricoes_geradas;


BEGIN
    nr_seq_lista_w := substr(nr_seq_ordem_lista_p, 1, 4000);
    while(nr_seq_lista_w IS NOT NULL AND nr_seq_lista_w::text <> '') and ( qt_loop_w < 101 ) loop begin
        nr_sequencia_w := 0;
        qt_loop_w := qt_loop_w + 1;
        posicao_w := position(',' in nr_seq_lista_w);

        if ( posicao_w > 0 ) then
            nr_sequencia_w := substr(nr_seq_lista_w, 1, posicao_w - 1);
            nr_seq_lista_w := substr(nr_seq_lista_w, posicao_w + 1, length(nr_seq_lista_w));
            if ( nr_sequencia_w > 0 ) then
                select nm_usuario, nr_prescricao, cd_estabelecimento
                into STRICT nm_usuario_w, nr_prescricao_w, cd_estabelecimento_w
                from can_ordem_prod
                where nr_sequencia = nr_sequencia_w;

                update can_ordem_prod
                set ie_conferido = ie_conferido_p,
                    nm_usuario_conf	= nm_usuario_p,
                    dt_conferencia 	= clock_timestamp()
                where nr_sequencia = nr_sequencia_w
                and nr_prescricao = nr_prescricao_w;

                if not prescricoes_geradas_w.exists(nr_prescricao_w) then
                    CALL gerar_etapa_prescr_prod(cd_estabelecimento_w, nr_prescricao_w, nm_usuario_w);
                    prescricoes_geradas_w(nr_prescricao_w) := 1;
                end if;

            end if;

        elsif ( length(nr_seq_lista_w) > 1 ) then
            nr_sequencia_w := substr(nr_seq_lista_w, 1, length(nr_seq_lista_w));

            if ( nr_sequencia_w > 0 ) then
                select nm_usuario, nr_prescricao, cd_estabelecimento
                into STRICT nm_usuario_w, nr_prescricao_w, cd_estabelecimento_w
                from can_ordem_prod 
                where nr_sequencia = nr_sequencia_w;

                update can_ordem_prod
                set ie_conferido = ie_conferido_p,
                    nm_usuario_conf	= nm_usuario_p,
                    dt_conferencia 	= clock_timestamp()
                where nr_sequencia = nr_sequencia_w
                and nr_prescricao = nr_prescricao_w;

                if not prescricoes_geradas_w.exists(nr_prescricao_w) then
                    CALL gerar_etapa_prescr_prod(cd_estabelecimento_w, nr_prescricao_w, nm_usuario_w);
                    prescricoes_geradas_w(nr_prescricao_w) := 1;
                end if;

                nr_seq_lista_w := null;
            end if;

        end if;

    end;
    end loop;

    commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE check_all_orders_prescr_quimio ( ie_conferido_p text, nr_seq_ordem_lista_p text, nm_usuario_p can_ordem_prod.nm_usuario_conf%type default null) FROM PUBLIC;
