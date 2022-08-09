-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_enviar_autorizacao_web ( nr_seq_guia_p bigint, cd_operadora_exec_p text, ie_glosa_biometria_p text, ie_calcula_franquia_p text, ie_autoriza_glosa_web_p text, ie_gerar_senha_web_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ie_transacao_p INOUT text, cd_cooperativa_p INOUT text, ie_tipo_intercambio_p INOUT text, ie_status_p INOUT text, ie_estagio_p INOUT bigint) AS $body$
DECLARE


ie_estagio_w		smallint;
ie_status_w		varchar(2);
ie_tipo_intercambio_w	varchar(2);
ie_tipo_trans_w		varchar(4) := null;
ie_estagio_req_w	bigint;
nm_cooperativa_w	varchar(255);
nr_seq_prestador_web_w	pls_guia_plano.nr_seq_prestador_web%type;
nr_seq_uni_exec_w	pls_guia_plano.nr_seq_uni_exec%type;
nr_seq_perfil_web_w	pls_usuario_web.nr_seq_perfil_web%type;
param_28_w		varchar(255);


BEGIN

begin
	select	nr_seq_prestador_web,
		nr_seq_uni_exec
	into STRICT	nr_seq_prestador_web_w,
		nr_seq_uni_exec_w
	from	pls_guia_plano
	where	nr_sequencia = nr_seq_guia_p;

	if (coalesce(nr_seq_uni_exec_w::text, '') = '') then
		begin
			select	nr_seq_perfil_web
			into STRICT	nr_seq_perfil_web_w
			from	pls_usuario_web
			where	nr_sequencia	= nr_seq_prestador_web_w;
		exception
		when others then
			nr_seq_perfil_web_w := null;
		end;

		param_28_w := pls_obter_param_web(1247, 28, cd_estabelecimento_p, nr_seq_prestador_web_w, nr_seq_perfil_web_w, null, null, 'P', null, null);

		if (param_28_w IS NOT NULL AND param_28_w::text <> '') and (param_28_w <> 'X') then
			update	pls_guia_plano
			set	nr_seq_uni_exec = (pls_obter_seq_cooperativa(param_28_w))::numeric
			where	nr_sequencia = nr_seq_guia_p;
		end if;
	end if;
exception
when others then
	nr_seq_prestador_web_w	:= null;
end;

CALL pls_atualizar_guia_web(nr_seq_guia_p, cd_operadora_exec_p , nm_usuario_p);

CALL pls_consistir_guia_web(nr_seq_guia_p, ie_glosa_biometria_p, ie_calcula_franquia_p,
		       cd_estabelecimento_p, nm_usuario_p);

SELECT * FROM pls_dados_intercambio_web(  nr_seq_guia_p, null, cd_estabelecimento_p, ie_tipo_trans_w, cd_cooperativa_p, nm_cooperativa_w, ie_tipo_intercambio_w, ie_estagio_req_w ) INTO STRICT ie_tipo_trans_w, cd_cooperativa_p, nm_cooperativa_w, ie_tipo_intercambio_w, ie_estagio_req_w;

if (coalesce(ie_tipo_trans_w, 'X') = 'I') then
	ie_tipo_trans_w := 'I';
end if;

begin
	select	ie_status,
		ie_estagio
	into STRICT	ie_status_w,
		ie_estagio_w
	from	pls_guia_plano
	where	nr_sequencia = nr_seq_guia_p;
exception
when others then
	ie_status_w := null;
	ie_estagio_w := null;
end;

if ( ie_status_w <> '1' and ie_estagio_w <> 9 and ie_estagio_w > 1) then

	if (coalesce(ie_tipo_trans_w::text, '') = '' or ie_tipo_trans_w <> 'I' or ( ie_tipo_trans_w = 'I' and ie_tipo_intercambio_w = 'A' )) then

		CALL pls_liberar_guia( nr_seq_guia_p, 0, 0,
				  'S', cd_estabelecimento_p, nm_usuario_p,
				  ie_autoriza_glosa_web_p, ie_gerar_senha_web_p);

		begin
			select	ie_status,
				ie_estagio
			into STRICT	ie_status_w,
				ie_estagio_w
			from	pls_guia_plano
			where	nr_sequencia = nr_seq_guia_p;
		exception
		when others then
			ie_status_w := null;
			ie_estagio_w := null;
		end;

	end if;
end if;

ie_status_p := ie_status_w;
ie_estagio_p := ie_estagio_w;
ie_transacao_p := ie_tipo_trans_w;
ie_tipo_intercambio_p := ie_tipo_intercambio_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_enviar_autorizacao_web ( nr_seq_guia_p bigint, cd_operadora_exec_p text, ie_glosa_biometria_p text, ie_calcula_franquia_p text, ie_autoriza_glosa_web_p text, ie_gerar_senha_web_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ie_transacao_p INOUT text, cd_cooperativa_p INOUT text, ie_tipo_intercambio_p INOUT text, ie_status_p INOUT text, ie_estagio_p INOUT bigint) FROM PUBLIC;
