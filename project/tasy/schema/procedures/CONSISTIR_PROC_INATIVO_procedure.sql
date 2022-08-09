-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_proc_inativo (nr_seq_proc_interno_p bigint, nm_usuario_p text, nm_estabelecimento_p bigint) AS $body$
DECLARE


ie_situacao_w	varchar(1);


BEGIN

if (nr_seq_proc_interno_p IS NOT NULL AND nr_seq_proc_interno_p::text <> '') then
	select	coalesce(max(ie_situacao),'A')
	into STRICT	ie_situacao_w
	from	proc_interno
	where	nr_sequencia = nr_seq_proc_interno_p;

	if (ie_situacao_w = 'I') then
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(262532);
	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_proc_inativo (nr_seq_proc_interno_p bigint, nm_usuario_p text, nm_estabelecimento_p bigint) FROM PUBLIC;
