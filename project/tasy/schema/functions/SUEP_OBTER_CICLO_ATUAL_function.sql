-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION suep_obter_ciclo_atual ( nr_seq_paciente_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
Ciclo atual				CA
Dia  atual				DA
Data prevista			DP
Data último ciclo			DU
Sequencia próximo data		SD

*/
nr_ciclo_w				bigint := 0;
nr_ciclo_total_w		bigint := 1;
ds_dia_ciclo_w 			varchar(5) := '';
ds_data_inicio_ciclo_w 	timestamp;
ds_retorno_w			varchar(2000) := '';
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
					into STRICT	ds_data_inicio_ciclo_w
					from	paciente_atendimento
					where	nr_seq_paciente = nr_seq_paciente_p
					and		nr_ciclo = nr_ciclo_w;

					if ( ds_data_inicio_ciclo_w < clock_timestamp()) then
						ds_retorno_w := ds_data_inicio_ciclo_w;
					end if;

					goto Fim;

				end if;

				if ( ie_opcao_p = 'CA' ) then

					if ( nr_ciclo_total_w > 0) then

						ds_retorno_w := nr_ciclo_w||' '||obter_desc_expressao(310214)||' '||nr_ciclo_total_w;

					else

						ds_retorno_w := nr_ciclo_w;

					end if;

					goto Fim;

				end if;


				select	min(DS_DIA_CICLO)
				into STRICT	ds_dia_ciclo_w
				from	paciente_atendimento
				where	nr_seq_paciente = nr_seq_paciente_p
				and		nr_ciclo = nr_ciclo_w
				and		coalesce(dt_real,dt_prevista) >= clock_timestamp();


				if (ie_opcao_p = 'DA') then

					ds_retorno_w := ds_dia_ciclo_w;

					goto Fim;

				end if;


				select	max(nr_seq_atendimento)
				into STRICT	nr_seq_atend_ciclo_w
				from	paciente_atendimento
				where	nr_seq_paciente = nr_seq_paciente_p
				and		nr_ciclo = nr_ciclo_w
				and		DS_DIA_CICLO = ds_dia_ciclo_w;

				if ( ie_opcao_p = 'SD' ) then

					ds_retorno_w := nr_seq_atend_ciclo_w;

					goto Fim;

				end if;

				If ( ie_opcao_p = 'DP') then

					select	coalesce(dt_real,dt_prevista)
					into STRICT	ds_retorno_w
					from	paciente_atendimento
					where	nr_seq_atendimento = nr_seq_atend_ciclo_w;


				end if;


		end if;

end if;

<<Fim>>

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION suep_obter_ciclo_atual ( nr_seq_paciente_p bigint, ie_opcao_p text) FROM PUBLIC;
