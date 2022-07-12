-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION suep_datas_ciclo_atual ( nr_seq_paciente_p bigint, ie_opcao_p text) RETURNS timestamp AS $body$
DECLARE


/*
Data prevista			DP
Data último ciclo			DU
*/
nr_ciclo_w				bigint := 0;
nr_ciclo_total_w		bigint := 1;
ds_dia_ciclo_w 			varchar(5) := '';
dt_data_inicio_ciclo_w 	timestamp;
dt_retorno_w			timestamp;
nr_seq_atend_ciclo_w	bigint;


BEGIN

if (nr_seq_paciente_p IS NOT NULL AND nr_seq_paciente_p::text <> '') then

		Select 	max(nr_ciclos)
		into STRICT	nr_ciclo_total_w
		from	paciente_setor a
		where	nr_seq_paciente = nr_seq_paciente_p;

		select	min(coalesce(nr_ciclo,0))
		into STRICT	nr_ciclo_w
		from	paciente_atendimento
		where	nr_seq_paciente = nr_seq_paciente_p
		and		coalesce(dt_real,dt_prevista) >= clock_timestamp();

		if ( nr_ciclo_w > 0) then


				if ( ie_opcao_p = 'DU' ) then

					select	min(coalesce(dt_real,dt_prevista))
					into STRICT	dt_data_inicio_ciclo_w
					from	paciente_atendimento
					where	nr_seq_paciente = nr_seq_paciente_p
					and		nr_ciclo = nr_ciclo_w;

					if ( dt_data_inicio_ciclo_w < clock_timestamp()) then
						dt_retorno_w := dt_data_inicio_ciclo_w;
					end if;

					goto Fim;

				end if;


				select	min(DS_DIA_CICLO)
				into STRICT	ds_dia_ciclo_w
				from	paciente_atendimento
				where	nr_seq_paciente = nr_seq_paciente_p
				and		nr_ciclo = nr_ciclo_w
				and		coalesce(dt_real,dt_prevista) >= clock_timestamp();


				select	max(nr_seq_atendimento)
				into STRICT	nr_seq_atend_ciclo_w
				from	paciente_atendimento
				where	nr_seq_paciente = nr_seq_paciente_p
				and		nr_ciclo = nr_ciclo_w
				and		DS_DIA_CICLO = ds_dia_ciclo_w;



				If ( ie_opcao_p = 'DP') then

					select	coalesce(dt_real,dt_prevista)
					into STRICT	dt_retorno_w
					from	paciente_atendimento
					where	nr_seq_atendimento = nr_seq_atend_ciclo_w;


				end if;


		end if;

end if;

<<Fim>>

return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION suep_datas_ciclo_atual ( nr_seq_paciente_p bigint, ie_opcao_p text) FROM PUBLIC;
