-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qtde_reg_ind_agenda ( nr_seq_agenda_p bigint) RETURNS bigint AS $body$
DECLARE



qt_registros_p		bigint;



BEGIN

select	count(*)
into STRICT    qt_registros_p
from    pessoa_fisica b,
        profissional_agenda a
where   b.cd_pessoa_fisica 	= a.cd_profissional
and     a.nr_seq_agenda 	= nr_seq_agenda_p
order by nm_pessoa_fisica desc;

return	qt_registros_p;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qtde_reg_ind_agenda ( nr_seq_agenda_p bigint) FROM PUBLIC;
