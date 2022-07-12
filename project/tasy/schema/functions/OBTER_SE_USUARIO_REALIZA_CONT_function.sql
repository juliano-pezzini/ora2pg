-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_usuario_realiza_cont ( nr_seq_inventario_p bigint, nr_sequencia_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


qt_existe_1_w		bigint;
qt_existe_2_w		bigint;
qt_existe_3_w		bigint;
qt_existe_4_w		bigint;
qt_existe_total_w		bigint  := 0;
ie_retorno_w		varchar(1) := 'S';

cd_perfil_palm_w		bigint; -- Perfil ativo do usuário no PalmWeb
qt_contagem_usuario_w	bigint; -- Quantidade de contagem que o usuário poderá realizar do item
/*
Está function irá verificar quantas contagens o usuário informado já realizou.
Caso o usuário já tenha realizado o número de contagem informado ( [164] ) , será retornado 'N' pois este usuário não poderá mais
realizar a contagem deste iem.
*/
BEGIN

cd_perfil_palm_w := Obter_Param_Usuario(88, 1, null, nm_usuario_p, cd_estabelecimento_p, cd_perfil_palm_w);
qt_contagem_usuario_w := Obter_Param_Usuario(88, 164, cd_perfil_palm_w, nm_usuario_p, cd_estabelecimento_p, qt_contagem_usuario_w);

select	count(*)
into STRICT	qt_existe_1_w
from    	inventario_material
where   	nr_sequencia = nr_sequencia_p
and	nr_seq_inventario = nr_seq_inventario_p
and     	coalesce(nm_usuario_contagem,'X') = nm_usuario_p;

select  	count(*)
into STRICT	qt_existe_2_w
from    	inventario_material
where   	nr_sequencia = nr_sequencia_p
and	nr_seq_inventario = nr_seq_inventario_p
and     	coalesce(nm_usuario_recontagem,'X') = nm_usuario_p;

select  	count(*)
into STRICT	qt_existe_3_w
from    	inventario_material
where   	nr_sequencia = nr_sequencia_p
and	nr_seq_inventario = nr_seq_inventario_p
and     	coalesce(nm_usuario_seg_recontagem,'X') = nm_usuario_p;

select  	count(*)
into STRICT	qt_existe_4_w
from    	inventario_material
where   	nr_sequencia = nr_sequencia_p
and	nr_seq_inventario = nr_seq_inventario_p
and     	coalesce(nm_usuario_terc_recontagem,'X') = nm_usuario_p;

qt_existe_total_w := (qt_existe_1_w + qt_existe_2_w + qt_existe_3_w + qt_existe_4_w);

if (coalesce(qt_contagem_usuario_w,0) > 0) and (qt_existe_total_w >= qt_contagem_usuario_w) then
	ie_retorno_w := 'N';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_usuario_realiza_cont ( nr_seq_inventario_p bigint, nr_sequencia_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

