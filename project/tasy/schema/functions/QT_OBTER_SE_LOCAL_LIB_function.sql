-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qt_obter_se_local_lib (nr_seq_ageint_item_p bigint, nr_seq_local_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1)	:= 'S';
ie_tipo_pend_Agenda_w	varchar(15);
qt_regra_local_w	bigint;
nr_seq_grupo_quimio_w	bigint;


BEGIN

if (nr_seq_ageint_item_p IS NOT NULL AND nr_seq_ageint_item_p::text <> '') then
	select	coalesce(max(ie_tipo_pend_agenda),0),
		coalesce(max(nr_seq_grupo_quimio),0)
	into STRICT	ie_tipo_pend_Agenda_w,
		nr_seq_grupo_quimio_w
	from	agenda_integrada_item
	where	nr_sequencia	= nr_seq_Ageint_item_p;

	if (nr_seq_grupo_quimio_w	= 0) and (ie_tipo_pend_agenda_w	= 'Q')  then
		select	max(nr_seq_grupo)
		into STRICT	nr_seq_grupo_quimio_w
		from	qt_item_agenda
		where	cd_item	= 'Q';
	end if;

	begin
	select	1
	into STRICT	qt_regra_local_w
	from	qt_tipo_quimio_local
	where	nr_seq_local		= nr_seq_local_p  LIMIT 1;
	exception
	when others then
		qt_regra_local_w	:= 0;
	end;

	if (qt_regra_local_w	> 0) then
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ds_retorno_w
		from	qt_tipo_quimio_local
		where	nr_seq_local		= nr_seq_local_p
		and	coalesce(ie_tipo_pend_Agenda, ie_tipo_pend_agenda_w)	= ie_tipo_pend_agenda_w
		and	coalesce(nr_seq_grupo_quimio, nr_seq_grupo_quimio_w)	=	nr_seq_grupo_quimio_w;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qt_obter_se_local_lib (nr_seq_ageint_item_p bigint, nr_seq_local_p bigint) FROM PUBLIC;
