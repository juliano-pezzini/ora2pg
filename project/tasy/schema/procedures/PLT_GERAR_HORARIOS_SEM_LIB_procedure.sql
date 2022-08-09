-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE plt_gerar_horarios_sem_lib ( nr_prescricao_p bigint, ie_modificar_p text, nm_usuario_p text, cd_perfil_p bigint default null) AS $body$
DECLARE


nr_sequencia_w		numeric(20);
qt_dieta_w		numeric(20);

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	prescr_material
	where	nr_prescricao = nr_prescricao_p;

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	prescr_procedimento
	where	nr_prescricao = nr_prescricao_p;

C03 CURSOR FOR
	SELECT	nr_sequencia
	from	prescr_dieta
	where	nr_prescricao = nr_prescricao_p;

C04 CURSOR FOR
	SELECT	nr_sequencia
	from	prescr_recomendacao
	where	nr_prescricao = nr_prescricao_p;


BEGIN

SELECT	COUNT(*)
INTO STRICT	qt_dieta_w
FROM	dieta b,
	prescr_dieta a,
	prescr_medica k
WHERE	b.ie_situacao = 'A'
AND	b.ie_tipo_dieta = 'O'
AND	b.cd_dieta = a.cd_dieta
AND	k.nr_prescricao = nr_prescricao_p
AND	k.nr_prescricao	= a.nr_prescricao
AND	coalesce(a.ie_suspenso,'N') <> 'S'
AND	coalesce(k.dt_suspensao::text, '') = '';

open C01;
loop
fetch C01 into
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	CALL Gerar_prescr_mat_sem_dt_lib(nr_prescricao_p,nr_sequencia_w,coalesce(cd_perfil_p, obter_perfil_ativo),'N',nm_usuario_p,null);
	end;
end loop;
close C01;

open C02;
loop
fetch C02 into
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	CALL Gerar_prescr_proc_sem_dt_lib(nr_prescricao_p,nr_sequencia_w,coalesce(cd_perfil_p, obter_perfil_ativo),'N',nm_usuario_p);
	end;
end loop;
close C02;

if (qt_dieta_w > 0) then
	open C03;
	loop
	fetch C03 into
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		CALL Gerar_prescr_dieta_hor_sem_lib(nr_prescricao_p,nr_sequencia_w,coalesce(cd_perfil_p, obter_perfil_ativo),'N','',ie_modificar_p,nm_usuario_p);
		end;
	end loop;
	close C03;
end if;

open C04;
loop
fetch C04 into
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C04 */
	begin
	CALL Gerar_prescr_hor_sem_lib(nr_prescricao_p,nr_sequencia_w,coalesce(cd_perfil_p, obter_perfil_ativo),'N',nm_usuario_p);
	end;
end loop;
close C04;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE plt_gerar_horarios_sem_lib ( nr_prescricao_p bigint, ie_modificar_p text, nm_usuario_p text, cd_perfil_p bigint default null) FROM PUBLIC;
