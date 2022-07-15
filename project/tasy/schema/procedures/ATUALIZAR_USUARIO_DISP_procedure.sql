-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_usuario_disp (nr_prescricao_p bigint, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '')	then

	update	prescr_material
	set		nm_usuario_disp	=	nm_usuario_p,
			nm_usuario		=	nm_usuario_p,
			dt_atualizacao	=	clock_timestamp()
	where	nr_prescricao 	=	nr_prescricao_p
	and		nr_sequencia	=	nr_sequencia_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_usuario_disp (nr_prescricao_p bigint, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

