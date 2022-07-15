-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_dados_cir_parto_atend ( nr_atendimento_p bigint, ie_apres_cirurgia_dados_p INOUT text) AS $body$
DECLARE


qt_cirurgias_w			bigint;
ie_apres_cirurgia_dados_w	varchar(1) := 'N';
nr_cirurgia_w			bigint;


BEGIN
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	begin
	select	coalesce(count(*),0)
	into STRICT	qt_cirurgias_w
	from	cirurgia
	where	nr_atendimento = nr_atendimento_p;

	if (qt_cirurgias_w > 1) then
		begin
		ie_apres_cirurgia_dados_w := 'S';
		end;
	else
		begin
		select	max(nr_cirurgia)
		into STRICT	nr_cirurgia_w
		from	cirurgia
		where	nr_atendimento = nr_atendimento_p;

		CALL inserir_dados_cirurgia_parto(nr_cirurgia_w);
		end;
	end if;
	end;
end if;
ie_apres_cirurgia_dados_p := ie_apres_cirurgia_dados_w;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_dados_cir_parto_atend ( nr_atendimento_p bigint, ie_apres_cirurgia_dados_p INOUT text) FROM PUBLIC;

