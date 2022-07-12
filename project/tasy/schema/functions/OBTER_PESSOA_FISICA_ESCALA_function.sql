-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pessoa_fisica_escala ( nr_seq_escala_p bigint, dt_referencia_p timestamp) RETURNS varchar AS $body$
DECLARE


cd_pessoa_fisica_w				varchar(10);


BEGIN

cd_pessoa_fisica_w				:= '';

select	min(a.cd_pessoa_fisica)
into STRICT	cd_pessoa_fisica_w
from	escala_diaria a, escala b
where	a.nr_seq_escala = nr_seq_escala_p
and	(a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '')
and b.nr_sequencia = a.nr_seq_escala
and b.ie_situacao = 'A'
and	dt_referencia_p between a.dt_inicio and a.dt_fim;

RETURN cd_pessoa_fisica_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pessoa_fisica_escala ( nr_seq_escala_p bigint, dt_referencia_p timestamp) FROM PUBLIC;
