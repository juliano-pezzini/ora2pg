-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_regra_pacote_proc_adic (nr_seq_secretaria_p bigint, nr_seq_ficha_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_seq_pacote_w		   lote_ent_secretaria.nr_seq_pacote%type;
nr_seq_ficha_w		   lote_ent_sec_ficha.nr_sequencia%type;
nr_seq_exame_lab_w	 exame_laboratorio.nr_seq_exame%type;
cd_material_exame_w	 material_exame_lab.cd_material_exame%type;
ie_tipo_data_w  		 lote_ent_tipo_coleta.ie_tipo_data%type;
qt_unidade_w		     lote_ent_tipo_coleta.qt_unidade%type;
qt_dif_coleta_w		   double precision;
qt_valor_abs_w		   double precision;
ie_precoce_w		     varchar(1);

C01 CURSOR FOR
SELECT	nr_sequencia,
		round((TO_DATE(TO_CHAR(coalesce(dt_coleta_ficha_f,clock_timestamp()),'dd/mm/yyyy')||' '||TO_CHAR(coalesce(hr_coleta_f,clock_timestamp()),'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') - TO_DATE(TO_CHAR(coalesce(dt_nascimento_f,clock_timestamp()),'dd/mm/yyyy')||' '||TO_CHAR(coalesce(hr_nascimento_f,clock_timestamp()),'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'))::numeric, 4)
FROM	lote_ent_sec_ficha
WHERE	nr_seq_lote_sec = nr_seq_secretaria_p
and		nr_sequencia = nr_seq_ficha_p;

C02 CURSOR FOR
	SELECT	substr(obter_cd_material_exame_lab(b.nr_seq_exame_lab),1,20),
			b.nr_seq_exame_lab
	from  	pacote_procedimento a,
			proc_interno b
	where	a.nr_seq_pacote = nr_seq_pacote_w
	and		a.nr_seq_proc_interno = b.nr_sequencia
	and		(b.nr_seq_exame_lab IS NOT NULL AND b.nr_seq_exame_lab::text <> '');


BEGIN
select	max(nr_seq_pacote)
into STRICT	nr_seq_pacote_w
from	lote_ent_secretaria
where	nr_sequencia = nr_seq_secretaria_p;

open c01;
loop
fetch c01 into 	nr_seq_ficha_w,
				qt_dif_coleta_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	open c02;
	loop
	fetch c02 into 	cd_material_exame_w,
					nr_seq_exame_lab_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin

		ie_precoce_w := '';

		select	max(a.qt_unidade),
				max(a.ie_tipo_data)
		into STRICT	qt_unidade_w,
				ie_tipo_data_w
		from	lote_ent_tipo_coleta a
		where	a.nr_seq_exame = nr_seq_exame_lab_w
		and		ie_tipo_coleta = 'P'
		and		coalesce(a.ie_situacao,'A') = 'A';

		if (ie_tipo_data_w IS NOT NULL AND ie_tipo_data_w::text <> '') then

			if (ie_tipo_data_w = 'H') then
				qt_valor_abs_w	:= qt_dif_coleta_w * 24;
			else
				qt_valor_abs_w	:= ROUND(qt_dif_coleta_w);
			end if;

			if (qt_valor_abs_w <= qt_unidade_w) then
				ie_precoce_w	:= 'P';
			end if;
		end if;

		select	max(a.qt_unidade),
				max(a.ie_tipo_data)
		into STRICT	qt_unidade_w,
				ie_tipo_data_w
		from	lote_ent_tipo_coleta a
		where	a.nr_seq_exame = nr_seq_exame_lab_w
		and		ie_tipo_coleta = 'T'
		and		coalesce(a.ie_situacao,'A') = 'A';

		if (ie_tipo_data_w IS NOT NULL AND ie_tipo_data_w::text <> '') then

			if (ie_tipo_data_w = 'H') then
				qt_valor_abs_w	:= qt_dif_coleta_w * 24;
			else
				qt_valor_abs_w	:= ROUND(qt_dif_coleta_w);
			end if;

			if (qt_valor_abs_w >= qt_unidade_w) then
				ie_precoce_w	:= 'T';
			end if;
		end if;

		insert into lote_ent_sec_ficha_exam(	nr_sequencia,
							cd_material_exame,
							dt_atualizacao,
							dt_atualizacao_nrec,
							nm_usuario,
							nm_usuario_nrec,
							nr_seq_exame,
							nr_seq_ficha,
							ie_tipo_coleta)
						values (	nextval('lote_ent_sec_ficha_exam_seq'),
							cd_material_exame_w,
							clock_timestamp(),
							clock_timestamp(),
							nm_usuario_p,
							nm_usuario_p,
							nr_seq_exame_lab_w,
							nr_seq_ficha_w,
							ie_precoce_w);
		end;
	end loop;
	close c02;

	end;

end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_regra_pacote_proc_adic (nr_seq_secretaria_p bigint, nr_seq_ficha_p bigint, nm_usuario_p text) FROM PUBLIC;
