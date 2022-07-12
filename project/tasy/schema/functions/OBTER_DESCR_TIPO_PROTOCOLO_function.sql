-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_descr_tipo_protocolo ( cd_tipo_protocolo_p tipo_protocolo.cd_tipo_protocolo%type ) RETURNS varchar AS $body$
DECLARE


	ds_retorno_w tipo_protocolo.ds_tipo_protocolo%type;


BEGIN

	select	max(ds_tipo_protocolo)
	into STRICT	ds_retorno_w
	from	tipo_protocolo
	where	cd_tipo_protocolo = cd_tipo_protocolo_p;

	return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_descr_tipo_protocolo ( cd_tipo_protocolo_p tipo_protocolo.cd_tipo_protocolo%type ) FROM PUBLIC;

