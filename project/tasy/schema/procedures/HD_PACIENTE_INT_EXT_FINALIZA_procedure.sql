-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_paciente_int_ext_finaliza (dt_verificacao_p timestamp DEFAULT clock_timestamp(), nr_periodo_p bigint DEFAULT 30, nm_usuario text DEFAULT 'TASY') AS $body$
DECLARE


    c01 CURSOR FOR
        SELECT pi.cd_pessoa_fisica
          FROM hd_paciente_int_ext pi,
               hd_escala_dialise   hed
         WHERE pi.cd_pessoa_fisica = hed.cd_pessoa_fisica
           AND coalesce(hed.dt_fim::text, '') = ''
           AND coalesce(pi.dt_retorno::text, '') = ''
           AND pi.dt_internacao <= trunc(dt_verificacao_p - nr_periodo_p);
BEGIN
    CALL wheb_usuario_pck.set_nm_usuario(nm_usuario);
    FOR i IN c01 LOOP
        CALL hd_encerrar_escalas_tratamento(cd_pessoa_fisica_p => i.cd_pessoa_fisica);
    END LOOP;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_paciente_int_ext_finaliza (dt_verificacao_p timestamp DEFAULT clock_timestamp(), nr_periodo_p bigint DEFAULT 30, nm_usuario text DEFAULT 'TASY') FROM PUBLIC;
