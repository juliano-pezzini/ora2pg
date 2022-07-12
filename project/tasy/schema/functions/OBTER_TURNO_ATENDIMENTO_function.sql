-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_turno_atendimento ( dt_atendimento_p timestamp, cd_estabelecimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


dt_atendimento_w	timestamp;
nr_seq_turno_w		bigint;
ds_turno_w		varchar(15);
dt_inicio_w		timestamp;
dt_final_w		timestamp;
ds_retorno_w		varchar(15);

c01 CURSOR FOR
	SELECT	nr_sequencia,
		ds_turno,ESTABLISHMENT_TIMEZONE_UTILS.todayAtTime(dt_inicial),
		ESTABLISHMENT_TIMEZONE_UTILS.todayAtTime(dt_final)
	from	turno_atendimento
	where	cd_estabelecimento	= cd_estabelecimento_p;


BEGIN

dt_atendimento_w	:= ESTABLISHMENT_TIMEZONE_UTILS.todayAtTime(dt_atendimento_p);

open c01;
	loop
	fetch c01 into
		nr_seq_turno_w,
		ds_turno_w,
		dt_inicio_w,
		dt_final_w;	
	EXIT WHEN NOT FOUND; /* apply on c01 */

		if	(dt_atendimento_w >= dt_inicio_w AND dt_atendimento_w <= dt_final_w) or
			((dt_final_w < dt_inicio_w) and ((dt_atendimento_w >= dt_inicio_w) or (dt_atendimento_w <= dt_final_w))) then

			if (ie_opcao_p = 'C') then
				ds_retorno_w	:= nr_seq_turno_w;
			elsif (ie_opcao_p = 'D') then
				ds_retorno_w	:= ds_turno_w;
			elsif (ie_opcao_p = 'T') then
				begin
				if (substr(upper(ds_turno_w), 1, 1) in ('N','M')) then
					begin
					if (dt_atendimento_w <= dt_inicio_w) then
						ds_retorno_w	:= dt_atendimento_w - 1;
					else
						ds_retorno_w	:= dt_atendimento_w;
					end if;
					end;
				else
					ds_retorno_w	:= dt_atendimento_w;
				end if;
				end;
			end if;
		end if;
	
	end loop;
close c01;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_turno_atendimento ( dt_atendimento_p timestamp, cd_estabelecimento_p bigint, ie_opcao_p text) FROM PUBLIC;

