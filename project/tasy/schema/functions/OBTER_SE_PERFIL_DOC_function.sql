-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_perfil_doc ( ie_tipo_protocolo_p text, nr_seq_tipo_item_p bigint, cd_perfil_p bigint) RETURNS varchar AS $body$
DECLARE


qt_documento_w		bigint;
ie_retorno_w		varchar(1) := 'S';
ie_tipo_protocolo_w	varchar(3);
nr_seq_tipo_item_w	bigint;

c01 CURSOR FOR
SELECT	ie_tipo_protocolo
from	perfil_tipo_doc
where	ie_tipo_protocolo	= ie_tipo_protocolo_p
and	cd_perfil		= cd_perfil_p;

c02 CURSOR FOR
SELECT	nr_seq_tipo_item
from	perfil_tipo_doc
where	nr_seq_tipo_item	= nr_seq_tipo_item_p
and	cd_perfil		= cd_perfil_p;


BEGIN

if (ie_tipo_protocolo_p IS NOT NULL AND ie_tipo_protocolo_p::text <> '') and (cd_perfil_p IS NOT NULL AND cd_perfil_p::text <> '') then

	select	count(*)
	into STRICT	qt_documento_w
	from	perfil_tipo_doc
	where	cd_perfil = cd_perfil_p
	and	(ie_tipo_protocolo IS NOT NULL AND ie_tipo_protocolo::text <> '');

	if (qt_documento_w = 0) then
		ie_retorno_w	:= 'S';
	else
		ie_retorno_w	:= 'N';
		open	c01;
		loop
		fetch 	c01 into
			ie_tipo_protocolo_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			ie_retorno_w	:= 'S';
		end loop;
		close	c01;
	end if;
end if;
if (nr_seq_tipo_item_p IS NOT NULL AND nr_seq_tipo_item_p::text <> '') and (cd_perfil_p IS NOT NULL AND cd_perfil_p::text <> '') then

	select	count(*)
	into STRICT	qt_documento_w
	from	perfil_tipo_doc
	where	cd_perfil = cd_perfil_p
	and	(nr_seq_tipo_item IS NOT NULL AND nr_seq_tipo_item::text <> '');

	if (qt_documento_w = 0) then
		ie_retorno_w	:= 'S';
	else
		ie_retorno_w	:= 'N';
		open	c02;
		loop
		fetch 	c02 into
			nr_seq_tipo_item_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			ie_retorno_w	:= 'S';
		end loop;
		close	c02;
	end if;
end if;

return coalesce(ie_retorno_w,'S');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_perfil_doc ( ie_tipo_protocolo_p text, nr_seq_tipo_item_p bigint, cd_perfil_p bigint) FROM PUBLIC;

