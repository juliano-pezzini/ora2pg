-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE definir_lote_laudo_sus ( nr_seq_interno_p bigint, nr_seq_lote_p bigint, nm_usuario_p text, ie_opcao_p bigint) AS $body$
DECLARE

/* 
ie_opcao_p 
 1 - Definir lote 
 2 - Retirar lote 
*/
 
 
nr_seq_lote_w		bigint;
nr_interno_conta_w		bigint;	
nr_seq_interno_w		bigint;
ie_inserir_laudos_conta_w	varchar(10) := 'N';
cd_estab_usuario_w	integer := 0;
ie_remover_laudos_conta_w	varchar(10) := 'N';
ie_tipo_laudo_sus_w		smallint;

C01 CURSOR FOR 
	SELECT	nr_seq_interno 
	from	sus_laudo_paciente 
	where	nr_interno_conta = nr_interno_conta_w 
	and	nr_seq_interno	<> nr_seq_interno_p 
	and	coalesce(nr_seq_lote::text, '') = '' 
	order by nr_seq_interno;

C02 CURSOR FOR 
	SELECT	nr_seq_interno 
	from	sus_laudo_paciente 
	where	nr_interno_conta = nr_interno_conta_w 
	and	nr_seq_interno	<> nr_seq_interno_p 
	and	nr_seq_lote = nr_seq_lote_w 
	and	ie_tipo_laudo_sus = 0 
	order by nr_seq_interno;	
	 

BEGIN 
 
begin 
cd_estab_usuario_w := wheb_usuario_pck.get_cd_estabelecimento;
exception 
when others then 
	cd_estab_usuario_w := 0;
end;
 
ie_inserir_laudos_conta_w := coalesce(obter_valor_param_usuario(1006,33,obter_perfil_ativo,nm_usuario_p,cd_estab_usuario_w),'N');
ie_remover_laudos_conta_w := coalesce(obter_valor_param_usuario(1006,37,obter_perfil_ativo,nm_usuario_p,cd_estab_usuario_w),'N');
 
begin 
select	coalesce(nr_seq_lote,0), 
	coalesce(nr_interno_conta,0), 
	ie_tipo_laudo_sus 
into STRICT	nr_seq_lote_w, 
	nr_interno_conta_w, 
	ie_tipo_laudo_sus_w 
from 	sus_laudo_paciente 
where 	nr_seq_interno = nr_seq_interno_p;
exception 
when others then 
	nr_interno_conta_w 	:= 0;
	nr_seq_lote_w		:= 0;
	ie_tipo_laudo_sus_w	:= null;
end;
 
if (ie_opcao_p	= 1) then 
	begin	 
 
	if (coalesce(nr_seq_lote_w,0) = 0) then 
		begin 
		update	sus_laudo_paciente 
		set	nr_seq_lote 	= nr_seq_lote_p, 
			nm_usuario	= nm_usuario_p, 
			dt_atualizacao	= clock_timestamp() 
		where	nr_seq_interno	= nr_seq_interno_p;
		end;
	end if;	
	 
	if (ie_inserir_laudos_conta_w = 'S') then 
		begin 
		 
		open C01;
		loop 
		fetch C01 into	 
			nr_seq_interno_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			 
			update	sus_laudo_paciente 
			set	nr_seq_lote 	= nr_seq_lote_p, 
				nm_usuario	= nm_usuario_p, 
				dt_atualizacao	= clock_timestamp() 
			where	nr_seq_interno	= nr_seq_interno_w;
			 
			end;
		end loop;
		close C01;
		 
		end;
	end if;
	 
	end;
 
elsif (ie_opcao_p	= 2) then 
	begin 
	update	sus_laudo_paciente 
	set	nr_seq_lote 	 = NULL, 
		nm_usuario	= nm_usuario_p, 
		dt_atualizacao	= clock_timestamp() 
	where	nr_seq_interno	= nr_seq_interno_p;
	 
	if (ie_remover_laudos_conta_w = 'S') and 
		((ie_tipo_laudo_sus_w IS NOT NULL AND ie_tipo_laudo_sus_w::text <> '') and (ie_tipo_laudo_sus_w not in (1,2))) then 
		begin 
		 
		open C02;
		loop 
		fetch C02 into	 
			nr_seq_interno_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin 
			 
			update	sus_laudo_paciente 
			set	nr_seq_lote 	 = NULL, 
				nm_usuario	= nm_usuario_p, 
				dt_atualizacao	= clock_timestamp() 
			where	nr_seq_interno	= nr_seq_interno_w;
			 
			end;
		end loop;
		close C02;
		 
		end;
	end if;
	 
	end;	
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE definir_lote_laudo_sus ( nr_seq_interno_p bigint, nr_seq_lote_p bigint, nm_usuario_p text, ie_opcao_p bigint) FROM PUBLIC;
