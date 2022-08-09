-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_grupo_aud_padrao ( nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, ie_tipo_grupo_p text, nm_usuario_p text) AS $body$
DECLARE

/*
IE_TIPO_GRUPO_P
GA - Campo "Grupo de auditores" da função OPS - Gestão de Operadoras > Parâmetros da OPS > Intercâmbio > Intercâmbio SCS
GC - GA - Campo "Grupo de conferência" da função OPS - Gestão de Operadoras > Parâmetros da OPS > Intercâmbio > Intercâmbio SCS
*/
qt_grupo_aud_w			smallint;
nr_seq_grupo_w			bigint;
nr_seq_auditoria_w		bigint;


BEGIN

if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then
	select	max(nr_sequencia)
	into STRICT	nr_seq_auditoria_w
	from	pls_auditoria
	where	nr_seq_guia	= nr_seq_guia_p;

	select	count(1)
	into STRICT	qt_grupo_aud_w
	from	pls_auditoria_grupo
	where	nr_seq_auditoria	= nr_seq_auditoria_w;

	if (qt_grupo_aud_w	= 0) then
		if (ie_tipo_grupo_p	= 'GA') then
			select	coalesce(nr_seq_grupo,0)
			into STRICT	nr_seq_grupo_w
			from	pls_param_intercambio_scs;
		elsif (ie_tipo_grupo_p	= 'GC') then
			select	coalesce(nr_seq_grupo_conferencia,0)
			into STRICT	nr_seq_grupo_w
			from	pls_param_intercambio_scs;
		end if;

		if (nr_seq_grupo_w	<> 0) then
			insert into pls_auditoria_grupo(nr_sequencia, nr_seq_auditoria, nr_seq_grupo,
				dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
				nm_usuario_nrec, nr_seq_ordem, ie_status,
				ie_manual)
			values (nextval('pls_auditoria_grupo_seq'), nr_seq_auditoria_w, nr_seq_grupo_w,
				clock_timestamp(), nm_usuario_p, clock_timestamp(),
				nm_usuario_p, 1, 'U',
				'N');
		end if;
	end if;
elsif (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
	select	max(nr_sequencia)
	into STRICT	nr_seq_auditoria_w
	from	pls_auditoria
	where	nr_seq_requisicao	= nr_seq_requisicao_p;

	select	count(1)
	into STRICT	qt_grupo_aud_w
	from	pls_auditoria_grupo
	where	nr_seq_auditoria	= nr_seq_auditoria_w;

	if (qt_grupo_aud_w	= 0) then
		if (ie_tipo_grupo_p	= 'GA') then
			select	coalesce(nr_seq_grupo,0)
			into STRICT	nr_seq_grupo_w
			from	pls_param_intercambio_scs;
		elsif (ie_tipo_grupo_p	= 'GC') then
			select	coalesce(nr_seq_grupo_conferencia,0)
			into STRICT	nr_seq_grupo_w
			from	pls_param_intercambio_scs;
		end if;

		if (nr_seq_grupo_w	<> 0) then
			insert into pls_auditoria_grupo(nr_sequencia, nr_seq_auditoria, nr_seq_grupo,
				dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
				nm_usuario_nrec, nr_seq_ordem, ie_status,
				ie_manual)
			values (nextval('pls_auditoria_grupo_seq'), nr_seq_auditoria_w, nr_seq_grupo_w,
				clock_timestamp(), nm_usuario_p, clock_timestamp(),
				nm_usuario_p, 1, 'U',
				'N');
		end if;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_grupo_aud_padrao ( nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, ie_tipo_grupo_p text, nm_usuario_p text) FROM PUBLIC;
