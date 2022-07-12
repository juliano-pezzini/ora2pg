-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exige_justificatica (nr_interno_conta_p bigint) RETURNS varchar AS $body$
DECLARE

ie_exige_w 	varchar(15) := 'N';
nr_Seq_etapa_W	bigint;
nr_sequencia_w	bigint;
qt_hora_etapa_w integer;
qt_horas_w	double precision;

BEGIN
select	(obter_ultima_etapa(nr_interno_conta_p, 'ET'))::numeric
into STRICT	nr_Seq_etapa_W
;

select	(obter_ultima_etapa(nr_interno_conta_p, 'N'))::numeric
into STRICT	nr_sequencia_w
;

if (coalesce(nr_Seq_etapa_W,0) <> 0) then
	begin
	select	coalesce(obter_hora_entre_datas(DT_ETAPA, coalesce(DT_FIM_ETAPA,clock_timestamp())),0)
	into STRICT	qt_horas_w
	from	conta_paciente_etapa
	where	nr_interno_conta = nr_interno_conta_p
	and	nr_seq_etapa = nr_seq_etapa_W
	and	nr_sequencia = nr_sequencia_w;

	select	coalesce(QT_HORAS,0)
	into STRICT	qt_hora_etapa_w
	from	fatur_etapa
	where	nr_sequencia = nr_seq_etapa_W;
	end;
end if;

if (qt_horas_w > qt_hora_etapa_w) then
	begin
	ie_exige_w := 'S';
	end;
end if;


return	ie_exige_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exige_justificatica (nr_interno_conta_p bigint) FROM PUBLIC;

