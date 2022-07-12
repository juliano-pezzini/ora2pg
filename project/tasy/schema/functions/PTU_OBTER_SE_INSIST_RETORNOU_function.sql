-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ptu_obter_se_insist_retornou ( nr_seq_guia_p bigint, nr_seq_compl_p bigint, ie_tipo_trans_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(2) := 'NV';
nr_seq_execucao_w		bigint;
qt_registros_w			bigint;
nr_seq_exec_aut_w		bigint;
nr_seq_exec_compl_w		bigint;
qt_reg_insist_w			bigint;


BEGIN

if (ie_tipo_trans_p	= 'PA') then
	begin
	select	coalesce(a.nr_sequencia,0)
	into STRICT	nr_seq_exec_aut_w
	from	ptu_pedido_autorizacao	b,
		ptu_controle_execucao	a
	where	a.nr_seq_pedido_aut	= b.nr_sequencia
	and	b.nr_seq_guia		= nr_seq_guia_p;
	exception
	when others then
		nr_seq_exec_aut_w	:= 0;
	end;

	nr_seq_execucao_w	:= nr_seq_exec_aut_w;
elsif (ie_tipo_trans_p	= 'PC') then
	begin
	select	coalesce(a.nr_sequencia,0)
	into STRICT	nr_seq_exec_compl_w
	from	ptu_pedido_compl_aut	b,
		ptu_controle_execucao	a
	where	a.nr_seq_pedido_compl	= b.nr_sequencia
	and	b.nr_sequencia		= nr_seq_compl_p;
	exception
	when others then
		nr_seq_exec_compl_w	:= 0;
	end;

	nr_seq_execucao_w	:= nr_seq_exec_compl_w;
end if;

if (nr_seq_execucao_w	<> 0) then
	select	count(*)
	into STRICT	qt_reg_insist_w
	from	ptu_pedido_insistencia
	where	nr_seq_execucao		= nr_seq_execucao_w;

	if (qt_reg_insist_w	> 0) then
		select	count(*)
		into STRICT	qt_registros_w
		from	ptu_confirmacao
		where	nr_seq_execucao		= nr_seq_execucao_w
		and	ie_tipo_resposta	= 'PI';

		if (qt_registros_w	> 0) then
			ds_retorno_w	:= 'S';
		else
			ds_retorno_w	:= 'N';
		end if;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ptu_obter_se_insist_retornou ( nr_seq_guia_p bigint, nr_seq_compl_p bigint, ie_tipo_trans_p text) FROM PUBLIC;

