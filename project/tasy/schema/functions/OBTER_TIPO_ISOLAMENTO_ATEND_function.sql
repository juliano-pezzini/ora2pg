-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_isolamento_atend (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_tipo_isolamento_w		varchar(100);
cd_doenca_w			diagnostico_doenca.cd_doenca%type;

C01 CURSOR FOR
	SELECT		cd_doenca
	from		diagnostico_doenca
	where		nr_atendimento = coalesce(nr_atendimento_p, 0)
	order by	dt_diagnostico desc;


BEGIN
	open C01;
		loop
		fetch C01 into
			cd_doenca_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */

			if (cd_doenca_w IS NOT NULL AND cd_doenca_w::text <> '') then
				begin
					select	max(ds_tipo_isolamento)
					into STRICT 	ds_tipo_isolamento_w
					from	cih_doenca_infecto a,
						cih_tipo_isolamento b
					where	a.nr_seq_tipo_isolamento = b.nr_sequencia
					and	cd_doenca_cid = cd_doenca_w;

					if (ds_tipo_isolamento_w IS NOT NULL AND ds_tipo_isolamento_w::text <> '') then
						return ds_tipo_isolamento_w;
					end if;
				end;
			else
				ds_tipo_isolamento_w := '';
			end if;
		end loop;
	close C01;
	return ds_tipo_isolamento_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_isolamento_atend (nr_atendimento_p bigint) FROM PUBLIC;

