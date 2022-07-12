-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_nome_prestador ( nr_seq_prestador_email_p pls_prestador_email.nr_sequencia%type ) RETURNS varchar AS $body$
DECLARE

    nm_prestador_w pls_prestador.nm_interno%type;

BEGIN
    select
        p.nm_interno
    into STRICT
        nm_prestador_w
    from
        pls_prestador p
    where
        p.nr_sequencia = nr_seq_prestador_email_p  LIMIT 1;

    return nm_prestador_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_nome_prestador ( nr_seq_prestador_email_p pls_prestador_email.nr_sequencia%type ) FROM PUBLIC;
