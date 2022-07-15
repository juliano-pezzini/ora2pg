-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fa_registrar_cancel_atend (nr_sequencia_p bigint, nr_seq_motivo_cancel_p bigint, ds_observacao_cancel_p text, ds_erro_p INOUT text, nm_usuario_p text) AS $body$
DECLARE


qtd_w		integer;
ds_erro_w	varchar(255);

BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	select 	count(*)
	into STRICT	qtd_w
	from 	fa_entrega_medicacao
	where 	nr_seq_paciente_entrega = nr_sequencia_p
	and	(dt_cancelamento IS NOT NULL AND dt_cancelamento::text <> '');

	if (qtd_w = 0) then
		update	fa_paciente_entrega
		set	dt_cancelamento		= 	clock_timestamp(),
			nr_seq_motivo_cancel 	=	nr_seq_motivo_cancel_p,
			ds_observacao_cancel 	=	ds_observacao_cancel_p,
			nm_usuario		=	nm_usuario_p,
			ie_status_paciente	= 	'EC'
		where	nr_sequencia 		=	nr_sequencia_p;
	else
		ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(278085,null);
	end if;
end if;

ds_erro_p := ds_erro_w;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fa_registrar_cancel_atend (nr_sequencia_p bigint, nr_seq_motivo_cancel_p bigint, ds_observacao_cancel_p text, ds_erro_p INOUT text, nm_usuario_p text) FROM PUBLIC;

