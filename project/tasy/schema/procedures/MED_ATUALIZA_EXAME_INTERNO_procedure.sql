-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_atualiza_exame_interno (nr_seq_cliente_p bigint, dt_exame_p timestamp, nr_seq_exame_p bigint) AS $body$
DECLARE


nr_seq_calcular_w		bigint;
ds_calculo_w			varchar(255);
ds_calculo_ref_w		varchar(255);
cd_medico_w			varchar(10);
nr_pos_inicio_w			integer;
nr_exame_ref_w			varchar(10);
nr_sequencia_ref_w		bigint;
vl_exame_ref_w			double precision;
nm_usuario_w			varchar(15);
ds_comando_w			varchar(500);
ie_calcula_result_w		varchar(01);
ds_restricao_w			varchar(255);
ie_restricao_correta_w		double precision;
vl_minimo_w			double precision;
vl_maximo_w			double precision;
vl_resultado_w			double precision;
qt_decimais_w			integer;
ds_sql_w			varchar(255);
vl_exame_w			double precision;

c01 CURSOR FOR
	SELECT	nr_sequencia,
		ds_calculo,
		ds_rest_calculo
	from	med_exame_padrao
	where	cd_medico	= cd_medico_w
	and	ds_calculo	like '%@' || to_char(nr_seq_exame_p) || '@%';

BEGIN

select	coalesce(max(qt_decimais),0)
into STRICT		qt_decimais_w
from		med_exame_padrao
where		nr_sequencia	= nr_seq_exame_p;

select	max(cd_medico)
into STRICT	cd_medico_w
from	med_cliente
where	nr_sequencia	= nr_seq_cliente_p;

select	max(nm_usuario)
into STRICT	nm_usuario_w
from	med_result_exame
where	nr_seq_exame	= nr_seq_exame_p
and	dt_exame	= dt_exame_p
and	nr_seq_cliente	= nr_seq_cliente_p;

open	c01;
loop
fetch	c01 into
	nr_seq_calcular_w,
	ds_calculo_w,
	ds_restricao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_sequencia_ref_w
	from	med_result_exame
	where	nr_seq_exame	= nr_seq_calcular_w
	and	nr_seq_cliente	= nr_seq_cliente_p
	and	dt_exame	= dt_exame_p;


	nr_pos_inicio_w		:= 0;
	nr_exame_ref_w		:= '0';
	ds_calculo_ref_w	:= ds_calculo_w;
	ie_calcula_result_w	:= 'S';

	for 	i in 1..length(ds_calculo_w) loop
		begin
		if (substr(ds_calculo_w,i,1) = '@') then
			begin
			if (nr_pos_inicio_w = 0) then
				nr_pos_inicio_w := i + 1;
			else
				begin
				nr_exame_ref_w := substr(ds_calculo_w, nr_pos_inicio_w, i - nr_pos_inicio_w);
				if (nr_exame_ref_w <> '0') then
					begin

					select	obter_valor_result_exame(
						nr_exame_ref_w,
						dt_exame_p,
						nr_seq_cliente_p)
					into STRICT	vl_exame_ref_w
					;

					if (vl_exame_ref_w IS NOT NULL AND vl_exame_ref_w::text <> '') then
						begin

						if (position('@' || nr_exame_ref_w ||'@' in ds_restricao_w) > 0) then
							begin
							ds_restricao_w :=
								replace(ds_restricao_w, '@' || nr_exame_ref_w ||'@',
									replace(to_char(vl_exame_ref_w),',','.'));
							end;
						end if;

						if (qt_decimais_w = 0) then
							ds_calculo_ref_w	:= 'round(' ||
								replace(ds_calculo_ref_w, '@' || nr_exame_ref_w ||'@',
									replace(to_char(vl_exame_ref_w),',','.')) || ')';
						else
							ds_calculo_ref_w	:=
								replace(ds_calculo_ref_w, '@' || nr_exame_ref_w ||'@',
									replace(to_char(vl_exame_ref_w),',','.'));
						end if;
						end;
					else
						ie_calcula_result_w	:= 'N';
					end if;

					nr_pos_inicio_w	:= 0;
					nr_exame_ref_w	:= '0';
					end;
				end if;
				end;
			end if;
			end;
		end if;
		end;
	end loop;

	ds_comando_w	:= 'select nvl(max(1),0) ie_retorno ' ||
			   'from dual where ' || ds_restricao_w;

	ie_restricao_correta_w := obter_valor_dinamico(ds_comando_w, ie_restricao_correta_w);

	if (nr_sequencia_ref_w <> 0) and (ie_calcula_result_w = 'N') or
		(ie_restricao_correta_w = 0 AND ds_restricao_w IS NOT NULL AND ds_restricao_w::text <> '') then
		CALL Exec_sql_Dinamico(obter_desc_expressao(774228),
			' update med_result_exame ' ||
			' set vl_exame = null ' ||
			' where nr_sequencia 	= ' || nr_sequencia_ref_w);
	end if;

	if (ds_calculo_ref_w <> '0') and (ds_calculo_ref_w IS NOT NULL AND ds_calculo_ref_w::text <> '') and
		((ie_restricao_correta_w = 1) or (coalesce(ds_restricao_w::text, '') = '')) then
		begin

		if (nr_sequencia_ref_w <> 0) then

			ds_sql_w:= 	' update med_result_exame ' ||
					' set vl_exame = ' || '(' || replace(ds_calculo_ref_w,',','.') || '),' ||
					'     ie_calculado = '||chr(39)||'S'||chr(39)||
					' where nr_sequencia 	= ' || nr_sequencia_ref_w;
			CALL Exec_sql_Dinamico(obter_desc_expressao(774228),ds_sql_w);
				SELECT	MAX(vl_exame)
				INTO STRICT 	vl_exame_w
				FROM 	med_result_exame
				WHERE 	NR_SEQUENCIA = nr_sequencia_ref_w;
		else
			begin
			select	nextval('med_result_exame_seq')
			into STRICT	nr_sequencia_ref_w
			;


			ds_comando_w :=
				' insert into med_result_exame (nr_sequencia, nr_seq_exame, ' ||
				' ds_valor_exame, dt_atualizacao, nm_usuario, 				nr_atendimento, ' ||
				' dt_exame, vl_exame, nr_seq_cliente, nr_seq_laborat, ' ||
				' ie_tipo_resultado,ie_calculado) (select  ' || nr_sequencia_ref_w || 				',' ||
				nr_seq_calcular_w || ',null,sysdate,' || chr(39) || 				nm_usuario_w || chr(39) || ',' ||
				'null,' || 'to_date(' || chr(39) || 			to_char(dt_exame_p,'dd/mm/yyyy') || chr(39) || ',' || chr(39) ||
				'dd/mm/yyyy' || chr(39) || ')' || ',' || '(' ||
				replace(ds_calculo_ref_w,',','.') || ')' || ',' ||
				nr_seq_cliente_p || ',null,' || chr(39) || 'N' || chr(39) || ',' || chr(39) || 'S' || chr(39) ||
				' from dual) ';


			CALL Exec_sql_Dinamico(obter_desc_expressao(774228), ds_comando_w);

			--insert into log_tasy 	(dt_atualizacao,
			--			NM_USUARIO,
			--			CD_LOG,
			--			DS_LOG)
			--values			(sysdate,
			--			nm_usuario_w,
			--			302,
			--			ds_comando_w);
			--commit;
			end;
		end if;

		select	max(vl_padrao_minimo),
			max(vl_padrao_maximo)
		into STRICT	vl_minimo_w,
			vl_maximo_w
		from	med_exame_padrao
		where	nr_sequencia	= nr_seq_calcular_w
		and	(vl_padrao_minimo IS NOT NULL AND vl_padrao_minimo::text <> '')
		and	(vl_padrao_maximo IS NOT NULL AND vl_padrao_maximo::text <> '');


		select	max(vl_exame)
		into STRICT	vl_resultado_w
		from	med_result_exame
		where	nr_sequencia	= nr_sequencia_ref_w;


		if (vl_resultado_w < vl_minimo_w) then
			update	med_result_exame
			set	ie_tipo_resultado = 'B'
			where	nr_sequencia	= nr_sequencia_ref_w;
		elsif (vl_resultado_w > vl_maximo_w) then
			update	med_result_exame
			set	ie_tipo_resultado = 'A'
			where	nr_sequencia	= nr_sequencia_ref_w;
		else
			update	med_result_exame
			set	ie_tipo_resultado = 'N'
			where	nr_sequencia	= nr_sequencia_ref_w;
		end if;


		end;
	end if;

	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_atualiza_exame_interno (nr_seq_cliente_p bigint, dt_exame_p timestamp, nr_seq_exame_p bigint) FROM PUBLIC;

