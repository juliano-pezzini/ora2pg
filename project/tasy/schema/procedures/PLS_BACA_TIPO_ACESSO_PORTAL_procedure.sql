-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_baca_tipo_acesso_portal () AS $body$
DECLARE


nr_seq_segurado_w		bigint;
nr_seq_estipulante_w		bigint;
nr_seq_prestador_w		bigint;
nm_usuario_rede_propria_w	varchar(255);
nr_seq_acesso_w			bigint;
ie_tipo_acesso_w		varchar(2);
qt_registro_w			smallint	:= 0;

C01 CURSOR FOR
	SELECT  nr_seq_segurado,
		nr_seq_usu_estipulante,
		nr_seq_usu_prestador,
		nm_usuario_rede_propria,
		nr_sequencia
	from    pls_acesso_portal_log;


BEGIN
open C01;
loop
fetch C01 into
	nr_seq_segurado_w,
	nr_seq_estipulante_w,
	nr_seq_prestador_w,
	nm_usuario_rede_propria_w,
	nr_seq_acesso_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	qt_registro_w := qt_registro_w + 1;
	if (nr_seq_segurado_w IS NOT NULL AND nr_seq_segurado_w::text <> '') then
		ie_tipo_acesso_w := 'B';
	elsif (nr_seq_estipulante_w IS NOT NULL AND nr_seq_estipulante_w::text <> '') then
		ie_tipo_acesso_w := 'E';
	elsif (nr_seq_prestador_w IS NOT NULL AND nr_seq_prestador_w::text <> '') then
		ie_tipo_acesso_w := 'P';
	elsif (nm_usuario_rede_propria_w IS NOT NULL AND nm_usuario_rede_propria_w::text <> '') then
		ie_tipo_acesso_w := 'R';
	end if;

	if (ie_tipo_acesso_w IS NOT NULL AND ie_tipo_acesso_w::text <> '') then
		update	pls_acesso_portal_log
		set	ie_tipo_acesso 	= ie_tipo_acesso_w
		where	nr_sequencia	= nr_seq_acesso_w;
	end if;

	if (qt_registro_w = 5000) then
		commit;
		qt_registro_w := 0;
	end if;
	end;
end loop;
close C01;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_baca_tipo_acesso_portal () FROM PUBLIC;

