-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cns_obter_domicilio_usuario ( nr_sequencia_p bigint, ie_tipo_p text) RETURNS varchar AS $body$
DECLARE


/* IE_TIPO_P
	S - Sequencia
	C - Codigo
*/
nr_seq_domicilio_w	bigint;
cd_domicilio_w		varchar(16);
ds_retorno_w		varchar(16);


BEGIN

select	coalesce(max(nr_seq_domicilio),0)
into STRICT	nr_seq_domicilio_w
from	cns_domicilio_usuario
where	nr_sequencia =	(SELECT	max(nr_sequencia)
			from	cns_domicilio_usuario
			where	nr_seq_usuario	= nr_sequencia_p
			and	ie_situacao	= 'A');

select	coalesce(max(cd_domicilio),0)
into STRICT	cd_domicilio_w
from	cns_domicilio
where	nr_sequencia	= nr_seq_domicilio_w;

if (ie_tipo_p	= 'S') then
	ds_retorno_w	:= nr_seq_domicilio_w;
elsif (ie_tipo_p	= 'C') then
	ds_retorno_w	:= cd_domicilio_w;
end if;

return	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cns_obter_domicilio_usuario ( nr_sequencia_p bigint, ie_tipo_p text) FROM PUBLIC;

