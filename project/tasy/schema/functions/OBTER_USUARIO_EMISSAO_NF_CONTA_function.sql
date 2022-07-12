-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_usuario_emissao_nf_conta ( nr_interno_conta_p conta_paciente.nr_interno_conta%type) RETURNS USUARIO.NM_USUARIO%TYPE AS $body$
DECLARE


ds_retorno_w	usuario.nm_usuario%type;
nr_seq_lote_w	cobranca_paciente_lote.nr_sequencia%type;


BEGIN

ds_retorno_w	:= '';

if (coalesce(nr_interno_conta_p,0) > 0) then

	select	max(nr_seq_lote)
	into STRICT	nr_seq_lote_w
	from	cobranca_paciente_conta
	where	nr_interno_conta = nr_interno_conta_p;

	if (coalesce(nr_seq_lote_w,0) > 0) then

		select	max(nm_usuario_nrec)
		into STRICT	ds_retorno_w
		from	cobranca_paciente_lote
		where	nr_sequencia = nr_seq_lote_w;

	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_usuario_emissao_nf_conta ( nr_interno_conta_p conta_paciente.nr_interno_conta%type) FROM PUBLIC;
