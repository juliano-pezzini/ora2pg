-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_guia_gravar_historico ( nr_seq_guia_p bigint, ie_tipo_log_p bigint, ds_observacao_p text, ds_parametro_p text, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gravar os históricos referentes as guias de autorização.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cd_guia_w			varchar(20);
ds_observacao_w			varchar(4000);

BEGIN

ds_observacao_w		:= substr(ds_observacao_p, 1,3970);

begin
	select	cd_guia
	into STRICT	cd_guia_w
	from	pls_guia_plano
	where	nr_sequencia	= nr_seq_guia_p;
exception
when others then
	cd_guia_w := null;
end;

insert into pls_guia_plano_historico(nr_sequencia, nr_seq_guia, ie_tipo_log,
	dt_historico, dt_atualizacao, nm_usuario,
	ds_observacao, ie_origem_historico, ie_tipo_historico)
values (	nextval('pls_guia_plano_historico_seq'), nr_seq_guia_p, ie_tipo_log_p,
	clock_timestamp(), clock_timestamp(), nm_usuario_p,
	'Guia: ' || cd_guia_w || ' / ' || ds_observacao_w,'A','L');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_guia_gravar_historico ( nr_seq_guia_p bigint, ie_tipo_log_p bigint, ds_observacao_p text, ds_parametro_p text, nm_usuario_p text) FROM PUBLIC;
