-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cm_insert_mult_conj_cic_barras ( nr_seq_conjuntos_p text, nr_seq_ciclo_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_conj_cont_w		cm_conjunto_cont.nr_sequencia%TYPE;
err_msg_w               cm_ciclo_consiste.ds_consistencia%TYPE;

C01 CURSOR FOR
SELECT	a.nr_sequencia
  from cm_conjunto_cont a
 where a.nr_sequencia in (WITH RECURSIVE cte AS (
SELECT regexp_substr(nr_seq_conjuntos_p,'[^,]+', 1, level)  (regexp_substr(nr_seq_conjuntos_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_seq_conjuntos_p, '[^,]+', 1, level))::text <> '')  UNION ALL
SELECT regexp_substr(nr_seq_conjuntos_p,'[^,]+', 1, level) JOIN cte c ON ()

) SELECT * FROM cte;
);


BEGIN
    open C01;
	loop
	fetch C01 into
    nr_seq_conj_cont_w;
    EXIT WHEN NOT FOUND; /* apply on C01 */
        begin
            CALL cm_inserir_conj_ciclo_barras(nr_seq_conj_cont_w, nr_seq_ciclo_p, cd_estabelecimento_p, nm_usuario_p);
        exception
            when others then
                err_msg_w := get_shortened_error_msg(SQLERRM);
                insert into cm_ciclo_consiste(nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, cd_conjunto, ds_consistencia, nr_seq_ciclo)
                values (nextval('cm_ciclo_consiste_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, nr_seq_conj_cont_w, err_msg_w, nr_seq_ciclo_p);
                commit;
        end;
    end loop;
    close C01;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cm_insert_mult_conj_cic_barras ( nr_seq_conjuntos_p text, nr_seq_ciclo_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
