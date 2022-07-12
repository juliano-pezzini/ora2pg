-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_status_bed_patient (nr_atendimento_p text, cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE

    status_vaga_w varchar(6);
    nr_seq_reserva_w bigint;

BEGIN

    select	coalesce(max(nr_sequencia),0)
    into STRICT	nr_seq_reserva_w
    from	gestao_vaga
    where (coalesce(cd_pessoa_fisica_p::text, '') = '') or (cd_pessoa_fisica		=	cd_pessoa_fisica_p)
    and (coalesce(nr_atendimento_p::text, '') = '') or (nr_atendimento		=	nr_atendimento_p)
    and	dt_solicitacao 		<= 	clock_timestamp();

    if (nr_seq_reserva_w <> 0) then
        select	a.ie_status
        into STRICT	status_vaga_w
        from	gestao_vaga a
        where	a.nr_sequencia	= nr_seq_reserva_w;
    end if;

    return	status_vaga_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_status_bed_patient (nr_atendimento_p text, cd_pessoa_fisica_p text) FROM PUBLIC;
