-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_mat_autor_quimio (nr_seq_atendimento_p bigint, nr_seq_interno_p bigint) RETURNS bigint AS $body$
DECLARE



nr_seq_autor_w			bigint := 0;
qt_retorno_w			double precision := 0;
nr_ciclo_w			integer := 0;
ds_dia_ciclo_w			varchar(5);
nr_seq_paciente_w		bigint;
cd_material_w			bigint;



BEGIN
select	nr_ciclo,
	ds_dia_ciclo,
	nr_seq_paciente
into STRICT	nr_ciclo_w,
	ds_dia_ciclo_w,
	nr_seq_paciente_w
from	paciente_atendimento
where	nr_seq_atendimento = nr_seq_atendimento_p;

select	cd_material
into STRICT	cd_material_w
from	paciente_atend_medic
where 	nr_seq_interno = nr_seq_interno_p;



begin
select	a.nr_sequencia
into STRICT	nr_seq_autor_w
from	autorizacao_convenio a,
	estagio_autorizacao b
where	a.nr_seq_paciente = nr_seq_atendimento_p
and	b.nr_sequencia	 = a.nr_seq_estagio
and	b.ie_interno = '10';
exception
when others then
	nr_seq_autor_w := 0;
end;

if (coalesce(nr_seq_autor_w,0) = 0) then
	begin
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_autor_W
	from	autorizacao_convenio a,
		estagio_autorizacao b
	where	a.nr_seq_paciente_setor = nr_seq_paciente_w
	and	a.nr_ciclo	= nr_ciclo_w
	and	a.nr_seq_estagio = b.nr_sequencia
	and	b.ie_interno = '10';
	end;
end if;

if (nr_seq_autor_w > 0) then
	begin
	select	sum(qt_autorizada)
	into STRICT	qt_retorno_w
	from	material_autorizado
	where	nr_sequencia_autor = nr_seq_autor_w
	and	cd_material	= cd_material_w;
	end;
end if;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_mat_autor_quimio (nr_seq_atendimento_p bigint, nr_seq_interno_p bigint) FROM PUBLIC;

