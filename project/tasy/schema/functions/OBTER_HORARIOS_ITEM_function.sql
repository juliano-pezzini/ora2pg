-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE campos AS (nr_prescricao 	double precision);
CREATE TYPE Datas AS (	ds_horario 	varchar(15),
			dt_horario	timestamp);


CREATE OR REPLACE FUNCTION obter_horarios_item ( cd_item_p bigint, nr_prescricao_p text, nr_seq_horario_p bigint) RETURNS varchar AS $body$
DECLARE


ds_horario_w		varchar(15);
ds_resultado_w		varchar(2000);
nr_prescricoes_w	varchar(2000);
nr_prescricao_w		bigint;
nr_seq_material_w	bigint;
i			bigint;
qt_registro_w		bigint;
dt_horario_w		timestamp;
type Vetor is table of campos index 	by integer;
Vetor_w			Vetor;
type Vetor_data is table of Datas index 	by integer;
Vetor_data_w			Vetor_data;

C01 CURSOR FOR
SELECT	to_char(b.dt_horario,'hh24:mi'),
	b.dt_horario
from	prescr_mat_hor b
where	b.nr_prescricao		= nr_prescricao_w
and	b.cd_material		= cd_item_p
and	b.nr_seq_material	= nr_seq_material_w
and	coalesce(b.dt_suspensao::text, '') = ''
and	Obter_se_horario_liberado(b.dt_lib_horario, b.dt_horario) = 'S'
group by b.dt_horario
order by b.dt_horario;


	procedure adiciona_horario(	dt_horario_p	timestamp,
					ds_horarios_p	text) is

	;
BEGIN
	qt_registro_w	:= 0;
	for k in 1..vetor_data_w.count loop
		begin
		if (dt_horario_p	= vetor_data_w[k].dt_horario) then
			qt_registro_w	:= 1;
			exit;
		end if;
		end;
	end loop;

	if (qt_registro_w	= 0) then
		vetor_data_w[vetor_data_w.Count + 1].dt_horario	:= dt_horario_p;
		vetor_data_w[vetor_data_w.Count + 1].ds_horario	:= ds_horarios_p;
	end if;

	end;

	procedure Ordenar_Vetor is
	dt_aux_w	date;
	ds_aux_w	varchar2(255);
	qtd		number(10);
	j		number(10);
	k		number(10);
	begin

	qtd	:= vetor_w.count;
	k	:= qtd -1;

	for i in 1..qtd loop
		begin
		for j in 1..k loop
			begin
			if (vetor_data_w[j].dt_horario	> vetor_data_w[j+1].dt_horario) then
				dt_aux_w	:= Vetor_data_w[j].dt_horario;
				ds_aux_w	:= Vetor_data_w[j].ds_horario;
				Vetor_data_w[j].dt_horario	:= Vetor_data_w[j+1].dt_horario;
				Vetor_data_w[j].ds_horario	:= Vetor_data_w[j+1].ds_horario;

				Vetor_data_w[j+1].dt_horario	:= dt_aux_w;
				Vetor_data_w[j+1].ds_horario	:= ds_aux_w;
			end if;

			end;
		end loop;
		k := k-1;
		end;
	end loop;

	end;

begin

nr_prescricoes_w	:= nr_prescricao_p;
i := 0;
while(length(nr_prescricoes_w) > 0) loop
	begin
	i	:= i+1;
	if (position(',' in nr_prescricoes_w)	>0)  then
		Vetor_w[i].nr_prescricao	:= somente_numero(substr(nr_prescricoes_w,1,position(',' in nr_prescricoes_w) ));
		nr_prescricoes_w		:= substr(nr_prescricoes_w,position(',' in nr_prescricoes_w)+1,40000);

	else
		Vetor_w[i].nr_prescricao	:= somente_numero(nr_prescricoes_w);
		nr_prescricoes_w	:= null;
	end if;

	end;
end loop;

for i in 1..vetor_w.count loop
	begin
	nr_prescricao_w	:= vetor_w[i].nr_prescricao;

	if (coalesce(nr_seq_horario_p,0) > 0) then
		select	max(x.nr_seq_material)
		into STRICT	nr_seq_material_w
		from	prescr_mat_hor x
		where	x.nr_prescricao	= nr_prescricao_w
		and	x.cd_material	= cd_item_p
		and	x.nr_sequencia	= nr_seq_horario_p
		and	coalesce(x.dt_suspensao::text, '') = '';
	else
		select	max(x.nr_seq_material)
		into STRICT	nr_seq_material_w
		from	prescr_mat_hor x
		where	x.nr_prescricao	= nr_prescricao_w
		and	x.cd_material	= cd_item_p
		and	coalesce(x.dt_suspensao::text, '') = '';
	end if;

	open c01;
	loop
	fetch c01 into
		ds_horario_w,
		dt_horario_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		adiciona_horario(dt_horario_w,ds_horario_w);
		end;
	end loop;
	close c01;
	end;
end loop;


Ordenar_Vetor;
ds_resultado_w	:= null;
for i in 1..Vetor_data_w.Count loop
	begin
	ds_resultado_w	:= ds_resultado_w ||' '|| Vetor_data_w[i].ds_horario;
	end;
end loop;

return replace(substr(ds_resultado_w,2,2000),'  ', ' ');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_horarios_item ( cd_item_p bigint, nr_prescricao_p text, nr_seq_horario_p bigint) FROM PUBLIC;

