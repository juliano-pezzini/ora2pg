-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_pag_benef_event ( nr_seq_segurado_p bigint, nr_seq_pagador_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_pagador_ant_w		bigint;
nm_pagador_ant_w		varchar(255);


BEGIN 
 
if (coalesce(nr_seq_pagador_p,0) <> 0) then 
	begin 
	select	nr_seq_pagador, 
		substr(pls_obter_dados_pagador(nr_seq_pagador,'N'),1,255) 
	into STRICT	nr_seq_pagador_ant_w, 
		nm_pagador_ant_w 
	from 	pls_segurado 
	where 	nr_sequencia	= nr_seq_segurado_p;
	exception 
	when others then 
		nr_seq_pagador_ant_w	:= null;
		nm_pagador_ant_w	:= null;
	end;
 
	if ( coalesce(nr_seq_pagador_ant_w,0) <> nr_seq_pagador_p) then 
		update	pls_segurado 
		set	nr_seq_pagador	= nr_seq_pagador_p, 
			dt_atualizacao	= clock_timestamp(), 
			nm_usuario	= nm_usuario_p 
		where	nr_sequencia	= nr_seq_segurado_p;		
		 
		CALL pls_alterar_pagador_segurado(nr_seq_segurado_p,nr_seq_pagador_ant_w,nr_seq_pagador_p,clock_timestamp(),'N',nm_usuario_p);
 
		CALL pls_gerar_segurado_historico( 
			nr_seq_segurado_p, '6', clock_timestamp(), 
			wheb_mensagem_pck.get_texto(280132, 'NR_SEQ_PAGADOR_P=' || to_char(nr_seq_pagador_ant_w) || ';NM_PAGAD0R_P=' || nm_pagador_ant_w),'pls_alterar_pag_benef_event', null, 
			null, null, null, 
			clock_timestamp(), null, null, 
			null, null, null, 
			null, nm_usuario_p, 'S');
	end if;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_pag_benef_event ( nr_seq_segurado_p bigint, nr_seq_pagador_p bigint, nm_usuario_p text) FROM PUBLIC;
