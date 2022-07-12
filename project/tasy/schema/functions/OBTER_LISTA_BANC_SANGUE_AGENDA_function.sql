-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_lista_banc_sangue_agenda ( nr_seq_agenda_p bigint, ie_opcao_p text default 'D') RETURNS varchar AS $body$
DECLARE


ds_banco_sangue_w		varchar(255);
ds_lista_banco_sangue_w		varchar(4000);
qt_bolsas_sangue_w		varchar(10);

c01 CURSOR FOR
	SELECT	substr(obter_desc_proc_interno(nr_seq_proc_interno),1,255),
			coalesce(qt_bolsas_sangue,0)
	from	agenda_pac_sangue a
	where	a.nr_seq_agenda = nr_seq_agenda_p
	order by 1;


BEGIN
if (ie_opcao_p = 'D') then
	OPEN C01;
	LOOP
	FETCH C01 into
		ds_banco_sangue_w,
		qt_bolsas_sangue_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

		if (ds_lista_banco_sangue_w IS NOT NULL AND ds_lista_banco_sangue_w::text <> '') then
			ds_lista_banco_sangue_w := substr(ds_lista_banco_sangue_w || ', ',1,4000);
		end if;

		ds_lista_banco_sangue_w	:= substr(ds_lista_banco_sangue_w || ds_banco_sangue_w,1,4000);

		end;
	END LOOP;
	CLOSE C01;
elsif (ie_opcao_p = 'Q') then
	OPEN C01;
	LOOP
	FETCH C01 into
		ds_banco_sangue_w,
		qt_bolsas_sangue_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

		if (ds_lista_banco_sangue_w IS NOT NULL AND ds_lista_banco_sangue_w::text <> '') then
			ds_lista_banco_sangue_w := substr(ds_lista_banco_sangue_w || ', ',1,4000);
		end if;

		ds_lista_banco_sangue_w	:= substr(ds_lista_banco_sangue_w || ds_banco_sangue_w,1,4000);

		if (qt_bolsas_sangue_w > 0) then
			ds_lista_banco_sangue_w := substr(ds_lista_banco_sangue_w || ' Qtde: ' || qt_bolsas_sangue_w,1,4000);
		end if;

		end;
	END LOOP;
	CLOSE C01;
end if;

return ds_lista_banco_sangue_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_lista_banc_sangue_agenda ( nr_seq_agenda_p bigint, ie_opcao_p text default 'D') FROM PUBLIC;
