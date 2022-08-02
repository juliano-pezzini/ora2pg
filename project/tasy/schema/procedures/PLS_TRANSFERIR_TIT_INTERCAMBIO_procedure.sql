-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_transferir_tit_intercambio ( nr_seq_titular_p bigint, nr_seq_titular_novo_p bigint, ie_tipo_alteracao_p text, ie_rescindir_titular_p text, dt_rescisao_titular_p timestamp, dt_limite_util_titular_p timestamp, nr_seq_motivo_cancel_titular_p bigint, ds_obs_resc_titular_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
/*	ie_tipo_alteracao_p 
	D - Alterar titularidade dos dependetes para o novo titular 
	T - Identifica cada dependente como titular 
*/
 
 
nr_seq_dependente_w		bigint;
ie_tipo_alteracao_w		varchar(1);
nm_titular_ant_w		varchar(255);
nr_seq_titular_ant_w		bigint;

dt_contratacao_titular_w	timestamp;
dt_contratacao_w		timestamp;

c01 CURSOR FOR 
	SELECT	nr_sequencia 
	from	pls_segurado 
	where	((nr_sequencia	= nr_seq_titular_p) 
	or (nr_seq_titular	= nr_seq_titular_p)) 
	and	coalesce(dt_rescisao::text, '') = '';


BEGIN 
 
ie_tipo_alteracao_w	:= coalesce(ie_tipo_alteracao_p,'X');
 
open c01;
loop 
fetch c01 into	 
	nr_seq_dependente_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	if (ie_tipo_alteracao_w <> 'X') then 
		 
		select	substr(pls_obter_dados_segurado(nr_seq_titular_p,'N'),1,255) 
		into STRICT	nm_titular_ant_w 
		;
		 
		if (ie_tipo_alteracao_p = 'D') then 
			 
			if (coalesce(ie_rescindir_titular_p,'N') = 'N') then 
				update	pls_segurado 
				set	nr_seq_titular	= nr_seq_titular_novo_p, 
					nm_usuario	= nm_usuario_p, 
					dt_atualizacao	= clock_timestamp() 
				where	nr_sequencia	= nr_seq_dependente_w 
				and	nr_sequencia	<> nr_seq_titular_novo_p;
			else 
				update	pls_segurado 
				set	nr_seq_titular	= nr_seq_titular_novo_p, 
					nm_usuario	= nm_usuario_p, 
					dt_atualizacao	= clock_timestamp() 
				where	nr_sequencia	= nr_seq_dependente_w 
				and	nr_sequencia	<> nr_seq_titular_novo_p 
				and	nr_sequencia	<> nr_seq_titular_p;
			end if;
			 
			update	pls_segurado 
			set	nr_seq_titular	 = NULL, 
				nr_seq_parentesco	 = NULL, 
				nm_usuario	= nm_usuario_p, 
				dt_atualizacao	= clock_timestamp() 
			where	nr_sequencia	= nr_seq_titular_novo_p;
		elsif (ie_tipo_alteracao_p = 'T') then 
			update	pls_segurado 
			set	nr_seq_titular	 = NULL, 
				nm_usuario	= nm_usuario_p, 
				dt_atualizacao	= clock_timestamp() 
			where	nr_sequencia	= nr_seq_dependente_w 
			and	nr_sequencia	<> nr_seq_titular_p;
		end if;
		 
		if (nr_seq_dependente_w <> nr_seq_titular_p) then 
			/* Gerar histórico */
 
			CALL pls_gerar_segurado_historico( 
				nr_seq_dependente_w, '8', clock_timestamp(), 
				'pls_transferir_tit_intercambio', 'Titular anterior: '||to_char(nr_seq_titular_p)||' - '||nm_titular_ant_w, null, 
				null, null, null, 
				clock_timestamp(), null, null, 
				nr_seq_titular_p, null, null, 
				null, nm_usuario_p, 'S');
		end if;
	end if;
	end;
end loop;
close c01;
 
if (coalesce(ie_rescindir_titular_p,'N') = 'S') then 
	 
	CALL pls_rescindir_intercambio(null,null,nr_seq_titular_p,dt_rescisao_titular_p,dt_limite_util_titular_p,nr_seq_motivo_cancel_titular_p, 
			ds_obs_resc_titular_p,null,cd_estabelecimento_p,nm_usuario_p);
 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_transferir_tit_intercambio ( nr_seq_titular_p bigint, nr_seq_titular_novo_p bigint, ie_tipo_alteracao_p text, ie_rescindir_titular_p text, dt_rescisao_titular_p timestamp, dt_limite_util_titular_p timestamp, nr_seq_motivo_cancel_titular_p bigint, ds_obs_resc_titular_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

