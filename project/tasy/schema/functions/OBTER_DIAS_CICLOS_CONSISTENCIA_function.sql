-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE campos AS (ds_dias_aplicacao	varchar(255));
CREATE TYPE campos_ciclos AS (ds_ciclos_aplicacao	varchar(255));


CREATE OR REPLACE FUNCTION obter_dias_ciclos_consistencia ( nr_seq_paciente_p bigint, ds_ciclos_p text, ds_dias_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
Dias		D
Ciclos		C
Abortar	A

*/
C01 CURSOR FOR
	SELECT	ds_dias_aplicacao ds,
			ds_ciclos_aplicacao ds_ciclos,
			nr_seq_material cd
	from	PACIENTE_PROTOCOLO_MEDIC
	where   nr_seq_paciente = nr_seq_paciente_p
	and		coalesce(nr_seq_diluicao::text, '') = ''
	and   	coalesce(nr_seq_solucao::text, '') = ''
	and   	coalesce(nr_seq_medic_material::text, '') = ''
	and   	coalesce(nr_seq_procedimento::text, '') = ''
	order by ds desc;

C02 CURSOR FOR
	SELECT	a.ds_dia_ciclo ds,
			'C'||a.nr_ciclo ds_ciclos,
			b.nr_seq_material cd
	from	paciente_atendimento a,
			paciente_atend_medic b
	where   a.nr_seq_atendimento = b.nr_seq_atendimento
	and		a.nr_seq_paciente = nr_seq_paciente_p
	and		coalesce(nr_seq_diluicao::text, '') = ''
	and   	coalesce(nr_seq_solucao::text, '') = ''
	and   	coalesce(nr_seq_medic_material::text, '') = ''
	and   	coalesce(nr_seq_procedimento::text, '') = ''
	and		coalesce(a.nr_prescricao::text, '') = ''
	order by ds desc;


ds_retorno_w			varchar(4000) := '';
ds_texto_w				varchar(4000) := '';
ds_dias_w				varchar(4000);
nr_seq_material_w 		bigint;
qt_reg_dias_w			bigint;
qt_ciclo_gerado_w		bigint;
qt_dia_gerado_w			bigint;
qt_reg_ciclos_gerados_w bigint;

ds_dias_aplicacao_w		varchar(4000);
ds_dias_valido_w		varchar(4000);
k						integer;
x						varchar(1);
y 						integer;
z 						integer;
cont_w					bigint;
posicao_w				smallint;
type vetor is table of campos index by integer;
dias_w					vetor;

qt_reg_ciclos_w			bigint;
qt_reg_w				bigint;
ds_ciclos_w				varchar(4000);
ds_ciclos_aplicacao_w	varchar(4000);
ds_ciclos_valido_w		varchar(4000);
type vetor_ciclos is table of campos_ciclos index by integer;
ciclos_w				vetor_ciclos;


BEGIN

if (nr_seq_paciente_p IS NOT NULL AND nr_seq_paciente_p::text <> '') then

select	count(*)
into STRICT	qt_reg_ciclos_gerados_w
from	paciente_atendimento
where	nr_seq_paciente = nr_seq_paciente_p
and		coalesce(dt_cancelamento::text, '') = ''
and		coalesce(dt_suspensao::text, '') = '';


	if (ie_opcao_p = 'C') then


		ds_ciclos_valido_w := '';

		select	count(*)
		into STRICT	qt_reg_w
		from	paciente_atendimento
		where	nr_seq_paciente = nr_seq_paciente_p
		and		coalesce(nr_prescricao::text, '') = ''
		and		coalesce(dt_cancelamento::text, '') = ''
		and		coalesce(dt_suspensao::text, '') = '';


		if (qt_reg_w > 0) then
			open C02;
			loop
			fetch C02 into
				ds_dias_w,
				ds_ciclos_w,
				nr_seq_material_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin

				ds_ciclos_aplicacao_w	:= ds_ciclos_w;
				z	:= 0;
				ds_ciclos_aplicacao_w	:= ds_ciclos_aplicacao_w ||',';
				cont_w	:= 0;
				ciclos_w.delete;
				while	(ds_ciclos_aplicacao_w IS NOT NULL AND ds_ciclos_aplicacao_w::text <> '') loop
					begin
					posicao_w	:= position(',' in ds_ciclos_aplicacao_w);
					z := z + 1;
					ciclos_w[z].ds_ciclos_aplicacao	:= substr(ds_ciclos_aplicacao_w,1,posicao_w - 1);

					select 	count(*)
					into STRICT	qt_reg_ciclos_w
					from	PACIENTE_PROTOCOLO_MEDIC
					where   nr_seq_paciente = nr_seq_paciente_p
					and		coalesce(nr_seq_diluicao::text, '') = ''
					and   	coalesce(nr_seq_solucao::text, '') = ''
					and   	coalesce(nr_seq_medic_material::text, '') = ''
					and   	coalesce(nr_seq_procedimento::text, '') = ''
					and		nr_seq_material <> nr_seq_material_w
					and		((ds_ciclos_aplicacao IS NOT NULL AND ds_ciclos_aplicacao::text <> '') and (instr((ds_ciclos_aplicacao||','),(ciclos_w[z].ds_ciclos_aplicacao||',')) = 0));

					if (qt_reg_ciclos_w = 0) and
						(instr((ds_ciclos_valido_w||','),(ciclos_w[z].ds_ciclos_aplicacao||',')) = 0) then

						ds_ciclos_valido_w := ds_ciclos_valido_w ||ciclos_w[z].ds_ciclos_aplicacao||',';

					end if;

					ds_ciclos_aplicacao_w		:= substr(ds_ciclos_aplicacao_w,posicao_w + 1,length(ds_ciclos_aplicacao_w));

					cont_w	:= cont_w + 1;
					if (cont_w > 820) then
						exit;
					end if;
					end;
				end loop;

				end;
			end loop;
			close C02;
		else
			open C01;
			loop
			fetch C01 into
				ds_dias_w,
				ds_ciclos_w,
				nr_seq_material_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin
				ds_ciclos_aplicacao_w	:= ds_ciclos_w;
				z	:= 0;
				ds_ciclos_aplicacao_w	:= ds_ciclos_aplicacao_w ||',';
				cont_w	:= 0;
				ciclos_w.delete;
				while	(ds_ciclos_aplicacao_w IS NOT NULL AND ds_ciclos_aplicacao_w::text <> '') loop
					begin
					posicao_w	:= position(',' in ds_ciclos_aplicacao_w);
					z := z + 1;
					ciclos_w[z].ds_ciclos_aplicacao	:= substr(ds_ciclos_aplicacao_w,1,posicao_w - 1);

					select	count(*)
					into STRICT	qt_ciclo_gerado_w
					from	paciente_atendimento
					where	nr_seq_paciente = nr_seq_paciente_p
					and		instr((ciclos_w[z].ds_ciclos_aplicacao||','),(to_char(nr_ciclo)||',')) > 0
					and		(nr_prescricao IS NOT NULL AND nr_prescricao::text <> '')
					and		coalesce(dt_cancelamento::text, '') = ''
					and		coalesce(dt_suspensao::text, '') = '';

					select 	count(*)
					into STRICT	qt_reg_ciclos_w
					from	PACIENTE_PROTOCOLO_MEDIC a
					where   a.nr_seq_paciente = nr_seq_paciente_p
					and		coalesce(a.nr_seq_diluicao::text, '') = ''
					and   	coalesce(a.nr_seq_solucao::text, '') = ''
					and   	coalesce(a.nr_seq_medic_material::text, '') = ''
					and   	coalesce(a.nr_seq_procedimento::text, '') = ''
					and		nr_seq_material <> nr_seq_material_w
					and		((a.ds_ciclos_aplicacao IS NOT NULL AND a.ds_ciclos_aplicacao::text <> '') and (instr((a.ds_ciclos_aplicacao||','),(ciclos_w[z].ds_ciclos_aplicacao||',')) = 0));


					if	((qt_reg_ciclos_w = 0 AND  qt_ciclo_gerado_w = 0) or
						  (qt_reg_ciclos_w > 0 AND qt_reg_ciclos_gerados_w > 0)) and
						(instr((ds_ciclos_valido_w||','),(ciclos_w[z].ds_ciclos_aplicacao||',')) = 0) then

						ds_ciclos_valido_w := ds_ciclos_valido_w ||ciclos_w[z].ds_ciclos_aplicacao||',';

					end if;

					ds_ciclos_aplicacao_w		:= substr(ds_ciclos_aplicacao_w,posicao_w + 1,length(ds_ciclos_aplicacao_w));

					cont_w	:= cont_w + 1;
					if (cont_w > 820) then
						exit;
					end if;
					end;
				end loop;

				end;
			end loop;
			close C01;
		end if;

		ds_ciclos_valido_w := substr(ds_ciclos_valido_w,1,length(ds_ciclos_valido_w) - 1);
		ds_retorno_w := ds_ciclos_valido_w;

	elsif (ie_opcao_p in ('A','D')) then


		ds_dias_valido_w := '';

		select	count(*)
		into STRICT	qt_reg_w
		from	paciente_atendimento
		where	nr_seq_paciente = nr_seq_paciente_p
		and		coalesce(nr_prescricao::text, '') = ''
		and		coalesce(dt_cancelamento::text, '') = ''
		and		coalesce(dt_suspensao::text, '') = '';

		if (qt_reg_w > 0) then
			open C02;
			loop
			fetch C02 into
				ds_dias_w,
				ds_ciclos_w,
				nr_seq_material_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin
				ds_dias_aplicacao_w	:= ds_dias_w;
				z	:= 0;
				ds_dias_aplicacao_w	:= ds_dias_aplicacao_w ||',';
				cont_w	:= 0;
				dias_w.delete;
				while	(ds_dias_aplicacao_w IS NOT NULL AND ds_dias_aplicacao_w::text <> '') loop
					begin
					posicao_w	:= position(',' in ds_dias_aplicacao_w);
					z := z + 1;
					dias_w[z].ds_dias_aplicacao	:= substr(ds_dias_aplicacao_w,1,posicao_w - 1);

					select 	count(*)
					into STRICT	qt_reg_dias_w
					from	PACIENTE_PROTOCOLO_MEDIC
					where   nr_seq_paciente = nr_seq_paciente_p
					and		coalesce(nr_seq_diluicao::text, '') = ''
					and   	coalesce(nr_seq_solucao::text, '') = ''
					and   	coalesce(nr_seq_medic_material::text, '') = ''
					and   	coalesce(nr_seq_procedimento::text, '') = ''
					and		nr_seq_material <> nr_seq_material_w
					and		((coalesce(ds_ciclos_p::text, '') = '') or (instr((ds_ciclos_aplicacao||','),(ds_ciclos_p||',')) > 0))
					and		((coalesce(ds_dias_aplicacao::text, '') = '') or (instr((ds_dias_aplicacao||','),(dias_w[z].ds_dias_aplicacao||',')) = 0));

					if (qt_reg_dias_w = 0) and
						(instr((ds_dias_valido_w||','),(dias_w[z].ds_dias_aplicacao||',')) = 0) then

						ds_dias_valido_w := ds_dias_valido_w ||dias_w[z].ds_dias_aplicacao||',';

					end if;

					ds_dias_aplicacao_w		:= substr(ds_dias_aplicacao_w,posicao_w + 1,length(ds_dias_aplicacao_w));

					cont_w	:= cont_w + 1;
					if (cont_w > 820) then
						exit;
					end if;
					end;
				end loop;

				end;
			end loop;
			close C02;
		else
			open C01;
			loop
			fetch C01 into
				ds_dias_w,
				ds_ciclos_w,
				nr_seq_material_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin
				ds_dias_aplicacao_w	:= ds_dias_w;
				z	:= 0;
				ds_dias_aplicacao_w	:= ds_dias_aplicacao_w ||',';
				cont_w	:= 0;
				dias_w.delete;
				while	(ds_dias_aplicacao_w IS NOT NULL AND ds_dias_aplicacao_w::text <> '') loop
					begin
					posicao_w	:= position(',' in ds_dias_aplicacao_w);
					z := z + 1;
					dias_w[z].ds_dias_aplicacao	:= substr(ds_dias_aplicacao_w,1,posicao_w - 1);

					select 	count(*)
					into STRICT	qt_reg_dias_w
					from	PACIENTE_PROTOCOLO_MEDIC
					where   nr_seq_paciente = nr_seq_paciente_p
					and		coalesce(nr_seq_diluicao::text, '') = ''
					and   	coalesce(nr_seq_solucao::text, '') = ''
					and   	coalesce(nr_seq_medic_material::text, '') = ''
					and   	coalesce(nr_seq_procedimento::text, '') = ''
					and		nr_seq_material <> nr_seq_material_w
					and		((coalesce(ds_ciclos_p::text, '') = '') or (instr((ds_ciclos_aplicacao||','),(ds_ciclos_p||',')) > 0))
					and		((coalesce(ds_dias_aplicacao::text, '') = '') or (instr((ds_dias_aplicacao||','),(dias_w[z].ds_dias_aplicacao||',')) = 0));

					select	count(*)
					into STRICT	qt_dia_gerado_w
					from	paciente_atendimento
					where	nr_seq_paciente = nr_seq_paciente_p
					and		instr((dias_w[z].ds_dias_aplicacao||','),(ds_dia_ciclo||',')) > 0
					and		(instr((ds_ciclos_w||','),(nr_ciclo||',')) = 0)
					and		(nr_prescricao IS NOT NULL AND nr_prescricao::text <> '')
					and		coalesce(dt_cancelamento::text, '') = ''
					and		coalesce(dt_suspensao::text, '') = '';

					if	((qt_reg_dias_w = 0) or
						(( qt_reg_dias_w > 0) and ( qt_dia_gerado_w = 0) and ( qt_reg_ciclos_gerados_w > 0))) and
						(instr((ds_dias_valido_w||','),(dias_w[z].ds_dias_aplicacao||',')) = 0) then

						ds_dias_valido_w := ds_dias_valido_w ||dias_w[z].ds_dias_aplicacao||',';

					end if;

					ds_dias_aplicacao_w		:= substr(ds_dias_aplicacao_w,posicao_w + 1,length(ds_dias_aplicacao_w));

					cont_w	:= cont_w + 1;
					if (cont_w > 820) then
						exit;
					end if;
					end;
				end loop;

				end;
			end loop;
			close C01;
		end if;

		ds_dias_valido_w := substr(ds_dias_valido_w,1,length(ds_dias_valido_w) - 1);

		if (ie_opcao_p = 'D') then

			ds_retorno_w := ds_dias_valido_w;

		else

			if (ds_dias_valido_w <> '') and
				(instr((ds_dias_valido_w||','),(ds_dias_p||',')) = 0) then

				ds_texto_w := substr(obter_texto_tasy(274170, wheb_usuario_pck.get_nr_seq_idioma),1,4000);
				--Os dias selecionados não correspondem ao protocolo/ciclo. As opções são:
				ds_texto_w := ds_texto_w || chr(13)||chr(10)||ds_dias_valido_w;

				ds_retorno_w := substr(ds_texto_w,1,4000);

			else

				ds_retorno_w := '';

			end if;

		end if;

	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION obter_dias_ciclos_consistencia ( nr_seq_paciente_p bigint, ds_ciclos_p text, ds_dias_p text, ie_opcao_p text) FROM PUBLIC;

