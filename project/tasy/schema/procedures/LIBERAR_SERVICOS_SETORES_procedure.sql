-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_servicos_setores ( dt_referencia_p timestamp, nm_usuario_p text) AS $body$
DECLARE

 
nr_sequencia_w		varchar(10);
ie_estabs_w		varchar(1);
cd_estab_w		bigint;
				
C01 CURSOR FOR 
	SELECT	nr_sequencia 
	from	nut_atend_serv_dia 
	where	dt_servico between dt_referencia_p and fim_dia(dt_referencia_p) 
	and	((ie_estabs_w = 'S' and cd_estab_w = (obter_dados_setor(cd_setor_atendimento,'E'))::numeric ) or (ie_estabs_w = 'N')) 
	and	coalesce(dt_liberacao::text, '') = '';
		

BEGIN 
ie_estabs_w := obter_param_usuario(1003, 78, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_estabs_w);
cd_estab_w	:= wheb_usuario_pck.get_cd_estabelecimento;
if (dt_referencia_p IS NOT NULL AND dt_referencia_p::text <> '') then 
 
	open C01;
	loop 
	fetch C01 into	 
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then 
			CALL Liberar_Servico_Nutricao(nr_sequencia_w, nm_usuario_p, 'L');
		end if;
		end;
	end loop;
	close C01;
	 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_servicos_setores ( dt_referencia_p timestamp, nm_usuario_p text) FROM PUBLIC;

