-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_turno_evento ( dt_evento_p timestamp, cd_estabelecimento_p bigint, ie_opcao_p text, ie_opcao_local_p text) RETURNS varchar AS $body$
DECLARE

/* ie_opcao
Resultado		Opção

Descrição		D
Código		C

 /*  ie_opcao_local
Descrição  		Opção

Evento - Quedas	EQ
Evento - PRM	EP
Escala Dor		ED
*/
ds_turno_w		varchar(15);
nr_turno_w		varchar(15);

ds_retorno_w		varchar(15);
hr_inicio_dia_w		varchar(10);
hr_fim_dia_w		varchar(10);
nr_seq_turno_w		bigint;
dt_inicio_w		timestamp;
dt_fim_w		timestamp;

C01 CURSOR FOR
	SELECT	to_date('01/01/1999' || ' ' || to_char(dt_inicial,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') dt_inicial,
		to_date('01/01/1999' || ' ' || to_char(dt_final,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') dt_final,
		to_date('01/01/1999' || ' ' || to_char(dt_evento_p,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') dt_atual,
		nr_sequencia
	from	REGRA_TURNO_EVENTO
	where	coalesce(ie_situacao,'A')	= 'A'
	and	coalesce(cd_estabelecimento,coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0);

Cw01	C01%RowType;


BEGIN

If (ie_opcao_local_p =  'EQ') then

	select	min(to_char(dt_inicial,'hh24:mi:ss'))
	into STRICT	hr_inicio_dia_w
	from 	REGRA_TURNO_EVENTO
	where	to_char(dt_inicial,'hh24') <>'00'
	and 	(to_char(dt_inicial,'hh24') IS NOT NULL AND (to_char(dt_inicial,'hh24'))::text <> '');



	select	min(to_char(dt_final,'hh24:mi:ss'))
	into STRICT	hr_fim_dia_w
	from 	REGRA_TURNO_EVENTO;

	dt_inicio_w	:= to_date(to_char(dt_evento_p,'dd/mm/yyyy')|| ' ' || hr_inicio_dia_w,'dd/mm/yyyy hh24:mi:ss');
	dt_fim_w	:= to_date(to_char((dt_evento_p + 1),'dd/mm/yyyy')|| ' ' ||hr_fim_dia_w,'dd/mm/yyyy hh24:mi:ss');

	OPEN  c01;
	LOOP
	FETCH c01 into	Cw01;
	EXIT WHEN NOT FOUND; /* apply on c01 */

		if	(Cw01.dt_atual >= Cw01.dt_inicial AND Cw01.dt_atual <= Cw01.dt_final) or
			((Cw01.dt_final < Cw01.dt_inicial) and
			 ((Cw01.dt_atual >= Cw01.dt_inicial) or (Cw01.dt_atual <= Cw01.dt_final))) then
			nr_seq_turno_w	:= Cw01.nr_sequencia;
		end if;

	END LOOP;
	CLOSE c01;

	select  max(cd_turno),
		max(nr_sequencia)
	into STRICT	ds_turno_w,
		nr_turno_w
	from	REGRA_TURNO_EVENTO
	where	nr_sequencia = nr_seq_turno_w;

End if;

if (ie_opcao_p = 'D') then
	ds_retorno_w := ds_turno_w;
elsif (ie_opcao_p = 'C') then
	ds_retorno_w := nr_turno_w;
elsif (ie_opcao_p = 'SEQ') then
	ds_retorno_w := nr_seq_turno_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_turno_evento ( dt_evento_p timestamp, cd_estabelecimento_p bigint, ie_opcao_p text, ie_opcao_local_p text) FROM PUBLIC;
