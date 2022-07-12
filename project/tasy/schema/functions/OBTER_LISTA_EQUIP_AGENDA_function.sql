-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_lista_equip_agenda ( nr_seq_agenda_p bigint ) RETURNS varchar AS $body$
DECLARE


ds_equipamento_w	varchar(200);
ds_equipamentos_w	varchar(2000);

c01 CURSOR FOR
	SELECT	substr(obter_desc_classif_equip(NR_SEQ_CLASSIF_EQUIP),1,80)
	from	agenda_pac_equip
	where	nr_seq_agenda	= nr_seq_agenda_p
	and	(NR_SEQ_CLASSIF_EQUIP IS NOT NULL AND NR_SEQ_CLASSIF_EQUIP::text <> '')
	and	IE_ORIGEM_INF = 'I'
	
union all

	SELECT	substr(Obter_Desc_Equip_Agenda(cd_equipamento),1,200)
	from	agenda_pac_equip
	where	nr_seq_agenda	= nr_seq_agenda_p
	and	(cd_equipamento IS NOT NULL AND cd_equipamento::text <> '')
	and	IE_ORIGEM_INF = 'I'
	order by 1;


BEGIN

OPEN C01;
LOOP
FETCH C01 into
	ds_equipamento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	if (ds_equipamentos_w IS NOT NULL AND ds_equipamentos_w::text <> '') then
		ds_equipamentos_w := ds_equipamentos_w || ', ';
	end if;

	ds_equipamentos_w	:= substr(ds_equipamentos_w || ds_equipamento_w,1,2000);

	end;
END LOOP;
CLOSE C01;

return ds_equipamentos_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_lista_equip_agenda ( nr_seq_agenda_p bigint ) FROM PUBLIC;
