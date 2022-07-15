-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_ajuste_dispensacao ( nr_cirurgia_p bigint, cd_perfil_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_material_w		integer;
cd_material_estoque_w	integer;
cd_unidade_medida_w	varchar(30);
qt_dispensacao_w	double precision;
nr_prescricao_w		bigint;
cd_estabelecimento_w	smallint;
ie_gerar_espec_w	varchar(15);
qt_dispensacao_ww	double precision;
ie_ajusta_disp_w	varchar(15);

C01 CURSOR FOR
	SELECT	a.cd_material,
		a.cd_unidade_medida,
		SUM(qt_dispensacao),
		c.cd_material_estoque
	FROM    material c,
		cirurgia_agente_disp a,
		cirurgia b
	WHERE	a.nr_cirurgia   = b.nr_cirurgia
	AND     a.cd_material   = c.cd_material
	AND	a.nr_cirurgia	= nr_cirurgia_p
	AND	a.ie_operacao	= 'D'
	AND 	coalesce(ie_sem_disp,'N') <> 'S'
	AND (c.ie_consignado <> 1)	--OS 182736 - Alterado para o parâmetro 24 somente trazer materiais que não são consignados, caso for consignado, o cliente deve veirifcar o parâmetro 142.
	AND (ie_ajusta_disp_w <> 'R')
	GROUP BY a.cd_material, a.cd_unidade_medida, c.cd_material_estoque
	
UNION

	SELECT	a.cd_material,
		a.cd_unidade_medida,
		SUM(qt_dispensacao),
		c.cd_material_estoque
	FROM    material c,
		cirurgia_agente_disp a,
		cirurgia b
	WHERE	a.nr_cirurgia   = b.nr_cirurgia
	AND     a.cd_material   = c.cd_material
	AND	a.nr_cirurgia	= nr_cirurgia_p
	AND	a.ie_operacao	= 'D'
	AND coalesce(ie_sem_disp,'N') <> 'S'
	AND (c.ie_consignado = 1)
	AND (c.ie_tipo_material IN (2,3,6))
	AND (ie_gerar_espec_w = 'SM')
	AND (ie_ajusta_disp_w <> 'R')
	GROUP BY a.cd_material, a.cd_unidade_medida, c.cd_material_estoque
	
UNION

	SELECT	a.cd_material,
		a.cd_unidade_medida,
		SUM(qt_dispensacao),
		c.cd_material_estoque
	FROM    material c,
		cirurgia_agente_disp a,
		cirurgia b
	WHERE	a.nr_cirurgia   = b.nr_cirurgia
	AND     a.cd_material   = c.cd_material
	AND	a.nr_cirurgia	= nr_cirurgia_p
	AND	a.ie_operacao	= 'D'
	AND 	coalesce(ie_sem_disp,'N') <> 'S'
	AND (ie_ajusta_disp_w = 'R')
	AND (obter_regra_disp_pepo(1,a.cd_material) = 'S')
	GROUP BY a.cd_material, a.cd_unidade_medida, c.cd_material_estoque;


C02 CURSOR FOR
	SELECT	x.cd_material,
		x.cd_unidade_medida,
		SUM(x.qt_material),
		y.cd_material_estoque
	FROM    material y,
		prescr_material x
	WHERE	y.cd_material           = x.cd_material
	AND	x.nr_prescricao		= nr_prescricao_w
	GROUP BY x.cd_material, x.cd_unidade_medida, y.cd_material_estoque;

C03 CURSOR FOR
	SELECT	a.cd_material,
		a.cd_unidade_medida,
		SUM(qt_dispensacao),
		c.cd_material_estoque
	FROM    material c,
		cirurgia_agente_disp a,
		cirurgia b
	WHERE	a.nr_cirurgia   = b.nr_cirurgia
	AND     a.cd_material   = c.cd_material
	AND	a.nr_cirurgia	= nr_cirurgia_p
	AND	a.ie_operacao	= 'P'
	AND 	coalesce(ie_sem_disp,'N') <> 'S'
	AND (c.ie_consignado <> 1)
	AND (ie_ajusta_disp_w <> 'R')
	GROUP BY a.cd_material, a.cd_unidade_medida, c.cd_material_estoque
	
UNION

	SELECT	a.cd_material,
		a.cd_unidade_medida,
		SUM(qt_dispensacao),
		c.cd_material_estoque
	FROM    material c,
		cirurgia_agente_disp a,
		cirurgia b
	WHERE	a.nr_cirurgia   = b.nr_cirurgia
	AND     a.cd_material   = c.cd_material
	AND	a.nr_cirurgia	= nr_cirurgia_p
	AND	a.ie_operacao	= 'P'
	AND (ie_ajusta_disp_w = 'R')
	AND (obter_regra_disp_pepo(1,a.cd_material) = 'S')
	GROUP BY a.cd_material, a.cd_unidade_medida, c.cd_material_estoque;



BEGIN

SELECT	nr_prescricao,
	cd_estabelecimento
INTO STRICT	nr_prescricao_w,
	cd_estabelecimento_w
FROM	cirurgia
WHERE	nr_cirurgia = nr_cirurgia_p;

ie_gerar_espec_w := obter_param_usuario(872, 142, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_gerar_espec_w);
ie_ajusta_disp_w := obter_param_usuario(872, 24, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_ajusta_disp_w);

DELETE	FROM ajuste_dispensacao_pepo
WHERE	nr_cirurgia = nr_cirurgia_p;

SELECT	nr_prescricao
INTO STRICT	nr_prescricao_w
FROM	cirurgia
WHERE	nr_cirurgia = nr_cirurgia_p;

OPEN C01;
LOOP
FETCH C01 INTO
	cd_material_w,
	cd_unidade_medida_w,
	qt_dispensacao_w,
	cd_material_estoque_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	BEGIN

	INSERT INTO ajuste_dispensacao_pepo(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_cirurgia,
		cd_material,
		cd_material_estoque,
		qt_dispensacao,
		cd_unidade_medida)
	VALUES (
		nextval('ajuste_dispensacao_pepo_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_cirurgia_p,
		cd_material_w,
		cd_material_estoque_w,
		qt_dispensacao_w,
		cd_unidade_medida_w);
	COMMIT;



	END;
END LOOP;
CLOSE C01;

OPEN C02;
LOOP
FETCH C02 INTO
	cd_material_w,
	cd_unidade_medida_w,
	qt_dispensacao_w,
	cd_material_estoque_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	BEGIN

	UPDATE	ajuste_dispensacao_pepo
	SET	qt_dispensacao		=	qt_dispensacao - qt_dispensacao_w
	WHERE	nr_cirurgia		=	nr_cirurgia_p
	AND	cd_material_estoque	=	cd_material_estoque_w
	AND	cd_unidade_medida	=	cd_unidade_medida_w;
	COMMIT;

	END;
END LOOP;
CLOSE C02;

	OPEN C03;
	LOOP
	FETCH C03 INTO
		cd_material_w,
		cd_unidade_medida_w,
		qt_dispensacao_ww,
		cd_material_estoque_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		BEGIN

		UPDATE	ajuste_dispensacao_pepo
		SET	qt_dispensacao		=	qt_dispensacao - qt_dispensacao_ww
		WHERE	nr_cirurgia		=	nr_cirurgia_p
		AND	cd_material_estoque	=	cd_material_estoque_w
		AND	cd_unidade_medida	=	cd_unidade_medida_w;
		COMMIT;

			END;
	END LOOP;
	CLOSE C03;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_ajuste_dispensacao ( nr_cirurgia_p bigint, cd_perfil_p bigint, nm_usuario_p text) FROM PUBLIC;

