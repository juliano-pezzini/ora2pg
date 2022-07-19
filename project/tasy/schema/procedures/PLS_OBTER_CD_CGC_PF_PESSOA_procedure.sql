-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_cd_cgc_pf_pessoa ( nr_sequencia_p bigint, cd_cgc_p INOUT text, cd_pessoa_fisica_p INOUT text) AS $body$
BEGIN

select	cd_cgc,
	cd_pessoa_fisica
into STRICT	cd_cgc_p,
	cd_pessoa_fisica_p
from	pls_atendimento
where	nr_sequencia = nr_sequencia_p;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_cd_cgc_pf_pessoa ( nr_sequencia_p bigint, cd_cgc_p INOUT text, cd_pessoa_fisica_p INOUT text) FROM PUBLIC;

