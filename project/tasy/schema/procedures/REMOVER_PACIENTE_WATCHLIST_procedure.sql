-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE remover_paciente_watchlist ( nm_usuario_p pessoa_fisica.nm_usuario%TYPE, cd_pessoa_fisica_p panorama_acomp_prof.cd_pessoa_fisica%Type) AS $body$
BEGIN
IF (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '' AND cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') THEN
    BEGIN
        DELETE FROM panorama_acomp_watchlist
        WHERE nm_usuario = nm_usuario_p
        AND cd_pessoa_fisica = cd_pessoa_fisica_p;
		
	DELETE FROM panorama_watchlist
        WHERE nm_usuario = nm_usuario_p
        AND cd_profissional = cd_pessoa_fisica_p;
    END;
END IF;
COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE remover_paciente_watchlist ( nm_usuario_p pessoa_fisica.nm_usuario%TYPE, cd_pessoa_fisica_p panorama_acomp_prof.cd_pessoa_fisica%Type) FROM PUBLIC;

