-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_consistir_copartic_zerada ( nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w    varchar(1);
qt_retorno_w    varchar(1);


BEGIN
if (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '')       then
        select  count(1)
        into STRICT    qt_retorno_w
        from    pls_conta_coparticipacao
        where   nr_seq_conta_proc = nr_seq_conta_proc_p
        and     vl_coparticipacao = 0;
elsif (nr_seq_conta_mat_p IS NOT NULL AND nr_seq_conta_mat_p::text <> '')        then
        select  count(1)
        into STRICT    qt_retorno_w
        from    pls_conta_coparticipacao
        where   nr_seq_conta_mat  = nr_seq_conta_mat_p
        and     vl_coparticipacao = 0;
end if;

if (qt_retorno_w > 0 )     then
        ds_retorno_w    := 'S';
else
        ds_retorno_w    := 'N';
end if;

return  ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_consistir_copartic_zerada ( nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, nm_usuario_p text) FROM PUBLIC;

