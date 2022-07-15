-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE egk_inserir_log ( nm_usuario_p egk_reader_log.nm_usuario%type, ds_log_p egk_reader_log.ds_log%type) AS $body$
DECLARE


nr_sequencia_w   egk_reader_log.nr_sequencia%type;


BEGIN

select  nextval('egk_reader_log_seq')
into STRICT    nr_sequencia_w
;

insert into egk_reader_log(
            nr_sequencia,
            dt_atualizacao,
            nm_usuario,
            ds_log)
values (   nr_sequencia_w,
            clock_timestamp(),
            nm_usuario_p,
            ds_log_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE egk_inserir_log ( nm_usuario_p egk_reader_log.nm_usuario%type, ds_log_p egk_reader_log.ds_log%type) FROM PUBLIC;

