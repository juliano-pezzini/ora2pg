-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_usuario_termo_uso (nm_usuario_p text, ie_termo_uso_p text default 'S') AS $body$
DECLARE


nr_seq_log_atual_w		bigint;
ie_log_w				varchar(10);


BEGIN

if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin

	update	usuario
	set	ie_termo_uso		= upper(coalesce(ie_termo_uso_p, 'S'))
	where	nm_usuario	= nm_usuario_p;

	commit;

	SELECT * FROM gravar_log_alteracao('N', ie_termo_uso_p, nm_usuario_p, nr_seq_log_atual_w, 'IE_TERMO_USO', ie_log_w, obter_desc_expressao(780984)/*'Aceite do termo de concordância'*/, 'USUARIO', nm_usuario_p, NULL) INTO STRICT nr_seq_log_atual_w, ie_log_w;

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_usuario_termo_uso (nm_usuario_p text, ie_termo_uso_p text default 'S') FROM PUBLIC;

