-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_atualiza_liberacao_incons (nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE
 							

										
nr_sequencia_w	cpoe_inconsistency.nr_sequencia%type;
qt_inv_liberacao_w	integer;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	cpoe_inconsistency
	where	nr_atendimento = nr_atendimento_p
	and nm_usuario = nm_usuario_p
	and coalesce(ie_libera,'S') = 'S'
	and coalesce(dt_liberacao::text, '') = '';
	
--c01_w c01%rowtype;	
	

BEGIN

if (coalesce(nr_atendimento_p,0) > 0) then
	
	select	count(*)
	into STRICT 	qt_inv_liberacao_w
	from	cpoe_inconsistency
	where	nr_atendimento = nr_atendimento_p
	and nm_usuario = nm_usuario_p
	and coalesce(ie_libera,'S') = 'N'
	and ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_atualizacao_nrec) > ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(clock_timestamp()) -5
	and coalesce(dt_liberacao::text, '') = '';
	
	if (coalesce(qt_inv_liberacao_w,0) = 0) then --Caso nao tenha inconsistencia que nao permite liberar, pode atualizar o registro.
	
		open C01;
		loop
		fetch C01 into	
			nr_sequencia_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			
			update cpoe_inconsistency
			set dt_liberacao = clock_timestamp(),
				dt_atualizacao = clock_timestamp()
			where	nr_atendimento = nr_atendimento_p		
			and nm_usuario = nm_usuario_p;
			
			end;
		end loop;
		close C01;
	
	else
		delete	from cpoe_inconsistency
		where	nr_atendimento	=	nr_atendimento_p
		and		nm_usuario		=	nm_usuario_p
	    and     ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_atualizacao_nrec) > ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(clock_timestamp()) -5		
		and		dt_liberacao	is	null;
	
	end if;
	
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_atualiza_liberacao_incons (nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;
