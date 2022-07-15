-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_func_evol_prescricao (nm_usuario_p text, nm_usuario_destino_p text, nm_usuario_origem_p text) AS $body$
DECLARE


ie_tipo_evolucao_w	varchar(3);


BEGIN
select	ie_tipo_evolucao
into STRICT	ie_tipo_evolucao_w
from	usuario
where	nm_usuario = nm_usuario_origem_p;

update	usuario
set	ie_tipo_evolucao = ie_tipo_evolucao_w,
	nm_usuario_atual = nm_usuario_p
where	nm_usuario = nm_usuario_destino_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_func_evol_prescricao (nm_usuario_p text, nm_usuario_destino_p text, nm_usuario_origem_p text) FROM PUBLIC;

