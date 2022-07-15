-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_agenda_acolhimento ( cd_agenda_p bigint, dt_agenda_p timestamp, nr_seq_escuta_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_retorno_w	varchar(255);
ie_gerado_w		varchar(255) := 'N';


BEGIN

if (cd_agenda_p IS NOT NULL AND cd_agenda_p::text <> '' AND dt_agenda_p IS NOT NULL AND dt_agenda_p::text <> '') then


	Select 	coalesce(max('S'),'N')
	into STRICT	ie_gerado_w
	from	agenda_consulta
	where	cd_agenda = cd_agenda_p
	and		trunc(dt_agenda) = trunc(dt_agenda_p);

	ie_gerado_w:= 'S'; -- Está executando no objeto gerar_agenda_mensal_triagem
	if ( ie_gerado_w = 'N') then

		ds_retorno_w := horario_livre_consulta(
			wheb_usuario_pck.get_cd_estabelecimento, cd_agenda_p, 'N', dt_agenda_p, nm_usuario_p, 'S', 'N', 'N', 0, ds_retorno_w);

	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_agenda_acolhimento ( cd_agenda_p bigint, dt_agenda_p timestamp, nr_seq_escuta_p bigint, nm_usuario_p text) FROM PUBLIC;

