-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_gerencia_envio_ans_pck.obter_informacao_alter_number ( nr_seq_conta_p pls_conta.nr_sequencia%type, ie_opcao_p text, nr_valor_atual_p bigint) RETURNS bigint AS $body$
DECLARE


nr_retorno_w		bigint;
qt_registro_alt_w	integer;
ds_campo_w		varchar(255);
ds_select_w		varchar(255);


BEGIN

if (ie_opcao_p = 'DO') then

	select	count(1)
	into STRICT	qt_registro_alt_w
	from	pls_monitor_tiss_aj_obito
	where	nr_seq_conta = nr_seq_conta_p;

	if (qt_registro_alt_w = 0) then
		nr_retorno_w := nr_valor_atual_p;
	else
		select	max(replace(nr_declaracao,'-',''))
		into STRICT	nr_retorno_w
		from	pls_monitor_tiss_aj_obito
		where	nr_seq_conta = nr_seq_conta_p;
	end if;
elsif (ie_opcao_p = 'DN') then
	select	count(1)
	into STRICT	qt_registro_alt_w
	from	pls_monitor_tiss_aj_nasc
	where	nr_seq_conta = nr_seq_conta_p;

	if (qt_registro_alt_w = 0) then
		nr_retorno_w := nr_valor_atual_p;
	else
		select	max(replace(nr_declaracao,'-',''))
		into STRICT	nr_retorno_w
		from	pls_monitor_tiss_aj_nasc
		where	nr_seq_conta = nr_seq_conta_p;
	end if;
end if;

return nr_retorno_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_gerencia_envio_ans_pck.obter_informacao_alter_number ( nr_seq_conta_p pls_conta.nr_sequencia%type, ie_opcao_p text, nr_valor_atual_p bigint) FROM PUBLIC;