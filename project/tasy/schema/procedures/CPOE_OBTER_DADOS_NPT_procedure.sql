-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_obter_dados_npt ( nr_atendimento_p bigint, qt_altura_cm_p INOUT bigint, qt_peso_p INOUT bigint, cd_doenca_cid_p INOUT text) AS $body$
DECLARE


cd_pessoa_fisica_w	atendimento_paciente.cd_pessoa_fisica%type;
qt_peso_w			double precision;
qt_altura_w			smallint;
cd_doenca_cid_w		varchar(15);

BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

qt_peso_w		:= obter_sinal_vital(nr_atendimento_p, 'PESO');
qt_altura_w		:= obter_sinal_vital(nr_atendimento_p, 'ALTURA');
cd_doenca_cid_w := obter_cod_diagnostico_atend(nr_atendimento_p);

	if (coalesce(qt_peso_w,0) = 0) or (coalesce(qt_altura_w,0) = 0) then

	begin
		select	cd_pessoa_fisica
		into STRICT	cd_pessoa_fisica_w
		from	atendimento_paciente
		where	nr_atendimento = nr_atendimento_p;
	exception
	when others then
		cd_pessoa_fisica_w := null;
	end;

		if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
			if (coalesce(qt_peso_w,0) = 0) then
				qt_peso_w := obter_ultimo_sinal_vital_pf(cd_pessoa_fisica_w, 'PESO');
			elsif (coalesce(qt_altura_w,0) = 0) then
				qt_altura_w := obter_ultimo_sinal_vital_pf(cd_pessoa_fisica_w, 'ALTURA');
			end if;
		end if;
	end if;
end if;

qt_altura_cm_p	:= coalesce(qt_altura_w,0);
qt_peso_p		:= coalesce(qt_peso_w,0);
cd_doenca_cid_p	:= cd_doenca_cid_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_obter_dados_npt ( nr_atendimento_p bigint, qt_altura_cm_p INOUT bigint, qt_peso_p INOUT bigint, cd_doenca_cid_p INOUT text) FROM PUBLIC;
