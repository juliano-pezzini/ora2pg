-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gedipa_gerar_w_preparo ( cd_material_p bigint, nr_seq_ficha_tecnica_p bigint, nr_seq_area_prep_p bigint, nr_seq_gedi_etapa_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_deleta_p text, nr_seq_etapa_hor_p bigint, nr_prescricao_p bigint default null) AS $body$
DECLARE


nr_sequencia_w 			bigint;
nr_seq_gedipa_cabine_w 		bigint;
cd_material_w 			bigint;
nr_seq_lote_fornec_w 		bigint;
cd_unidade_medida_w 		varchar(30);
qt_dose_w			double precision;
cd_unidade_medida_dose_w	varchar(30);
qt_dose_util_w              	double precision;
ie_setar_qt_util_w 		varchar(1);
somente_mat_prep_w	varchar(1);
motivo_baixa_apresenta_mat_w varchar(2000);
cd_motivo_baixa_param_91_w varchar(255);

c01 CURSOR FOR
SELECT 	a.nr_sequencia,
		a.cd_material,
		a.nr_seq_lote_fornec,
		b.cd_unidade_medida_consumo
FROM 	gedipa_estoque_cabine a,
		material b
WHERE 	a.cd_material = b.cd_material
AND 	((a.cd_material = cd_material_p) OR (b.nr_seq_ficha_tecnica = nr_seq_ficha_tecnica_p))
AND 	a.nr_seq_area_prep = nr_seq_area_prep_p
AND		a.qt_estoque > 0;

C02 CURSOR FOR
SELECT 	a.nr_sequencia,
		a.cd_material,
		a.nr_seq_lote_fornec,
		b.cd_unidade_medida_consumo,
		( 	SELECT 	coalesce(sum(y.qt_dose),0) qt_dose
			from  	prescr_material y
			where 	y.cd_material 	= a.cd_material
			and   	y.nr_prescricao = nr_prescricao_p  ) qt_dose
FROM 	gedipa_estoque_cabine a,
		material b
WHERE 	a.cd_material = b.cd_material
AND 	a.nr_seq_area_prep = nr_seq_area_prep_p
AND		a.qt_estoque > 0
AND 	b.ie_tipo_material	=	1;

C03 CURSOR FOR
SELECT 	a.nr_sequencia,
		a.cd_material,
		a.nr_seq_lote_fornec,
		b.cd_unidade_medida_consumo,		
		d.cd_motivo_baixa,
		c.qt_dose qt_dose
FROM 	gedipa_estoque_cabine a,
		material b,			
		prescr_material c,
		prescr_mat_hor d,
		gedipa_etapa_hor e
WHERE 	a.cd_material 		= b.cd_material
AND   	b.cd_material 		= c.cd_material
AND 	b.cd_material 		= d.cd_material
AND 	c.nr_sequencia 		= d.nr_seq_material
AND 	d.nr_prescricao 	= c.nr_prescricao
AND 	d.nr_sequencia 		= e.nr_seq_horario
AND 	a.nr_seq_area_prep 	= nr_seq_area_prep_p
AND		c.nr_prescricao 	= nr_prescricao_p
AND 	d.dt_horario 		= (select 	max(x.dt_horario)
								from 	prescr_mat_hor x,
										gedipa_etapa_hor z
								where 	x.nr_sequencia = z.nr_seq_horario
								and 	x.nr_prescricao = c.nr_prescricao
								and 	z.nr_sequencia = nr_seq_etapa_hor_p)
AND 	d.nr_seq_superior 	= (select 	max(z.nr_sequencia)
								from 	prescr_mat_hor x,
										prescr_material z,
										gedipa_etapa_hor y
								where 	x.nr_prescricao = z.nr_prescricao
								and		x.nr_seq_material = z.nr_sequencia
								and 	x.nr_sequencia = y.nr_seq_horario
								and 	z.nr_prescricao = nr_prescricao_p
								and 	y.nr_sequencia = nr_seq_etapa_hor_p)
AND		a.qt_estoque > 0
AND 	b.ie_tipo_material	= 1;
BEGIN

somente_mat_prep_w := obter_param_usuario_logado(3112, 90);
motivo_baixa_apresenta_mat_w := obter_param_usuario_logado(3112, 91);

ie_setar_qt_util_w := 'S';

SELECT	MAX(qt_dose),
		MAX(cd_unidade_medida_dose)
INTO STRICT	qt_dose_w,
		cd_unidade_medida_dose_w
FROM	gedipa_etapa_hor
WHERE	nr_sequencia = nr_seq_gedi_etapa_p;

IF (ie_deleta_p = 'S') THEN
	DELETE 	FROM w_gedipa_preparo
	WHERE 	nm_usuario = nm_usuario_p
	AND		coalesce(ie_tipo_material,'M')	=	'M';
	COMMIT;
END IF;

DELETE 	FROM w_gedipa_preparo
WHERE 	nm_usuario = nm_usuario_p
AND		coalesce(ie_tipo_material,'M')	=	'A';


OPEN C01;
LOOP
FETCH C01 INTO
	nr_seq_gedipa_cabine_w,
	cd_material_w,
	nr_seq_lote_fornec_w,
	cd_unidade_medida_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	BEGIN

    delete  FROM w_gedipa_preparo a
    where   a.nr_seq_gedipa_cabine = nr_seq_gedipa_cabine_w
    and     a.nr_seq_etapa_hor = nr_seq_etapa_hor_p
    and     a.cd_material = cd_material_w
    and     coalesce(a.nr_seq_lote_fornec, 0) = coalesce(nr_seq_lote_fornec_w, 0);

	SELECT 	nextval('w_gedipa_preparo_seq')
	INTO STRICT	nr_sequencia_w
	;

	qt_dose_util_w := 0;
	IF (ie_setar_qt_util_w = 'S') THEN
		qt_dose_util_w := Obter_dose_convertida_quimio(cd_material_w, qt_dose_w, cd_unidade_medida_dose_w, cd_unidade_medida_w);
		IF (coalesce(qt_dose_util_w,0) > 0) THEN
			ie_setar_qt_util_w := 'N';
		END IF;
	END IF;

	INSERT 	INTO w_gedipa_preparo(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_gedipa_cabine,
			cd_material,
			nr_seq_lote_fornec,
			qt_dose_util,
			cd_unidade_medida,
			ie_tipo_material,
			nr_seq_etapa_hor)
		VALUES (nr_sequencia_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_gedipa_cabine_w,
			cd_material_w,
			nr_seq_lote_fornec_w,
			qt_dose_util_w,
			cd_unidade_medida_w,
			'M',
			nr_seq_etapa_hor_p);

	END;
END LOOP;
CLOSE C01;

ie_setar_qt_util_w := 'S';

if (somente_mat_prep_w = 'N') then

	for c02_w in c02
	loop
        delete  FROM w_gedipa_preparo a
        where   a.nr_seq_gedipa_cabine = c02_w.nr_sequencia
        and     a.nr_seq_etapa_hor = nr_seq_etapa_hor_p
        and     a.cd_material = c02_w.cd_material
        and     coalesce(a.nr_seq_lote_fornec, 0) = coalesce(c02_w.nr_seq_lote_fornec, 0);

		INSERT 	INTO w_gedipa_preparo(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_gedipa_cabine,
				cd_material,
				nr_seq_lote_fornec,
				qt_dose_util,
				cd_unidade_medida,
				ie_tipo_material,
				nr_seq_etapa_hor)
			VALUES (nextval('w_gedipa_preparo_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				c02_w.nr_sequencia,
				c02_w.cd_material,
				c02_w.nr_seq_lote_fornec,
				c02_w.qt_dose,
				c02_w.cd_unidade_medida_consumo,
				'A',
				nr_seq_etapa_hor_p)
			returning nr_sequencia into nr_sequencia_w;
	end loop;

else

	select max(x.cd_registro)
	into STRICT cd_motivo_baixa_param_91_w
	from table(lista_pck.obter_lista_char(obter_param_usuario_logado(3112, 91))) x;
	
	for c03_w in c03
	loop
		if (coalesce(motivo_baixa_apresenta_mat_w::text, '') = '' or
				(cd_motivo_baixa_param_91_w IS NOT NULL AND cd_motivo_baixa_param_91_w::text <> '') and
				c03_w.cd_motivo_baixa not in (cd_motivo_baixa_param_91_w)) then
            delete  FROM w_gedipa_preparo a
            where   a.nr_seq_gedipa_cabine = c03_w.nr_sequencia
            and     a.nr_seq_etapa_hor = nr_seq_etapa_hor_p
            and     a.cd_material = c03_w.cd_material
            and     coalesce(a.nr_seq_lote_fornec, 0) = coalesce(c03_w.nr_seq_lote_fornec, 0);

			insert 	into w_gedipa_preparo(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_gedipa_cabine,
					cd_material,
					nr_seq_lote_fornec,
					qt_dose_util,
					cd_unidade_medida,
					ie_tipo_material,
					nr_seq_etapa_hor,
					cd_motivo_baixa)
				values (nextval('w_gedipa_preparo_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					c03_w.nr_sequencia,
					c03_w.cd_material,
					c03_w.nr_seq_lote_fornec,
					c03_w.qt_dose,
					c03_w.cd_unidade_medida_consumo,
					'A',
					nr_seq_etapa_hor_p,
					c03_w.cd_motivo_baixa)
				returning nr_sequencia into nr_sequencia_w;
		end if;
	end loop;
	
end if;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gedipa_gerar_w_preparo ( cd_material_p bigint, nr_seq_ficha_tecnica_p bigint, nr_seq_area_prep_p bigint, nr_seq_gedi_etapa_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_deleta_p text, nr_seq_etapa_hor_p bigint, nr_prescricao_p bigint default null) FROM PUBLIC;
