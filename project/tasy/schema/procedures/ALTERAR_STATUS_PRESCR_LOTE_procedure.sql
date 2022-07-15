-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_status_prescr_lote ( nr_prescricao_p bigint, nr_sequencia_lote_p bigint, cd_barras_ficha_p text, nm_usuario_p text) AS $body$
DECLARE


nr_prescricao_lote_w	bigint;
nr_prescricao_ficha_w	bigint;
ie_status_atend_w		varchar(10);
ie_novo_status_w		varchar(10);
ds_lista_parametro_w	varchar(255);


BEGIN

select	coalesce(max(ie_status_atend),10)
into STRICT	ie_status_atend_w
from	prescr_procedimento
where	nr_prescricao = nr_prescricao_p;

ds_lista_parametro_w := obter_param_usuario(722, 2, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ds_lista_parametro_w);

SELECT	SUBSTR((ds_lista_parametro_w),(position(ie_status_atend_w in ds_lista_parametro_w)+3),2)
into STRICT	ie_novo_status_w

WHERE	obter_se_contido_char(ie_status_atend_w,ds_lista_parametro_w) =  'S';

IF (ie_novo_status_w IS NOT NULL AND ie_novo_status_w::text <> '') and (ie_novo_status_w <= 30) THEN

	IF (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') THEN

		UPDATE	prescr_procedimento
		SET	ie_status_atend	= ie_novo_status_w,
			nm_usuario	= nm_usuario_p,
			dt_atualizacao	= clock_timestamp()
		WHERE	nr_prescricao	= nr_prescricao_p
		AND	ie_status_atend	< ie_novo_status_w;

	ELSIF (nr_sequencia_lote_p IS NOT NULL AND nr_sequencia_lote_p::text <> '') THEN

		SELECT 	MAX(b.nr_prescricao)
		INTO STRICT	nr_prescricao_lote_w
		FROM	lote_ent_secretaria a,
			prescr_medica b
		WHERE	a.nr_sequencia = b.nr_seq_lote_entrada
		AND	a.nr_sequencia = nr_sequencia_lote_p;

		IF (nr_prescricao_lote_w IS NOT NULL AND nr_prescricao_lote_w::text <> '') THEN

			UPDATE	prescr_procedimento
			SET	ie_status_atend	= ie_novo_status_w,
				nm_usuario	= nm_usuario_p,
				dt_atualizacao	= clock_timestamp()
			WHERE	nr_prescricao = nr_prescricao_lote_w
			AND	ie_status_atend < ie_novo_status_w;

		END IF;

	ELSIF (cd_barras_ficha_p IS NOT NULL AND cd_barras_ficha_p::text <> '') THEN

		SELECT	MAX(nr_prescricao)
		INTO STRICT	nr_prescricao_ficha_w
		FROM	lote_ent_sec_ficha
		WHERE	cd_barras = cd_barras_ficha_p;

		IF (nr_prescricao_ficha_w IS NOT NULL AND nr_prescricao_ficha_w::text <> '') THEN

			UPDATE  prescr_procedimento
			SET	ie_status_atend	= ie_novo_status_w,
				nm_usuario	= nm_usuario_p,
				dt_atualizacao	= clock_timestamp()
			WHERE	nr_prescricao = nr_prescricao_ficha_w
			AND	ie_status_atend < ie_novo_status_w;

		END IF;

	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_status_prescr_lote ( nr_prescricao_p bigint, nr_sequencia_lote_p bigint, cd_barras_ficha_p text, nm_usuario_p text) FROM PUBLIC;

