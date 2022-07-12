-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_lib_exige_auditoria ( nr_seq_auditoria_p bigint) RETURNS varchar AS $body$
DECLARE


ie_libera_w		varchar(1);
ie_tipo_auditoria_w		varchar(3);
ie_agrupamento_w		varchar(5);
qt_mat_w			bigint;
qt_proc_w		bigint;
qt_item_w		bigint;


BEGIN

ie_libera_w := 'S';

begin

select 	ie_tipo_auditoria,
	ie_agrupamento
into STRICT	ie_tipo_auditoria_w,
	ie_agrupamento_w
from 	auditoria_conta_paciente
where 	nr_sequencia = nr_seq_auditoria_p;

exception
	when others then
	ie_tipo_auditoria_w	:= 'I';
	ie_agrupamento_w	:= '';
end;


if (ie_tipo_auditoria_w = 'E') then -- Auditoria externa
	select 	count(*)
	into STRICT	qt_item_w
	from 	auditoria_externa
	where 	nr_seq_auditoria = nr_seq_auditoria_p
	and 	coalesce(ie_auditado,'N') = 'N'
	and 	coalesce(qt_ajuste::text, '') = '';

	if (qt_item_w > 0) then
		ie_libera_w:= 'N';
	end if;

else --Auditoria interna
	select 	count(*)
	into STRICT	qt_mat_w
	from 	auditoria_matpaci
	where 	nr_seq_auditoria = nr_seq_auditoria_p
	and 	coalesce(ie_tipo_auditoria,'A') = 'A'
	and	ie_exige_auditoria = 'S'
	and 	coalesce(qt_ajuste::text, '') = '';

	select 	count(*)
	into STRICT	qt_proc_w
	from 	auditoria_propaci
	where 	nr_seq_auditoria = nr_seq_auditoria_p
	and 	coalesce(ie_tipo_auditoria,'A') = 'A'
	and	ie_exige_auditoria = 'S'
	and 	coalesce(qt_ajuste::text, '') = ''
	and 	coalesce(tx_proc_ajuste::text, '') = '';

	if	((qt_mat_w + qt_proc_w) > 0) then
		ie_libera_w:= 'N';
	end if;

end if;

return	ie_libera_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_lib_exige_auditoria ( nr_seq_auditoria_p bigint) FROM PUBLIC;

