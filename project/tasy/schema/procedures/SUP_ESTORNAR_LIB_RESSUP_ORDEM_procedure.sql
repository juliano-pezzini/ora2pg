-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_estornar_lib_ressup_ordem ( nr_requisicao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_existe_w	bigint;


BEGIN

update	requisicao_material
set	dt_liberacao  = NULL
where	nr_requisicao = nr_requisicao_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_estornar_lib_ressup_ordem ( nr_requisicao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

