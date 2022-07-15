-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE des_criar_diagrama (nm_diagrama_p text, ie_tipo_p text, nr_seq_projeto_p bigint, nm_usuario_p text, nr_seq_objeto_p bigint, nr_seq_diag_p INOUT bigint) AS $body$
BEGIN

select	nextval('des_diagrama_seq')
into STRICT	nr_seq_diag_p
;

insert	into	des_diagrama(nr_sequencia, ie_tipo_diagrama, dt_atualizacao,
							 nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
							 nr_seq_projeto, nm_diagrama)
					  values (nr_seq_diag_p, ie_tipo_p, clock_timestamp(),
							 nm_usuario_p, clock_timestamp(), nm_usuario_p,
							 nr_seq_projeto_p, nm_diagrama_p);

if (nr_seq_objeto_p IS NOT NULL AND nr_seq_objeto_p::text <> '') then
	update	des_diagrama_objeto
	set	nr_des_diagrama = nr_seq_diag_p
	where	nr_sequencia = nr_seq_objeto_p;
end if;

commit;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE des_criar_diagrama (nm_diagrama_p text, ie_tipo_p text, nr_seq_projeto_p bigint, nm_usuario_p text, nr_seq_objeto_p bigint, nr_seq_diag_p INOUT bigint) FROM PUBLIC;

