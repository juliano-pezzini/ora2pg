-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alternate_ie_gera_definicao ( nm_tabela_p tabela_sistema.nm_tabela%TYPE, nm_usuario_p tabela_sistema.nm_usuario%TYPE) AS $body$
DECLARE


ie_gera_definicao_sim_s CONSTANT tabela_sistema.ie_gera_definicao%TYPE := 'S';
ie_gera_definicao_nao_s CONSTANT tabela_sistema.ie_gera_definicao%TYPE := 'N';

BEGIN

    UPDATE tabela_sistema
    SET    ie_gera_definicao = CASE WHEN ie_gera_definicao=ie_gera_definicao_sim_s THEN  ie_gera_definicao_nao_s WHEN ie_gera_definicao=ie_gera_definicao_nao_s THEN  ie_gera_definicao_sim_s  ELSE ie_gera_definicao_nao_s END ,
           nm_usuario = nm_usuario_p,
           dt_atualizacao = clock_timestamp()
    WHERE  nm_tabela = nm_tabela_p;

    COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alternate_ie_gera_definicao ( nm_tabela_p tabela_sistema.nm_tabela%TYPE, nm_usuario_p tabela_sistema.nm_usuario%TYPE) FROM PUBLIC;

