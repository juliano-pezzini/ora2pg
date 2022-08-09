-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE import_sus_etnia (nr_sequencia_p bigint, cd_etnia_p text, ds_etnia_p text, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Importar dados AIH
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
ie_opcao_p
IN - insere dado tabela sus_etnia
UP - update
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN
if (upper(ie_opcao_p) = 'IN') then
	if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
			insert	into sus_etnia(  nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					cd_etnia,
					ds_etnia)
			values (	nr_sequencia_p,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					cd_etnia_p,
					ds_etnia_p);
	end if;
elsif (upper(ie_opcao_p) = 'UP') then
	update	sus_etnia
	set	ds_etnia = ds_etnia_p,
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where	cd_etnia = cd_etnia_p;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE import_sus_etnia (nr_sequencia_p bigint, cd_etnia_p text, ds_etnia_p text, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;
