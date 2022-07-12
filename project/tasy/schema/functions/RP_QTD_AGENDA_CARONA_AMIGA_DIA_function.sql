-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rp_qtd_agenda_carona_amiga_dia (dt_agenda_p timestamp, nr_seq_regiao_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


cd_pessoa_fisica_w	varchar(10);
qt_agendamento_w	bigint;
qt_retorno_w		bigint;

C01 CURSOR FOR
	SELECT	distinct cd_pessoa_fisica
	from	rp_paciente_reabilitacao a
	where	ie_carona_amiga = 'S'
	and	nr_seq_regiao_p = (SELECT	max(CD_MUNICIPIO_IBGE)
				from		compl_pessoa_fisica b
				where		a.cd_pessoa_fisica = b.cd_pessoa_fisica
				and		b.ie_tipo_complemento = 1);


BEGIN
if (dt_agenda_p IS NOT NULL AND dt_agenda_p::text <> '') and (nr_seq_regiao_p IS NOT NULL AND nr_seq_regiao_p::text <> '') then
	if (ie_opcao_p = 'T') then
		qt_retorno_w := 0;

		open C01;
		loop
		fetch C01 into
			cd_pessoa_fisica_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			qt_agendamento_w := 0;

			select	count(*)
			into STRICT	qt_agendamento_w
			from	agenda_paciente
			where	cd_pessoa_fisica	= cd_pessoa_fisica_w
			and	trunc(hr_inicio)	= trunc(dt_agenda_p)
			and	ie_status_agenda not in ('C','B');

			if (qt_agendamento_w > 0) then
				qt_retorno_w := qt_retorno_w + 1;
			else
				select	count(*)
				into STRICT	qt_agendamento_w
				from	agenda_consulta
				where	cd_pessoa_fisica 	= cd_pessoa_fisica_w
				and	trunc(dt_agenda)	= trunc(dt_agenda_p)
				and	ie_status_agenda not in ('C','B');

				if (qt_agendamento_w > 0) then
					qt_retorno_w := qt_retorno_w + 1;
				else
					select	count(*)
					into STRICT	qt_agendamento_w
					from	agenda_integrada
					where	cd_pessoa_fisica = cd_pessoa_fisica_w
					and	trunc(dt_inicio_agendamento) = trunc(dt_agenda_p);

					if (qt_agendamento_w > 0) then
						qt_retorno_w := qt_retorno_w + 1;
					end if;
				end if;

			end if;

			end;
		end loop;
		close C01;
	elsif (ie_opcao_p = 'C') then
		qt_retorno_w := 0;
		open C01;
		loop
		fetch C01 into
			cd_pessoa_fisica_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			select	count(*)
			into STRICT	qt_agendamento_w
			from	agenda_consulta
			where	cd_pessoa_fisica 	= cd_pessoa_fisica_w
			and	trunc(dt_agenda)	= trunc(dt_agenda_p)
			and	ie_status_agenda not in ('C','B');

			if (qt_agendamento_w > 0) then
				qt_retorno_w := qt_retorno_w + 1;
			end if;
			end;
		end loop;
		close C01;
	elsif (ie_opcao_p = 'P') then

		qt_retorno_w := 0;
		open C01;
		loop
		fetch C01 into
			cd_pessoa_fisica_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			select	count(*)
			into STRICT	qt_agendamento_w
			from	agenda_paciente
			where	cd_pessoa_fisica	= cd_pessoa_fisica_w
			and	trunc(hr_inicio)	= trunc(dt_agenda_p)
			and	ie_status_agenda not in ('C','B');

			if (qt_agendamento_w > 0) then
				qt_retorno_w := qt_retorno_w + 1;
			end if;
			end;
		end loop;
		close C01;

	elsif (ie_opcao_p = 'I') then
		qt_retorno_w := 0;
		open C01;
		loop
		fetch C01 into
			cd_pessoa_fisica_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			select	count(*)
			into STRICT	qt_agendamento_w
			from	agenda_integrada
			where	cd_pessoa_fisica = cd_pessoa_fisica_w
			and	trunc(dt_inicio_agendamento) = trunc(dt_agenda_p);

			if (qt_agendamento_w > 0) then
				qt_retorno_w := qt_retorno_w + 1;
			end if;
			end;
		end loop;
		close C01;
	end if;
end if;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rp_qtd_agenda_carona_amiga_dia (dt_agenda_p timestamp, nr_seq_regiao_p bigint, ie_opcao_p text) FROM PUBLIC;
