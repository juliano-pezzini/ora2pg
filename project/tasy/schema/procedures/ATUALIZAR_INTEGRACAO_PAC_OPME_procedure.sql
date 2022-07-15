-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_integracao_pac_opme ( nr_seq_agenda_p agenda_paciente.nr_sequencia%type, cd_material_p material.cd_material%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

update	agenda_pac_opme
set	ie_integracao_util = 'S'
where	nr_seq_agenda = nr_seq_agenda_p
and	cd_material = cd_material_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_integracao_pac_opme ( nr_seq_agenda_p agenda_paciente.nr_sequencia%type, cd_material_p material.cd_material%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

