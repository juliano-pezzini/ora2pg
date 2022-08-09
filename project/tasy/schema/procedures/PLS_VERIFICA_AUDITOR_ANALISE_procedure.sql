-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_verifica_auditor_analise ( nr_seq_auditoria_p bigint, nr_seq_grupo_analise_p bigint, nm_usuario_p text, ie_opcao_p bigint, ie_retorno_p INOUT text) AS $body$
DECLARE

/*
IE_OPCAO_P
1 - Verificar se já existe um auditor realizando a análise
*/
qt_registros_w			bigint;


BEGIN

if (ie_opcao_p	= 1) then
	select	count(1)
	into STRICT	qt_registros_w
	from	pls_analise_auditor_aut
	where	nr_seq_auditoria	= nr_seq_auditoria_p
	and	(dt_inicio_analise IS NOT NULL AND dt_inicio_analise::text <> '')
	and	coalesce(dt_fim_analise::text, '') = '';

	if (qt_registros_w	> 0) then
		select	count(1)
		into STRICT	qt_registros_w
		from	pls_analise_auditor_aut
		where	nr_seq_auditoria	= nr_seq_auditoria_p
		and	(dt_inicio_analise IS NOT NULL AND dt_inicio_analise::text <> '')
		and	coalesce(dt_fim_analise::text, '') = ''
		and	nm_usuario		= nm_usuario_p;

		if (qt_registros_w > 0) then
			ie_retorno_p	:= 'A';
		else
			ie_retorno_p	:= 'S';
		end if;
	else
		ie_retorno_p	:= 'N';
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_verifica_auditor_analise ( nr_seq_auditoria_p bigint, nr_seq_grupo_analise_p bigint, nm_usuario_p text, ie_opcao_p bigint, ie_retorno_p INOUT text) FROM PUBLIC;
