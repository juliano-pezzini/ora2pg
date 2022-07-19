-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_cad_material ( cd_material_p material.cd_material%type, cd_material_ops_p pls_material.cd_material_ops%type, nr_seq_material_p pls_material.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


qt_registro_w		integer;


BEGIN
select	count(*)
into STRICT	qt_registro_w
from	pls_material
where	cd_material_ops = cd_material_ops_p
and	ie_situacao = 'A'
and	coalesce(dt_exclusao::text, '') = ''
and	nr_sequencia <> nr_seq_material_p;

if (qt_registro_w > 0) then			-- Se ter ativo e não houver a data de exclusão para o CD_MATERIAL, não deixar salvar
	CALL wheb_mensagem_pck.exibir_mensagem_abort(113457);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_cad_material ( cd_material_p material.cd_material%type, cd_material_ops_p pls_material.cd_material_ops%type, nr_seq_material_p pls_material.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

