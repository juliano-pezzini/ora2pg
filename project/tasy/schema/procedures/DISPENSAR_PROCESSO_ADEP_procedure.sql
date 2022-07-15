-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dispensar_processo_adep ( cd_estabelecimento_p bigint, nr_seq_processo_p bigint, ie_dispensar_p text, cd_perfil_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ie_adep_map_w	varchar(15);
nr_seq_map_w	bigint;


BEGIN 
if (nr_seq_processo_p IS NOT NULL AND nr_seq_processo_p::text <> '') and (ie_dispensar_p IS NOT NULL AND ie_dispensar_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	 
	ie_adep_map_w	:= obter_regra_lanc_conta_adep(cd_estabelecimento_p, cd_perfil_p, nm_usuario_p, 'SP');
 
	if (ie_dispensar_p = 'S') then 
	 
		/* 
		update	adep_processo 
		set	dt_dispensacao		= sysdate, 
			nm_usuario_dispensacao	= nm_usuario_p, 
			nm_usuario		= nm_usuario_p 
		where	nr_sequencia		= nr_seq_processo_p 
		and	dt_dispensacao		is null 
		and	nm_usuario_dispensacao	is null; 
		*/
 
		 
		CALL atualiza_status_processo_adep(nr_seq_processo_p, null, 'A', 'S', clock_timestamp(), nm_usuario_p);
		 
		if (ie_adep_map_w = 'S') then		 
			nr_seq_map_w := gerar_estornar_adep_map(nr_seq_processo_p, null, null, 'G', clock_timestamp(), nm_usuario_p, nr_seq_map_w, null, null, null);
		end if;
		 
	elsif (ie_dispensar_p = 'N') then 
	 
		/* 
		update	adep_processo 
		set	dt_dispensacao		= null, 
			nm_usuario_dispensacao	= null, 
			ie_status_processo		= 'G', 
			nm_usuario		= nm_usuario_p 
		where	nr_sequencia		= nr_seq_processo_p 
		and	dt_dispensacao		is not null 
		and	nm_usuario_dispensacao	is not null; 
		*/
 
		 
		CALL atualiza_status_processo_adep(nr_seq_processo_p, null, 'A', 'RS', clock_timestamp(), nm_usuario_p);
 
		if (ie_adep_map_w = 'S') then		 
			nr_seq_map_w := gerar_estornar_adep_map(nr_seq_processo_p, null, null, 'E', clock_timestamp(), nm_usuario_p, nr_seq_map_w, null, null, null);
		end if;
		 
	end if;
 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dispensar_processo_adep ( cd_estabelecimento_p bigint, nr_seq_processo_p bigint, ie_dispensar_p text, cd_perfil_p bigint, nm_usuario_p text) FROM PUBLIC;

