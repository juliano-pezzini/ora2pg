-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_bloqueio_convenio ( cd_convenio_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_processos_w			bigint;
i				integer;
ie_excluir_lanc_manual_w	varchar(1);


BEGIN

ie_excluir_lanc_manual_w := obter_valor_param_usuario(921,32, Obter_Perfil_ativo, nm_usuario_p,cd_estabelecimento_p);

select	coalesce(round(count(*) / 2000),0) + 1
into STRICT		nr_processos_w
from 		convenio_bloqueio
where 	cd_convenio	= cd_convenio_p;

for 	i in 1.. nr_processos_w LOOP
    	begin

	delete 	from 	convenio_bloqueio
	where	cd_convenio = cd_convenio_p
	and 	((ie_excluir_lanc_manual_w = 'S') or ((ie_excluir_lanc_manual_w = 'N') and (coalesce(ie_tipo_registro,'I') <> 'M')))  LIMIT 1999;

	commit;
	end;
end loop;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_bloqueio_convenio ( cd_convenio_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

