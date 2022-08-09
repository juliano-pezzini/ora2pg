-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_watchlist ( nm_usuario_p pessoa_fisica.nm_usuario%TYPE, cd_profissional_p panorama_acomp_prof.cd_profissional%Type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%TYPE, nr_atendimento_p atendimento_paciente.nr_atendimento%TYPE) AS $body$
DECLARE


nr_sequencia_w          gestao_vaga.nr_sequencia%TYPE;
dt_atualizacao_w	    timestamp;
nm_usuario_w            pessoa_fisica.nm_usuario%TYPE;
cd_profissional_w       panorama_acomp_prof.cd_profissional%TYPE;
cd_pessoa_fisica_w      pessoa_fisica.cd_pessoa_fisica%TYPE;

C01 CURSOR FOR
    SELECT  nr_sequencia,
            nm_usuario,
            cd_pessoa_fisica,
            cd_profissional
    FROM    PANORAMA_WATCHLIST
    WHERE   nm_usuario = nm_usuario_p
	AND     nr_sequencia = nr_atendimento_p
    AND     cd_profissional = cd_profissional_p;


BEGIN

    SELECT	coalesce(MAX(cd_profissional),0)
    INTO STRICT	cd_profissional_w
    FROM	PANORAMA_WATCHLIST
    WHERE	cd_profissional = cd_profissional_p
    AND nr_sequencia = nr_atendimento_p
    AND	nm_usuario = nm_usuario_p;

    dt_atualizacao_w	:= clock_timestamp();

    IF (cd_profissional_w = 0) THEN
        BEGIN
            INSERT INTO PANORAMA_WATCHLIST(nr_sequencia,
                dt_atualizacao,
                nm_usuario,
                dt_atualizacao_nrec,
                nm_usuario_nrec,
                cd_pessoa_fisica,
                cd_profissional)
            VALUES (nr_atendimento_p,		
                dt_atualizacao_w,
                nm_usuario_p,
                dt_atualizacao_w,
                nm_usuario_p,
                cd_pessoa_fisica_p,
                cd_profissional_p);

           CALL panorama_watchlist_pck.atualiza_acomp_watchlist(nm_usuario_p, 
                                                        cd_profissional_p, 
                                                        cd_pessoa_fisica_p,
                                                        nr_atendimento_p);
        END;
    END IF;

OPEN C01;
LOOP
FETCH C01 INTO
    nr_sequencia_w,
    nm_usuario_w,
    cd_pessoa_fisica_w,
    cd_profissional_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

IF (cd_profissional_w = cd_profissional_p) THEN
    BEGIN
        UPDATE PANORAMA_WATCHLIST
        SET nm_usuario_nrec = nm_usuario_p,
            cd_pessoa_fisica = cd_pessoa_fisica_p,
            cd_profissional = cd_profissional_p,
            dt_atualizacao_nrec = dt_atualizacao_w
        WHERE nm_usuario = nm_usuario_p
	            AND nr_sequencia = nr_atendimento_p
              AND cd_profissional = cd_profissional_p;

        CALL panorama_watchlist_pck.atualiza_acomp_watchlist(nm_usuario_p, 
                                                        cd_profissional_p, 
                                                        cd_pessoa_fisica_p,
                                                        nr_atendimento_p);
    END;
END IF;
END LOOP;
CLOSE C01;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_watchlist ( nm_usuario_p pessoa_fisica.nm_usuario%TYPE, cd_profissional_p panorama_acomp_prof.cd_profissional%Type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%TYPE, nr_atendimento_p atendimento_paciente.nr_atendimento%TYPE) FROM PUBLIC;
