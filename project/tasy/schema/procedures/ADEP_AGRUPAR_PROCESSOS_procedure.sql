-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE adep_agrupar_processos (nr_atendimento_p bigint, dt_horario_p timestamp, nr_processo_origem_p bigint, nr_processo_destino_p bigint, nr_seq_area_prep_p bigint, nm_usuario_p text) AS $body$
DECLARE

					
ie_origem_valida_w		varchar(1);
ie_destino_valido_w	varchar(1);
ie_status_origem_w		varchar(15);
ie_status_destino_w	varchar(15);
ie_agrupar_area_w	varchar(1) := 'S';
cd_local_estoque_dest_w	smallint;
cd_local_estoque_orig_w	smallint;
					

BEGIN

begin

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (dt_horario_p IS NOT NULL AND dt_horario_p::text <> '') and (nr_processo_origem_p IS NOT NULL AND nr_processo_origem_p::text <> '') and (nr_processo_destino_p IS NOT NULL AND nr_processo_destino_p::text <> '') then
	
	select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
	into STRICT	ie_origem_valida_w
	from	adep_processo
	where	nr_sequencia		= nr_processo_origem_p
	and	nr_atendimento		= nr_atendimento_p
	and	dt_horario_processo	= dt_horario_p;
	
	if (ie_origem_valida_w = 'S') then
	
		select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
		into STRICT	ie_destino_valido_w
		from	adep_processo
		where	nr_sequencia		= nr_processo_destino_p
		and	nr_atendimento		= nr_atendimento_p
		and	dt_horario_processo	= dt_horario_p;	
		
		if (ie_destino_valido_w = 'S') then
		
			select	ie_status_processo,
				cd_local_estoque
			into STRICT	ie_status_origem_w,
				cd_local_estoque_orig_w
			from	adep_processo
			where	nr_sequencia	= nr_processo_origem_p;
			
			select	ie_status_processo,
				cd_local_estoque
			into STRICT	ie_status_destino_w,
				cd_local_estoque_dest_w
			from	adep_processo
			where	nr_sequencia	= nr_processo_destino_p;			
			
			if (ie_status_origem_w	= ie_status_destino_w) and (coalesce(cd_local_estoque_orig_w,0) = coalesce(cd_local_estoque_dest_w,0)) then
			
				if (nr_seq_area_prep_p IS NOT NULL AND nr_seq_area_prep_p::text <> '') and (nr_seq_area_prep_p > 0) then
					ie_agrupar_area_w	:= coalesce(obter_se_agrupar_processo_area(nr_processo_origem_p, nr_processo_destino_p, nr_seq_area_prep_p),'S');
				end if;
				
				if (ie_agrupar_area_w = 'S') then
			
					update	prescr_mat_hor
					set	nr_seq_processo	= nr_processo_destino_p,
						nm_usuario	= nm_usuario_p
					where	nr_seq_processo	= nr_processo_origem_p;
					
					update	adep_processo
					set	nr_seq_processo	= nr_processo_destino_p
					where	nr_seq_processo	= nr_processo_origem_p;
					
					update	adep_processo_item
					set	nr_seq_processo	= nr_processo_destino_p,
						nm_usuario	= nm_usuario_p
					where	nr_seq_processo	= nr_processo_origem_p;
					
					update	adep_processo_frac
					set	nr_seq_processo	= nr_processo_destino_p,
						nm_usuario	= nm_usuario_p
					where	nr_seq_processo	= nr_processo_origem_p;
					
					if (nr_seq_area_prep_p IS NOT NULL AND nr_seq_area_prep_p::text <> '') and (nr_seq_area_prep_p > 0) then
						begin
						update	adep_processo_area
						set	nr_seq_processo		= nr_processo_destino_p,
							nm_usuario		= nm_usuario_p
						where	nr_seq_processo 	= nr_processo_origem_p
						and	nr_seq_area_prep	= nr_seq_area_prep_p;
						end;
					else
						begin
						update	adep_processo_area
						set	nr_seq_processo		= nr_processo_destino_p,
							nm_usuario		= nm_usuario_p
						where	nr_seq_processo 	= nr_processo_origem_p;					
						end;
					end if;
					
					update	material_atend_paciente
					set	nr_seq_processo	= nr_processo_destino_p,
						nm_usuario	= nm_usuario_p
					where	nr_seq_processo	= nr_processo_origem_p;

                    delete 
                    from adep_processo_controle
                    where nr_seq_processo = nr_processo_origem_p;
					
					delete
					from	adep_processo
					where	nr_sequencia	= nr_processo_origem_p;
				
				else
					-- As areas dos processos de origem e destino sao incompativeis, favor verificar!
					CALL Wheb_mensagem_pck.exibir_mensagem_abort( 261373 );
				end if;
				
			else
				-- Os processos de origem e destino sao incompativeis (locais de estoque ou status diferem), favor verificar!
				CALL Wheb_mensagem_pck.exibir_mensagem_abort( 261372 );
			end if;
		
		else
			-- O processo de destino nao corresponde a este atendimento e horario, favor verificar!
			CALL Wheb_mensagem_pck.exibir_mensagem_abort( 261371 );	
		end if;
		
	else
		-- O processo de origem nao corresponde a este atendimento e horario, favor verificar!
		CALL Wheb_mensagem_pck.exibir_mensagem_abort( 261370 );	
	end if;
	
end if;

commit;

exception
when others then
	-- #@DS_ERRO#@
	CALL Wheb_mensagem_pck.exibir_mensagem_abort( 193870 , 'DS_ERRO=' || sqlerrm );
	rollback;
end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adep_agrupar_processos (nr_atendimento_p bigint, dt_horario_p timestamp, nr_processo_origem_p bigint, nr_processo_destino_p bigint, nr_seq_area_prep_p bigint, nm_usuario_p text) FROM PUBLIC;

