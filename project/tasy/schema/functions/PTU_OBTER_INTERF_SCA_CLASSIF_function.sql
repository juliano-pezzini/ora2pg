-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ptu_obter_interf_sca_classif (nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


cd_interface_w		bigint;


BEGIN
	select	cd_interface
	into STRICT	cd_interface_w
	from	pls_sca_classificacao
	where	nr_sequencia = nr_sequencia_p;
return	cd_interface_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ptu_obter_interf_sca_classif (nr_sequencia_p bigint) FROM PUBLIC;
