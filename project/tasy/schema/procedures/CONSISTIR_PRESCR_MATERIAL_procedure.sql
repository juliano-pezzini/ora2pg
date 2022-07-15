-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_prescr_material (nr_prescricao_p bigint, nr_seq_prescricao_p bigint, nm_usuario_p text, cd_perfil_p bigint, ds_erro_p INOUT bigint) AS $body$
DECLARE


cd_estabelecimento_w		smallint;
ds_erro_w			varchar(2000);
ds_proced_glosa_w		varchar(2000);
cd_perfil_aviso_w		varchar(2000);
nm_usuario_aviso_w		varchar(2000);

/*	Erros
	0   - Não tem erro
	124 - Tem erro mas permite liberar a prescrição
	125 - Tem erro e não permite liberar a prescrição

	As consistências 125 devem fical no final da procedure;
*/
BEGIN

SELECT	max(a.cd_estabelecimento)
INTO STRICT	cd_estabelecimento_w
FROM	prescr_medica a
WHERE	a.nr_prescricao	= nr_prescricao_p;

if (coalesce(cd_estabelecimento_w,0) > 0) then

	SELECT * FROM consistir_regra_prescr_mat(nr_prescricao_p, nr_seq_prescricao_p, cd_estabelecimento_w, cd_perfil_p, nm_usuario_p, ds_erro_w, ds_proced_glosa_w, cd_perfil_aviso_w, nm_usuario_aviso_w) INTO STRICT ds_erro_w, ds_proced_glosa_w, cd_perfil_aviso_w, nm_usuario_aviso_w;

	SELECT	MAX(ie_erro)
	INTO STRICT	ds_erro_p
	FROM	prescr_material
	WHERE	nr_prescricao	= nr_prescricao_p
	AND	nr_sequencia	= nr_seq_prescricao_p;

end if;
	
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_prescr_material (nr_prescricao_p bigint, nr_seq_prescricao_p bigint, nm_usuario_p text, cd_perfil_p bigint, ds_erro_p INOUT bigint) FROM PUBLIC;

