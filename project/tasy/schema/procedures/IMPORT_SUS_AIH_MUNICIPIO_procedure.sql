-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE import_sus_aih_municipio (cd_municipio_ibge_p text, ds_municipio_p text, ds_unidade_federacao_p text, ie_novo_p text, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Importar dados AIH
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN
if (upper(ie_novo_p) = 'S') then
	if (cd_municipio_ibge_p IS NOT NULL AND cd_municipio_ibge_p::text <> '') and (ds_municipio_p IS NOT NULL AND ds_municipio_p::text <> '') and (ds_unidade_federacao_p IS NOT NULL AND ds_unidade_federacao_p::text <> '') then
		insert	into sus_municipio(cd_municipio_ibge,
					ds_municipio,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					ds_unidade_federacao,
					IE_IMPORTACAO_SUS)
		values (cd_municipio_ibge_p,
					ds_municipio_p,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					ds_unidade_federacao_p,
					'S');

	else
		update	sus_municipio
		set	ie_importacao_sus = 'S'
		where	cd_municipio_ibge = cd_municipio_ibge_p;
	end if;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE import_sus_aih_municipio (cd_municipio_ibge_p text, ds_municipio_p text, ds_unidade_federacao_p text, ie_novo_p text, nm_usuario_p text) FROM PUBLIC;
