-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_pf_departamento ( NM_USUARIO_P USUARIO.NM_USUARIO%TYPE, CD_PESSOA_FISICA_P PESSOA_FISICA.CD_PESSOA_FISICA%TYPE, SG_DEPARTAMENTO_P pessoa_fisica_aux.sg_departamento%TYPE, DS_DIGITO_VERIF_P PESSOA_FISICA_AUX.DS_DIGITO_VERIF%TYPE ) AS $body$
DECLARE

    VCount smallint := 0;

BEGIN
    SELECT COUNT(1) INTO STRICT VCount FROM PESSOA_FISICA_AUX a WHERE a.CD_PESSOA_FISICA = CD_PESSOA_FISICA_P;

    IF (VCount > 0) THEN
        UPDATE PESSOA_FISICA_AUX a SET 
            a.NM_USUARIO = NM_USUARIO_P, 
            a.DT_ATUALIZACAO = clock_timestamp(), 
            a.SG_DEPARTAMENTO = SG_DEPARTAMENTO_P, 
            a.DS_DIGITO_VERIF = DS_DIGITO_VERIF_P
        WHERE 
            a.CD_PESSOA_FISICA = CD_PESSOA_FISICA_P;
    ELSE
        INSERT INTO PESSOA_FISICA_AUX(
            NR_SEQUENCIA,
            DT_ATUALIZACAO,
            DT_ATUALIZACAO_NREC,
            NM_USUARIO,
            NM_USUARIO_NREC,
            CD_PESSOA_FISICA,
            SG_DEPARTAMENTO,
            DS_DIGITO_VERIF
        ) VALUES (
            nextval('pessoa_fisica_aux_seq'),
            clock_timestamp(),
            clock_timestamp(),
            NM_USUARIO_P,
            NM_USUARIO_P,
            CD_PESSOA_FISICA_P,
            SG_DEPARTAMENTO_P,
            DS_DIGITO_VERIF_P
        );
    END IF;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_pf_departamento ( NM_USUARIO_P USUARIO.NM_USUARIO%TYPE, CD_PESSOA_FISICA_P PESSOA_FISICA.CD_PESSOA_FISICA%TYPE, SG_DEPARTAMENTO_P pessoa_fisica_aux.sg_departamento%TYPE, DS_DIGITO_VERIF_P PESSOA_FISICA_AUX.DS_DIGITO_VERIF%TYPE ) FROM PUBLIC;

