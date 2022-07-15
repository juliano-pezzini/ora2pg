-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desvincula_kit_estoque (nr_prescricao_p bigint) AS $body$
DECLARE


nr_seq_reg_kit_w	bigint;
nm_usuario_w		varchar(15);

c01 CURSOR FOR
SELECT	a.nr_sequencia
from	kit_estoque_reg a
where	exists (select 1
				from 	kit_estoque b
				where 	a.nr_sequencia 	= b.nr_seq_reg_kit
				and 	nr_prescricao 	= nr_prescricao_p);



BEGIN

nm_usuario_w	 := wheb_usuario_pck.get_nm_usuario;

open C01;
	loop
	fetch C01 into
	nr_seq_reg_kit_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		update	kit_estoque_reg
		set	dt_utilizacao	 = NULL,
			nm_usuario_util  = NULL,
			dt_atualizacao 	= clock_timestamp(),
			nm_usuario	= nm_usuario_w
		where	nr_sequencia 	= nr_seq_reg_kit_w;
		end;
	end loop;
close C01;

update	kit_estoque
set	nm_usuario_util 	 = NULL,
	dt_utilizacao	 = NULL,
	ie_status	= 'C'
where	nr_prescricao	= nr_prescricao_p;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desvincula_kit_estoque (nr_prescricao_p bigint) FROM PUBLIC;

