-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_consistir_imp_plano_ans () AS $body$
DECLARE


ds_consistencia_w			varchar(4000);

c01 CURSOR FOR
	SELECT	a.*
	from	w_imp_conta_contabil a
	order by a.nr_sequencia;

vet01	c01%RowType;


BEGIN

open C01;
loop
fetch C01 into
	vet01;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	ds_consistencia_w := '';

	if (coalesce(vet01.cd_plano, 0) = 0) then
		ds_consistencia_w	:= substr(ds_consistencia_w || obter_desc_expressao(779677) || chr(13),1,4000);
	end if;

	if (coalesce(vet01.ds_conta_contabil, 'X') = 'X') then
		ds_consistencia_w	:= substr(ds_consistencia_w || obter_desc_expressao(779679) || chr(13),1,4000);
	end if;

	if (coalesce(vet01.ds_conta_contabil, 'X') = 'X') then
		ds_consistencia_w	:= substr(ds_consistencia_w || obter_desc_expressao(779685) || chr(13),1,4000);
	end if;

	if (coalesce(vet01.ie_tipo, 'X') <> 'X') then

		if (vet01.ie_tipo <> '1') and (vet01.ie_tipo <> '3') then
			ds_consistencia_w	:= substr(ds_consistencia_w || obter_desc_expressao(779687) || chr(13),1,4000);
		end if;
	else
		ds_consistencia_w		:= substr(ds_consistencia_w || obter_desc_expressao(779687) || chr(13),1,4000);
	end if;

	update	w_imp_conta_contabil
	set		ds_consistencia	= substr(ds_consistencia_w,1,4000)
	where	nr_sequencia	= vet01.nr_sequencia;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_consistir_imp_plano_ans () FROM PUBLIC;
