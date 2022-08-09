-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_setor_principal_usuario (nm_usuario_p text, nm_usuario_destino_p text, nm_usuario_origem_p text) AS $body$
DECLARE


cd_setor_atendimento_w	integer;


BEGIN
select	cd_setor_atendimento
into STRICT	cd_setor_atendimento_w
from	usuario
where	nm_usuario = nm_usuario_origem_p;

update	usuario
set	cd_setor_atendimento = cd_setor_atendimento_w,
	nm_usuario_atual = nm_usuario_p
where	nm_usuario = nm_usuario_destino_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_setor_principal_usuario (nm_usuario_p text, nm_usuario_destino_p text, nm_usuario_origem_p text) FROM PUBLIC;
