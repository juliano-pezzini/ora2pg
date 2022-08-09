-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_utiliza_glosa_evento ( nr_seq_glosa_evento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_plano_w			varchar(1);
ie_plano_ww			varchar(1);


BEGIN

select	coalesce(max(ie_plano),'N')
into STRICT	ie_plano_w
from	pls_glosa_evento
where	nr_sequencia	= nr_seq_glosa_evento_p;

if (ie_plano_w = 'S') then
	ie_plano_ww	:= 'N';
elsif (ie_plano_w = 'N') then
	ie_plano_ww	:= 'S';
end if;

update	pls_glosa_evento
set	ie_plano	= ie_plano_ww,
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp()
where	nr_sequencia	= nr_seq_glosa_evento_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_utiliza_glosa_evento ( nr_seq_glosa_evento_p bigint, nm_usuario_p text) FROM PUBLIC;
