-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_estornar_solicitacao ( nr_seq_solic_p bigint, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE


/*
ie_opcao_p
LS - Liberar Solicitação;
ES - Estornar Solicitação;
AS - Atender Solicitação;
BS - Baixar Solicitação;
*/
count_w				bigint;
ie_valida_w			varchar(1);
qt_atendido_w			bigint;
qt_inexistente_w		bigint;


BEGIN
if (ie_opcao_p = 'LS') then
	update	solic_documento
	set	dt_liberacao 	= clock_timestamp(),
		nm_usuario 	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia 	= nr_seq_solic_p;
elsif (ie_opcao_p = 'ES') then
	update	solic_documento
	set	dt_liberacao 	 = NULL,
		nm_usuario 	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia 	= nr_seq_solic_p;
elsif (ie_opcao_p = 'AS') then
	select	count(1)
	into STRICT	qt_atendido_w
	from	solic_item_documento	x
	where	x.nr_seq_solic_doc	= nr_seq_solic_p
	and	exists (SELECT	1
				from	solic_item_documento	a,
					solic_documento		b
				where	b.nr_sequencia			= a.nr_seq_solic_doc
				and	coalesce(b.dt_baixa::text, '') = ''
				and	(b.dt_atendimento IS NOT NULL AND b.dt_atendimento::text <> '')
				and	a.nr_seq_item_gestao_doc 	= x.nr_seq_item_gestao_doc
				and	a.nr_seq_solic_doc		!= nr_seq_solic_p)  LIMIT 1;

	select	count(1)
	into STRICT	qt_inexistente_w
	from	solic_item_documento	x
	where	x.nr_seq_solic_doc	= nr_seq_solic_p
	and	not exists (SELECT	1
				from	gestao_doc_item		a,
					gestao_documento	b
				where	b.nr_sequencia	= a.nr_seq_gestao_doc
				and	a.nr_sequencia 	= x.nr_seq_item_gestao_doc
				and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> ''))  LIMIT 1;

	if (qt_atendido_w = 0) and (qt_inexistente_w = 0) then
		update	solic_documento
		set	dt_atendimento 		= clock_timestamp(),
			nm_usuario_atend 	= nm_usuario_p
		where	nr_sequencia 		= nr_seq_solic_p;
	else
		CALL wheb_mensagem_pck.exibir_mensagem_abort(325026);
	end if;
elsif (ie_opcao_p = 'BS') then
	update	solic_documento
	set	dt_baixa 		= clock_timestamp(),
		nm_usuario_baixa 	= nm_usuario_p
	where	nr_sequencia 		= nr_seq_solic_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_estornar_solicitacao ( nr_seq_solic_p bigint, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;

