-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_estorno_lib_dev ( nr_devolucao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
 
ie_estornar_liberacao_receb_w	varchar(1);
ie_estorno_lib_usuario_w		varchar(1);
qt_existe_w			integer;

 

BEGIN 
ie_estornar_liberacao_receb_w	:= obter_valor_param_usuario(42, 2, Obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p);
ie_estorno_lib_usuario_w		:= obter_valor_param_usuario(42, 60, Obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p);
 
 
if (ie_estornar_liberacao_receb_w = 'N') then 
	begin 
	select	count(*) 
	into STRICT	qt_existe_w 
	from	item_devolucao_material_pac a 
	where	nr_devolucao	= nr_devolucao_p 
	and	(dt_recebimento IS NOT NULL AND dt_recebimento::text <> '');
 
	if (qt_existe_w > 0) then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(265952);
		--'Existem materiais já recebidos, impossível estornar.' 
		--'Verifique parâmetro[2]' 
	end if;
	end;
end if;
 
 
if (ie_estorno_lib_usuario_w = 'S') then 
	begin 
	select	count(*) 
	into STRICT	qt_existe_w 
	from	devolucao_material_pac 
	where	nr_devolucao	= nr_devolucao_p 
	and	cd_pessoa_fisica_devol <> obter_pessoa_fisica_usuario(nm_usuario_p, 'C');
 
	if (qt_existe_w > 0) then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(265953);
		--'Somente o usuário responsável desta devolução pode estornar a liberação.' 
		--'Verifique parâmetro[60]' 
	end if;
	end;
end if;
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_estorno_lib_dev ( nr_devolucao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
