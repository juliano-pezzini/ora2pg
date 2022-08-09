-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE import_sus_aih_ativ_cnaer (cd_atividade_cnaer_p bigint, ds_atividade_cnaer_p text, ie_novo_p text, nm_usuario_p text) AS $body$
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

if (cd_atividade_cnaer_p IS NOT NULL AND cd_atividade_cnaer_p::text <> '') and (ds_atividade_cnaer_p IS NOT NULL AND ds_atividade_cnaer_p::text <> '') then
	if (upper(ie_novo_p) = 'S') then
		insert	into sus_atividade_cnaer(cd_atividade_cnaer,
				ds_atividade_cnaer,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec)
		values (cd_atividade_cnaer_p,
				ds_atividade_cnaer_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p);
	else
		update	sus_atividade_cnaer
		set	ds_atividade_cnaer = ds_atividade_cnaer_p
		where	cd_atividade_cnaer = cd_atividade_cnaer_p;
	commit;
	end if;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE import_sus_aih_ativ_cnaer (cd_atividade_cnaer_p bigint, ds_atividade_cnaer_p text, ie_novo_p text, nm_usuario_p text) FROM PUBLIC;
